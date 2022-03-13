library pappes.utilites;

import 'dart:async' show StreamController, FutureOr;
import 'dart:convert' show json, utf8;
import 'dart:math';

import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/jsonp_transformer.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:universal_io/io.dart'
    show
        HttpClient,
        HttpClientResponse,
        HttpHeaders; // limit inclusions to reduce size

typedef DataSourceFn = FutureOr<Stream<String>> Function(dynamic s);
typedef TransformFn = List Function(Map? map);

const _defaultSearchResultsLimit = 100;

/// Extend [WebFetchBase] to provide a dynamically switchable stream of <[OUTPUT_TYPE]>
/// from online and offline sources.
///
/// Classes extending WebFetchBase can be interchanged
/// making it easy to switch data source
/// without changing the rest of the application
/// e.g. switching data source from from IMDB to TMDB.
///
/// Workflow delegated to child class:
///   JSON, JSONP or HTML from web/file -> Map<Object?> via [offlineData] or [myConstructURI]
///   Map<Object?> -> Objects of type [OUTPUT_TYPE] via [myTransformMapToOutput]
///   Exception handling via [myYieldError]
///
/// Naming convention for internal methods in this class:
///   myMethodName - should be overridden by child class
///   baseMethodName - should not need to be overridden by base class
/// Methods without these prefixes are intended for external use and should not be overridden
abstract class WebFetchBase<OUTPUT_TYPE, INPUT_TYPE> {
  INPUT_TYPE? criteria;
  int? searchResultsLimit;
  int _searchResultsreturned = 0;
  bool transformJsonP = false;

  //void baseTestSetCriteria(INPUT_TYPE criteria) => _criteria = criteria;

  String? get getCriteriaText => myFormatInputAsText(criteria);
  String? get _getFetchContext =>
      '${myDataSourceName()} with criteria $getCriteriaText';

  /// Populate [StreamController] with data matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  void populateStream(
    StreamController<OUTPUT_TYPE> sc,
    INPUT_TYPE criteria, {
    DataSourceFn? source,
    int? limit = _defaultSearchResultsLimit,
  }) {
    void errorHandler(error, stackTrace) {
      logger.e(
        'Error in WebFetch populate: $error\n${stackTrace.toString()}',
      );
    }

    baseYieldWebText(
      source: source,
      newCriteria: criteria,
      resultSize: limit,
    ).pipe(sc).onError(errorHandler);
  }

  /// Return a list with data matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<OUTPUT_TYPE>> readList(
    INPUT_TYPE criteria, {
    DataSourceFn? source,
    int? limit = _defaultSearchResultsLimit,
  }) async {
    final list = baseYieldWebText(
      source: source,
      newCriteria: criteria,
      resultSize: limit,
    ).toList();
    return list;
  }

  /// Return a list with data matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<OUTPUT_TYPE>> readCachedList(
    INPUT_TYPE criteria, {
    DataSourceFn? source,
    int? limit = _defaultSearchResultsLimit,
  }) async {
    if (myIsResultCached(criteria)) {
      return baseYieldWebText(
        source: source,
        newCriteria: criteria,
        resultSize: limit,
      ).toList();
    }
    return <OUTPUT_TYPE>[];
  }

  /// Create a stream with data matching [newCriteria].
  Stream<OUTPUT_TYPE> baseYieldWebText({
    required INPUT_TYPE newCriteria,
    required int? resultSize,
    DataSourceFn? source,
  }) async* {
    // if cached yield from cache
    if (myIsResultCached(newCriteria)) {
      print(
        'base ${ThreadRunner.currentThreadName} '
        'value was cached ${myFormatInputAsText(newCriteria)}',
      );
      yield* myFetchResultFromCache(newCriteria);
    }
    // if not cached or cache is stale retrieve fresh data
    if (!myIsResultCached(newCriteria) || myIsCacheStale(newCriteria)) {
      print(
        'base ${ThreadRunner.currentThreadName} ${myDataSourceName()} '
        'uncached ${myFormatInputAsText(newCriteria)}',
      );

      if (myFormatInputAsText(newCriteria) == 'nm0000243') {
        print(
          'base ${ThreadRunner.currentThreadName} base uncached '
          '${myFormatInputAsText(newCriteria)} ',
        );
      }
      _searchResultsreturned = 0;
      criteria = newCriteria;
      // apply the lowest supplied result size limit
      if (null == searchResultsLimit || null == resultSize) {
        searchResultsLimit = searchResultsLimit ?? resultSize;
      } else {
        searchResultsLimit = min(searchResultsLimit!, resultSize);
      }

      final selecter = OnlineOfflineSelector<DataSourceFn>();
      final selectedSource = selecter.select(
        source ?? baseFetchWebText,
        myOfflineData(),
      );
      // Need to await completion of future before we can transform it.
      final result = selectedSource(newCriteria);
      final Stream<String> data = await result;

      // Emit each element from the list as a seperate element.
      yield* myTransformTextStreamToOutputObject(data);
    }
  }

  /// Describe where the data is comming from.
  ///
  /// Should be overridden by child classes.
  String myDataSourceName() {
    return 'unknown';
  }

  /// Define alternate [Stream] of data for offline operation.
  ///
  /// Implements return a function [DataSourceFn] which
  ///    accepts a [String] criteria and
  ///    asynchronosly returns a [String] stream.
  ///
  /// Only called if [OnlineOffline] operation is enabled.
  ///
  /// Should be overridden by child classes.
  DataSourceFn myOfflineData();

  /// Generates an error message in the format of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  ///
  /// Should be overridden by child classes.
  /// Called from [baseTransformMapToOutputHandler] when [myTransformMapToOutput] throws an exception.
  OUTPUT_TYPE myYieldError(String contents);

  /// Define the [Uri] called to fetch online data for criteria [searchText].
  ///
  /// When pagination is not supported and [pageNumber] is not 1
  /// an empty Uri() must be returned.
  ///
  /// Should be overridden by child classes.
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1});

  /// converts <INPUT_TYPE> to a string representation.
  ///
  /// Can be overridden by child classes.
  String? myFormatInputAsText(INPUT_TYPE? contents) {
    return contents.toString();
  }

  /// Define the http headers to be passed to the web server.
  /// Returns a [Map] of header -> value.
  ///
  /// Can be overridden by child classes if required.
  void myConstructHeaders(HttpHeaders headers) {}

  /// Check cache to see if data has already been fetched.
  ///
  /// Can be overridden by child classes if required.
  bool myIsResultCached(INPUT_TYPE criteria) {
    return false;
  }

  /// Check cache to see if data in cache should be refreshed.
  ///
  /// Can be overridden by child classes if required.
  bool myIsCacheStale(INPUT_TYPE criteria) {
    return false;
  }

  /// Insert transformed data into cache.
  ///
  /// Can be overridden by child classes if required.
  void myAddResultToCache(OUTPUT_TYPE fetchedResult) {}

  /// Retrieve cached result.
  ///
  /// Can be overridden by child classes if required.
  Stream<OUTPUT_TYPE> myFetchResultFromCache(INPUT_TYPE criteria) async* {}

  /// Convert a [Map] representation of the response to a [List] of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  ///
  /// Should be overridden by child classes.
  /// Should not be called directly by child classes,
  /// Child classes can call [baseTransformMapToOutputHandler]
  ///     as a wrapper to myTransformMapToOutput.
  List<OUTPUT_TYPE> myTransformMapToOutput(Map map);

  /// Convert a HTML, JSON or JSONP [Stream] of [String]
  /// to a [Stream] of <OUTPUT_TYPE> objects.
  ///
  /// Used for both online and offline operation.
  /// For online operation [webStream] is utf8 decoded before being passed to
  ///     [baseTransformMapToOutputHandler].
  ///
  /// Can be overridden by child classes to scrape web pages.
  /// Should call [baseTransformMapToOutputHandler]
  ///     to wrap [myTransformMapToOutput] in exception handling.
  Stream<OUTPUT_TYPE> myTransformTextStreamToOutputObject(
    Stream<String> webStream,
  ) async* {
    // Private function to simplify stream transformation.
    List<OUTPUT_TYPE> fnFromMapToListOfOutputType(decodedMap) {
      return baseTransformMapToOutputHandler(
        decodedMap as Map<dynamic, dynamic>?,
      );
    }

    // Strip JSONP if required
    final Stream<String> jsonStream;
    if (transformJsonP) {
      jsonStream = webStream.transform(JsonPDecoder());
    } else {
      jsonStream = webStream;
    }

    yield* jsonStream
        .transform(json.decoder) // JSON text to Map<Object?>
        .map(fnFromMapToListOfOutputType) // Map<Object?> to List<OUTPUT_TYPE>
        .expand((element) => element); // List<TYPE> to Stream<TYPE)
  }

  /// Convert a map of the response to a [List] of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  /// Wraps [myTransformMapToOutput] in exception handling.
  ///
  /// Limits the number of returned results to
  /// the limit requested by read() or populate().
  ///
  /// Should not be overridden by child classes.
  List<OUTPUT_TYPE> baseTransformMapToOutputHandler(Map? resultMap) {
    List<OUTPUT_TYPE> retval = [];
    if (resultMap == null) {
      logger.i('0 results returned from query for $_getFetchContext');
      return retval;
    }

    int remaining = double.maxFinite.toInt(); // Default to unlimited results.
    if (searchResultsLimit != null) {
      remaining = searchResultsLimit! - _searchResultsreturned;
    }

    // Construct resultset with a subset of results
    if (remaining > 1) {
      try {
        final list = myTransformMapToOutput(resultMap);
        _searchResultsreturned += list.length;
        for (final element in list) {
          myAddResultToCache(element);
        }
        retval = list.take(remaining).toList();
      } catch (exception, stacktrace) {
        logger.e(
          'Exception raised during myTransformMapToOutput for _getFetchContext, '
          'constructing error for data ${resultMap.toString()}\n '
          '${exception.toString()}.',
        );
        logger.i(
          '$runtimeType .myTransformMapToOutput stacktrace: '
          '${stacktrace.toString()}',
        );
        final error = myYieldError(
          'Could not interpret response ' '${resultMap.toString()}',
        );
        retval = [error];
      }
    }
    return retval;
  }

  /// Fetches and [utf8] decodes online data matching [criteria].
  ///
  /// The criteria does not need to be Uri encoded for safe searching.
  ///
  /// Should not be overridden by child classes.
  Future<Stream<String>> baseFetchWebText(dynamic criteria) async {
    final encoded = Uri.encodeQueryComponent(
      myFormatInputAsText(criteria as INPUT_TYPE) ?? '',
    );
    final address = myConstructURI(encoded);

    final client = await myGetHttpClient().getUrl(address);
    myConstructHeaders(client.headers);
    final request = client.close();

    HttpClientResponse response;
    try {
      response = await request;
    } catch (error, stackTrace) {
      logger.e(
        'Error in $_getFetchContext fetching web text:'
        ' $error\n${stackTrace.toString()}',
      );
      rethrow;
    }
    // Check for successful HTTP status before transforming (avoid HTTP 404)
    if (200 != response.statusCode) {
      logger.e(
        'Error in http read, '
        'HTTP status code : ${response.statusCode} for $address',
      );
      final offlineFunction = myOfflineData();
      return offlineFunction(criteria);
    }
    return response.transform(utf8.decoder);
  }

  /// Returns a new [HttpClient] instance to allow mocking in tests.
  ///
  /// Can be overridden by child classes.
  HttpClient myGetHttpClient() {
    return HttpClient();
  }
}
