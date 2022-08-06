library web_fetch;

import 'dart:async' show StreamController;
import 'dart:convert' show json, jsonDecode, utf8;

import 'package:html/parser.dart';

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
  INPUT_TYPE? criteria;
  WebFetchLimiter searchResultsLimit = WebFetchLimiter();
  bool transformJsonP = false;
  late DataSourceFn selectedDataSource =
      baseFetchWebText; // Online data source or offline data source.

  String? get getCriteriaText =>
      null == criteria ? 'NullCriteria' : myFormatInputAsText(criteria);
  String? get _getFetchContext =>
      '${myDataSourceName()} with criteria $getCriteriaText';

  /// Populate [StreamController] with [OUTPUT_TYPE] objects matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  void populateStream(
    StreamController<OUTPUT_TYPE> sc,
    INPUT_TYPE criteria, {
    DataSourceFn? source,
    int? limit,
  }) {
    void errorHandler(error, stackTrace) {
      logger.e(
        'Error in WebFetch populate: $error\n${stackTrace.toString()}',
      );
      sc.add(myYieldError(error.toString()));
    }

    searchResultsLimit.limit = limit;
    try {
      baseYieldFetchedObjects(
        source: source,
        newCriteria: criteria,
      ).pipe(sc).onError(errorHandler);
    } catch (error, stackTrace) {
      errorHandler(error, stackTrace);
    }
  }

  /// Return a list of [OUTPUT_TYPE] objects matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<OUTPUT_TYPE>> readList(
    INPUT_TYPE criteria, {
    DataSourceFn? source,
    int? limit,
  }) async {
    searchResultsLimit.limit = limit;
    final list = baseYieldFetchedObjects(
      source: source,
      newCriteria: criteria,
    ).toList();
    return list;
  }

  /// Return a cached list of [OUTPUT_TYPE] objects matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<OUTPUT_TYPE>> readCachedList(
    INPUT_TYPE criteria, {
    DataSourceFn? source,
    int? limit,
  }) async {
    searchResultsLimit.limit = limit;
    if (myIsResultCached(criteria)) {
      return baseYieldFetchedObjects(
        source: source,
        newCriteria: criteria,
      ).toList();
    }
    return <OUTPUT_TYPE>[];
  }

  /// Convert dart [List] or [Map] or [document] to [OUTPUT_TYPE] object data.
  ///
  /// Must be overridden by child classes.
  /// resulting Object(s) are returned in a list
  /// to allow for Maps that contain multiple records.
  Future<List<OUTPUT_TYPE>> myConvertTreeToOutputType(
    dynamic listOrMapOrDocument,
  );

  /// Convert webtext to a traversable tree of [List] or [Map] data.
  ///
  /// Can be overridden by child classes.
  /// Default implementation is a simple JSON decode or html parse.
  ///
  /// For HTML text it is stongly recommended to override
  /// the default implementation skipping the json decode
  /// and extract the required html elements into a map
  /// (decode and extract content from the dom).
  ///
  /// Resulting Tree(s) are returned in a list to allow for web sources that
  /// return multiple chucks of results.
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if ('' == webText) throw 'No content returned from web call';
    try {
      // Assume text is json encoded.
      final tree = jsonDecode(webText);
      return [tree];
    } catch (jsonException) {
      // Allow text to be HTML encoded if not json enecoded
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
  /// Datasource can be offline or online data source as requested by calling function.
  /// online data fetches from the web URL defined by [myConstructURI].
  Future<Stream<String>> myConvertCriteriaToWebText(INPUT_TYPE criteria) async {
    // Use a controller to allow the onError callback to populate the stream.
    final controller = StreamController<String>();
    bool returningError = false;

    Stream<String> _logError(error, stackTrace) {
      returningError = true;
      controller.addError(
        baseConstructErrorMessage('fetching web text', error),
      );
      baseCloseController(controller);
      return const Stream.empty();
    }

    final Future<Stream<String>> webData = selectedDataSource(criteria);
    final webStream = await webData.onError(_logError);
    if (returningError) return controller.stream;

    if (transformJsonP) {
      return webStream.transform(JsonPDecoder());
    } else {
      return webStream;
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
  /// Called when an error occures.
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
  void myAddResultToCache(INPUT_TYPE criteria, OUTPUT_TYPE fetchedResult) {}

  /// Flush all data from the cache.
  ///
  /// Can be overridden by child classes if required.
  void myClearCache() {}

  /// Retrieve cached result.
  ///
  /// Can be overridden by child classes if required.
  Stream<OUTPUT_TYPE> myFetchResultFromCache(INPUT_TYPE criteria) async* {}

  /// Convert a HTML, JSON or JSONP [Stream] of [String]
  /// to a [Stream] of <OUTPUT_TYPE> objects.
  ///
  /// Should not be overridden by child classes.
  Stream<OUTPUT_TYPE> baseTransform(
    INPUT_TYPE criteria,
  ) async* {
    try {
      final tree = baseConvertCriteriaToWebText(criteria);
      final map = baseConvertWebTextToTraversableTree(tree);
      yield* baseConvertTreeToOutputType(criteria, map);
    } catch (error) {
      final errorMessage = baseConstructErrorMessage(
        'transform ${criteria.toString()} to resulting object',
        error,
      );
      yield myYieldError(errorMessage);
    }
  }

  /// Fetch text from the web source with exception handling.
  ///
  /// Calls child class [myConvertCriteriaToWebText]
  /// Converts Future<Stream<String>> to Stream<String>
  Stream<String> baseConvertCriteriaToWebText(INPUT_TYPE criteria) async* {
    // Use a controller to allow callback functions to populate the stream.
    final controller = StreamController<String>();

    Stream<String> _logError(error, stackTrace) {
      controller.addError(
        baseConstructErrorMessage('fetching web text', error),
      );
      baseCloseController(controller);
      return const Stream<String>.empty();
    }

    Future<void> _yieldStream(Stream<String> text) async {
      await controller.addStream(text);
      baseCloseController(controller);
    }

    myConvertCriteriaToWebText(criteria)
        .timeout(Duration(seconds: 24)) // TODO: allow timeout to be passed in
        .then(_yieldStream)
        .onError(_logError);
    yield* controller.stream;
  }

  /// Convert webtext to a traversable tree of [List] or [Map] data with exception handling.
  ///
  /// Calls child class [myConvertWebTextToTraversableTree]
  /// Unpacks Stream<String> to a single String to make child class logic simpler
  /// Converts Future<List<Map>> to Stream<Map>
  Stream<dynamic> baseConvertWebTextToTraversableTree(
    Stream<String> webStream,
  ) async* {
    // Use a controller to allow callback functions to populate the stream.
    final controller = StreamController<dynamic>();

    void _addListToStream(List<dynamic> values) =>
        values.forEach(controller.add);

    List<dynamic> _logError(error, stackTrace) {
      final msg =
          baseConstructErrorMessage('intepreting web text as a map', error);
      controller.addError(msg);
      baseCloseController(controller);
      return [];
    }

    // Combine all HTTP chunks together for HTML parsing.
    // Use a StringBuffer to speed up reduce() processing time.
    // This is only called if the stream has multiple events!
    final content = StringBuffer();
    String _concatenate(String value, String text) {
      //Value will be blank after the first call
      if ('' != value) content.write(value);
      content.write(text);
      return '';
    }

    List<dynamic> _wrapChildFunction(String reduceResult) {
      // reduceResult will be empty if the stream had multiple events.
      final webText = ('' == reduceResult) ? content.toString() : reduceResult;
      print(webText);
      myConvertWebTextToTraversableTree(webText)
          .then(_addListToStream, onError: _logError);
      return [];
    }

    webStream
        .timeout(Duration(seconds: 25)) // TODO: allow timeout to be passed in
        .reduce(_concatenate)
        .then(_wrapChildFunction)
        .onError(_logError)
        .whenComplete(() => baseCloseController(controller));

    yield* controller.stream;
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

  Stream<OUTPUT_TYPE> baseConvertTreeToOutputType(
    INPUT_TYPE criteria,
    Stream<dynamic> pageMap,
  ) async* {
    // Use a controller to allow callback functions to populate the stream.
    final controller = StreamController<OUTPUT_TYPE>();

    List<OUTPUT_TYPE> _logError(error, stackTrace) {
      final errorMessage =
          baseConstructErrorMessage('translating pagemap to objects', error);
      final errorObject = myYieldError(errorMessage);
      controller.add(errorObject);
      return [];
    }

    List<OUTPUT_TYPE> _yieldList(List<OUTPUT_TYPE> objects) {
      for (final object in objects) {
        myAddResultToCache(criteria, object);
      }
      // Construct resultset with a subset of results.
      final capacity = searchResultsLimit.consume(objects.length);
      final subset = objects.take(capacity).toList();
      for (final object in subset) {
        controller.add(object);
      }
      return [];
    }

    void _wrapChildFunction(dynamic map) {
      myConvertTreeToOutputType(map).then(_yieldList).onError(_logError);
    }

    pageMap
        .timeout(Duration(seconds: 26)) // TODO: allow timeout to be passed in
        .listen(
          _wrapChildFunction,
          onDone: () => baseCloseController(controller),
          onError: _logError,
        );

    yield* controller.stream;
  }

  /// Create a stream with data matching [newCriteria].
  ///
  /// Should not be overridden by child classes.
  /// Should not be called directly by child classes.
  Stream<OUTPUT_TYPE> baseYieldFetchedObjects({
    required INPUT_TYPE newCriteria,
    DataSourceFn? source,
  }) async* {
    criteria = newCriteria;
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

      searchResultsLimit.reset();

      final selecter = OnlineOfflineSelector<DataSourceFn>();
      selectedDataSource = selecter.select(
        source ?? baseFetchWebText,
        myOfflineData(),
      );

      yield* baseTransform(newCriteria);
    }
  }

  /// Fetches and [utf8] decodes online data matching [criteria].
  ///
  /// The criteria does not need to be Uri encoded for safe searching.
  ///
  /// Should not be overridden by child classes.
  Future<Stream<String>> baseFetchWebText(dynamic criteria) async {
    Uri address;
    HttpClientResponse response;

    try {
      final encoded = Uri.encodeQueryComponent(
        myFormatInputAsText(criteria as INPUT_TYPE) ?? '',
      );
      address = myConstructURI(encoded);
      final client = await myGetHttpClient().getUrl(address);
      myConstructHeaders(client.headers);
      final request = client.close();

      response = await request;
    } catch (error, stackTrace) {
      final errorMessge = baseConstructErrorMessage(
        'fetching web text:',
        error,
      );
      return Stream.error(errorMessge);
    }
    // Check for successful HTTP status before transforming (avoid HTTP 404)
    if (200 != response.statusCode) {
      final errorMsg = 'Error in http read, '
          'HTTP status code : ${response.statusCode} for $address';
      logger.e(
        errorMsg,
      );
      return Stream.error(errorMsg);
    }
    return response.transform(utf8.decoder);
  }

  /// Wrap raw error message in web_fetch context.
  ///
  /// Keeps existing error message if it is already wrapped in web_fetch context
  ///
  /// Should not be be overridden by child classes.
  String baseConstructErrorMessage(String context, dynamic error) {
    final boilerplate = 'Error in $_getFetchContext';
    final errorText = error.toString();
    if (errorText.startsWith(boilerplate)) return errorText;
    return '$boilerplate $context :$errorText';
  }

  /// Allow queued async tasks to finish, then close the stream.
  ///
  /// Only required if using WhenComplete to close the stream and
  /// //using OnError to call child classes that can delay adding error
  /// Can be overridden by child classes.
  Future<void> baseCloseController(StreamController controller) async {
    await Future.delayed(const Duration(seconds: 1));
    controller.close();
  }

  /// Returns a new [HttpClient] instance to allow mocking in tests.
  ///
  /// Can be overridden by child classes.
  HttpClient myGetHttpClient() {
    return HttpClient();
  }
}
