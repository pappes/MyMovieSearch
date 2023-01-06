library web_fetch;

import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Execute [WebFetchBase] requests in another thread and cache output.
///
/// ```dart
/// TC().readPrioritisedCachedList(
///   criteria,
///   priority: ThreadRunner.verySlow,
/// );
/// ```
abstract class WebFetchThreadedCache<OUTPUT_TYPE, INPUT_TYPE>
    extends WebFetchBase<OUTPUT_TYPE, INPUT_TYPE> {
  static final _cache = TieredCache();

  /// Return a list with data matching [criteria].
  ///
  /// Optionally override the [priority] to push slow operations to another thread.
  /// Optionally inject [source] as an alternate data source for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<OUTPUT_TYPE>> readPrioritisedCachedList(
    INPUT_TYPE criteria, {
    String priority = ThreadRunner.slow,
    DataSourceFn? source,
    int? limit,
  }) async {
    var result = <OUTPUT_TYPE>[];

    // if cached and not stale yield from cache
    if (await isThreadedResultCached(criteria) &&
        !await isThreadedCacheStale(criteria)) {
      print(
        '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
        'value was pre-cached ${myFormatInputAsText(criteria)}',
      );
      return fetchResultFromThreadedCache(criteria).toList();
    }
    final newPriority = confirmThreadCachePriority(criteria, priority, limit);

    if (null == newPriority) {
      print(
        '${ThreadRunner.currentThreadName}($priority) '
        'discarded ${myFormatInputAsText(criteria)}',
      );
      completeThreadCacheRequest(criteria, priority);
      return [];
    }
    print(
      '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
      'requesting ${myFormatInputAsText(criteria)}',
    );

    initialiseThreadCacheRequest(criteria, newPriority, limit);
    result = await ThreadRunner.namedThread(newPriority).run(
      runReadList,
      {
        'newInstance': myClone(),
        'criteria': criteria,
        'source': source,
        'limit': limit,
      },
    ) as List<OUTPUT_TYPE>;

    _addResultToCache(criteria, result);
    completeThreadCacheRequest(criteria, priority);

    return result;
  }

  /// Allow child classes to increase or reduce priority.
  ///
  /// Returns new priority for the request.
  /// Returns null if the request should be discarded.
  String? confirmThreadCachePriority(
    INPUT_TYPE criteria,
    String priority,
    int? limit,
  ) =>
      priority;

  /// Perform any class specific request tracking.
  void initialiseThreadCacheRequest(
    INPUT_TYPE criteria,
    String priority,
    int? limit,
  ) {}

  /// Perform any class specific request tracking.
  void completeThreadCacheRequest(INPUT_TYPE criteria, String priority) {}

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
  WebFetchBase<OUTPUT_TYPE, INPUT_TYPE> myClone();

  /// static wrapper to readList() for compatibility with ThreadRunner.
  static Future<List> runReadList(Map input) {
    final instance = input['newInstance'] as WebFetchBase;
    return instance.readList(
      input['criteria'],
      source: input['source'] as DataSourceFn?,
      limit: input['limit'] as int?,
    );
  }

  void clearThreadedCache() => _cache.clear();

  /// Check cache to see if data has already been fetched.
  Future<bool> isThreadedResultCached(INPUT_TYPE criteria) =>
      _cache.isCached(_getCacheKey(criteria));

  /// Check cache to see if data in cache should be refreshed.
  Future<bool> isThreadedCacheStale(INPUT_TYPE criteria) async {
    return false;
    //return _cache.isCached(_getCacheKey(criteria));
  }

  /// Retrieve cached result.
  Stream<OUTPUT_TYPE> fetchResultFromThreadedCache(
    INPUT_TYPE criteria,
  ) async* {
    final value = await _cache.get(_getCacheKey(criteria));
    if (value is List<OUTPUT_TYPE>) {
      yield* Stream.fromIterable(value);
    }
  }

  /// Insert transformed data into cache.
  Future<void> _addResultToCache(
    INPUT_TYPE criteria,
    List<OUTPUT_TYPE> fetchedResult,
  ) =>
      _cache.add(_getCacheKey(criteria), fetchedResult);

  String _getCacheKey(INPUT_TYPE criteria) =>
      '${myDataSourceName()}${myFormatInputAsText(criteria)}';
}
