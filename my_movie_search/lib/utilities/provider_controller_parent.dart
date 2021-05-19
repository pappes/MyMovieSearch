library pappes.utilites;

import 'package:universal_io/io.dart'
    show HttpClient, HttpHeaders; // limit inclusions to reduce size

import 'package:my_movie_search/utilities/provider_controller.dart';
import 'package:my_movie_search/utilities/online_offline_search.dart';

typedef FutureOr<Stream<String>> DataSourceFn(String s);
typedef List TransformFn(Map? map);

/// Extend ProviderController to provide a dynamically switchable stream of <T>
/// from online and offline sources.
///
/// Classes extending ProviderController can be interchanged
/// making it easy to switch datasource
/// without changing the rest of the application.
///
/// Workflow delegated to child class:
///   web/file -> Json via [offlineData] or [constructURI]
///   Json(Map) -> Objects of type T via [transformMap]
///   Exception handling via [constructError]
abstract class ProviderController<T> {
  SearchCriteriaDTO? criteria;

  /// Populate [StreamController] with data matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  void populate(StreamController<T> sc, SearchCriteriaDTO criteria,
      {DataSourceFn? source}) async {
    this.criteria = criteria;
    (await fetch(source: source)).pipe(sc);
  }

  /// Return a list with data matching [criteria].
  ///
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  Future<List<T>> read(SearchCriteriaDTO criteria,
      {DataSourceFn? source}) async {
    this.criteria = criteria;
    var results = fetch(source: source);
    return (await results).toList();
  }

  /// Create a stream with data matching [criteria].
  Future<Stream<T>> fetch({DataSourceFn? source}) async {
    //TODO: use BloC patterns to test the stream processing
    final selecter = OnlineOfflineSelector<DataSourceFn>();

    source = selecter.select(source ?? streamResult, offlineData());
    // Need to await completion of future before we can transform it.
    //logger.i('got function, getting stream for ${dataSourceName()} using ${childClassDescriptor()}');
    var result = source(criteria!.criteriaTitle);
    final Stream<String> data = await result;
    //logger.i('got stream getting data');

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

  /// Convert a map of the response to a [List] of <T>.
  ///
  /// Used for both online and offline operation.
  ///
  /// Should be overridden by child classes.
  /// Should not be called directly by child classes,
  /// child classes call [transformMapSafe] as a wrapper to transformMap.
  List<T> transformMap(Map map);

  /// Generates an error message in the format of <T>.
  ///
  /// Used for both online and offline operation.
  ///
  /// Should be overridden by child classes.
  /// Called from [transformMapSafe] when [transformMap] throws an exception.
  T constructError(String contents);

  /// Define the [Uri] called to fetch online data for criteria [searchText].
  ///
  /// When pagination is not supported and [pageNumber] is not 1
  /// an empty Uri() must be returned.
  ///
  /// Should be overridden by child classes.
  Uri constructURI(String searchText, {int pageNumber = 1});

  /// Define the http headers to be passed to the web server.
  /// Returns a [Map] of header -> value.
  ///
  /// Can be overridden by child classes if required.
  void constructHeaders(HttpHeaders headers) {}

  /// Convert [Stream] of [String] to a stream containing a [List] of <T>.
  ///
  /// Used for both online and offline operation.
  /// For online operation [input] is utf8 decoded
  /// before being passed to transformStreaawait m().
  ///
  /// Can be overridden by child classes.
  /// Should call [transformMapSafe]
  /// to wrap [transformMap] in exception handling.
  Stream<List<T>> transformStream(Stream<String> input) async* {
    yield* input.transform(json.decoder).map(
        (decodedMap) => transformMapSafe(decodedMap as Map<dynamic, dynamic>?));
  }

  /// Describe the source of the data for the child class.
  ///
  /// Can be overridden by child classes.
  String childClassDescriptor() {
    return constructURI('criteria').toString();
  }

  /// Fetches and [utf8] decodes online data matching [criteria].
  ///
  /// The criteria does not need to be Uri encoded for safe searching.
  ///
  /// Should not be overridden by child classes.
  Future<Stream<String>> streamResult(String criteria) async {
    final encoded = Uri.encodeQueryComponent(criteria);
    final address = constructURI(encoded);

    logger.i('querying ${address.toString()}');
    final request = await HttpClient().getUrl(address);
    constructHeaders(request.headers);
    final response = await request.close();
    // TODO: check for HTTP status before transforming (avoid 404)
    return response.transform(utf8.decoder);
  }

  /// Convert a map of the response to a [List] of <T>.
  ///
  /// Used for both online and offline operation.
  /// Wraps [transformMap] in exception handling.
  ///
  /// Should not be overridden by child classes.
  List<T> transformMapSafe(Map? map) {
    if (map == null) {
      logger.i('0 results returned from query');
      return [];
    }
    try {
      var list = transformMap(map);
      //logger.i('${list.length} results returned from ${childClassDescriptor()}');
      return list;
    } catch (e) {
      logger.e('Exception raised during transformMap, constructing error'
          ' for ${map.toString()}\n ${e.toString()}.');
      logger.i('${this.runtimeType}].transformMapSafe stacktrace: '
          '${StackTrace.current}');
      var error =
          constructError('Could not interpret response ' '${map.toString()}');
      return [error];
    }
  }
}
