import 'package:my_movie_search/movies/blocs/repositories/repository_types/movie_list_repository.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_movies_for_keyword.dart';

/// Search for movie data for the supplied keyword.
class MoviesForKeywordRepository extends MovieListRepository {
  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {
    initProvider();
    QueryIMDBMoviesForKeyword(criteria)
        .readList(limit: 10)
        .then((values) => addResults(searchUID, values))
        .whenComplete(finishProvider);
  }
}
