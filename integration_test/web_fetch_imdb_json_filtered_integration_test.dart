import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';

import '../test/test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

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

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final futures = <Future<List<MovieResultDTO>>>[];
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
  final queryResult = <String, MovieResultDTO>{};
  for (final future in futures) {
    for (final dto in await future) {
      if (queryResult.containsKey(dto.uniqueId)) {
        queryResult[dto.uniqueId]?.merge(dto);
      } else {
        queryResult[dto.uniqueId] = dto;
      }
    }
  }
  final unsorted = queryResult.values.toList()
    ..sort((l, r) => l.uniqueId.compareTo(r.uniqueId));
  return unsorted;
}

Future<void> main() async {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBJsonDetails test', () {
    // Convert 3 IMDB pages into dtos.
    testWidgets('Run read 2 json queries from IMDB', (tester) async {
      await tester.pumpWidget(const MyApp());

      final jsonString = await rootBundle.loadString(
        'integration_test/web_fetch_imdb_json_filtered_integration_test.json',
      );
      final expectedOutput = loadTestData(jsonString);

      final actualOutput =
          //<MovieResultDTO>[]; //
          await _testRead(['nm0000233', 'nm0000149']);
      final sampleOutput = sampleTestData(
        actualOutput,
        relatedSampleQuantity: 5,
      );

      // To update expected data, uncomment the following lines
      // print(actualOutput.first.related.values.first.length);
      // print(actualOutput.last.related.values.first.length);
      // printTestData(sampleOutput);
      final relatedLengths = <int>[
        actualOutput.first.related.values.first.length,
        actualOutput.last.related.values.first.length,
      ]..sort((a, b) => a.compareTo(b));

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
        greaterThanOrEqualTo(44),
        reason:
            'Quinten should have 44 Actor credits but the data says '
            '${actualOutput.first.related.keys.first}:'
            '${actualOutput.first.related.values.first.length}',
      );
      expect(
        relatedLengths.last,
        greaterThanOrEqualTo(88),
        reason:
            'Jodie Foster should have 88 Actress credits but the data says '
            '${actualOutput.first.related.keys.first}:'
            '${actualOutput.last.related.values.first.length}',
      );
    });
    testWidgets('Run an empty search', (tester) async {
      await tester.pumpWidget(const MyApp());
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
    });
  });
}
