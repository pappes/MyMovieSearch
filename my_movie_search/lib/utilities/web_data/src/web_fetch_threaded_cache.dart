/// This library provides a framework for fetching different types of web data
/// in a concsistent manner.
library web_fetch;

import 'package:meta/meta.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Execute [WebFetchBase] requests in another thread and cache output.
///
/// ```dart
/// TC().readPrioritisedCachedList(
///   priority: ThreadRunner.verySlow,
/// );
/// ```
abstract class WebFetchThreadedCache<OUTPUT_TYPE, INPUT_TYPE>
    extends WebFetchBase<OUTPUT_TYPE, INPUT_TYPE> {
  static final _cache = TieredCache();

  WebFetchThreadedCache(super.criteria);

  /// Return a list with data matching [criteria].
  ///
  /// Optionally override the [priority] to push slow operations to another thread.
  /// Optionally inject [source] as an alternate data source for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  @useResult
  Future<List<OUTPUT_TYPE>> readPrioritisedCachedList({
    String priority = ThreadRunner.slow,
    DataSourceFn? source,
    int? limit,
  }) async {
    var result = <OUTPUT_TYPE>[];

    // if cached and not stale yield from cache
    if (isThreadedResultCached() && !isThreadedCacheStale()) {
      logger.t(
        '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
        'value was pre-cached ${myFormatInputAsText()}',
      );
      return fetchResultFromThreadedCache().toList();
    }
    final newPriority = confirmThreadCachePriority(priority, limit);

    if (null == newPriority) {
      logger.t(
        '${ThreadRunner.currentThreadName}($priority) '
        'discarded ${myFormatInputAsText()}',
      );
      completeThreadCacheRequest(priority);
      return [];
    }
    logger.t(
      '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
      'requesting ${myFormatInputAsText()}',
    );

    initialiseThreadCacheRequest(newPriority, limit);
    result = await ThreadRunner.namedThread(newPriority).run(
      runReadList,
      {
        'newInstance': myClone(criteria),
        'criteria': criteria,
        'source': source,
        'limit': limit,
      },
    ) as List<OUTPUT_TYPE>;

    _addResultToCache(result);
    completeThreadCacheRequest(priority);

    return result;
  }

  /// Allow child classes to increase or reduce priority.
  ///
  /// Returns new priority for the request.
  /// Returns null if the request should be discarded.
  @visibleForOverriding
  String? confirmThreadCachePriority(
    String priority,
    int? limit,
  ) =>
      priority;

  /// Perform any class specific request tracking.
  @visibleForOverriding
  void initialiseThreadCacheRequest(
    String priority,
    int? limit,
  ) {}

  /// Perform any class specific request tracking.
  @visibleForOverriding
  void completeThreadCacheRequest(String priority) {}

  /// Returns new instance of the child class.
  ///
  /// Used for multithreaded operation.
  ///
  /// Should be overridden by child classes.
  /// To ensure thread safety, must not return "this".
  ///
  /// ```dart
  /// return QueryIMDBNameDetails();
  /// ```
  @factory
  WebFetchBase<OUTPUT_TYPE, INPUT_TYPE> myClone(INPUT_TYPE criteria);

  /// static wrapper to readList() for compatibility with ThreadRunner.
  static Future<List> runReadList(Map input) {
    final instance = input['newInstance'] as WebFetchBase;
    return instance.readList(
      source: input['source'] as DataSourceFn?,
      limit: input['limit'] as int?,
    );
  }

  @visibleForTesting
  @mustCallSuper
  void clearThreadedCache() => _cache.clear();

  /// Check cache to see if data has already been fetched.
  @useResult
  bool isThreadedResultCached() => _cache.isCached(_getCacheKey());

  /// Check cache to see if data in cache should be refreshed.
  @useResult
  bool isThreadedCacheStale() {
    return false;
    //return _cache.isCached(_getCacheKey());
  }

  /// Retrieve cached result.
  @useResult
  Stream<OUTPUT_TYPE> fetchResultFromThreadedCache() async* {
    final value = _cache.get(_getCacheKey());
    if (value is List<OUTPUT_TYPE>) {
      yield* Stream.fromIterable(value);
    }
  }

  /// Insert transformed data into cache.
  void _addResultToCache(
    List<OUTPUT_TYPE> fetchedResult,
  ) =>
      _cache.add(_getCacheKey(), fetchedResult);

  String _getCacheKey() => '${myDataSourceName()}${myFormatInputAsText()}';
}
