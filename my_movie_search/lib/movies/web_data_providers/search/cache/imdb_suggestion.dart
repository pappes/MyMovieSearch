import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for caching movie suggestions from IMDB.
mixin ThreadedCacheIMDBSuggestions
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final _cache = TieredCache<MovieResultDTO>();
  static final List<SearchCriteriaDTO> _normalQueue = [];
  static final List<SearchCriteriaDTO> _verySlowQueue = [];

  /// Return a list with data matching [criteria].
  ///
  /// Optionally override the [priority]
  /// to push slow operations to another thread.
  ///
  /// Optionally inject [source]
  /// as an alternate data source for mocking/testing.
  ///
  /// Optionally supply [limit]
  /// to change the quantity of results returned from the query.
  Future<List<MovieResultDTO>> readPrioritisedCachedList({
    String priority = ThreadRunner.slow,
    DataSourceFn? source,
    int? limit = QueryIMDBSuggestions.defaultSearchResultsLimit,
  }) async {
    var result = <MovieResultDTO>[];

    // if cached and not stale yield from cache
    if (await _isResultCached() && !await _isCacheStale()) {
      logger.t(
        '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
        'value was pre cached ${myFormatInputAsText()}',
      );
      return [_fetchResultFromCache()!];
    }

    final newPriority = _enqueueRequest(priority);
    if (null == newPriority) {
      logger.t(
        '${ThreadRunner.currentThreadName}($priority) '
        'discarded ${myFormatInputAsText()}',
      );
      return [];
    }
    logger.t(
      '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
      'requesting ${myFormatInputAsText()}',
    );

    result = await ThreadRunner.namedThread(newPriority).run(
      runReadList,
      {
        'criteria': criteria,
        'source': source,
        'limit': limit,
      },
    ) as List<MovieResultDTO>
      ..forEach(_addResultToCache);

    _normalQueue.remove(criteria);
    _verySlowQueue.remove(criteria);
    return result;
  }

  /// static wrapper to readList() for compatability with ThreadRunner.
  static Future<List<MovieResultDTO>> runReadList(
    Map<String, dynamic> input,
  ) =>
      QueryIMDBSuggestions(input['criteria'] as SearchCriteriaDTO).readList(
        source: input['source'] as DataSourceFn?,
        limit: input['limit'] as int?,
      );

  /// Check cache to see if data has already been fetched.
  Future<bool> _isResultCached() async {
    final key = '${myDataSourceName()}${criteria.criteriaTitle}';
    return _cache.isCached(key);
  }

  /// Check cache to see if data in cache should be refreshed.
  Future<bool> _isCacheStale() async => false;
  //=> _cache.isCached(criteria.criteriaTitle);

  /// Insert transformed data into cache.
  Future<void> _addResultToCache(MovieResultDTO fetchedResult) async {
    final key = '${myDataSourceName()}${fetchedResult.uniqueId}';
    logger.t(
      '${ThreadRunner.currentThreadName} cache add '
      '${fetchedResult.uniqueId} size:${_cache.cachedSize()}',
    );

    return _cache.add(key, fetchedResult);
  }

  /// Retrieve cached result.
  MovieResultDTO? _fetchResultFromCache() {
    return _cache.get(_makeKey());
  }

  String? _enqueueRequest(String priority) {
    // Track and throttle low priority requests
    if (ThreadRunner.slow == priority || ThreadRunner.verySlow == priority) {
      if (_normalQueue.contains(criteria) ||
          _verySlowQueue.contains(criteria)) {
        return null;
      }

      if (_normalQueue.length < 3 && ThreadRunner.verySlow != priority) {
        _normalQueue.add(criteria);
      } else {
        _verySlowQueue.add(criteria);
        return ThreadRunner.verySlow;
      }
    }
    return priority;
  }

  /// Retrieve cached result.
  String _makeKey() => '${myDataSourceName()}${criteria.criteriaTitle}';
}
