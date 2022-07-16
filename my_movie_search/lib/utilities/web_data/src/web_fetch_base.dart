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
///   *  via [offlineData] or [myConstructURI]
/// * JSON, JSONP or HTML is converted to
///   *  is converted to [Map<Object?>]
///   *  via [offlineData] or [myConstructURI]
/// * [Map<Object?>]
///   *  is converted to Objects of type [OUTPUT_TYPE]
///   *  via [myTransformMapToOutput]
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
  late DataSourceFn
      _selectedDataSource; // Online data source or offline data source.

  //void baseTestSetCriteria(INPUT_TYPE criteria) => _criteria = criteria;

  String? get getCriteriaText => myFormatInputAsText(criteria);
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
    }

    searchResultsLimit.limit = limit;
    baseYieldFetchedObjects(
      source: source,
      newCriteria: criteria,
    ).pipe(sc).onError(errorHandler);
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

  /// Convert dart [List] or [Map] to [OUTPUT_TYPE] object data.
  ///
  /// Must be overridden by child classes.
  /// resulting Object(s) are returned in a list to allow for Maps that
  /// contain multiple records.
  Future<List<OUTPUT_TYPE>> myConvertTreeToOutputType(Map map) async {
    return [];
  }

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
    try {
      // Assume text is json encoded.
      final tree = jsonDecode(webText);
      return [tree];
    } catch (jsonException) {
      try {
        // Allow text to be HTML encoded if not json enecoded
        final tree = parse(webText);
        return [tree];
      } catch (_) {
        // If text is not valid json and not valid html then show the json error
        throw jsonException;
      }
    }
  }

  /// Fetch text from the web source.
  ///
  /// Can be overridden by child classes.
  /// Default implementation pulls back and UTF8 decodes HTML or Json or JsonP.
  /// Datasource can be offline or online data source as requested by calling function.
  /// online data fetches from the web URL defined by [myConstructURI].
  Future<Stream<String>> myConvertCriteriaToWebText(INPUT_TYPE criteria) async {
    final selecter = OnlineOfflineSelector<DataSourceFn>();
    final selectedDataSource = selecter.select(
      baseFetchWebText,
      myOfflineData(),
    );
    final webStream = selectedDataSource(criteria);

    final controller = StreamController<String>();

    // Strip JSONP when future completes
    void _stripFutureJsonP(Future<Stream<String>> future) {
      void streamJson(Stream<String> jsonp) {
        controller.addStream(jsonp.transform(JsonPDecoder()));
      }

      future
        ..then(streamJson)
        ..whenComplete(() => baseCloseController(controller));
    }

    if (transformJsonP) {
      // Need completion of future before we can transform it.
      _stripFutureJsonP(webStream);
      return controller.stream;
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

  /// Flush all data from the cache.
  ///
  /// Can be overridden by child classes if required.
  void myClearCache() {}

  /// Retrieve cached result.
  ///
  /// Can be overridden by child classes if required.
  Stream<OUTPUT_TYPE> myFetchResultFromCache(INPUT_TYPE criteria) async* {}

  /// Convert a [Map] representation of the response to a [List] of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  ///
  /// Should be overridden by child classes.
  /// Should not be called directly by child classes.
  /// Child classes can call [baseTransformMapToOutputHandler]
  ///     as a wrapper to myTransformMapToOutput.
  List<OUTPUT_TYPE> myTransformMapToOutput(Map map);

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

    // Construct resultset with a subset of results
    if (!searchResultsLimit.limitExceeded) {
      try {
        final list = myTransformMapToOutput(resultMap);
        final capacity = searchResultsLimit.consume(list.length);
        for (final element in list) {
          myAddResultToCache(element);
        }
        retval = list.take(capacity).toList();
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

  /// Can be overridden by child classes to scrape web pages.
  /// Should call [baseTransformMapToOutputHandler]
  ///     to wrap [myTransformMapToOutput] in exception handling.
  /// ```dart
  ///@override
  ///Stream<MovieResultDTO> baseTransform(
  ///  Stream<String> str,
  ///) async* {
  ///  // Combine all HTTP chunks together for HTML parsing.
  ///  final content = await str.reduce((value, element) => '$value$element');
  ///  final document = parse(content);
  ///  final movieData = _scrapeWebPage(document);
  ///  yield* Stream.fromIterable(baseTransformMapToOutputHandler(movieData));
  ///}
  /// ```
  ///
  Stream<OUTPUT_TYPE> myTransformTextStreamToOutputObject(
    Stream<String> webStream,
  ) async* {
    yield* baseTransform(webStream);
  }

  /// Convert a HTML, JSON or JSONP [Stream] of [String]
  /// to a [Stream] of <OUTPUT_TYPE> objects.
  ///
  /// Used for both online and offline operation.
  /// For online operation [webStream] is utf8 decoded before being passed to
  ///     [baseTransformMapToOutputHandler].
  ///
  Stream<OUTPUT_TYPE> baseTransform(
    Stream<String> webStream,
  ) async* {
    // Private function to encapsulate stream transformation.
    // This single line of logic could be embedded in the below code
    // but would make the below code more cryptic.
    List<OUTPUT_TYPE> fnFromMapToListOfOutputType(decodedMap) {
      return baseTransformMapToOutputHandler(decodedMap as Map?);
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
        .expand((element) => element); // [<OUTPUT_TYPE>] to Stream<OUTPUT_TYPE>
  }

  /// Fetch text from the web source with exception handling.
  ///
  /// Calls child class [myConvertCriteriaToWebText]
  /// Converts Future<Stream<String>> to Stream<String>
  ///
  Stream<String> baseConvertCriteriaToWebText(
    INPUT_TYPE criteria,
  ) async* {
    final controller = StreamController<String>();

    void _logError(error, stackTrace) {
      logger.e(
        'Error in $_getFetchContext fetching web text'
        ' $error\n${stackTrace.toString()}',
      );
      baseCloseController(controller);
    }

    void _yieldStream(Stream<String> text) {
      controller.addStream(text);
    }

    myConvertCriteriaToWebText(criteria)
      ..then(_yieldStream, onError: _logError)
      ..whenComplete(() => baseCloseController(controller));

    yield* controller.stream;
  }

  /// Convert webtext to a traversable tree of [List] or [Map] data with exception handling.
  ///
  /// Calls child class [myConvertWebTextToTraversableTree]
  /// Unpacks Stream<String> to a single String to make child class logic simpler
  /// Converts Future<List<Map>> to Stream<Map>
  ///
  Stream<dynamic> baseConvertWebTextToTraversableTree(
    Stream<String> webStream,
  ) async* {
    final controller = StreamController<dynamic>();

    void _addListToStream(List<dynamic> values) {
      values.forEach(controller.add);
    }

    void _logError(error, stackTrace) {
      logger.e(
        'Error in $_getFetchContext intepreting web text as a map:'
        ' $error\n${stackTrace.toString()}',
      );
      baseCloseController(controller);
    }

    // Combine all HTTP chunks together for HTML parsing.
    // Use a StringBuffer to speed up reduce() processing time.
    final content = StringBuffer();
    String _concatenate(String value, String text) {
      content.write(text);
      return '';
    }

    void _wrapChildFunction(String ignoredInput) {
      print('should be empty  $ignoredInput');
      if ('' == ignoredInput) {
        myConvertWebTextToTraversableTree(content.toString())
          ..then(_addListToStream, onError: _logError)
          ..whenComplete(() => baseCloseController(controller));
      } else {
        // TODO: determine why _concatenate is not being called.
        myConvertWebTextToTraversableTree(ignoredInput)
          ..then(_addListToStream, onError: _logError)
          ..whenComplete(() => baseCloseController(controller));
      }
    }

    webStream.reduce(_concatenate).then(_wrapChildFunction);

    yield* controller.stream;
  }

  /// Convert dart [Map] to [OUTPUT_TYPE] object data with exception handling.
  ///
  /// Calls child class [myConvertTreeToOutputType]
  /// Unpacks Stream<Map> to Map to make child class logic simpler
  /// Converts Future<List<OUTPUT_TYPE>> to Stream<OUTPUT_TYPE>
  ///
  Stream<OUTPUT_TYPE> baseConvertTreeToOutputType(
    Stream<dynamic> pageMap,
  ) async* {
    final controller = StreamController<OUTPUT_TYPE>();

    void _logError(error, stackTrace) {
      logger.e(
        'Error in $_getFetchContext translating pagemap to objects:'
        ' $error\n${stackTrace.toString()}',
      );
    }

    void _yieldList(List<OUTPUT_TYPE> objects) {
      for (final obj in objects) {
        controller.add(obj);
      }
    }

    void _wrapChildFunction(dynamic map) {
      myConvertTreeToOutputType(map as Map)
        ..then(_yieldList, onError: _logError)
        ..whenComplete(() => baseCloseController(controller));
    }

    pageMap.listen(_wrapChildFunction);

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
      criteria = newCriteria;

      final selecter = OnlineOfflineSelector<DataSourceFn>();
      _selectedDataSource = selecter.select(
        source ?? baseFetchWebText,
        myOfflineData(),
      );
      // Need to await completion of future before we can transform it.
      final result = _selectedDataSource(newCriteria);
      try {
        final Stream<String> data = await result;
        yield* baseTransform(data);
      } catch (error, stacktrace) {
        yield myYieldError(error.toString());
      }

      // Emit each element from the list as a seperate element.
    }
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
      final errorMsg = 'Error in http read, '
          'HTTP status code : ${response.statusCode} for $address';
      logger.e(
        errorMsg,
      );
      // Rely upon child class to detect non conformant response and wrap it in an error.
      // TODO: throw
      throw errorMsg;
      //return Stream.value(errorMsg);
    }
    return response.transform(utf8.decoder);
  }

  /// Allow queued async tasks to finish, then close the stream.
  ///
  /// Can be overridden by child classes.
  Future<void> baseCloseController(StreamController controller) async {
    //
    await Future.delayed(const Duration(seconds: 2));
    controller.close();
  }

  /// Returns a new [HttpClient] instance to allow mocking in tests.
  ///
  /// Can be overridden by child classes.
  HttpClient myGetHttpClient() {
    return HttpClient();
  }
}
