import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';

import '../test/test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
///     WebJsonExtractor uses a HeadlessInAppWebView
/// which requires a real android device or emulator to run
/// hence this is an integration test with a full MyApp widget.
///
/// Android device must be connected or launch from the command line with:
/// flutter test integration_test/web_fetch_imdb_json_paginated_integration_test.dart -d 192.168.0.33:41471
////////////////////////////////////////////////////////////////////////////////


void main() {
  // Ensure the platform bindings are initialized for the integration test.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBJsonDetails test', () {
    // Convert 3 IMDB pages into dtos.
    test(
      'Run read 10 json queries from QueryIMDBJsonPaginatedFilmographyDetails',
      () async {
        final actualOutput = await _testRead(['nm0000233', 'nm0000149']);
        final sampleOutput = sampleTestData(
          actualOutput,
          relatedSampleQuantity: 5,
        );

        // To update expected data, uncomment the following lines
        /*printTestData(sampleOutput);
        print(actualOutput.first.related.values.first.length);
        print(actualOutput.last.related.values.first.length);*/
        final relatedLengths = <int>[
          actualOutput.first.related.values.first.length,
          actualOutput.last.related.values.first.length,
        ]..sort((a, b) => a.compareTo(b));

        final jsonString = await rootBundle.loadString(
          'integration_test/web_fetch_imdb_json_paginated_integration_test.json',
        );
        final expectedOutput = loadTestData(jsonString);
        // Check the results.
        expect(
          sampleOutput,
          MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 50),
          reason:
              'Emitted DTO list ${sampleOutput.toPrintableString()} '
              'needs to match expected DTO list '
              '${expectedOutput.toPrintableString()}',
        );
        expect(
          relatedLengths.first,
          greaterThanOrEqualTo(17),
          reason:
              'Quinten should have 17 Actor credits but the data says '
              '${actualOutput.first.related.keys.first}:'
              '${actualOutput.first.related.values.first.length}',
        );
        expect(
          relatedLengths.last,
          greaterThanOrEqualTo(69),
          reason:
              'Jodie Foster should have 69 Actress credits but the data says '
              '${actualOutput.first.related.keys.first}:'
              '${actualOutput.last.related.values.first.length}',
        );
      },
      timeout: const Timeout(Duration(seconds: 60)),
      // This test uses flutter_inappwebview which is configured for Android.
      skip: !Platform.isAndroid,
    );
    test(
      'Run an empty QueryIMDBJsonPaginatedFilmographyDetails search',
      () async {
        final criteria = SearchCriteriaDTO().fromString(
          'therearenoresultszzzz',
        );
        final actualOutput = await QueryIMDBJsonPaginatedFilmographyDetails(
          criteria,
        ).readList(limit: 10);
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
      },
    );
  });
}

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final futures =
      <Future<List<MovieResultDTO>>>[];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    futures.add(QueryIMDBJsonPaginatedFilmographyDetails(criteria).readList());
  }
  return futures;
}

Future<List<MovieResultDTO>> _testRead(List<String> criteria) async {
  // Call IMDB for each criteria in the list.
  final futures = _queueDetailSearch(criteria);

  // Collect the result of all the IMDB queries.
  final queryResult = <MovieResultDTO>[];
  for (final future in futures) {
    queryResult.addAll(await future);
  }
  return queryResult;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Json Extractor Integration Test')),
      body: const MyWebViewWidget(),
    ),
  );
}

class MyWebViewWidget extends StatefulWidget {
  const MyWebViewWidget({super.key});

  @override
  State<MyWebViewWidget> createState() => _MyWebViewWidgetState();
}

class _MyWebViewWidgetState extends State<MyWebViewWidget> {
  @override
  Widget build(BuildContext context) => const Text('Json extractor');
}
