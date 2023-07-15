import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/uhtt_barcode.dart';

/// Search for barcode for a DVD.
class BarcodeRepository extends BaseMovieRepository {
  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {
    initProvider();
    QueryUhttBarcodeSearch(criteria)
        .readList(limit: 1000)
        .then((values) => addResults(searchUID, values))
        .whenComplete(finishProvider);
  }
}
