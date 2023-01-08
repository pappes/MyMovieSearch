import 'package:my_movie_search/movies/blocs/repositories/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/movies/web_data_providers/search/omdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tmdb.dart';

/// Search for movie data from multiple online sources.
///
/// BlockRepository to consolidate data retrieval from multiple search
/// and detail providers using the WebFetch framework.
///
/// [Search] provides a stream of incomplete and complete results.
/// [Close] can be used to cancel a search.
class MovieSearchRepository extends BaseMovieRepository {
  final QueryIMDBSuggestions _imdbSuggestions;
  final QueryIMDBSearch _imdbSearch;
  final QueryOMDBMovies _omdbSearch;
  final QueryTMDBMovies _tmdbSearch;
  final QueryGoogleMovies _googleSearch;

  MovieSearchRepository()
      : _imdbSuggestions = QueryIMDBSuggestions(),
        _imdbSearch = QueryIMDBSearch(),
        _omdbSearch = QueryOMDBMovies(),
        _tmdbSearch = QueryTMDBMovies(),
        _googleSearch = QueryGoogleMovies();

  @override

  /// Initiates a search for the provied [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {
    if (criteria.criteriaList.isEmpty) {
      searchText(searchUID, criteria);
    } else {
      searchList(searchUID, criteria);
    }
  }

  /// Initiates a search with all known movie "search" providers.
  /// Requests details retrival for all returned search results.
  void searchText(int searchUID, SearchCriteriaDTO criteria) {
    for (final provider in [
      _imdbSearch,
      _imdbSuggestions,
      _omdbSearch,
      _tmdbSearch,
      _googleSearch,
    ]) {
      initProvider();
      provider
          .readList(criteria, limit: 10)
          .then((values) => addResults(searchUID, values))
          .whenComplete(finishProvider);
    }
  }

  /// Initiates a details retrival for a specified list of movies.
  void searchList(int searchUID, SearchCriteriaDTO criteria) {
    initProvider();
    addResults(searchUID, criteria.criteriaList);
    finishProvider();
  }
}
