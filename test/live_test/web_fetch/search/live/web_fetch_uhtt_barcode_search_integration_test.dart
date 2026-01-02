import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/uhtt_barcode.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real MagnetDb endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryUhttBarcodeSearch test', () {
    // Search for a known movie.
    test('Run a search on Tpb that is likely to have static results', () async {
      final criteria = SearchCriteriaDTO().fromString('9324915073425');
      final actualOutput =
          await QueryUhttBarcodeSearch(
        criteria,
      ).readList(limit: 10);
      actualOutput.clearCopyrightedData();

      // Uncomment this line to update expectedOutput if sample data changes
      // writeTestData(actualOutput);

      // Check the results.
      final expectedOutput = readTestData();
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          percentMatch: 60,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryUhttBarcodeSearch(criteria).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(
          expectedOutput,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
  });
}
