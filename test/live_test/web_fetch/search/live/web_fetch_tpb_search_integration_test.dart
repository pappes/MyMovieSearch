import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tpb_search.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real Tpb endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryTpbSearch test', () {
    // Search for a rare movie.
    test('Run a search on Tpb that is likely to have static results', () async {
      final criteria = SearchCriteriaDTO().fromString('shark.side.of.the.moon');
      final actualOutput = await QueryTpbSearch(criteria).readList(limit: 10);
      actualOutput.clearCopyrightedData();

      // Uncomment this line to update expectedOutput if sample data changes
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
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryTpbSearch(criteria).readList(limit: 10);
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
