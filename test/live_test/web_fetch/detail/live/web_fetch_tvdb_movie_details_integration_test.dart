import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tvdb_common.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tvdb_movie_details.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';
////////////////////////////////////////////////////////////////////////////////
/// Read from real TVDB endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryTVDBMovieDetails test', () {
    // Convert 10 TVDB pages into dtos.
    test('Run read 1 detailed series page from TVDB', () async {
      await QueryTVDBCommon.init();
      final movieDto = MovieResultDTO()..type = MovieContentType.series;
      final criteria = SearchCriteriaDTO().fromString('397060')
        ..criteriaContext = movieDto;
      final actualOutput = await QueryTVDBMovieDetails(criteria).readList();
      // final actualOutput = await executeMultipleFetches(
      //   (criteria) => QueryTVDBMovieDetails(criteria).readList(),
      //   qty: 10,
      // );

      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, suffix: '_series.json');

      // Check the results.
      final expectedOutput = readTestData(suffix: '_series.json');
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    // Convert 10 TVDB pages into dtos.
    test('Run read 1 detailed movie page from TVDB', () async {
      await QueryTVDBCommon.init();
      final movieDto = MovieResultDTO()..type = MovieContentType.title;
      final criteria = SearchCriteriaDTO().fromString('5391')
        ..criteriaContext = movieDto;
      final actualOutput = await QueryTVDBMovieDetails(criteria).readList();
      // final actualOutput = await executeMultipleFetches(
      //   (criteria) => QueryTVDBMovieDetails(criteria).readList(),
      //   qty: 10,
      // );

      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, suffix: '_movie.json');

      // Check the results.
      final expectedOutput = readTestData(suffix: '_movie.json');
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('123123113123');
      await QueryTVDBCommon.init();
      final actualOutput = await QueryTVDBMovieDetails(
        criteria,
      ).readList(limit: 10);

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, suffix: '_empty.json');

      // Check the results.
      final expectedOutput = readTestData(suffix: '_empty.json');
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
