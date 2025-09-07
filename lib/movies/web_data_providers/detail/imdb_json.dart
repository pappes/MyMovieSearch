import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/imdb_sha_extractor.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:universal_io/io.dart';

const imdbQueryActor = deepPersonActorHeader;
const imdbQueryActress = deepPersonActressHeader;
const imdbQueryDirector = deepPersonDirectorHeader;
const imdbQueryProducer = deepPersonProducerHeader;
const imdbQueryWriter = deepPersonWriterHeader;

enum ImdbJsonSource { actor, actress, director, producer, writer }

/// Implements [WebFetchBase] for retrieving filtered Json
/// crew information from IMDB.
///
/// This is the equivalent of clicking one of the unselected
/// filters available under "credits" for the person.
/// Only returns the first 20 results!!!
///
/// ```dart
/// QueryIMDBJsonDetails().readList(criteria);
/// ```
// ignore: missing_override_of_must_be_overridden
class QueryIMDBJsonFilteredFilmographyDetails extends QueryIMDBJsonDetailsBase {
  QueryIMDBJsonFilteredFilmographyDetails(SearchCriteriaDTO criteria)
    : super(criteria, _imdbOperation) {
    updateShaKeys();
  }

  static const _imdbOperation = 'NameMainFilmographyFilteredCredits';
  static const _imdbShaCreditsOld =
      '47ffacde22ede1b84480c604ae6cda83362ff6e4a033dd105853670fa5a0ed56';
  late String _imdbShaCredits;

  @override
  @factory
  WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> myClone(
    SearchCriteriaDTO criteria,
  ) => QueryIMDBJsonFilteredFilmographyDetails(criteria);

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflineFilteredData;

  /// API call to IMDB search returning the top matching results
  /// for [searchCriteria].
  ///
  /// e.g.
  /// https://caching.graphql.imdb.com/?operationName=NameMainFilmographyFilteredCredits&variables=%7B%22id%22%3A%22nm0000619%22%2C%22includeUserRating%22%3Afalse%2C%22locale%22%3A%22en-GB%22%7D&extensions=%7B%22persistedQuery%22%3A%7B%22sha256Hash%22%3A%2247ffacde22ede1b84480c604ae6cda83362ff6e4a033dd105853670fa5a0ed56%22%2C%22version%22%3A1%7D%7D
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    imdbSha = _imdbShaCredits;
    return super.myConstructURI(searchCriteria, pageNumber: pageNumber);
  }

  ///
  void updateShaKeys() {
    _imdbShaCredits = _imdbShaCreditsOld;
  }
}

/// Implements [WebFetchBase] for retrieving paginated Json
/// crew information from IMDB.
///
/// This is the equivalent of clicking "see all" on the IMDB person page.
///
/// ```dart
/// QueryIMDBJsonDetails().readList(criteria);
/// ```
// ignore: missing_override_of_must_be_overridden
class QueryIMDBJsonPaginatedFilmographyDetails
    extends QueryIMDBJsonDetailsBase {
  QueryIMDBJsonPaginatedFilmographyDetails(
    SearchCriteriaDTO criteria, {
    this.imdbQuery = ImdbJsonSource.actor,
  }) : super(criteria, _imdbOperation) {
    updateShaKeys();
  }

  static const _imdbOperation = 'NameMainFilmographyPaginatedCredits';

  // These values are used when clicking "see all" or expanding the accordion.
  // from https://www.imdb.com/name/nm0000095
  static const _imdbShaActor =
      '7ed0c54ec0a95c77fde16a992d918034e8ff37dfc79934b49d8276fa40361aa2';
  // from https://www.imdb.com/name/nm0000149
  static const _imdbShaActress =
      'e514283c305a9580f246a87d6b492695244bac357b9bf4c8b9f7c9f68abcfc1d';
  // from https://www.imdb.com/name/nm0000095
  static const _imdbShaDirector =
      '229d41acc1f3a84c7797d9aa1bc9d039d4ac45dd96d98e744c12433ff40c5014';
  // from https://www.imdb.com/name/nm0000095
  static const _imdbShaProducer =
      '8dcb18732c6bef2c1a97e4e9549f6ff0141f2c8e8b3f1dd41b2ff0be1368d5e8';
  // from https://www.imdb.com/name/nm0000095
  static const _imdbShaWriter =
      'beb0469e88579c36dc67d25352be48e1efc749ed800aec44c468a275fc9e5fe6';

  static bool _updatedSha = false;
  static final _shaMap = {
    ImdbJsonSource.actor: _imdbShaActor,
    ImdbJsonSource.actress: _imdbShaActress,
    ImdbJsonSource.director: _imdbShaDirector,
    ImdbJsonSource.producer: _imdbShaProducer,
    ImdbJsonSource.writer: _imdbShaWriter,
  };

  final ImdbJsonSource imdbQuery;

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => '${super.myDataSourceName()}-$imdbQuery';

  @override
  @factory
  WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> myClone(
    SearchCriteriaDTO criteria,
  ) => QueryIMDBJsonPaginatedFilmographyDetails(criteria, imdbQuery: imdbQuery);

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflinePaginatedData;

  /// API call to IMDB search returning the top matching results
  /// for [searchCriteria].
  ///
  /// e.g.
  /// https://caching.graphql.imdb.com/?operationName=NameMainFilmographyPaginatedCredits&variables=%7B%22after%22%3A%22bm0wMDAwMTQ5%22%2C%22id%22%3A%22nm0000149%22%2C%22includeUserRating%22%3Afalse%2C%22locale%22%3A%22en-GB%22%7D&extensions=%7B%22persistedQuery%22%3A%7B%22sha256Hash%22%3A%229c2aaa61b79d348988d90e7420366ff13de8508e54ba7b8cf10f959f64f049d2%22%2C%22version%22%3A1%7D%7D
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    urlVariablesPrefix = '{"after":"';
    const variablesMid = '","id":"';
    final parameters = <String, String>{};

    // Define value for variables that includes the base64 encoded id e.g.
    // {"after":"bm0wMDAwMTQ5","id":"nm0000149",
    // "includeUserRating":false,"locale":"en-GB"}
    final encodedQuery = base64Encode(utf8.encode(searchCriteria));
    final variables =
        '$urlVariablesPrefix$encodedQuery'
        '$variablesMid$searchCriteria'
        '$urlVariablesSuffix';

    imdbSha = _shaMap[imdbQuery] ?? '';
    final baseUri = super.myConstructURI(
      searchCriteria,
      pageNumber: pageNumber,
    );

    // Replace value for the parameter called 'variables'.
    parameters.addAll(baseUri.queryParameters);
    parameters['variables'] = variables;

    return baseUri.replace(queryParameters: parameters);
  }

  ///
  void updateShaKeys() {
    if (!_updatedSha) {
      _updatedSha = true;
      _shaMap[ImdbJsonSource.actor] = _imdbShaActor;
      _shaMap[ImdbJsonSource.actress] = _imdbShaActress;
      _shaMap[ImdbJsonSource.director] = _imdbShaDirector;
      _shaMap[ImdbJsonSource.producer] = _imdbShaProducer;
      _shaMap[ImdbJsonSource.writer] = _imdbShaWriter;
      if (Platform.isAndroid || Platform.isIOS) {
        // Mobile platforms do not need to extract the sha keys.
        return;
      }
      unawaited(IMDBShaExtractor(_shaMap, ImdbJsonSource.actor).updateSha());
      unawaited(IMDBShaExtractor(_shaMap, ImdbJsonSource.actress).updateSha());
      unawaited(IMDBShaExtractor(_shaMap, ImdbJsonSource.director).updateSha());
      unawaited(IMDBShaExtractor(_shaMap, ImdbJsonSource.producer).updateSha());
      unawaited(IMDBShaExtractor(_shaMap, ImdbJsonSource.writer).updateSha());
    }
  }
}

/// Implements [WebFetchBase] for retrieving Json information from IMDB.
///
abstract class QueryIMDBJsonDetailsBase
    extends WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> {
  QueryIMDBJsonDetailsBase(super.criteria, this.imdbOperation);

  static const _baseURLprefix = 'caching.graphql.imdb.com';

  final String imdbOperation;

  String urlExtensionsPrefix = '{"persistedQuery":{"sha256Hash":"';
  String urlExtensionsSuffix = '","version":1}}';

  String urlVariablesPrefix = '{"id":"';
  String urlVariablesSuffix = '","includeUserRating":false,"locale":"en-GB"}';

  String imdbSha = '123456';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => 'imdb_Json-$imdbOperation';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflinePaginatedData;

  /// API call to IMDB search returning the top matching results
  /// for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final variables =
        '$urlVariablesPrefix$searchCriteria'
        '$urlVariablesSuffix';
    final extensions =
        '$urlExtensionsPrefix'
        '$imdbSha'
        '$urlExtensionsSuffix';

    return Uri.https(_baseURLprefix, '/', {
      'operationName': imdbOperation,
      'variables': variables,
      'extensions': extensions,
    });
  }

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() {
    final text = criteria.toPrintableString();
    if (text.startsWith(imdbPersonPrefix)) {
      return text;
    }
    return ''; // do not allow searches for non-imdb IDs
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return ImdbWebScraperConverter().dtoFromCompleteJsonMap(
        map,
        DataSourceType.imdbJson,
      );
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  // Force return data format to json.
  @override
  void myConstructHeaders(HttpHeaders headers) {
    headers.add('content-type', 'application/json');
  }

  /// Convert json to a traversable tree of [List] or [Map] data.
  /// Ensure that th fetch results Map has a "data"
  /// key which is a Map with a "name" key.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if ('' == webText) {
      throw WebConvertException('No content returned from web call');
    }
    try {
      // Assume text is json encoded.
      final tree = jsonDecode(webText);
      // ignore: avoid_dynamic_calls
      final results = tree['data']!['name'];
      if (results != null && results is Map) {
        return [results];
      }
    } on FormatException catch (jsonException) {
      throw WebConvertException('Invalid json $jsonException');
    } catch (_) {}
    throw WebConvertException(
      'could not find search results at data->name in json: $webText',
    );
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
    '[${myDataSourceName()}] $message',
    DataSourceType.imdb,
  );
}
