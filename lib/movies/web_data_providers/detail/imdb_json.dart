import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_json_extractor.dart';

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
class QueryIMDBJsonCastDetails extends QueryIMDBJsonDetailsBase {
  QueryIMDBJsonCastDetails(SearchCriteriaDTO criteria)
    : super(criteria, _imdbOperation);

  static const _imdbOperation = 'FilmographyV2Pagination';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflineFilteredData;

  /// API call to IMDB search returning the top matching results
  /// for [searchCriteria].
  ///
  /// e.g.
  /// https://www.imdb.com/title/tt33852162/fullcredits/?ref_=tt_cst_sm
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) =>
      Uri.parse('https://www.imdb.com/title/${searchCriteria}/fullcredits/');
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
  QueryIMDBJsonPaginatedFilmographyDetails(SearchCriteriaDTO criteria)
    : super(criteria, _imdbOperation) {
    // TODO: get imdb json data
  }

  static const _imdbOperation = 'FilmographyV2Pagination';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflinePaginatedData;

  /// API call to IMDB search returning the top matching results
  /// for [searchCriteria].
  ///
  /// e.g.
  /// https://www.imdb.com/name/nm0000149/
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) =>
      Uri.parse('https://www.imdb.com/name/${searchCriteria}/');
}

/// Implements [WebFetchBase] for retrieving Json information from IMDB.
///
abstract class QueryIMDBJsonDetailsBase
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryIMDBJsonDetailsBase(super.criteria, this.imdbOperation);

  String? replacementUrl;

  final String imdbOperation;

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => 'imdb_Json-$imdbOperation';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflinePaginatedData;

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() {
    final text = criteria.toPrintableString();
    if (text.startsWith(imdbPersonPrefix)) {
      return text;
    }
    return ''; // do not allow searches for non-imdb IDs
  }

  @override
  Stream<String> baseConvertCriteriaToWebText() async* {
    final controller = StreamController<String>();
    final url = myConstructURI(myFormatInputAsText()).toString();

    final extractor = WebJsonExtractor(url, controller.add, imdbOperation);
    await extractor.waitForCompletion();
    final listener = controller.close();
    yield* controller.stream;
    await listener;
    print('done');
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      final dtos = ImdbWebScraperConverter().dtoFromCompleteJsonMap(
        map,
        DataSourceType.imdbJson,
      );
      return dtos;
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// Convert json to a traversable tree of [List] or [Map] data.
  /// Ensure that the fetch results Map has a "data"
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
