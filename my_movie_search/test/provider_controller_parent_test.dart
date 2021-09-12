import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';

////////////////////////////////////////////////////////////////////////////////
/// Mock provider
////////////////////////////////////////////////////////////////////////////////
final _imdbHtmlSampleFull = r'''
<!DOCTYPE html>
<html
    <head>
      <script type="application/ld+json">{
        "description": "123." }
      </script>
    </head>
    <body>
    </body>
</html>
''';

List<String> _makeQueries(int qty) {
  List<String> results = [];
  for (int i = 0; i < qty; i++) {
    results.add('123');
  }
  return results;
}

List<MovieResultDTO> _makeResults(int qty) {
  List<MovieResultDTO> results = [];
  for (int i = 0; i < qty; i++) {
    results.add({
      'source': DataSourceType.imdb.toString(),
      'uniqueId': '123',
      'description': '123.',
    }.toMovieResultDTO());
  }
  return results;
}

Stream<String> _offlineSearch(String dummy) async* {
  await Future.delayed(const Duration(seconds: 10), () => "1");
  yield _imdbHtmlSampleFull;
}

Uri constructURI(String searchText, {int pageNumber = 1}) {
  final baseURL = 'https://www.imdb.com/title/';
  final baseURLsuffix = '/?ref_=fn_tt_tt_1';
  var url = '${baseURL}tt0451279$baseURLsuffix';
  print("fetching imdb details $url");

  url = 'http://localhost:8080?origin=https://www.imdb.com&'
      'referer=https://www.imdb.com/&'
      'destination=${Uri.encodeQueryComponent(url)}';
  return Uri.parse(url);
}

Future<Stream<String>> _onlineSearch(dynamic criteria) async {
  final encoded = Uri.encodeQueryComponent(criteria!.criteriaTitle);
  final address = constructURI(encoded);
  print("fetching redirected details ${address.toString()}");

  //logger.d('querying ${address.toString()}');
  final client = await HttpClient().getUrl(address);
  //constructHeaders(client.headers);
  final request = client.close();

  //await Future.delayed(const Duration(seconds: 10), () => "1");
  var response;
  try {
    response = await request;
  } catch (error, stackTrace) {
    print('Error in provider read $error\n${stackTrace.toString()}');
    rethrow;
  }
  // TODO: check for HTTP status before transforming (avoid 404)
  return response.transform(utf8.decoder);
  return _offlineSearch(criteria);
}

List<Future> _queueDetailSearch(List<String> queries) {
  List<Future> futures = [];
  queries.forEach((queryKey) {
    var criteria = SearchCriteriaDTO();
    final imdbDetails =
        QueryIMDBTitleDetails(); //Seperate instance per search (async)
    criteria.criteriaTitle = queryKey;
    futures.add(imdbDetails.readList(criteria, source: _onlineSearch));
  });
  return futures;
}

void main() async {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('provider controller parent', () {
    testRead(List<String> criteria, List<MovieResultDTO> expectedValue) async {
      var futures = _queueDetailSearch(criteria);

      List<MovieResultDTO> queryResult = [];
      futures.forEach((future) {
        future.then((value) => queryResult.addAll(value));
      });
      for (var future in futures) {
        await future;
      }
      /* expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emmitted DTO list ${queryResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );*/
    }

    test('Run read(3)', () async {
      var queries = _makeQueries(3);
      var queryResult = _makeResults(queries.length);
      await testRead(queries, queryResult);
    });

    test('Run read(300)', () async {
      var queries = _makeQueries(300);
      var queryResult = _makeResults(queries.length);
      await testRead(queries, queryResult);
    });
  });
}
