import 'package:my_movie_search/movies/blocs/repositories/movie_list_repository.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/movies/web_data_providers/search/omdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tmdb.dart';

/// Search for movie data from multiple online search sources.
///
/// BlockRepository to consolidate data retrieval from multiple search
/// and detail providers using the WebFetch framework.
///
/// [Search] provides a stream of incomplete and complete results.
/// [Close] can be used to cancel a search.
class MovieSearchRepository extends MovieListRepository {
  late QueryIMDBSuggestions _imdbSuggestions;
  late QueryIMDBSearch _imdbSearch;
  late QueryOMDBMovies _omdbSearch;
  late QueryTMDBMovies _tmdbSearch;
  late QueryGoogleMovies _googleSearch;

  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {
    _imdbSuggestions = QueryIMDBSuggestions(criteria);
    _imdbSearch = QueryIMDBSearch(criteria);
    _omdbSearch = QueryOMDBMovies(criteria);
    _tmdbSearch = QueryTMDBMovies(criteria);
    _googleSearch = QueryGoogleMovies(criteria);
    if (criteria.criteriaList.isEmpty) {
      _searchText(searchUID);
    } else {
      _searchList(searchUID);
    }
  }

  /// Initiates a search with all known movie "search" providers.
  /// Requests details retrieval for all returned search results.
  void _searchText(int searchUID) {
    for (final provider in [
      _imdbSearch,
      _imdbSuggestions,
      _googleSearch,
      _omdbSearch,
      _tmdbSearch,
    ]) {
      initProvider();
      provider
          .readList(limit: 10)
          .then((values) => addResults(searchUID, values))
          .whenComplete(finishProvider);
    }
  }

  /// Initiates a details retrival for a specified list of movies.
  void _searchList(int searchUID) {
    initProvider();
    addResults(searchUID, criteria.criteriaList);
    finishProvider();
  }
}
