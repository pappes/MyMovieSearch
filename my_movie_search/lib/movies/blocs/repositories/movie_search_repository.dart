import 'package:my_movie_search/movies/blocs/repositories/repository_types/movie_list_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/movies/web_data_providers/search/omdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tmdb.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Search for movie data from all online search sources.
class MovieSearchRepository extends MovieListRepository {
  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {
    if (criteria.criteriaList.isEmpty) {
      _searchText(searchUID);
    } else {
      _searchList(searchUID);
    }
  }

  /// Initiates a search with all known movie "search" providers.
  /// Requests details retrieval for all returned search results.
  void _searchText(int searchUID) {
    final providers = <WebFetchBase<MovieResultDTO, SearchCriteriaDTO>>[
      QueryIMDBSuggestions(criteria),
      QueryIMDBSearch(criteria),
      QueryOMDBMovies(criteria),
      QueryTMDBMovies(criteria),
      QueryGoogleMovies(criteria),
    ];
    for (final provider in providers) {
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
