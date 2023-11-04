import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/yts_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/yts_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for the IMDB search suggestions API.
///
/// Search suggestions are used by the lookup bar in the IMDB web page.
///
/// ```dart
/// QueryYtsSearch().readList(criteria, limit: 10)
/// ```
class QueryYtsSearch extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://yts.mx/ajax/search?query=';

  /// Limit results to 10 most relevant by default.
  QueryYtsSearch(super.criteria) {
    transformJsonP = true;
  }

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.ytsSearch.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamJsonOfflineData;

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toSearchId();

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) return YtsSearchConverter.dtoFromCompleteJsonMap(map);
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryYtsSearch] $message',
        DataSourceType.ytsSearch,
      );

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL/$searchCriteria';
    return Uri.parse(url);
  }

  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if ('' == webText) throw 'No content returned from web call';
    try {
      // Assume text is json encoded.
      final tree = jsonDecode(webText);
      return [tree];
    } catch (jsonException) {
      throw 'Invalid json returned from web call $webText';
    }
  }
}
