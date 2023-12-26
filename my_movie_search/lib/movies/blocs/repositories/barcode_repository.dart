import 'dart:async';

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
  Future<void> initSearch(int searchUID, SearchCriteriaDTO criteria) async {
    if (criteria.criteriaList.isEmpty) {
      await _searchText(searchUID);
    } else {
      await _searchList(searchUID);
    }
  }

  /// Initiates a search with all known movie "search" providers.
  /// Requests details retrieval for all returned search results.
  Future<void> _searchText(int searchUID) async {
    final providers = <WebFetchBase<MovieResultDTO, SearchCriteriaDTO>>[
      QueryLibsaBarcodeSearch(criteria),
      QueryFishpondBarcodeSearch(criteria),
      QueryUhttBarcodeSearch(criteria),
      QueryPicclickBarcodeSearch(criteria),
    ];
    for (final provider in providers) {
      initProvider(provider);
      await provider
          .readList(limit: 1000)
          .then((values) => addResults(searchUID, values))
          .whenComplete(() => finishProvider(provider));
    }
  }

  /// Initiates a details retrival for a specified list of movies.
  Future<void> _searchList(int searchUID) async {
    initProvider(this);
    return addResults(searchUID, criteria.criteriaList)
        .then((_) => finishProvider(this));
  }
}
