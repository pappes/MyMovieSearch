import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/cache/imdb_suggestion.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_suggestion.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_suggestions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';

/// Implements [WebFetchBase] for the IMDB search suggestions API.
/// Search suggestions are used by the lookup bar in the IMDB web page.
class QueryIMDBSuggestions
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ThreadedCacheIMDBSuggestions {
  static const _baseURL = 'https://sg.media-imdb.com/suggests';
  static const defaultSearchResultsLimit = 10;

  /// Limit results to 10 most relevant by default.
  QueryIMDBSuggestions() {
    searchResultsLimit = defaultSearchResultsLimit;
    transformJsonP = true;
  }

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() => DataSourceType.imdbSuggestions.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbJsonPOfflineData;

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      ImdbSuggestionConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO();
    error.title = '[QueryIMDBSuggestions] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdbSuggestions;
    return error;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final prefix = searchCriteria.isEmpty ? '' : searchCriteria.substring(0, 1);
    final url = '$_baseURL/$prefix/$searchCriteria.json';
    return WebRedirect.constructURI(url);
  }
}
