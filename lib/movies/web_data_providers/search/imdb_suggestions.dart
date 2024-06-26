import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/cache/imdb_suggestion.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_suggestion.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_suggestions.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_limiter.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for the IMDB search suggestions API.
///
/// Search suggestions are used by the lookup bar in the IMDB web page.
///
/// ```dart
/// QueryIMDBSuggestions().readList(criteria, limit: 10)
/// ```
class QueryIMDBSuggestions
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ThreadedCacheIMDBSuggestions {
  QueryIMDBSuggestions(super.criteria) {
    searchResultsLimit = WebFetchLimiter(defaultSearchResultsLimit);
    transformJsonP = true;
  }

  static const _baseURL = 'https://sg.media-imdb.com/suggestion/x/';
  // Limit results to 10 most relevant by default.
  static const defaultSearchResultsLimit = 10;

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.imdbSuggestions.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbJsonPOfflineData;

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableString();

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) return ImdbSuggestionConverter.dtoFromCompleteJsonMap(map);
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryIMDBSuggestions] $message',
        DataSourceType.imdbSuggestions,
      );

  /// API call to IMDB search returning the top matching results
  /// for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria.json';
    return Uri.parse(url);
  }

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
      return [tree];
    } on FormatException {
      throw WebConvertException('Invalid json returned from web call $webText');
    }
  }
}
