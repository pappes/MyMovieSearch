import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';

import 'test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
///     WebWebExtractor uses a HeadlessInAppWebView
/// which requires a real android device or emulator or web to run
/// hence this is an integration test with a full MyApp widget.
///
/// Android device must be connected or launch from the command line with:
/// flutter test integration_test/web_fetch_imdb_title_details_android_test.dart -d 192.168.0.33:41471
/// flutter test integration_test/web_fetch_imdb_title_details_android_test.dart -d chrome
/// flutter test integration_test/web_fetch_imdb_title_details_android_test.dart
///
/* not yet working
flutter drive \
  --driver=integration_test/driver.dart \
  --target=integration_test/web_fetch_imdb_title_details_android_test.dart \
  -d chrome --headless --chrome-binary-flags="--no-sandbox" */
////////////////////////////////////////////////////////////////////////////////

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Run read 3 pages from IMDB',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await warmUpHeadlessEngine();
      await tester.pumpAndSettle();

      // Convert 3 IMDB pages into dtos.
      final actualOutput = await executeMultipleFetches(
        (criteria) => QueryIMDBTitleDetails(criteria).readList(),
      );
      actualOutput.clearCopyrightedData();

      // To update expected data, uncomment the following line
      // printTestDataJson(actualOutput);

      // Check the results.
    final expectedOutput = await readIntegrationTestData();
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );

  testWidgets('Run an empty search', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await warmUpHeadlessEngine();
    await tester.pumpAndSettle();

    final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
    final actualOutput = await QueryIMDBTitleDetails(
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
  }, timeout: const Timeout(Duration(seconds: 60)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Html Extractor Integration Test')),
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
  Widget build(BuildContext context) => const Text('Html extractor');
}
