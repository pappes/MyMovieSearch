import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/google.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/google.dart';
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

  group('google search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryGoogleMovies().myDataSourceName(), 'google');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryGoogleMovies().myFormatInputAsText(input),
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
        QueryGoogleMovies().myFormatInputAsText(input),
        contains('test1'),
      );
      expect(
        QueryGoogleMovies().myFormatInputAsText(input),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'source': 'DataSourceType.google',
        'title': '[QueryGoogleMovies] new query',
        'type': 'MovieContentType.custom',
        'related': {}
      };

      // Invoke the functionality.
      final actualResult =
          QueryGoogleMovies().myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          QueryGoogleMovies().myConvertWebTextToTraversableTree(
        googleMoviesJsonSearchFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('GoogleMovieSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          GoogleMovieSearchConverter.dtoFromCompleteJsonMap(map as Map),
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

  group('QueryGoogleMovies integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () async {
      await EnvironmentVars.init();
      const expectedResult1 =
          'https://customsearch.googleapis.com/customsearch/v1?cx=';
      const expectedResult2 = '&q=new%20query&start=0&num=10';

      // Invoke the functionality.
      final actualResult =
          QueryGoogleMovies().myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, startsWith(expectedResult1));
      expect(actualResult, endsWith(expectedResult2));
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryGoogleMovies
////////////////////////////////////////////////////////////////////////////////

  group('QueryGoogleMovies integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final testClass = QueryGoogleMovies();
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
      final testClass = QueryGoogleMovies();

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
  /// Integration tests using WebFetchBase and env and QueryGoogleMovies
////////////////////////////////////////////////////////////////////////////////

  group('google search query', () {
    // Read google search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryGoogleMovies();

      // Invoke the functionality.
      await testClass
          .readList(
            SearchCriteriaDTO(),
            source: streamGoogleMoviesJsonOfflineData,
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

    // Read google search results from a simulated byte stream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryGoogleMovies();
      const expectedException = '''
[QueryGoogleMovies] Error in google with criteria  interpreting web text as a map :FormatException: Unexpected character (at character 1)
not valid json
^
''';

      // Invoke the functionality.
      await testClass
          .readList(SearchCriteriaDTO(), source: _emitInvalidJsonSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read google search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryGoogleMovies] Error in google with criteria  translating page map to objects :expected map got List<dynamic> unable to interpret data [{hello: world}]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryGoogleMovies();

      // Invoke the functionality.
      await testClass
          .readList(SearchCriteriaDTO(), source: _emitUnexpectedJsonSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
