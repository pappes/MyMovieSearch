import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/movie_list_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/persistence/web_log.dart';

/// Search for movie data from all online search sources.
class ApplicationStatisticsRepository extends MovieListRepository {
  /// Initiates a search for application statistics.
  ///
  @override
  Future<void> initSearch(int searchUID, SearchCriteriaDTO criteria) async {
    initProvider(SearchCriteriaType.statistics);
    final stats = WebLog.getStats();
    for (final stat in stats) {
      await addResults(searchUID, [_formatStatistic(stat)]);
    }
    return finishProvider(SearchCriteriaType.statistics);
  }

  MovieResultDTO _formatStatistic(Stats stat) {
    final dto = MovieResultDTO()
      ..uniqueId = stat.source
      ..type = MovieContentType.information
      ..title = stat.source
      ..userRatingCount = stat.qtyRequests
      ..alternateTitle =
          'requests:${stat.qtyRequests}  -  '
          'responses:${stat.qtyResponses}  -  '
          'cachedResponses:${stat.qtyCachedResponses}  -  '
          'emptyResponses:${stat.qtyEmptyResponses}  -  '
          'errors:${stat.qtyErrors}'
          '\n${stat.lastError.characters.take(1000)}';
    return dto;
  }
}
