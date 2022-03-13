import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';

////////////////////////////////////////////////////////////////////////////////
/// Mock provider
////////////////////////////////////////////////////////////////////////////////

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
    final errorMesage =
        'Error in http read, HTTP status code : ${response.statusCode} for address';
    throw errorMesage;
  }
  return response.transform(utf8.decoder);
}

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO();
    final imdbDetails =
        QueryIMDBTitleDetails(); //Seperate instance per search (async)
    criteria.criteriaTitle = queryKey;
    final future = imdbDetails.readList(criteria, source: _onlineSearch);
    futures.add(future);
  }
  return futures;
}

Future<void> _testRead(List<String> criteria) async {
  // Call IMDB for each criteria in the list.
  final futures = _queueDetailSearch(criteria);

  // Collect the result of all the IMDB queries.
  final queryResult = <MovieResultDTO>[];
  for (final future in futures) {
    future.then((value) => queryResult.addAll(value));
  }
  for (final future in futures) {
    await future;
  }
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchBase parent', () {
    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from IMDB', () async {
      final queries = _makeQueries(3);
      await _testRead(queries);
    });
  });
}
