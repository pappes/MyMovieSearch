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
  Future<bool> myIsResultCached(SearchCriteriaDTO criteria) async {
    return _cache.isCached(_makeKey(criteria));
  }

  /// Check cache to see if data in cache should be refreshed.
  @override
  Future<bool> myIsCacheStale(SearchCriteriaDTO criteria) async {
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
    await _cache.add(key, fetchedResult);
    // Add search result to cache
    return _appendDTOToCacheResult(criteria, fetchedResult);
  }

  /// Retrieve cached result.
  @override
  Stream<MovieResultDTO> myFetchResultFromCache(
    SearchCriteriaDTO criteria,
  ) async* {
    yield* Stream.fromIterable(await _getValueFromCache(criteria));
  }

  /// Flush all data from the cache.
  @override
  Future<void> myClearCache() async {
    return _cache.clear();
  }

  /// Retrieve cached result.
  String _makeKey(
    SearchCriteriaDTO criteria,
  ) =>
      '${myDataSourceName()}${criteria.criteriaTitle}';

  /// Retrieve cached result.
  Future<List<MovieResultDTO>> _getValueFromCache(
    SearchCriteriaDTO criteria,
  ) async {
    final value =
        await _cache.get('${myDataSourceName()}${criteria.criteriaTitle}');
    if (value is MovieResultDTO) {
      return [value];
    }
    if (value is List<MovieResultDTO>) {
      return value;
    }
    return [];
  }

  Future<void> _appendDTOToCacheResult(
    SearchCriteriaDTO criteria,
    MovieResultDTO fetchedResult,
  ) async {
    // Get existing search result from cache.
    List<MovieResultDTO> searchResult = [];
    if (await myIsResultCached(criteria)) {
      searchResult = await _getValueFromCache(criteria);
    }
    searchResult.add(fetchedResult);
    // Write new search result back into cache.
    return _cache.add(_makeKey(criteria), searchResult);
  }
}
