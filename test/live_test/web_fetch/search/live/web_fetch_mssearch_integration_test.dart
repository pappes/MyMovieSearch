import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/ms_search.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real MsSearch endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryMsSearchMovies test', () {
    // Search for a rare movie.
    test('Run read 2 pages from MsSearch', () async {
      final criteria = SearchCriteriaDTO().fromString('humdrum');
      final actualOutput =
          await QueryMsSearchMovies(criteria).readList(limit: 1000);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
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
      Settings().init();
      await Settings().cloudSettingsInitialised;

      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryMsSearchMovies(criteria).readList(limit: 10);
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
