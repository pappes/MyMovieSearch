import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/data/search_criteria_mappers.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_formatting.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_transformation.dart';
import 'package:my_movie_search/movies/domain/models/search_criteria_transformation.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBSuggestions test', () {
    // Search for a rare movie.
    test('Run read 3 pages from IMDB', () async {
      final criteria = SearchCriteriaDTO().fromString('rize 2005');
      final actualOutput = await QueryIMDBSuggestions(criteria).readList();
      actualOutput.clearCopyrightedData();

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
    test('Run read multiple results from imdbSuggestions by imdbid', () async {
      final criteria = SearchCriteriaDTO().init(
        .movieDTOList,
        list: [
          MovieResultDTO().init(uniqueId: 'tt37071105'),
          MovieResultDTO().init(uniqueId: 'tt6992922'),
          MovieResultDTO().init(uniqueId: 'tt10443084'),
          MovieResultDTO().init(uniqueId: 'tt4712840'),
          MovieResultDTO().init(uniqueId: 'tt4051886'),
          MovieResultDTO().init(uniqueId: 'tt2714072'),
          MovieResultDTO().init(uniqueId: 'tt2271733'),
          MovieResultDTO().init(uniqueId: 'tt2291131'),
          MovieResultDTO().init(uniqueId: 'tt0497374'),
          MovieResultDTO().init(uniqueId: 'tt4799686'),
          MovieResultDTO().init(uniqueId: 'tt0358864'),
          MovieResultDTO().init(uniqueId: 'tt2887856'),
          MovieResultDTO().init(uniqueId: 'tt2887828'),
          MovieResultDTO().init(uniqueId: 'tt1997772'),
        ],
      );
      final actualOutput = await QueryIMDBSuggestions(
        criteria,
      ).readMultipleList();

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, testName: 'multiple_id');

      // Check the results.
      final expectedOutput = readTestData(testName: 'multiple_id');
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
      final actualOutput = await QueryIMDBSuggestions(
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
