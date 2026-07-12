import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/data/search_criteria_mappers.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_formatting.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_transformation.dart';
import 'package:my_movie_search/movies/domain/models/search_criteria_transformation.dart';
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
  setUpAll(() => Settings().init(includeCloudSettings: false));
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryGoogleMovies test', () {
    // Search for a rare movie.
    test('Run read 4 results from Google by title', () async {
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
    test('Run read multiple results from Google by imdbid', () async {
      final criteria = SearchCriteriaDTO().init(
        .movieDTOList,
        list: [
          //        "title": "Google Custom Search - tt37071105 OR tt6992922 OR tt10443084 OR tt4712840 OR tt4051886 OR tt2714072 OR tt2271733 OR tt2291131 OR tt0497374 OR tt4799686 OR tt0358864 OR tt2887856 OR tt2887828 
          //OR tt1997772 ",
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
          MovieResultDTO().init(uniqueId: 'tt1997772')
        ],
      );
      final actualOutput = await QueryGoogleMovies(criteria).readMultipleList();

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
