import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/fishpond_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/libsa_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/picclick_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/uhtt_barcode.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

/// Search for barcode for a DVD.
class BarcodeRepository extends BaseMovieRepository {
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
      QueryLibsaBarcodeSearch(criteria),
      QueryFishpondBarcodeSearch(criteria),
      QueryUhttBarcodeSearch(criteria),
      QueryPicclickBarcodeSearch(criteria),
    ];
    for (final provider in providers) {
      initProvider();
      provider
          .readList(limit: 1000)
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
