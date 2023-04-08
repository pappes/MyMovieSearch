import 'package:my_movie_search/movies/blocs/repositories/movie_list_repository.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_more_keywords.dart';

/// Search for keyword data from IMDB.
class MoreKeywordsRepository extends MovieListRepository {
  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {
    initProvider();
    QueryIMDBMoreKeywordsDetails(criteria)
        .readList(limit: 10)
        .then((values) => addResults(searchUID, values))
        .whenComplete(finishProvider);
  }
}
