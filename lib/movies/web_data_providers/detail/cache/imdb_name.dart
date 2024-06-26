import 'package:meta/meta.dart';
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
// ignore: missing_override_of_must_be_overridden
mixin ThreadedCacheIMDBNameDetails
    on WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> {
  static final normalQueue = <String>{};
  static final verySlowQueue = <String>{};

  /// Adds criteria to a collection of currently processing requests.
  ///
  /// Returns new priority for the request.
  /// Returns null if the request should be discarded.
  @override
  String? confirmThreadCachePriority(
    String priority,
    int? limit,
  ) {
    // Track and throttle low priority requests
    if (ThreadRunner.slow == priority || ThreadRunner.verySlow == priority) {
      final text = criteria.toPrintableString();
      if (normalQueue.contains(text) || verySlowQueue.contains(text)) {
        return null; // Already requested.
      }

      // If there are more than 4 requests already in progress,
      // run the request on the lowest priority thread
      if (normalQueue.length > 4) {
        return ThreadRunner.verySlow;
      }
    }
    return priority;
  }

  /// Adds criteria to a collection of currently processing requests.
  @override
  void initialiseThreadCacheRequest(
    String priority,
    int? limit,
  ) {
    // Track and throttle low priority requests
    final text = criteria.toPrintableString();
    if (ThreadRunner.verySlow == priority) {
      verySlowQueue.add(text);
    } else {
      normalQueue.add(text);
    }
    // ignore: parameter_assignments
    limit ??= QueryIMDBNameDetails.defaultSearchResultsLimit;
  }

  /// Perform any class specific request tracking.
  @override
  void completeThreadCacheRequest(String priority) {
    final text = criteria.toPrintableString();
    normalQueue.remove(text);
    verySlowQueue.remove(text);
  }

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
  @override
  @factory
  WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> myClone(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBNameDetails(criteria);

  @override
  @visibleForTesting
  Future<void> clearThreadedCache() async {
    // ignore: invalid_use_of_visible_for_testing_member
    await super.clearThreadedCache();
    normalQueue.clear();
    verySlowQueue.clear();
  }
}
