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
  /// Only required if [OnlineOffline] operation is enabled.
  DataSourceFn offlineData() {
    logger.e("concrete class needs to define offlineData()");
  }

  /// Convert [Stream] of [String] to stream containing a [List] of <T>.
  ///
  /// Used for both online and offline operation.
  /// For online operation [str] is utf8 decoded
  /// before being passed to transformStream().
  Stream<List<T>> transformStream(Stream<String> str) {
    logger.e("concrete class needs to define transformStream()");
  }

  /// Define the [Uri] called to fetch online data for criteria [searchText].
  ///
  /// When pagination is not supported and [pageNumber] is not 1
  /// an empty Uri() must be returned.
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    logger.e("concrete class needs to define constructURI()");
    return Uri();
  }

  /// Fetches and [utf8] decodes online data matching [criteria].
  ///
  /// The criteria does not need to be Uri encoded for safe searching.
  Future<Stream<String>> streamResult(String criteria) async {
    final encoded = Uri.encodeQueryComponent(criteria);
    final request = await HttpClient().getUrl(constructURI(encoded));
    final response = await request.close();
    return response.transform(utf8.decoder);
  }
}
