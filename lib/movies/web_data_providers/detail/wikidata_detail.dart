import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/wikidata_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';


const wikiIdPrefix = 'Q';
const queryContext = 'http://query.wikidata.org/sparql?query=';
const uriPrefix = 'https://www.wikidata.org/wiki/Special:EntityData/';
const uriSuffix = '.json';
const wikidataWebAddressPrefix = 'https://www.wikidata.org/wiki/';

/// Implements [WebFetchBase] for retrieving full list of keywords
/// for a movie from IMDB.
///
/// ```dart
/// QueryWikidataDetails().readList(criteria);
/// ```
class QueryWikidataDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryWikidataDetails(super.criteria);

  static String? wikiQuery;

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.wikidataDetail.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflineData;

  /// converts SearchCriteriaDTO to a string representation
  /// in the format "tt123" "tt456"
  @override
  String myFormatInputAsText() {
    final text = criteria.toPrintableString();
    if (criteria.criteriaContext != null) {
      return '"${criteria.criteriaContext?.uniqueId}"';
    }
    if (criteria.criteriaList.isNotEmpty) {
      final builder = StringBuffer();
      for (final dto in criteria.criteriaList) {
        // format IDs to "id1" "id2" ... "idx"
        builder.write('"${dto.uniqueId}" ');
      }
      if (builder.isNotEmpty) {
        return builder.toString();
      }
    } else {
      if (text.startsWith(imdbPersonPrefix) ||
          text.startsWith(imdbTitlePrefix)) {
        return '"$text"';
      }
      if (text.startsWith(wikiIdPrefix) || text.startsWith(webAddressPrefix)) {
        return text;
      }
    }
    logger.t('surpressed ${myDataSourceName()} search for non IMDB id $text');
    return ''; // do not allow searches for non-imdb IDs
  }

  /// API call to wikidata returning all details for [searchCriteria].
  ///
  /// criteria can be:
  ///   * "IMDBID1" "IMDBID2" ... "IMDBIDx"
  ///   * wikidata ID
  ///   * wikidata url
  ///   * wikidata json url
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    // remove url encoding from criteria text
    final decoded = Uri.decodeQueryComponent(searchCriteria);

    if (decoded.startsWith('"$imdbPersonPrefix') ||
        decoded.startsWith('"$imdbTitlePrefix')) {
      return Uri.parse(createQueryUrl(decoded));
    }
    if (decoded.startsWith(wikidataWebAddressPrefix)) {
      // convert https://www.wikidata.org/wiki/Q13794921
      //to https://www.wikidata.org/wiki/Special:EntityData/Q13794921.json
      // decode wikdataWebAddressPrefix
      final rawUri = Uri.parse(decoded);
      return Uri.parse('$uriPrefix${rawUri.pathSegments.last}$uriSuffix');
    }
    if (searchCriteria.startsWith(webAddressPrefix)) {
      return Uri.parse(searchCriteria);
    }
    return Uri.parse('$uriPrefix$searchCriteria$uriSuffix');
  }

  /// API call to convert IMDBid to wikidataid.
  @override
  FutureOr<Uri> myConstructURIAsync(
    String searchCriteria, {
    int pageNumber = 1,
  }) async {
    wikiQuery = await rootBundle.loadString(
      'lib/movies/web_data_providers/detail/wikidata_detail_movie_query.sql',
    );
    // Ensure imdb lookup is valid.
    if (searchCriteria.startsWith(imdbTitlePrefix) ||
        searchCriteria.startsWith(imdbPersonPrefix)) {
      // Run the imdb lookup.
      final idText = await QueryWikidataImdbSearch().getWikiID(searchCriteria);
      if (idText.isNotEmpty) {
        return myConstructURI(idText, pageNumber: pageNumber);
      }
    }
    // perform the normal search
    return myConstructURI(searchCriteria, pageNumber: pageNumber);
  }


  String createQueryUrl(String imdbIds) {
    //read query from wikidata_detail_movie_query.sql
    final fileContents = wikiQuery ?? '';
    // inject IDs into loaded string replacing "tt000"
    final query = fileContents.replaceAll('"tt000"', imdbIds);
    // use regex to remove all single line comments
    // any text starting with # the is not in a string or in <>
    const quotedString = '"[^"]*"';
    const angledBrackets = '<[^>]*>';
    const singleLineComment = '#.*';
    final sparce = query.replaceAllMapped(
      RegExp('$quotedString|$angledBrackets|$singleLineComment'),
      (match) => match[0]!.startsWith('#') ? '' : match[0]!,
    );

    // remove all blank lines
    final compact = sparce.replaceAll(RegExp(r'^\s*\n', multiLine: true), '');
    // urlencode the query
    final encoded = Uri.encodeQueryComponent(compact);
    // prefix the query with http://query.wikidata.org/sparql?query=
    final fullUrl = '$queryContext$encoded';
    return fullUrl;
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return WikidataDetailConverter().dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  // Set Wikidata specific headers
  @override
  void myConstructHeaders(HttpHeaders headers) {
    super.myConstructHeaders(headers);
    // prevent invalid UTF encoding.
    headers
      ..set(
        'accept',
        'application/vnd.api+json;q=0.9,application/json;q=0.8,text/html;q=0.7,application/xhtml+xml;q=0.6,application/xml;q=0.5',
      )
      ..set('content-type', 'application/json; charset=utf-8')
      ..set('accept-encoding', 'text/plain');
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
    '[QueryWikidataDetails] $message',
    DataSourceType.wikidataDetail,
  );
}

class QueryWikidataImdbSearch {
  /// Lookup IMDB id on wikidata and get the wikidata id.
  /// e.g. tt2724064 -> Q13794921
  Future<String> getWikiID(String imdbId) async {
    const queryPrefix = '''
SELECT DISTINCT ?item ?itemLabel WHERE {
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],mul,en". }
  {
    SELECT DISTINCT ?item WHERE {
      ?item p:P345 ?statement0.
      ?statement0 (ps:P345) "''';
    const querySuffix = '''
".
    }
    LIMIT 1
  }
}''';
    final query = queryPrefix + imdbId + querySuffix;
    // Convert query to http encoded string.
    // e.g. SELECT%20DISTINCT%20%3Fitem%20%3FitemLabel%20WHERE%20%7B%0A%20%20...
    final encoded = Uri.encodeFull(query);

    // Construct http url for query.
    // e.g. https://query.wikidata.org/sparql?<query>>
    final uri = Uri.parse('$queryContext$encoded');
    //https://query.wikidata.org/sparql?query=SELECT%20DISTINCT%20?item%20?itemLabel%20WHERE%20%7B%0A%20%20SERVICE%20wikibase:label%20%7B%20bd:serviceParam%20wikibase:language%20%22%5BAUTO_LANGUAGE%5D,mul,en%22.%20%7D%0A%20%20%7B%0A%20%20%20%20SELECT%20DISTINCT%20?item%20WHERE%20%7B%0A%20%20%20%20%20%20?item%20p:P345%20?statement0.%0A%20%20%20%20%20%20?statement0%20(ps:P345)%20%22%0Anm0598241%22.%0A%20%20%20%20%7D%0A%20%20%20%20LIMIT%201%0A%20%20%7D%0A%7D
    final response = await _runQuery(uri);

    if (response != null) {
      final jsonData = jsonDecode(response);
      final wikiId = _getWikiIdFromQueryResults(jsonData);
      return wikiId;
    }
    return '';
  }

  ///  Retrieve json results from http endpoint
  /// with headers: { Accept: 'application/sparql-results+json' },
  Future<String?> _runQuery(Uri uri) async {
    // create http client
    final client = await HttpClient().openUrl('GET', uri);
    // set headers
    client.headers.set('Accept', 'application/sparql-results+json');
    //client.headers.set('Accept', 'application/json');
    // close client
    final response = await client.close();
    // execute fetch
    // check results
    if (response.statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      return body.characters.take(1000).toString();
    }
    return null;
  }

  /// Extract wikidata id from json query results.
  String _getWikiIdFromQueryResults(dynamic jsonData) =>
      /*    
[{"item":"http://www.wikidata.org/entity/Q13794921","itemLabel":"Sharknado"}]

or 

{
  "head" : {
    "vars" : [ "item", "itemLabel" ]
  },
  "results" : {
    "bindings" : [ {
      "item" : {
        "type" : "uri",
        "value" : "http://www.wikidata.org/entity/Q189132"
      },
      "itemLabel" : {
        "xml:lang" : "en",
        "type" : "literal",
        "value" : "Sophie Monk"
      }
    } ]
  }
}
*/
      getJsonWikidataId('value') ?? getJsonWikidataId('item') ?? '';

  String? getJsonWikidataId(String jsonData) {
    final url = TreeHelper(jsonData).searchForString(key: 'value');
    if (url is String && url.isNotEmpty) {
      // Extract is from full url http://www.wikidata.org/entity/Q13794921
      return url.split('/').last;
    }
    return null;
  }
}
