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
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<OUTPUT_TYPE>> readPrioritisedCachedList(
    INPUT_TYPE criteria, {
    String priority = ThreadRunner.slow,
    DataSourceFn? source,
    int? limit,
  }) async {
    var retval = <OUTPUT_TYPE>[];

    // yield from cache if cache is not stale
    if (await _isResultCached(criteria) && !await _isCacheStale(criteria)) {
      print(
        '${ThreadRunner.currentThreadName} '
        'value was precached ${myFormatInputAsText(criteria)}',
      );
      return _fetchResultFromCache(criteria).toList();
    }
    retval = await ThreadRunner.namedThread(priority).run(
      runReadList,
      {
        'newInstance': myClone(),
        'criteria': criteria,
        'source': source,
        'limit': limit,
      },
    ) as List<OUTPUT_TYPE>;
    for (final value in retval) {
      _addResultToCache(criteria, value);
    }

    return retval;
  }

  /// Returns new instance of the child class.
  ///
  /// Used for multithreaded operation.
  ///
  /// Should be overridden by child classes.
  /// To ensure thread safety, must not return "this".
  WebFetchBase<OUTPUT_TYPE, INPUT_TYPE> myClone();

  /// static wrapper to readList() for compatability with ThreadRunner.
  static Future<List> runReadList(Map input) {
    final instance = input['newInstance'] as WebFetchBase;
    return instance.readList(
      input['criteria'],
      source: input['source'] as DataSourceFn?,
      limit: input['limit'] as int?,
    );
  }

  /// Check cache to see if data has already been fetched.
  Future<bool> _isResultCached(INPUT_TYPE criteria) async {
    return _cache.isCached(_getCacheKey(criteria));
  }

  /// Check cache to see if data in cache should be refreshed.
  Future<bool> _isCacheStale(INPUT_TYPE criteria) async {
    return false;
    //return _cache.isCached(_getCacheKey(criteria));
  }

  /// Insert transformed data into cache.
  Future<void> _addResultToCache(
      INPUT_TYPE criteria, OUTPUT_TYPE fetchedResult) {
    return _cache.add(_getCacheKey(criteria), fetchedResult);
  }

  /// Retrieve cached result.
  Stream<OUTPUT_TYPE> _fetchResultFromCache(INPUT_TYPE criteria) async* {
    final value = await _cache.get(_getCacheKey(criteria));
    if (value is OUTPUT_TYPE) {
      yield value;
    }
  }

  String _getCacheKey(INPUT_TYPE criteria) {
    return '${myDataSourceName()}${myFormatInputAsText(criteria)}';
  }
}
