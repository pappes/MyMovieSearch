import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/movie_list_repository.dart';
import 'package:my_movie_search/movies/web_data_providers/search/ms_search.dart';

/// Search for movie data from all online search sources.
class MovieMeiliSearchRepository extends MovieListRepository {
  @override
  LimitedDtoFetch getProviders() => {
    QueryMsSearchMovies(criteria): 100,
  };
}
