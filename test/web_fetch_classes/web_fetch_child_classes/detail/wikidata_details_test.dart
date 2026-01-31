import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/wikidata_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/wikidata_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/wikidata_detail.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';
import '../../../test_helper.dart';

final imdbCriteria = SearchCriteriaDTO().fromString('tt1231');
void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
  ////////////////////////////////////////////////////////////////////////////////

  group('Wikidata details unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryWikidataDetails(imdbCriteria).myDataSourceName(),
        DataSourceType.wikidataDetail.name,
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO wikiid title', () {
      final criteria = SearchCriteriaDTO().fromString('Q123456');
      expect(
        QueryWikidataDetails(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });
    test('Run myFormatInputAsText() for SearchCriteriaDTO imdbid title', () {
      final criteria = SearchCriteriaDTO().fromString('tt123456');
      expect(
        QueryWikidataDetails(criteria).myFormatInputAsText(),
        '"${criteria.criteriaTitle}"',
      );
    });
    test('Run myFormatInputAsText() for SearchCriteriaDTO context', () {
      final criteria = SearchCriteriaDTO()..criteriaContext = MovieResultDTO();
      criteria.criteriaContext!.uniqueId = 'tt112233';
      expect(
        QueryWikidataDetails(criteria).myFormatInputAsText(),
        '"${criteria.criteriaContext!.uniqueId}"',
      );
    });
    test('Run myFormatInputAsText() for SearchCriteriaDTO list', () {
      final criteria = SearchCriteriaDTO();

      criteria.criteriaList.add(MovieResultDTO()..init(uniqueId: 'tt11111111'));
      criteria.criteriaList.add(MovieResultDTO()..init(uniqueId: 'tt22222222'));
      criteria.criteriaList.add(MovieResultDTO()..init(uniqueId: 'tt33333333'));
      criteria.criteriaList.add(MovieResultDTO()..init(uniqueId: 'tt44444444'));
      expect(
        QueryWikidataDetails(criteria).myFormatInputAsText(),
        '"tt11111111" "tt22222222" "tt33333333" "tt44444444" ',
      );
    });
    test('Run myFormatInputAsText() for SearchCriteriaDTO wiki url', () {
      final criteria = SearchCriteriaDTO().fromString(
        'https://www.wikidata.org/wiki/Q13794921',
      );
      expect(
        QueryWikidataDetails(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'uniqueId': '-2',
        'bestSource': 'DataSourceType.wikidataDetail',
        'title': '[QueryWikidataDetails] new query',
        'type': 'MovieContentType.error',
      };
      MovieResultDTOHelpers.resetError();

      // Invoke the functionality.
      final actualResult = QueryWikidataDetails(
        imdbCriteria,
      ).myYieldError('new query').toMap();

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      final expectedOutput = [jsonMovie];
      final actualOutput = QueryWikidataDetails(
        imdbCriteria,
        // valid to use for testing.
        // ignore: invalid_use_of_visible_for_overriding_member
      ).myConvertWebTextToTraversableTree(jsonEncode(jsonMovie));
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('WikidataDetailsConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap() for Movie', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in [jsonMovie]) {
        actualResult.addAll(
          WikidataDetailConverter().dtoFromCompleteJsonMap(map as Map),
        );
      }

      // Uncomment this line to update expectedDTOList if sample data changes
      //writeTestData(actualResult, testName: 'movie');

      final expectedValue = readTestData(testName: 'movie');
      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap() for Person', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in [jsonPerson]) {
        actualResult.addAll(
          WikidataDetailConverter().dtoFromCompleteJsonMap(map as Map),
        );
      }

      // Uncomment this line to update expectedDTOList if sample data changes
      // writeTestData(actualResult, testName: 'person');

      final expectedValue = readTestData(testName: 'person');
      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
  });
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryWikidataDetails uri tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI() for movie imdbid', () {
      final testClass = QueryWikidataDetails(imdbCriteria);
      final criteria = Uri.encodeQueryComponent('"tt1234"');
      const expected = 'http://query.wikidata.org/sparql';

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI(criteria).toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
    // Confirm URL is constructed as expected.
    test('Run myConstructURI() for person imdbid', () {
      final testClass = QueryWikidataDetails(imdbCriteria);
      final criteria = Uri.encodeQueryComponent('"nm1234"');
      const expected = 'http://query.wikidata.org/sparql';

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI(criteria).toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
    // Confirm URL is constructed as expected.
    test('Run myConstructURI() for wikidata web page', () {
      final testClass = QueryWikidataDetails(imdbCriteria);
      const expected =
          'https://www.wikidata.org/wiki/Special:EntityData/Q13794921.json';

      final criteria = Uri.encodeQueryComponent(
        'https://www.wikidata.org/wiki/Q13794921',
      );
      // Invoke the functionality.
      final actualResult = testClass.myConstructURI(criteria).toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
    // Confirm URL is constructed as expected.
    test('Run myConstructURI() for wikidata json page', () {
      final testClass = QueryWikidataDetails(imdbCriteria);
      const expected =
          'https://www.wikidata.org/wiki/Special:EntityData/Q13794921.json';
      final criteria = Uri.encodeQueryComponent(
        'https://www.wikidata.org/wiki/Special:EntityData/Q13794921.json',
      );

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI(criteria).toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
  });
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryWikidataDetails
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryWikidataDetails integration tests', () {
    // Confirm singleresult map can be converted to DTO.
    test('Run myConvertTreeToOutputType() single movie', () async {
      final testClass = QueryWikidataDetails(imdbCriteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in [jsonMovie]) {
        actualResult.addAll(await testClass.myConvertTreeToOutputType(map));
      }
      //writeTestData(actualResult, testName: 'movie');

      // Check the results.
      final expectedValue = readTestData(testName: 'movie');
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    test('Run myConvertTreeToOutputType() single series', () async {
      final testClass = QueryWikidataDetails(imdbCriteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in [jsonSeries]) {
        actualResult.addAll(await testClass.myConvertTreeToOutputType(map));
      }
      // writeTestData(actualResult, testName: 'series');

      // Check the results.
      final expectedValue = readTestData(testName: 'series');
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    // Confirm multipleresult map can be converted to DTO.
    test('Run myConvertTreeToOutputType() multi', () async {
      final testClass = QueryWikidataDetails(imdbCriteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in [jsonMultipleMovie]) {
        actualResult.addAll(await testClass.myConvertTreeToOutputType(map));
      }
      // writeTestData(actualResult, testName: 'multi_movie');

      // Check the results.
      final expectedValue = readTestData(testName: 'multi_movie');
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () {
      final expectedOutput = throwsA(
        isA<TreeConvertException>().having(
          (e) => e.cause,
          'cause',
          startsWith(
            'expected map got String unable to interpret data wrongData',
          ),
        ),
      );
      final testClass = QueryWikidataDetails(imdbCriteria);

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryWikidataDetails
  ////////////////////////////////////////////////////////////////////////////////

  group('Wikidata search query', () {
    // Read Wikidata search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryWikidataDetails(imdbCriteria);

      // Invoke the functionality.
      await testClass
          .readList(source: streamMovieJsonOfflineData)
          .then(queryResult.addAll)
          .onError(
            // Print any errors encountered during processing.
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      final expectedValue = readTestData(suffix: '_movie.json');
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
  });
}
