import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_person_detail.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';
////////////////////////////////////////////////////////////////////////////////
/// Read from real TMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryTMDBPersonDetails test', () {
    // Convert 3 TMDB pages into dtos.
    test('Run read 3 pages from TMDB', () async {
      MovieResultDTOHelpers.resetError();

      final actualOutput = await executeMultipleFetches(
        (criteria) => QueryTMDBPersonDetails(criteria).readList(),
        qty: 10,
        prefix: '',
      );

      // To update expected data, uncomment the following line
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
    test('Run an IMDBid search', () async {
      MovieResultDTOHelpers.resetError();

      final criteria = SearchCriteriaDTO().fromString('nm0005346');
      final actualOutput = await QueryTMDBPersonDetails(
        criteria,
      ).readList(limit: 10);

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, testName: 'imdb');

      // Check the results.
      final expectedOutput = readTestData(testName: 'imdb');
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      MovieResultDTOHelpers.resetError();

      final criteria = SearchCriteriaDTO().fromString('0');
      final actualOutput = await QueryTMDBPersonDetails(
        criteria,
      ).readList(limit: 10);
      actualOutput.first.uniqueId = '-1';

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, testName: 'empty');

      // Check the results.
      final expectedOutput = readTestData(testName: 'empty');
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
