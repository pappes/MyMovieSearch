import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/wikidata_detail.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';
////////////////////////////////////////////////////////////////////////////////
/// Read from real wikidata endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryWikidataDetails test', () {
    test('Run read 1 detailed imdb movie page from wikidata', () async {
      final criteria = SearchCriteriaDTO().fromString('tt2724064');
      final actualOutput = await QueryWikidataDetails(criteria).readList();

      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, testName: 'imdb_movie');

      // Check the results.
      final expectedOutput = readTestData(testName: 'imdb_movie');
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run read 1 detailed imdb series page from wikidata', () async {
      final criteria = SearchCriteriaDTO().fromString('tt13443470');
      final actualOutput = await QueryWikidataDetails(criteria).readList();

      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, testName: 'imdb_series');

      // Check the results.
      final expectedOutput = readTestData(testName: 'imdb_series');
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run read multiple detailed imdb movie pages from wikidata', () async {
      final criteria = SearchCriteriaDTO();

      criteria.criteriaList.add(MovieResultDTO()..init(uniqueId: 'tt13443470'));
      criteria.criteriaList.add(MovieResultDTO()..init(uniqueId: 'nm0005346'));
      criteria.criteriaList.add(MovieResultDTO()..init(uniqueId: 'tt2724064'));
      criteria.criteriaList.add(MovieResultDTO()..init(uniqueId: 'tt28996126'));
      criteria.criteriaList.add(MovieResultDTO()..init(uniqueId: 'tt15253488'));
      final actualOutput = await QueryWikidataDetails(criteria).readList();

      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, testName: 'imdb_movies');

      // Check the results.
      final expectedOutput = readTestData(testName: 'imdb_movies');
      expect(
        actualOutput,
        MovieResultDTOListMatcher(expectedOutput),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run read 1 detailed person page from wikidata', () async {
      final criteria = SearchCriteriaDTO().fromString(
        'https://www.wikidata.org/wiki/Q211082',
      );
      final actualOutput = await QueryWikidataDetails(criteria).readList();

      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, testName: 'person');

      // Check the results.
      final expectedOutput = readTestData(testName: 'person');
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run read 1 detailed movie page from wikidata', () async {
      final criteria = SearchCriteriaDTO().fromString(
        'https://www.wikidata.org/wiki/Q13794921',
      );
      final actualOutput = await QueryWikidataDetails(criteria).readList();

      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, testName: 'movie');

      // Check the results.
      final expectedOutput = readTestData(testName: 'movie');
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run read 1 detailed series page from wikidata', () async {
      final criteria = SearchCriteriaDTO().fromString(
        'https://www.wikidata.org/wiki/Q253205',
      );
      final actualOutput = await QueryWikidataDetails(criteria).readList();

      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, testName: 'series');

      // Check the results.
      final expectedOutput = readTestData(testName: 'series');
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
      final criteria = SearchCriteriaDTO().fromString('https://www.wikidata.org/wiki/Q13794921123123');
      final actualOutput = await QueryWikidataDetails(
        criteria,
      ).readList(limit: 10);

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
