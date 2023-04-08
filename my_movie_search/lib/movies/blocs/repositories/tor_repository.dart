import 'package:my_movie_search/movies/blocs/repositories/movie_list_repository.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tpb_search.dart';

/// Search for download data from TPB.
class TorRepository extends MovieListRepository {
  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {
    initProvider();
    QueryTpbSearch(criteria)
        .readList()
        .then((values) => addResults(searchUID, values))
        .whenComplete(finishProvider);
  }
}
