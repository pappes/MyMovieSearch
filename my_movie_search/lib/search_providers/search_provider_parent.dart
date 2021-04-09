import 'package:universal_io/io.dart'
    show HttpClient; // limit inclusions to reduce size

import 'package:my_movie_search/search_providers/search_provider.dart';
import 'package:my_movie_search/search_providers/online_offline_search.dart';

typedef Future<Stream<String>> DataSourceFn(String s);

/// Extend SearchProvider to provide a dynamically switchable stream of <T>
/// from online and offline sources.
///
/// Classes extending SearchProvider can be interchanged
/// making it easy to switch datasource
/// without changing the rest of the application.
///
/// Workflow delegated to child class:
///   web/file -> Json via [offlineData] or [constructURI]
///   Json(Map) -> Objects of type T via [transformMap]
///   Exception handling via [constructError]
abstract class SearchProvider<T> {
  /// Populate [StreamController] with data matching [criteria].
  ///
  /// Optionally inject alternate datasource for mocking/testing.
  executeQuery(StreamController<T> sc, SearchCriteriaDTO criteria,
      {DataSourceFn source}) async {
    //TODO: use BloC patterns to test the stream processing
    final selecter = OnlineOffline<DataSourceFn>();

    source = selecter.selectBetween(source ?? streamResult, offlineData());
    // Need to await completion of future before we can transform it.
    logger.i("got function, getting stream");
    final Stream<String> result = await source(criteria.criteriaTitle);
    logger.i("got stream getting data");

    transformStream(result)
        .expand((element) =>
            element) // Emit each element from the dto list as a seperate dto.
        .pipe(sc);
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
  List<T> constructError(String contents);

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
  Map constructHeaders() {
    return {};
  }

  /// Convert [Stream] of [String] to a stream containing a [List] of <T>.
  ///
  /// Used for both online and offline operation.
  /// For online operation [input] is utf8 decoded
  /// before being passed to transformStream().
  ///
  /// Can be overridden by child classes.
  /// Should call [transformMapSafe]
  /// to wrap [transformMap] in exception handling.
  Stream<List<T>> transformStream(Stream<String> input) {
    return input
        .transform(json.decoder)
        .map((decodedMap) => transformMapSafe(decodedMap));
  }

  /// Fetches and [utf8] decodes online data matching [criteria].
  ///
  /// The criteria does not need to be Uri encoded for safe searching.
  ///
  /// Should not be overridden by child classes.
  Future<Stream<String>> streamResult(String criteria) async {
    final encoded = Uri.encodeQueryComponent(criteria);
    final request = await HttpClient().getUrl(constructURI(encoded));
    final response = await request.close();
    return response.transform(utf8.decoder);
  }

  /// Convert a map of the response to a [List] of <T>.
  ///
  /// Used for both online and offline operation.
  /// Wraps [transformMap] in exception handling.
  ///
  /// Should not be overridden by child classes.
  List<T> transformMapSafe(Map map) {
    try {
      return transformMap(map);
    } catch (e) {
      logger.e("Exception raised during transformMap, constructing error.");
      logger.i(
          "${this.runtimeType}].transformMapSafe stacktrace: ${StackTrace.current}");
      return constructError("Could not interpret response ${map.toString()}");
    }
  }
}
