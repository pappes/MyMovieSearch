import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';

import 'test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Mock provider
////////////////////////////////////////////////////////////////////////////////

/// Make dummy dto results for offline queries.
List<MovieResultDTO> _makeExpectedResults(int qty) {
  final results = <MovieResultDTO>[];
  for (int i = 0; i < qty; i++) {
    final uniqueId = 1000 + i;
    results.add(
      {
        'source': DataSourceType.imdb.toString(),
        'uniqueId': '$uniqueId',
        'description': '$uniqueId.',
      }.toMovieResultDTO(),
    );
  }
  return results;
}

/// Make dummy html results for offline queries.
Stream<String> _getOffline(String id) async* {
  yield '''
<!DOCTYPE html>
<html
    <head>
      <script type="application/ld+json">{
        "description": "$id." }
      </script>
    </head>
    <body>
    </body>
</html>
''';
}

/// Make dummy html results for offline queries.
Future<Stream<String>> _offlineSearch(dynamic criteria) async {
  criteria as SearchCriteriaDTO;
  return _getOffline(criteria.criteriaTitle);
}

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (int i = 0; i < qty; i++) {
    results.add((1000 + i).toString());
  }
  return results;
}

/// Build a live IMDB url and route Javascript requests through a HTTP tunnel.
Uri constructURI(String searchText) {
  const baseURL = 'https://www.imdb.com/title/';
  const baseURLsuffix = '/?ref_=fn_tt_tt_1';
  final titleId = searchText.padLeft(7, '0');
  var url = '${baseURL}tt$titleId$baseURLsuffix';

  // Route web requests through a tunnel if using the Javascript
  // XMLHttpRequest http client library.
  if (kIsWeb) {
    url = 'http://localhost:8080?origin=https://www.imdb.com&'
        'referer=https://www.imdb.com/&'
        'destination=${Uri.encodeQueryComponent(url)}';
  }

  // ignore: avoid_print
  print('fetching redirected details $url');
  return Uri.parse(url);
}

/// Retrieve HTML from IMDB.
Future<Stream<String>> _onlineSearch(dynamic criteria) async {
  final SearchCriteriaDTO criteriaText = criteria as SearchCriteriaDTO;
  final encoded = Uri.encodeQueryComponent(criteriaText.criteriaTitle);
  final address = constructURI(encoded);

  final client = await HttpClient().getUrl(address);
  final request = client.close();

  HttpClientResponse response;
  try {
    response = await request;
  } catch (error, stackTrace) {
    // ignore: avoid_print
    print('Error in web_fetch read: $error\n${stackTrace.toString()}');
    rethrow;
  }
  // Check for successful HTTP status before transforming (avoid HTTP 404)
  if (200 != response.statusCode) {
    // ignore: avoid_print
    print(
      'Error in http read, HTTP status code : ${response.statusCode} for address',
    );
    return _offlineSearch(criteria);
  }
  return response.transform(utf8.decoder);
}

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(
  List<String> queries,
  bool online,
) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO();
    final imdbDetails =
        QueryIMDBTitleDetails(); //Seperate instance per search (async)
    criteria.criteriaTitle = queryKey;
    final future = imdbDetails.readList(
      criteria,
      source: online ? _onlineSearch : _offlineSearch,
    );
    futures.add(future);
  }
  return futures;
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchBase parent', () {
    Future<void> testRead(
      List<String> criteria,
      List<MovieResultDTO> expectedValue, {
      bool online = true,
    }) async {
      // Call IMDB for each criteria in the list.
      final futures = _queueDetailSearch(criteria, online);

      // Collect the result of all the IMDB queries.
      final queryResult = <MovieResultDTO>[];
      for (final future in futures) {
        future.then((value) => queryResult.addAll(value));
      }
      for (final future in futures) {
        await future;
      }

      // Compare IMDB results to expectations.
      if (!online) {
        expect(
          queryResult,
          MovieResultDTOListMatcher(expectedValue),
          reason: 'Emmitted DTO list ${queryResult.toString()} '
              'needs to match expected DTO list ${expectedValue.toString()}',
        );
      }
    }

    // Convert 1 sample offline page into a dto.
    test('Run read 1 offline page', () async {
      final queries = _makeQueries(1);
      final queryResult = _makeExpectedResults(queries.length);
      await testRead(queries, queryResult, online: false);
    });

    // Convert 300 sample offline pages into dtos.
    test('Run read 300 offline pages', () async {
      final queries = _makeQueries(300);
      final queryResult = _makeExpectedResults(queries.length);
      await testRead(queries, queryResult, online: false);
    });

    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from IMDB', () async {
      final queries = _makeQueries(3);
      final queryResult = _makeExpectedResults(queries.length);
      await testRead(queries, queryResult);
    });

    // Convert 300 IMDB pages into dtos!!!
    /* only run test occasionaly as it hammers IMDB
    test('Run read(300)', () async {
      var queries = _makeQueries(300);
      var queryResult = _makeExpectedResults(queries.length);
      await testRead(queries, queryResult);
    }, timeout: Timeout(Duration(seconds: 120)));
    */
  });
}
