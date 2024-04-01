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
  @override
  Map<WebFetchBase<MovieResultDTO, SearchCriteriaDTO>, int> getProviders() => {
        QueryIMDBSuggestions(criteria): 10,
        QueryIMDBSearch(criteria): 10,
        QueryOMDBMovies(criteria): 10,
        QueryTMDBMovies(criteria): 10,
        QueryGoogleMovies(criteria): 10,
      };
}
