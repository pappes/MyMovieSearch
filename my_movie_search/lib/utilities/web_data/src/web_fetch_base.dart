/// This library provides a framework for fetching different types of web data
/// in a concsistent manner.
library web_fetch;

import 'dart:async' show StreamController;
import 'dart:convert' show jsonDecode, utf8;

import 'package:html/parser.dart';
import 'package:meta/meta.dart';
import 'package:my_movie_search/utilities/extensions/stream_extensions.dart';

import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/jsonp_transformer.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_limiter.dart';
import 'package:universal_io/io.dart'
    show
        HttpClient,
        HttpClientResponse,
        HttpHeaders; // limit inclusions to reduce size

typedef DataSourceFn = Future<Stream<String>> Function(dynamic s);
typedef TransformFn = List Function(Map? map);

/// Fetch data from web sources (web services or web pages).
///
/// Extend [WebFetchBase] to provide a dynamically switchable stream of <[OUTPUT_TYPE]>
/// from online and offline sources.
///
/// Classes extending WebFetchBase can be interchanged
/// making it easy to switch data source
/// without changing the rest of the application
/// e.g. switching data source from from IMDB to TMDB.
///
/// Workflow delegated to child class:
/// * criteria
///   *  is converted to [Stream<Text>]
///   *  via [offlineData] or [baseConvertCriteriaToWebText]
/// * JSON, JSONP or HTML is converted to
///   *  is converted to [Map<Object?>]
///   *  via [offlineData] or [baseConvertWebTextToTraversableTree]
/// * [Map<Object?>]
///   *  is converted to Objects of type [OUTPUT_TYPE]
///   *  via [baseConvertTreeToOutputType]
/// * Exception handling via [myYieldError]
///
/// Naming convention for internal methods in this class:
///   myMethodName - should be overridden by child class
///   baseMethodName - should not need to be overridden by base class
/// Methods without these prefixes are intended for external use and should not be overridden
abstract class WebFetchBase<OUTPUT_TYPE, INPUT_TYPE> {
  INPUT_TYPE criteria;
  WebFetchLimiter searchResultsLimit = WebFetchLimiter();
  bool transformJsonP = false;
  // retry with exponential backoff 0.5 second -> 1 -> 2 -> 4 -> 8 seconds
  int retryDelay = 500;
  int maxDelay = 8000;
  // Online data source or offline data source.
  late DataSourceFn selectedDataSource = baseFetchWebText;

  WebFetchBase(this.criteria);

  String get getCriteriaText => myFormatInputAsText();
  String? get _getFetchContext =>
      '${myDataSourceName()} with criteria $getCriteriaText';

  /// Populate [StreamController] with [OUTPUT_TYPE] objects matching [criteria].
  ///
  /// Optionally inject [source] as an alternate data source for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  void populateStream(
    StreamController<OUTPUT_TYPE> sc, {
    DataSourceFn? source,
    int? limit,
  }) {
    void errorHandler(error, stackTrace) {
      logger.e(
        'Error in WebFetch populate: $error\n$stackTrace',
      );
      sc.add(myYieldError(error.toString()));
    }

    searchResultsLimit.limit = limit;
    try {
      baseYieldFetchedObjects(
        source: source,
      ).pipe(sc).onError(errorHandler);
    } catch (error, stackTrace) {
      errorHandler(error, stackTrace);
    }
  }

  /// Return a list of [OUTPUT_TYPE] objects matching [criteria].
  ///
  /// Optionally inject [source] as an alternate data source for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  @useResult
  Future<List<OUTPUT_TYPE>> readList({DataSourceFn? source, int? limit}) {
    searchResultsLimit.limit = limit;
    final list = baseYieldFetchedObjects(source: source).toList();
    return list;
  }

  /// Return a cached list of [OUTPUT_TYPE] objects matching [criteria].
  ///
  /// Optionally inject [source] as an alternate data source for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  @useResult
  Future<List<OUTPUT_TYPE>> readCachedList({DataSourceFn? source, int? limit}) {
    searchResultsLimit.limit = limit;
    if (myIsResultCached()) {
      return baseYieldFetchedObjects(
        source: source,
      ).toList();
    }
    return Future.value(<OUTPUT_TYPE>[]);
  }

  /// Convert dart [List] or [Map] or [document] to [OUTPUT_TYPE] object data.
  ///
  /// Must be overridden by child classes.
  /// resulting Object(s) are returned in a list
  /// to allow for Maps that contain multiple records.
  @visibleForOverriding
  Future<List<OUTPUT_TYPE>> myConvertTreeToOutputType(
    dynamic listOrMapOrDocument,
  );

  /// Convert web text to a traversable tree of [List] or [Map] data.
  ///
  /// Can be overridden by child classes.
  /// Default implementation is a simple JSON decode or html parse.
  ///
  /// For HTML text it is strongly recommended to override
  /// the default implementation skipping the json decode
  /// and extract the required html elements into a map
  /// (decode and extract content from the dom).
  ///
  /// Resulting Tree(s) are returned in a list to allow for web sources that
  /// return multiple chucks of results.
  @visibleForOverriding
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if ('' == webText) throw 'No content returned from web call';
    try {
      // Assume text is json encoded.
      final tree = jsonDecode(webText);
      return [tree];
    } catch (jsonException) {
      // Allow text to be HTML encoded if not json encoded
      final tree = parse(webText);
      if (tree.outerHtml == '<html><head></head><body>$webText</body></html>') {
        // If text is not valid json and not valid html then show the json error
        rethrow;
      }
      return [tree];
    }
  }

  /// Fetch text from the web source.
  ///
  /// Can be overridden by child classes.
  /// Default implementation pulls back and UTF8 decodes HTML or Json or JsonP.
  /// Data source can be offline or online data source as requested by calling function.
  /// online data fetches from the web URL defined by [myConstructURI].
  @visibleForOverriding
  Future<Stream<String>> myConvertCriteriaToWebText() async {
    final errors = StringBuffer();

    Stream<String> captureError(error, StackTrace _) {
      errors.writeln(baseConstructErrorMessage('fetching web text', error));
      return const Stream.empty();
    }

    final Future<Stream<String>> webData = selectedDataSource(criteria);
    final webStream = await webData.onError(captureError);
    if (errors.isNotEmpty) {
      return Stream.error(errors.toString());
    }

    if (transformJsonP) {
      return webStream.transform(JsonPDecoder());
    } else {
      return webStream;
    }
  }

  /// Describe where the data is coming from.
  ///
  /// Should be overridden by child classes.
  String myDataSourceName() => 'unknown';

  /// Define alternate [Stream] of data for offline operation.
  ///
  /// Implements return a function [DataSourceFn] which
  ///    accepts a [String] criteria and
  ///    asynchronously returns a [String] stream.
  ///
  /// Only called if [OnlineOffline] operation is enabled.
  ///
  /// Should be overridden by child classes.
  @visibleForOverriding
  DataSourceFn myOfflineData();

  /// Generates an error message in the format of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  ///
  /// Should be overridden by child classes.
  /// Called when an error occurs.
  @visibleForOverriding
  OUTPUT_TYPE myYieldError(String contents);

  /// Define the [Uri] called to fetch online data for criteria [searchText].
  ///
  /// When pagination is not supported and [pageNumber] is not 1
  /// an empty Uri() must be returned.
  ///
  /// Should be overridden by child classes.
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1});

  /// converts [criteria] as a string representation.
  ///
  /// Can be overridden by child classes.
  /// If this is blank the query will not run!
  String myFormatInputAsText() => criteria?.toString() ?? '';

  /// Extracts page number from [criteria]
  ///
  /// Can be overridden by child classes.
  /// If this is blank the query will not run!
  int myGetPageNumber() => 1;

  /// Define the http headers to be passed to the web server.
  /// Returns a [Map] of header -> value.
  ///
  /// Can be overridden by child classes if required.
  @visibleForOverriding
  void myConstructHeaders(HttpHeaders headers) {}

  /// Check cache to see if data has already been fetched.
  ///
  /// Can be overridden by child classes if required.
  @visibleForOverriding
  bool myIsResultCached() => false;

  /// Check cache to see if data in cache should be refreshed.
  ///
  /// Can be overridden by child classes if required.
  @visibleForOverriding
  bool myIsCacheStale() => false;

  /// Insert transformed data into cache.
  ///
  /// Can be overridden by child classes if required.
  @visibleForTesting // and for override!
  Future<void> myAddResultToCache(
    OUTPUT_TYPE fetchedResult,
  ) async {}

  /// Flush all data from the cache.
  ///
  /// Can be overridden by child classes if required.
  @visibleForTesting // and for override!
  void myClearCache() {}

  /// Prevent response parsing for http errors.
  ///
  /// Returning null will allow standard processing.
  ///
  /// Can be overridden by child classes if required.
  @visibleForTesting // and for override!
  Stream<String>? myHttpError(
    Uri address,
    int statusCode,
    HttpClientResponse response,
  ) {
    if (200 != statusCode) {
      final errorMsg =
          'Error in http read, HTTP status code : $statusCode for $address';
      logger.e(errorMsg);
      return Stream.error(errorMsg);
    }
    return null;
  }

  /// Retrieve cached result.
  ///
  /// Can be overridden by child classes if required.
  @visibleForOverriding
  List<OUTPUT_TYPE> myFetchResultFromCache() => [];

  /// Convert a HTML, JSON or JSONP [Stream] of [String]
  /// to a [Stream] of <OUTPUT_TYPE> objects.
  ///
  /// Should not be overridden by child classes.
  @visibleForTesting
  Stream<OUTPUT_TYPE> baseTransform() async* {
    try {
      final tree = baseConvertCriteriaToWebText();
      final map = baseConvertWebTextToTraversableTree(tree).printStream(
        'Output from ${myDataSourceName()}:${myFormatInputAsText()}->',
      );
      yield* baseConvertTreeToOutputType(map);
    } catch (error) {
      final errorMessage = baseConstructErrorMessage(
        'transform ${myFormatInputAsText()} to resulting object',
        error,
      );
      yield myYieldError(errorMessage);
    }
  }

  /// Fetch text from the web source with exception handling.
  ///
  /// Calls child class [myConvertCriteriaToWebText]
  /// Converts Future<Stream<String>> to Stream<String>
  @visibleForTesting
  Stream<String> baseConvertCriteriaToWebText() async* {
    final errors = <String>[];

    Stream<String> captureError(error, StackTrace _) {
      errors.add(
        baseConstructErrorMessage('fetching web text chunks', error),
      );
      return const Stream.empty();
    }

    yield* await myConvertCriteriaToWebText()
        .timeout(const Duration(seconds: 24)) // TODO: allow configurable
        .onError(captureError);
    for (final error in errors) {
      yield* Stream.error(error);
    }
  }

  /// Convert web text to a traversable tree of [List] or [Map] data with exception handling.
  ///
  /// Calls child class [myConvertWebTextToTraversableTree]
  /// Unpacks Stream<String> to a single String to make child class logic simpler
  /// Converts Future<List<Map>> to Stream<Map>
  @visibleForTesting
  Stream<dynamic> baseConvertWebTextToTraversableTree(
    Stream<String> webStream,
  ) async* {
    final errors = <String>[];
    List<String> captureError(error, String message) {
      final errorMessge = baseConstructErrorMessage(message, error);
      errors.add(errorMessge);
      return [];
    }

    List<String> captureStreamError(error, StackTrace _) =>
        captureError(error, 'stream error interpreting web text as a map');
    List<String> captureConvertError(error, StackTrace _) =>
        captureError(error, 'convert error interpreting web text as a map');

    final list = await webStream
        .handleError(captureStreamError)
        .timeout(const Duration(seconds: 25))
        .toList();
    final webText = list.join();
    final rawObjects = await myConvertWebTextToTraversableTree(webText)
        .onError(captureConvertError);

    for (final object in rawObjects) {
      yield object;
    }

    for (final error in errors) {
      yield* Stream.error(error);
    }
  }

  /// Convert dart [Map] to [OUTPUT_TYPE] object data with exception handling.
  ///
  /// Calls child class [myConvertTreeToOutputType]
  /// Unpacks Stream<Map> to Map to make child class logic simpler
  /// Converts Future<List<OUTPUT_TYPE>> to Stream<OUTPUT_TYPE>
  ///
  /// Limits the number of returned results to
  /// the limit requested by read() or populate().
  ///
  /// Should not be overridden by child classes.
  @visibleForTesting
  Stream<OUTPUT_TYPE> baseConvertTreeToOutputType(
    Stream<dynamic> pageMap,
  ) async* {
    final errors = <OUTPUT_TYPE>[];
    List<OUTPUT_TYPE> captureError(error, String message) {
      final errorMessge = baseConstructErrorMessage(message, error);
      errors.add(myYieldError(errorMessge));
      return [];
    }

    List<OUTPUT_TYPE> captureStreamError(error, StackTrace _) =>
        captureError(error, 'stream error translating page map to objects');
    List<OUTPUT_TYPE> captureConvertError(error, StackTrace _) =>
        captureError(error, 'convert error translating page map to objects');

    List<OUTPUT_TYPE> filterList(List<OUTPUT_TYPE> objects) {
      for (final object in objects) {
        myAddResultToCache(object);
      }
      // Construct result set with a subset of results.
      final capacity = searchResultsLimit.consume(objects.length);
      final subset = objects.take(capacity).toList();
      return subset;
    }

    final list = await pageMap.handleError(captureStreamError).toList();
    for (final rawObjects in list) {
      final processedObjects = await myConvertTreeToOutputType(rawObjects)
          .then(filterList)
          .onError(captureConvertError);
      for (final object in processedObjects) {
        yield object;
      }
    }

    if (errors.isNotEmpty) {
      yield* Stream.fromIterable(errors);
    }
  }

  /// Create a stream with data matching [criteria].
  ///
  /// Should not be overridden by child classes.
  /// Should not be called directly by child classes.
  @visibleForTesting
  Stream<OUTPUT_TYPE> baseYieldFetchedObjects({
    DataSourceFn? source,
  }) {
    final isCached = myIsResultCached();
    // if cached yield from cache
    if (isCached && !myIsCacheStale()) {
      logger.t(
        'base ${ThreadRunner.currentThreadName} '
        'value was cached ${myFormatInputAsText()}',
      );
      return Stream.fromIterable(myFetchResultFromCache());
    }
    if (myFormatInputAsText() == '') {
      return Stream.fromIterable([]);
    }
    // if not cached or cache is stale retrieve fresh data
    logger.t(
      'base ${ThreadRunner.currentThreadName} ${myDataSourceName()} '
      'uncached ${myFormatInputAsText()}',
    );

    searchResultsLimit.reset();

    final selector = OnlineOfflineSelector<DataSourceFn>();
    selectedDataSource = selector.select(
      source ?? baseFetchWebText,
      myOfflineData(),
    );

    final outputStream = baseTransform();
    return outputStream;
  }

  /// Fetches and [utf8] decodes online data matching [criteria].
  ///
  /// The criteria does not need to be Uri encoded for safe searching.
  ///
  /// Should not be overridden by child classes.
  @visibleForTesting
  Future<Stream<String>> baseFetchWebText(dynamic criteria) async {
    Uri address;
    HttpClientResponse response;

    try {
      criteria as INPUT_TYPE;
      final encoded = Uri.encodeQueryComponent(
        myFormatInputAsText(),
      );
      address = myConstructURI(encoded, pageNumber: myGetPageNumber());

      logger.t('requesting: $address');
      final client = await baseGetHttpClient().getUrl(address);
      myConstructHeaders(client.headers);
      final request = client.close();

      response = await request;
    } catch (error) {
      final errorMessage = baseConstructErrorMessage(
        'fetching web text:',
        error,
      );
      return Stream.error(errorMessage);
    }

    // Retry with exponential backoff for server errors
    if (response.statusCode >= 500 && retryDelay <= maxDelay) {
      final oldDelay = retryDelay;
      retryDelay = retryDelay * 2;
      return Future.delayed(Duration(milliseconds: oldDelay))
          .then((value) => baseFetchWebText(criteria));
    }

    // Check for successful HTTP status before transforming (avoid HTTP 404)
    return myHttpError(address, response.statusCode, response) ??
        response.transform(utf8.decoder);
  }

  /// Wrap raw error message in web_fetch context.
  ///
  /// Keeps existing error message if it is already wrapped in web_fetch context
  ///
  /// Should not be be overridden by child classes.
  @visibleForTesting
  String baseConstructErrorMessage(String context, dynamic error) {
    final boilerplate = 'Error in $_getFetchContext';
    final errorText = error.toString();
    if (errorText.startsWith(boilerplate)) return errorText;
    return '$boilerplate $context :$errorText';
  }

  /// Returns a new [HttpClient] instance to allow mocking in tests.
  ///
  /// Should not be be overridden by child classes.
  @visibleForTesting
  HttpClient baseGetHttpClient() => HttpClient();
}
