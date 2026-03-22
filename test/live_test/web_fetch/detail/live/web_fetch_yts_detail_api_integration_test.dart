import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/yts_detail_api.dart';
import 'package:quiver/iterables.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real YTS endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryYtsDetails test', () {
    // Test the website is up.
    test('Simple yifystatus test', () async {
      const url = 'https://yifystatus.com';

      final client = HttpClient()
        // Allow HttpClient to handle compressed data from web servers.
        ..autoUncompress = true;
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      final webPage = await response.transform(utf8.decoder).join();

      // Check the results.
      expect(
        webPage,
        contains('Current official domain:'),
        reason: 'unable to decode web page',
      );
    });
    // Test the API returns 404 for an invalid movie.
    test('Simple 404 test', () async {
      const url =
          'https://movies-api.accel.li/api/v2/movie_details.json?imdb_id=2000000000';

      final client = HttpClient()
        // Allow HttpClient to handle compressed data from web servers.
        ..autoUncompress = true;
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      final webPage = await response.transform(utf8.decoder).join();

      // Check the results.
      expect(
        webPage,
        contains(
          '{"status":"ok","status_message":"Query was successful","data":{',
        ),
        reason: 'unable to decode web page',
      );
    });
    // Convert 3 YTS pages into dtos.
    test('Run read 3 torrents from YTS', () async {
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);

      // To update expected data, uncomment the following lines
      // writeTestData(actualOutput);

      // Check the results.
      final expectedOutput = readTestData();
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 50),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('space odyssey')
        ..criteriaContext = MovieResultDTO().init(uniqueId: 'tt62622');
      final actualOutput = await QueryYtsDetailApi(criteria).readList();
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(expectedOutput),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
  });
}

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (final i in range(0, qty)) {
    results.add('tt002${1000 + i}');
  }
  results..add('tt0062622')
  ..add('tt2724064')
  ..add('tt6644286');
  return results;
}

/// Call YTS for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final futures = <Future<List<MovieResultDTO>>>[];
  for (final queryKey in queries) {
    final dto = MovieResultDTO().init(uniqueId: queryKey);
    final criteria = SearchCriteriaDTO().fromString(queryKey)
      ..criteriaContext = dto;
    final future = QueryYtsDetailApi(criteria).readList();
    futures.add(future);
  }
  return futures;
}

Future<List<MovieResultDTO>> _testRead(List<String> criteria) async {
  // Call webfetch for each criteria in the list.
  final futures = _queueDetailSearch(criteria);

  // Collect the result of all the IMDB queries.
  final queryResult = <MovieResultDTO>[];
  for (final future in futures) {
    queryResult.addAll(await future);
  }
  return queryResult;
}
