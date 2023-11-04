// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/omdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/omdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/omdb.dart';
import 'package:my_movie_search/utilities/settings.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(_) {
  return Future.value(Stream.value('[{"hello":"world"}]'));
}

Future<Stream<String>> _emitInvalidJsonSample(_) {
  return Future.value(Stream.value('not valid json'));
}

final criteria = SearchCriteriaDTO().fromString('123');

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings.singleton().init());
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('omdb search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryOMDBMovies(criteria).myDataSourceName(), 'omdb');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryOMDBMovies(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
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
        QueryOMDBMovies(input).myFormatInputAsText(),
        contains('test1'),
      );
      expect(
        QueryOMDBMovies(input).myFormatInputAsText(),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.omdb',
        'title': '[QueryOMDBMovies] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult =
          QueryOMDBMovies(criteria).myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          QueryOMDBMovies(criteria).myConvertWebTextToTraversableTree(
        jsonSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () {
      final expectedOutput = [];
      final actualOutput =
          QueryOMDBMovies(criteria).myConvertWebTextToTraversableTree(
        jsonSampleEmpty,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results', () {
      final expectedOutput = intermediateErrorMapList;
      final actualOutput =
          QueryOMDBMovies(criteria).myConvertWebTextToTraversableTree(
        jsonSampleError,
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('OmdbMovieSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          OmdbMovieSearchConverter.dtoFromCompleteJsonMap(map as Map),
        );
      }

      // Uncomment this line to update expectedDTOList if sample data changes
      // printTestData(actualResult);

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

  group('QueryOMDBMovies integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult1 = 'https://www.omdbapi.com/?apikey=';
      const expectedResult2 = '&s=new%20query&page=1';

      // Invoke the functionality.
      final actualResult =
          QueryOMDBMovies(criteria).myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, startsWith(expectedResult1));
      expect(actualResult, endsWith(expectedResult2));
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryOMDBMovies
////////////////////////////////////////////////////////////////////////////////

  group('QueryOMDBMovies integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final testClass = QueryOMDBMovies(criteria);
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
      final testClass = QueryOMDBMovies(criteria);

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
  /// Integration tests using WebFetchBase and env and QueryOMDBMovies
////////////////////////////////////////////////////////////////////////////////

  group('omdb search query', () {
    // Read omdb search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryOMDBMovies(criteria);

      // Invoke the functionality.
      await testClass
          .readList(
            source: streamOmdbJsonOfflineData,
          )
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });

    // Read omdb search results from a simulated byte stream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryOMDBMovies(criteria);
      const expectedException =
          '[QueryOMDBMovies] Error in omdb with criteria 123 '
          'convert error interpreting web text as a map '
          ':Invalid json returned from web call not valid json';

      // Invoke the functionality.
      await testClass
          .readList(
            source: _emitInvalidJsonSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read omdb search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException = '[QueryOMDBMovies] Error in omdb '
          'with criteria 123 convert error translating page map to objects '
          ':expected map got List<dynamic> unable to interpret data [{hello: world}]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryOMDBMovies(criteria);

      // Invoke the functionality.
      await testClass
          .readList(
            source: _emitUnexpectedJsonSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
