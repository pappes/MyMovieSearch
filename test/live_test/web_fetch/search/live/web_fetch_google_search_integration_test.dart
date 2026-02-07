import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real Google endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryGoogleMovies test', () {
    // Search for a rare movie.
    test('Run read 4 results from Google', () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput = await QueryGoogleMovies(
        criteria,
      ).readList(limit: 1000);

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput);

      // Check the results.
      final expectedOutput = readTestData();
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 60),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    // Search for a rare movie.
    test('long title', () async {
      final datafile = getDataFileLocation(suffix: '_long_title.json');
      final criteria = SearchCriteriaDTO().fromString('tt13211062');
      final actualOutput = await QueryGoogleMovies(
        criteria,
      ).readList(limit: 1000);

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, location: datafile);

      // Check the results.
      final expectedOutput = readTestData(location: datafile);
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 60),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryGoogleMovies(
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
