// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/brave.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/brave.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/brave.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(_) =>
    Future.value(Stream.value('[{"hello":"world"}]'));

Future<Stream<String>> _emitInvalidJsonSample(_) =>
    Future.value(Stream.value('not valid json'));

final criteria = SearchCriteriaDTO().fromString('123');

void main() {
  // Wait for api key to be initialised
  setUpAll(() async => Settings().init());
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('brave search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryBraveMovies(criteria).myDataSourceName(), 'brave');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryBraveMovies(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO()
        ..criteriaList = [
          MovieResultDTO().error('test1'),
          MovieResultDTO().error('test2'),
        ];
      expect(
        QueryBraveMovies(input).myFormatInputAsText(),
        contains('test1'),
      );
      expect(
        QueryBraveMovies(input).myFormatInputAsText(),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.brave',
        'title': '[QueryBraveMovies] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryBraveMovies(criteria)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm web text is parsed as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          QueryBraveMovies(criteria).myConvertWebTextToTraversableTree(
        jsonSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () async {
      final expectedOutput = intermediateEmptyMapList;
      final actualOutput =
          QueryBraveMovies(criteria).myConvertWebTextToTraversableTree(
        jsonSampleEmpty,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results',
        () async {
      final expectedOutput = intermediateErrorMapList;
      final actualOutput =
          QueryBraveMovies(criteria).myConvertWebTextToTraversableTree(
        jsonSampleError,
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('BraveMovieSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          BraveMovieSearchConverter.dtoFromCompleteJsonMap(map as Map),
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
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    // Confirm map can be converted to DTO.
    test('Run getYearRange() success', () {
      final input = {'og:title': 'title (TV Series 1988–1993)'};
      const expectedOutput = '1988-1993';

      final actualResult = BraveMovieSearchConverter.getYearRange(input);
      expect(actualResult, expectedOutput);
    });
    // Confirm map can be converted to DTO.
    test('Run getYearRange() short truncated', () {
      final input = {'og:title': 'title (TV Series 1988–1993...'};
      const expectedOutput = '1988-1993';

      final actualResult = BraveMovieSearchConverter.getYearRange(input);
      expect(actualResult, expectedOutput);
    });
    // Confirm map can be converted to DTO.
    test('Run getYearRange() long truncated', () {
      final input = {
        'og:title': 'title blah blah blah (TV Series 1988–1993...',
      };
      const expectedOutput = '1988-1993';

      final actualResult = BraveMovieSearchConverter.getYearRange(input);
      expect(actualResult, expectedOutput);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryBraveMovies integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult1 =
          'https://customsearch.braveapis.com/customsearch/v1?cx=';
      const expectedResult2 = '&q=new%20query&start=0&num=10';

      // Invoke the functionality.
      final actualResult =
          QueryBraveMovies(criteria).myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, startsWith(expectedResult1));
      expect(actualResult, endsWith(expectedResult2));
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryBraveMovies
////////////////////////////////////////////////////////////////////////////////

  group('QueryBraveMovies integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final testClass = QueryBraveMovies(criteria);
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
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    test('Run myConvertTreeToOutputType() with empty search results', () async {
      final expectedValue = <MovieResultDTO>[];
      final testClass = QueryBraveMovies(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateEmptyMapList) {
        actualResult.addAll(
          await testClass.myConvertTreeToOutputType(map),
        );
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    test('Run myConvertTreeToOutputType() with error results', () async {
      final expectedValue = expectedErrorDTOList;
      final testClass = QueryBraveMovies(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateErrorMapList) {
        actualResult.addAll(
          await testClass.myConvertTreeToOutputType(map),
        );
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () async {
      final expectedOutput = throwsA(
        isA<TreeConvertException>().having(
          (e) => e.cause,
          'cause',
          startsWith(
            'expected map got String unable to interpret data wrongData',
          ),
        ),
      );
      final testClass = QueryBraveMovies(criteria);

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      //NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryBraveMovies
////////////////////////////////////////////////////////////////////////////////

  group('brave search query', () {
    // Read brave search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryBraveMovies(criteria);

      // Invoke the functionality.
      await testClass
          .readList(source: streamBraveMoviesJsonOfflineData)
          .then(queryResult.addAll)
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Read brave search results from a simulated byte stream
    // and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryBraveMovies(criteria);
      const expectedException = '''
[QueryBraveMovies] Error in brave with criteria 123 convert error interpreting web text as a map :Invalid json FormatException: Unexpected character (at character 1)
not valid json
^
''';

      // Invoke the functionality.
      await testClass
          .readList(source: _emitInvalidJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read brave search results from a simulated byte stream
    // and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException = '[QueryBraveMovies] Error in brave '
          'with criteria 123 convert error translating page map to objects '
          ':expected map got List<dynamic> unable to interpret data '
          '[{hello: world}]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryBraveMovies(criteria);

      // Invoke the functionality.
      await testClass
          .readList(source: _emitUnexpectedJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
