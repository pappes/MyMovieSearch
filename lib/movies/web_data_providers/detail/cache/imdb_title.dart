import 'dart:async';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [TieredCache] for retrieving movie details from IMDB.

// ignore: missing_override_of_must_be_overridden
mixin ThreadedCacheIMDBTitleDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final _cache = TieredCache<List<MovieResultDTO>>();

  /// Check cache to see if data has already been fetched.
  @override
  Future<bool> myIsResultCached() async => _cache.isCached(_makeKey(criteria));

  /// Check cache to see if data in cache should be refreshed.
  @override
  bool myIsCacheStale() => false;
  //return _cache.isCached(criteria.criteriaTitle);

  /// Insert transformed data into cache.
  // add search results result to cache, keyed by search criteria
  @override
  Future<void> myAddResultToCache(MovieResultDTO fetchedResult) async =>
      _cache.add(_makeKey(criteria), [fetchedResult]);

  /// Retrieve cached result.
  @override
  List<MovieResultDTO> myFetchResultFromCache() =>
      _cache.get(_makeKey(criteria));
  // TODO(pappes): treat value as a list not as a single DTO

  /// Flush all data from the cache.
  @override
  Future<void> myClearCache() async => _cache.clear();

  /// Retrieve cached result.
  String _makeKey(SearchCriteriaDTO criteria) =>
      '${myDataSourceName()}${criteria.criteriaTitle}';
}
