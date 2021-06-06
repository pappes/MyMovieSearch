library pappes.utilites;

import 'dart:async' show StreamController, FutureOr;
import 'dart:convert' show json, utf8;

import 'package:universal_io/io.dart'
    show HttpClient, HttpHeaders; // limit inclusions to reduce size

import 'online_offline_search.dart';

typedef FutureOr<Stream<String>> DataSourceFn(dynamic s);
typedef List TransformFn(Map? map);

const _DEFAULT_SEARCH_RESULTS_LIMIT = 100;

/// Extend ProviderController to provide a dynamically switchable stream of <OUTPUT_TYPE>
/// from online and offline sources.
///
/// Classes extending ProviderController can be interchanged
/// making it easy to switch datasource
/// without changing the rest of the application.
///
/// Workflow delegated to child class:
///   web/file -> Json via [offlineData] or [myConstructURI]
///   Json(Map) -> Objects of type OUTPUT_TYPE via [myTransformMapToOutput]
///   Exception handling via [myYieldError]
abstract class WebFetchBase<OUTPUT_TYPE, INPUT_TYPE> {
  INPUT_TYPE? _criteria;
  int? _searchResultsLimit;
  int _searchResultsreturned = 0;

  void baseTestSetCriteria(INPUT_TYPE criteria) => _criteria = criteria;
  void setSearchResultsLimit(int limit) => _searchResultsLimit = limit;
  String? get getCriteriaText => myFormatInputAsText(_criteria);
  int? get getSearchResultsLimit => _searchResultsLimit;

  /// Populate [StreamController] with data matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  void populateStream(StreamController<OUTPUT_TYPE> sc, INPUT_TYPE criteria,
      {DataSourceFn? source,
      int? limit = _DEFAULT_SEARCH_RESULTS_LIMIT}) async {
    var errorHandler = (error, stackTrace) =>
        print('Error in WebFetch populate: $error\n${stackTrace.toString()}');
    baseYieldWebText(
      source: source,
      criteria: criteria,
      resultSize: limit,
    ).pipe(sc).onError(errorHandler);
  }

  /// Return a list with data matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<OUTPUT_TYPE>> readList(INPUT_TYPE criteria,
      {DataSourceFn? source,
      int? limit = _DEFAULT_SEARCH_RESULTS_LIMIT}) async {
    return baseYieldWebText(
      source: source,
      criteria: criteria,
      resultSize: limit,
    ).toList();
  }

  /// Create a stream with data matching [criteria].
  Stream<OUTPUT_TYPE> baseYieldWebText({
    required INPUT_TYPE criteria,
    required int? resultSize,
    DataSourceFn? source,
  }) async* {
    _searchResultsreturned = 0;
    _criteria = criteria;
    _searchResultsLimit = resultSize;
    final selecter = OnlineOfflineSelector<DataSourceFn>();

    source = selecter.select(source ?? baseFetchWebText, myOfflineData());
    // Need to await completion of future before we can transform it.
    logger.v('got function, getting stream for ${myDataSourceName()} '
        'using ${myConstructURI(getCriteriaText ?? '').toString()}');
    var result = source(_criteria);
    final Stream<String> data = await result;
    logger.v('got stream getting data');

    // Emit each element from the list as a seperate element.
    yield* baseTransformTextStreamToOutput(data);
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

  /// Convert a map of the response to a [List] of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  ///
  /// Should be overridden by child classes.
  /// Should not be called directly by child classes,
  /// child classes call [baseTransformMapToOutputHandler] as a wrapper to transformMap.
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
  List<OUTPUT_TYPE> baseTransformMapToOutputHandler(Map? map) {
    List<OUTPUT_TYPE> retval = [];
    int remaining = double.maxFinite.toInt();
    if (map == null) {
      logger.i('0 results returned from query');
      return retval;
    }
    if (_searchResultsLimit != null) {
      remaining = _searchResultsLimit! - _searchResultsreturned;
    }
    if (remaining > 1) {
      try {
        var list = myTransformMapToOutput(map);
        _searchResultsreturned += list.length;
        logger.v('${list.length} results returned from ' // Verbose message/
            '${myDataSourceName()}');
        retval = list.take(remaining).toList();
      } catch (exception, stacktrace) {
        logger.e('Exception raised during transformMap, constructing error'
            ' for ${map.toString()}\n ${exception.toString()}.');
        logger.i('${this.runtimeType}].transformMapSafe stacktrace: '
            '${stacktrace.toString()}');
        var error =
            myYieldError('Could not interpret response ' '${map.toString()}');
        retval = [error];
      }
    }
    return retval;
  }

  /// Convert [Stream] of [String] to a stream of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  /// For online operation [str] is utf8 decoded
  /// before being passed to transformStream.
  ///
  /// Can be overridden by child classes.
  /// Should call [baseTransformMapToOutputHandler]
  /// to wrap [myTransformMapToOutput] in exception handling.
  Stream<OUTPUT_TYPE> baseTransformTextStreamToOutput(
      Stream<String> str) async* {
    var fnFromMapToListOfOutputType = (decodedMap) =>
        baseTransformMapToOutputHandler(decodedMap as Map<dynamic, dynamic>?);
    yield* str
        .transform(json.decoder)
        .map(fnFromMapToListOfOutputType)
        .expand((element) => element);
  }

  /// Fetches and [utf8] decodes online data matching [criteria].
  ///
  /// The criteria does not need to be Uri encoded for safe searching.
  ///
  /// Should not be overridden by child classes.
  Future<Stream<String>> baseFetchWebText(dynamic criteria) async {
    final encoded =
        Uri.encodeQueryComponent(myFormatInputAsText(criteria) ?? '');
    final address = myConstructURI(encoded);

    logger.d('querying ${address.toString()}');
    final client = await HttpClient().getUrl(address);
    myConstructHeaders(client.headers);
    final request = client.close();

    var response;
    try {
      response = await request;
    } catch (error, stackTrace) {
      print('Error in provider read $error\n${stackTrace.toString()}');
      rethrow;
    }
    // TODO: check for HTTP status before transforming (avoid 404)
    return response.transform(utf8.decoder);
  }
}
