import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';

import 'test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
///     WebJsonExtractor uses a HeadlessInAppWebView
/// which requires a real android device or emulator or web to run
/// hence this is an integration test with a full MyApp widget.
///
/// Android device must be connected or launch from the command line with:
/// flutter test integration_test/web_fetch_imdb_json_filtered_integration_test.dart -d 192.168.0.33:41471
/// flutter test integration_test/web_fetch_imdb_json_filtered_integration_test.dart -d chrome
///
/* flutter drive \
  --driver=integration_test/driver.dart \
  --target=integration_test/web_fetch_imdb_json_filtered_integration_test.dart \
  -d chrome --headless --chrome-binary-flags="--no-sandbox" */
////////////////////////////////////////////////////////////////////////////////

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBJsonDetails test', () {
    // Convert 3 IMDB pages into dtos.
    testWidgets('Run read 2 json queries from IMDB', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await warmUpHeadlessEngine();
      await tester.pumpAndSettle();

        final expectedOutput = await readIntegrationTestData();

      final actualOutput = await _testRead(['nm0000233', 'nm0000149']);
      final sampleOutput = sampleTestData(
        actualOutput,
        relatedSampleQuantity: 5,
      );
      late MovieResultDTO actualOutput233;
      late MovieResultDTO actualOutput149;
      if (actualOutput.first.uniqueId == 'nm0000233') {
        actualOutput233 = actualOutput.first;
        actualOutput149 = actualOutput.last;
      } else {
        actualOutput149 = actualOutput.first;
        actualOutput233 = actualOutput.last;
      }

      // To update expected data, uncomment the following lines
      // print(actualOutput.first.related.values.first.length);
      // print(actualOutput.last.related.values.first.length);
      // printTestDataJson(sampleOutput);

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
        actualOutput233.related['Actor:']?.length,
        greaterThanOrEqualTo(40),
        reason:
            'Quinten should have 41 Actor credits but the data says '
            '${actualOutput.first.title}-'
            '${actualOutput.first.related.keys.first}'
            '${actualOutput.first.related.values.first.length}'
            '${actualOutput.last.title}-'
            '${actualOutput.last.related.keys.first}'
            '${actualOutput.last.related.values.first.length}',
      );
      expect(
        actualOutput149.related['Actress:']?.length,
        greaterThanOrEqualTo(80),
        reason:
            'Jodie Foster should have 84 Actress credits but the data says '
            '${actualOutput.first.title}-'
            '${actualOutput.first.related.keys.first}:'
            '${actualOutput.last.related.values.first.length}',
      );
      },
      timeout: const Timeout(Duration(seconds: 60)),
      // This test uses flutter_inappwebview which is configured for Android.
      skip: !Platform.isAndroid,
    );
    testWidgets('Run an empty search', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await warmUpHeadlessEngine();
      await tester.pumpAndSettle();

      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryIMDBJsonCastDetails(
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
      timeout: const Timeout(Duration(seconds: 60)),
      // This test uses flutter_inappwebview which is configured for Android.
      skip: !Platform.isAndroid,
    );
  });
}

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

/// Call IMDB for each criteria in the list.
Future<List<Future<List<MovieResultDTO>>>> _queueDetailSearch(
  List<String> queries,
) async {
  final futures = <Future<List<MovieResultDTO>>>[];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    futures.add(QueryIMDBJsonPaginatedFilmographyDetails(criteria).readList());
    // Pause between queries to avoid overwhelming the IMDB server.
    //await Future<void>.delayed(const Duration(seconds: 5));
  }
  return futures;
}

Future<List<MovieResultDTO>> _testRead(List<String> criteria) async {
  // Call IMDB for each criteria in the list.
  final futures = await _queueDetailSearch(criteria);

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
