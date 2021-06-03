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
///   web/file -> Json via [offlineData] or [constructURI]
///   Json(Map) -> Objects of type OUTPUT_TYPE via [transformMap]
///   Exception handling via [constructError]
abstract class WebFetch<OUTPUT_TYPE, INPUT_TYPE> {
  INPUT_TYPE? _criteria;
  int? _searchResultsLimit;
  int _searchResultsreturned = 0;

  void setCriteria(INPUT_TYPE criteria) => _criteria = criteria;
  void setSearchResultsLimit(int limit) => _searchResultsLimit = limit;
  String get getCriteriaText => toText(_criteria);
  int? get getSearchResultsLimit => _searchResultsLimit;

  /// Populate [StreamController] with data matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  void populate(StreamController<OUTPUT_TYPE> sc, INPUT_TYPE criteria,
      {DataSourceFn? source,
      int? limit = _DEFAULT_SEARCH_RESULTS_LIMIT}) async {
    _criteria = criteria;
    _searchResultsLimit = limit;
    (await fetch(source: source)).pipe(sc).onError((error, stackTrace) =>
        print('Error in provider populate $error\n${stackTrace.toString()}'));
  }

  /// Return a list with data matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<OUTPUT_TYPE>> read(INPUT_TYPE criteria,
      {DataSourceFn? source,
      int? limit = _DEFAULT_SEARCH_RESULTS_LIMIT}) async {
    _criteria = criteria;
    _searchResultsLimit = limit;
    var results = fetch(source: source);
    return (await results).toList();
  }

  /// Create a stream with data matching [criteria].
  Future<Stream<OUTPUT_TYPE>> fetch({DataSourceFn? source}) async {
    final selecter = OnlineOfflineSelector<DataSourceFn>();

    source = selecter.select(source ?? streamResult, offlineData());
    // Need to await completion of future before we can transform it.
    logger.v('got function, getting stream for ${dataSourceName()} '
        'using ${constructURI(_criteria.toString()).toString()}');
    var result = source(_criteria);
    final Stream<String> data = await result;
    logger.v('got stream getting data');

    // Emit each element from the list as a seperate element.
    return transformStream(data).expand((element) => element);
  }

  /// Describe where the data is comming from.
  ///
  /// Should be overridden by child classes.
  String dataSourceName() {
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
  DataSourceFn offlineData();

  /// Convert a map of the response to a [List] of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  ///
  /// Should be overridden by child classes.
  /// Should not be called directly by child classes,
  /// child classes call [transformMapSafe] as a wrapper to transformMap.
  List<OUTPUT_TYPE> transformMap(Map map);

  /// converts <INPUT_TYPE> to a string representation.
  ///
  /// should be overridden by child classes.
  String toText(dynamic contents) {
    return contents.toString();
  }

  /// Generates an error message in the format of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  ///
  /// Should be overridden by child classes.
  /// Called from [transformMapSafe] when [transformMap] throws an exception.
  OUTPUT_TYPE constructError(String contents);

  /// Define the [Uri] called to fetch online data for criteria [searchText].
  ///
  /// When pagination is not supported and [pageNumber] is not 1
  /// an empty Uri() must be returned.
  ///
  /// Should be overridden by child classes.
  Uri constructURI(String searchCriteria, {int pageNumber = 1});

  /// Define the http headers to be passed to the web server.
  /// Returns a [Map] of header -> value.
  ///
  /// Can be overridden by child classes if required.
  void constructHeaders(HttpHeaders headers) {}

  /// Convert [Stream] of [String] to a stream containing a [List] of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  /// For online operation [input_TYPE] is utf8 decoded
  /// before being passed to transformStreaawait m().
  ///
  /// Can be overridden by child classes.
  /// Should call [transformMapSafe]
  /// to wrap [transformMap] in exception handling.
  Stream<List<OUTPUT_TYPE>> transformStream(Stream<String> input_TYPE) async* {
    yield* input_TYPE.transform(json.decoder).map(
        (decodedMap) => transformMapSafe(decodedMap as Map<dynamic, dynamic>?));
  }

  /// Fetches and [utf8] decodes online data matching [criteria].
  ///
  /// The criteria does not need to be Uri encoded for safe searching.
  ///
  /// Should not be overridden by child classes.
  Future<Stream<String>> streamResult(dynamic criteria) async {
    final encoded = Uri.encodeQueryComponent(toText(criteria));
    final address = constructURI(encoded);

    logger.d('querying ${address.toString()}');
    final client = await HttpClient().getUrl(address);
    constructHeaders(client.headers);
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

  /// Convert a map of the response to a [List] of <OUTPUT_TYPE>.
  ///
  /// Used for both online and offline operation.
  /// Wraps [transformMap] in exception handling.
  ///
  /// Limits the number of returned results to
  /// the limit requested by read() or populate().
  ///
  /// Should not be overridden by child classes.
  List<OUTPUT_TYPE> transformMapSafe(Map? map) {
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
        var list = transformMap(map);
        _searchResultsreturned += list.length;
        logger.v('${list.length} results returned from ' // Verbose message/
            '${dataSourceName()}');
        retval = list.take(remaining).toList();
      } catch (exception, stacktrace) {
        logger.e('Exception raised during transformMap, constructing error'
            ' for ${map.toString()}\n ${exception.toString()}.');
        logger.i('${this.runtimeType}].transformMapSafe stacktrace: '
            '${stacktrace.toString()}');
        var error =
            constructError('Could not interpret response ' '${map.toString()}');
        retval = [error];
      }
    }
    return retval;
  }
}
