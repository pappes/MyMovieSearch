import 'dart:async';

import 'package:my_movie_search/movies/blocs/repositories/repository_types/movie_list_repository.dart';
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
      await addResults(searchUID, [stat.formatStatistic()]);
    }
    return finishProvider(SearchCriteriaType.statistics);
  }

}
