import 'dart:async';
import 'dart:convert';

import 'package:universal_io/io.dart'
    show HttpClient; // limit inclusions to reduce size

import 'package:my_movie_search/data_model/search_criteria_dto.dart';
import 'package:my_movie_search/search_providers/online_offline_search.dart';

typedef Future<Stream<String>> DataSourceFn(String s);

abstract class SearchProvider<T> {
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

  DataSourceFn offlineData() {
    logger.e("parent class needs to define offlineData()");
  }

  Stream<List<T>> transformStream(Stream<String> str) {
    logger.e("parent class needs to define transformStream()");
  }

  Future<Stream<String>> streamResult(String criteria) async {
    final client = HttpClient();
    final encoded = Uri.encodeQueryComponent(criteria);
    final request = await client.getUrl(constructURI(encoded));
    final response = await request.close();
    return response.asBroadcastStream().transform(utf8.decoder);
  }

  Uri constructURI(String searchText, {int pageNumber = 1}) {
    logger.e("parent class needs to define constructURI()");
  }
}
