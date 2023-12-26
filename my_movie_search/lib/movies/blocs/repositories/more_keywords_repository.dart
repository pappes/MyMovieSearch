import 'dart:async';

import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_more_keywords.dart';

/// Search for keyword data from IMDB.
class MoreKeywordsRepository extends BaseMovieRepository {
  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  Future<void> initSearch(int searchUID, SearchCriteriaDTO criteria) async {
    initProvider(criteria);
    await QueryIMDBMoreKeywordsDetails(criteria)
        .readList(limit: 1000)
        .then((values) => addResults(searchUID, values))
        .whenComplete(() => finishProvider(criteria));
  }
}
