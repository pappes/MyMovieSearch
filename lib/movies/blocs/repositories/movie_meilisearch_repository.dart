import 'package:my_movie_search/movies/blocs/repositories/repository_types/movie_list_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/ms_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Search for movie data from all online search sources.
class MovieMeiliSearchRepository extends MovieListRepository {
  @override
  Map<WebFetchBase<MovieResultDTO, SearchCriteriaDTO>, int> getProviders() => {
        QueryMsSearchMovies(criteria): 100,
      };
}
