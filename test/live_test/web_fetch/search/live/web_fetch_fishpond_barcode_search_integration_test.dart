import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/fishpond_barcode.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real MagnetDb endpoint!
////////////////////////////////////////////////////////////////////////////////

const expectedDtoJsonStringListOld = [
  r'''
{"uniqueId":"DataSourceType.fishpondBarcode 9789461879530","bestSource":"DataSourceType.fishpondBarcode","alternateTitle":"Everything Everywhere All ­at Once (Nederland) ","type":"MovieContentType.barcode","sources":{"DataSourceType.fishpondBarcode":"DataSourceType.fishpondBarcode 9789461879530"}}
''',
];

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryFishpondBarcodeSearch test', () {
    // Search for a known movie.
    test(
      'Run a search on fishpond/mightyape that will hopefully have static results',
      () async {
        final expectedOutput = readTestData(
          'test/live_test/web_fetch/search/live/web_fetch_fishpond_barcode_search_integration_test.json',
        );

        final criteria = SearchCriteriaDTO().fromString('9789461879530');
        final actualOutput = await QueryFishpondBarcodeSearch(
          criteria,
        ).readList(limit: 10);
        actualOutput.clearCopyrightedData();

        // Uncomment this line to update expectedOutput if sample data changes
        // writeTestData(
        //   'test/live_test/web_fetch/search/live/web_fetch_fishpond_barcode_search_integration_test.json',
        //   actualOutput,
        // );

        // Check the results.
        expect(
          actualOutput,
          MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 60),
          reason:
              'Emitted DTO list ${actualOutput.toPrintableString()} '
              'needs to match expected DTO list '
              '${expectedOutput.toPrintableString()}',
        );
      },
    );
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryFishpondBarcodeSearch(
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
