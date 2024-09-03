import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:universal_io/io.dart';

const imdbQueryActor = deepPersonActorHeader;
const imdbQueryActress = deepPersonActressHeader;
const imdbQueryDirector = deepPersonDirectorHeader;
const imdbQueryProducer = deepPersonProducerHeader;
const imdbQueryWriter = deepPersonWriterHeader;

enum ImdbJsonSource {
  actor,
  actress,
  director,
  producer,
  writer,
}

/// Implements [WebFetchBase] for retrieving filtered Json
/// crew information from IMDB.
///
/// ```dart
/// QueryIMDBJsonDetails().readList(criteria);
/// ```
// ignore: missing_override_of_must_be_overridden
class QueryIMDBJsonFilteredFilmographyDetails extends QueryIMDBJsonDetailsBase {
  QueryIMDBJsonFilteredFilmographyDetails(SearchCriteriaDTO criteria)
      : super(criteria, _imdbOperation);

  static const _imdbOperation = 'NameMainFilmographyFilteredCredits';
  static const _creditsSha =
      '47ffacde22ede1b84480c604ae6cda83362ff6e4a033dd105853670fa5a0ed56';

  @override
  @factory
  WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> myClone(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBJsonFilteredFilmographyDetails(criteria);

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
    imdbSha = _creditsSha;
    return super.myConstructURI(searchCriteria, pageNumber: pageNumber);
  }
}

/// Implements [WebFetchBase] for retrieving paginated Json
/// crew information from IMDB.
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
  }) : super(criteria, _imdbOperation);

  static const _imdbOperation = 'NameMainFilmographyPaginatedCredits';

  static const _imdbShaActor =
      '4faf04583fbf1fbc7a025e5dffc7abc3486e9a04571898a27a5a1ef59c2965f3';
  static const _imdbShaActress =
      '0cf092f3616dbc56105327bf09ec9f486d5fc243a1d66eb3bf791fda117c5079';
  static const _imdbShaDirector =
      'f01a9a65c7afc1b50f49764610257d436cf6359e48c08de26c078da0d438d0e9';
  static const _imdbShaProducer =
      '9c2aaa61b79d348988d90e7420366ff13de8508e54ba7b8cf10f959f64f049d2';
  static const _imdbShaWriter =
      '2f142f86bfbb49a239bd4df6c2f40f3ed1438fecc8da45235e66d9062d321535';

  static const _imdbQueryShaMap = {
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
  ) =>
      QueryIMDBJsonPaginatedFilmographyDetails(criteria, imdbQuery: imdbQuery);

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
    final variables = '$urlVariablesPrefix$encodedQuery'
        '$variablesMid$searchCriteria'
        '$urlVariablesSuffix';

    imdbSha = _imdbQueryShaMap[imdbQuery] ?? '';
    final baseUri =
        super.myConstructURI(searchCriteria, pageNumber: pageNumber);

    // Replace value for the parameter called 'variables'.
    parameters.addAll(baseUri.queryParameters);
    parameters['variables'] = variables;

    return baseUri.replace(queryParameters: parameters);
  }
}

/// Implements [WebFetchBase] for retrieving Json information from IMDB.
///
abstract class QueryIMDBJsonDetailsBase
    extends WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> {
  QueryIMDBJsonDetailsBase(
    super.criteria,
    this.imdbOperation,
  );

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
    final variables = '$urlVariablesPrefix$searchCriteria'
        '$urlVariablesSuffix';
    final extensions = '$urlExtensionsPrefix'
        '$imdbSha'
        '$urlExtensionsSuffix';

    return Uri.https(
      _baseURLprefix,
      '/',
      {
        'operationName': imdbOperation,
        'variables': variables,
        'extensions': extensions,
      },
    );
  }

  /// converts <INPUT_TYPE> to a string representation.
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
      return ImdbWebScraperConverter()
          .dtoFromCompleteJsonMap(map, DataSourceType.imdbJson);
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
