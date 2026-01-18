import 'dart:io';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/wikidata_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonKeywordKey = 'keyword';
const jsonPageKey = 'page';
const jsonCategoryKey = 'category';
const jsonMagnetKey = 'magnet';
const jsonNameKey = 'name';
const jsonImageKey = 'image';
const jsonYearKey = 'year';
const jsonDescriptionKey = 'description';
const jsonSeedersKey = 'seeders';
const jsonLeechersKey = 'leechers';

const uriPrefix = 'https://www.wikidata.org/wiki/Special:EntityData/';
const uriSuffix = '.json';
const wikdataWebAddressPrefix = 'https://www.wikidata.org/wiki/';

/// Implements [WebFetchBase] for retrieving full list of keywords
/// for a movie from IMDB.
///
/// ```dart
/// QueryWikidataDetails().readList(criteria);
/// ```
class QueryWikidataDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryWikidataDetails(super.criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.wikidataDetail.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflineData;

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() {
    final text = criteria.toPrintableString();
    if (text.startsWith(imdbPersonPrefix) ||
        text.startsWith(imdbTitlePrefix) ||
        text.startsWith(webAddressPrefix)) {
      return text;
    }
    logger.t('surpressed ${myDataSourceName()} search for non IMDB id $text');
    return ''; // do not allow searches for non-imdb IDs
  }

  /// API call to IMDB returning all keywords for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    if (searchCriteria.startsWith(imdbPersonPrefix) ||
        searchCriteria.startsWith(imdbTitlePrefix)) {
      return Uri.parse(searchCriteria);
    }
    if (searchCriteria.startsWith(
      Uri.encodeQueryComponent(wikdataWebAddressPrefix),
    )) {
      // convert https://www.wikidata.org/wiki/Q13794921
      //to https://www.wikidata.org/wiki/Special:EntityData/Q13794921.json
      // decode wikdataWebAddressPrefix
      final decoded = Uri.decodeFull(searchCriteria);
      final rawUri = Uri.parse(decoded);
      return Uri.parse('$uriPrefix${rawUri.pathSegments.last}$uriSuffix');
    }
    if (searchCriteria.startsWith(webAddressPrefix)) {
      return Uri.parse(searchCriteria);
    }
    final url = searchCriteria;
    return Uri.parse(url);
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
        // do not accept ;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7,
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
