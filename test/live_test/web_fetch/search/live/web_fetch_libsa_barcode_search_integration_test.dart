import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/data/search_criteria_mappers.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_formatting.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/libsa_barcode.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real QueryLibsaBarcodeSearch endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryLibsaBarcodeSearch test', () {
    // Search for a known movie.
    test(
      'Run a search on libsa that will hopefully have static results',
      () async {
        final criteria = SearchCriteriaDTO().fromString('9317731106354');
        final actualOutput = await QueryLibsaBarcodeSearch(
          criteria,
        ).readList(limit: 10);
        actualOutput.clearCopyrightedData();

        // Uncomment this line to update expectedOutput if sample data changes
        // writeTestData(actualOutput, testName: 'nodate');
        // writeTestData(actualOutput, testName: 'noimage');
        // writeTestData(actualOutput);

        // Check the results.
        final expectedOutput = readTestData();
        final expectedOutput2 = readTestData(testName: 'noimage');
        final expectedOutput3 = readTestData(testName: 'nodate');

        final goodMatch = MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          percentMatch: 60,
        );
        final noImageMatch = MovieResultDTOListFuzzyMatcher(
          expectedOutput2,
          percentMatch: 60,
        );
        final noDateMatch = MovieResultDTOListFuzzyMatcher(
          expectedOutput3,
          percentMatch: 60,
        );
        if (!goodMatch.matches(actualOutput, <Object?, Object?>{}) &&
            !noImageMatch.matches(actualOutput, <Object?, Object?>{}) &&
            !noDateMatch.matches(actualOutput, <Object?, Object?>{})) {
          expect(
            actualOutput,
            goodMatch,
            reason:
                'Emitted DTO list ${actualOutput.toPrintableString()} '
                'needs to match expected DTO list '
                '${expectedOutput.toPrintableString()}',
          );
        }
      },
    );
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryLibsaBarcodeSearch(
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
  }, skip: skipLiveGroup());
}
