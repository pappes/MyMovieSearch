import 'dart:async';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [TieredCache] for retrieving movie details from IMDB.
mixin ThreadedCacheIMDBTitleDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final _cache = TieredCache();

  /// Check cache to see if data has already been fetched.
  @override
  bool myIsResultCached(SearchCriteriaDTO criteria) {
    return _cache.isCached(_makeKey(criteria));
  }

  /// Check cache to see if data in cache should be refreshed.
  @override
  bool myIsCacheStale(SearchCriteriaDTO criteria) {
    return false;
    //return _cache.isCached(criteria.criteriaTitle);
  }

  /// Insert transformed data into cache.
  @override
  Future<void> myAddResultToCache(
    SearchCriteriaDTO criteria,
    MovieResultDTO fetchedResult,
  ) async {
    // add individual result to cache
    final key = '${myDataSourceName()}${fetchedResult.uniqueId}';
    _cache.add(key, fetchedResult);
    return _cache.add(_makeKey(criteria), fetchedResult);
  }

  /// Retrieve cached result.
  @override
  Stream<MovieResultDTO> myFetchResultFromCache(
    SearchCriteriaDTO criteria,
  ) async* {
    final value = await _cache.get(_makeKey(criteria));
    yield* Stream.value(value as MovieResultDTO);
  }

  /// Flush all data from the cache.
  @override
  void myClearCache() {
    return _cache.clear();
  }

  /// Retrieve cached result.
  String _makeKey(SearchCriteriaDTO criteria) =>
      '${myDataSourceName()}${criteria.criteriaTitle}';
}
