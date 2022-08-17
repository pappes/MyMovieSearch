import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [TieredCache] for retrieving person details from IMDB.
///
/// Caches results in default thread but moves data retrieval to
/// a different thread.  Runs lower priority requests on a slower thread.
mixin ThreadedCacheIMDBNameDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final _cache = TieredCache();
  static final List<SearchCriteriaDTO> _normalQueue = [];
  static final List<SearchCriteriaDTO> _verySlowQueue = [];

  /// Return a list with data matching [criteria].
  ///
  /// Optionally override the [priority] to push slow operations to another thread.
  /// Optionally inject [source] as an alternate data source for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<MovieResultDTO>> readPrioritisedCachedList(
    SearchCriteriaDTO criteria, {
    String priority = ThreadRunner.slow,
    DataSourceFn? source,
    int? limit = QueryIMDBNameDetails.defaultSearchResultsLimit,
  }) async {
    var retval = <MovieResultDTO>[];

    // if cached and not stale yield from cache
    if (await isThreadedResultCached(criteria) &&
        !await isThreadedCacheStale(criteria)) {
      print(
        '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
        'value was pre-cached ${myFormatInputAsText(criteria)}',
      );
      return fetchResultFromThreadedCache(criteria).toList();
    }

    final newPriority = _enqueueRequest(criteria, priority);
    if (null == newPriority) {
      print(
        '${ThreadRunner.currentThreadName}($priority) '
        'discarded ${myFormatInputAsText(criteria)}',
      );
      return [];
    }
    print(
      '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
      'requesting ${myFormatInputAsText(criteria)}',
    );

    retval = await ThreadRunner.namedThread(newPriority).run(
      runReadList,
      {
        'criteria': criteria,
        'source': source,
        'limit': limit,
      },
    ) as List<MovieResultDTO>;
    retval.forEach(_addResultToCache);

    _normalQueue.remove(criteria);
    _verySlowQueue.remove(criteria);
    return retval;
  }

  /// static wrapper to readList() for compatibility with ThreadRunner.
  static Future<List<MovieResultDTO>> runReadList(Map input) {
    return QueryIMDBNameDetails().readList(
      input['criteria'] as SearchCriteriaDTO,
      source: input['source'] as DataSourceFn?,
      limit: input['limit'] as int?,
    );
  }

  Future<void> clearThreadedCache() => _cache.clear();

  /// Check cache to see if data has already been fetched.
  Future<bool> isThreadedResultCached(SearchCriteriaDTO criteria) async {
    final key = '${myDataSourceName()}${criteria.criteriaTitle}';
    return _cache.isCached(key);
  }

  /// Check cache to see if data in cache should be refreshed.
  Future<bool> isThreadedCacheStale(SearchCriteriaDTO criteria) async {
    return false;
    //return _cache.isCached(criteria.criteriaTitle);
  }

  /// Insert transformed data into cache.
  Future<void> _addResultToCache(MovieResultDTO fetchedResult) async {
    final key = '${myDataSourceName()}${fetchedResult.uniqueId}';
    print(
      '${ThreadRunner.currentThreadName} cache add '
      '${fetchedResult.uniqueId} size:${_cache.cachedSize()}',
    );

    if (fetchedResult.uniqueId == 'nm0000243') {
      print(
        '${ThreadRunner.currentThreadName} breakpoint cache add '
        '${fetchedResult.uniqueId} size:${_cache.cachedSize()}',
      );
    }
    return _cache.add(key, fetchedResult);
  }

  /// Retrieve cached result.
  Stream<MovieResultDTO> fetchResultFromThreadedCache(
    SearchCriteriaDTO criteria,
  ) async* {
    final value =
        await _cache.get('${myDataSourceName()}${criteria.criteriaTitle}');
    if (value is MovieResultDTO) {
      yield value;
    }
  }

  String? _enqueueRequest(SearchCriteriaDTO criteria, String priority) {
    // Track and throttle low priority requests
    if (ThreadRunner.slow == priority || ThreadRunner.verySlow == priority) {
      if (_normalQueue.contains(criteria) ||
          _verySlowQueue.contains(criteria)) {
        return null;
      }
      if (criteria.criteriaTitle == 'nm0000243') {
        print(
          '${ThreadRunner.currentThreadName}cache miss '
          '${criteria.criteriaTitle}',
        );
      }

      if (_normalQueue.length < 10 && ThreadRunner.verySlow != priority) {
        _normalQueue.add(criteria);
      } else {
        _verySlowQueue.add(criteria);
        return ThreadRunner.verySlow;
      }
    }
    return priority;
  }
}
