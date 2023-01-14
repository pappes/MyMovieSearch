import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_person_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_person_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_person_detail.dart';
import 'package:my_movie_search/utilities/environment.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(dynamic dummy) {
  return Future.value(Stream.value('[{"hello":"world"}]'));
}

Future<Stream<String>> _emitInvalidJsonSample(dynamic dummy) {
  return Future.value(Stream.value('not valid json'));
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('tmdb details unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryTMDBPersonDetails().myDataSourceName(), 'tmdbPerson');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryTMDBPersonDetails().myFormatInputAsText(input),
        'testing',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO();
      input.criteriaList = [
        MovieResultDTO().error('test1'),
        MovieResultDTO().error('test2'),
      ];
      expect(
        QueryTMDBPersonDetails().myFormatInputAsText(input),
        contains('test1'),
      );
      expect(
        QueryTMDBPersonDetails().myFormatInputAsText(input),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'uniqueId': '-2',
        'bestSource': 'DataSourceType.tmdbPerson',
        'title': '[QueryTMDBDetails] new query',
        'type': 'MovieContentType.error',
        'related': {}
      };
      MovieResultDTOHelpers.resetError();

      // Invoke the functionality.
      final actualResult =
          QueryTMDBPersonDetails().myYieldError('new query').toMap();

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          QueryTMDBPersonDetails().myConvertWebTextToTraversableTree(
        tmdbJsonSearchFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('TmdbPersonDetailConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          TmdbPersonDetailConverter.dtoFromCompleteJsonMap(map as Map),
        );
      }

      final expectedValue = expectedDTOList;
      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryTMDBPersonDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () async {
      await EnvironmentVars.init();
      final testClass = QueryTMDBPersonDetails();
      testClass.myClearCache();
      const expected = 'https://api.themoviedb.org/3/person/1234?api_key=';

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI('1234').toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryTMDBPersonDetails
////////////////////////////////////////////////////////////////////////////////

  group('QueryTMDBPersonDetails integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final testClass = QueryTMDBPersonDetails();
      testClass.myClearCache();
      final expectedValue = expectedDTOList;
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          await testClass.myConvertTreeToOutputType(map),
        );
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () async {
      final testClass = QueryTMDBPersonDetails();
      testClass.myClearCache();

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      //NOTE: Using expect on an async result only works as the last line of the test!
      expect(
        actualResult,
        throwsA('expected map got String unable to interpret data wrongData'),
      );
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryTMDBPersonDetails
////////////////////////////////////////////////////////////////////////////////

  group('tmdb search query', () {
    // Read tmdb search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBPersonDetails();
      testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(
            SearchCriteriaDTO().fromString('123'),
            source: streamTmdbJsonOfflineData,
          )
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, ${stackTrace.toString()}'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });

    // Read tmdb search results from a simulated byte stream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBPersonDetails();
      const expectedException = '''
[QueryTMDBDetails] Error in tmdbPerson with criteria 123 interpreting web text as a map :FormatException: Unexpected character (at character 1)
not valid json
^
''';

      // Invoke the functionality.
      await testClass
          .readList(
            SearchCriteriaDTO().fromString('123'),
            source: _emitInvalidJsonSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read tmdb search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException = '[QueryTMDBDetails] Error in tmdbPerson '
          'with criteria 123 translating page map to objects '
          ':expected map got List<dynamic> unable to interpret data [{hello: world}]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBPersonDetails();

      // Invoke the functionality.
      await testClass
          .readList(
            SearchCriteriaDTO().fromString('123'),
            source: _emitUnexpectedJsonSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}