// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_person_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_person_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_person_detail.dart';
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
  setUpAll(() async => Settings.singleton().init());
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('tmdb details unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryTMDBPersonDetails(criteria).myDataSourceName(), 'tmdbPerson');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryTMDBPersonDetails(criteria).myFormatInputAsText(),
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
        QueryTMDBPersonDetails(input).myFormatInputAsText(),
        contains('test1'),
      );
      expect(
        QueryTMDBPersonDetails(input).myFormatInputAsText(),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'uniqueId': '-2',
        'bestSource': 'DataSourceType.tmdbPerson',
        'title': '[tmdbPerson] new query',
        'type': 'MovieContentType.error',
      };
      MovieResultDTOHelpers.resetError();

      // Invoke the functionality.
      final actualResult =
          QueryTMDBPersonDetails(criteria).myYieldError('new query').toMap();

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          QueryTMDBPersonDetails(criteria).myConvertWebTextToTraversableTree(
        jsonSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () async {
      final expectedOutput = throwsA(
        isA<WebConvertException>().having(
          (e) => e.cause,
          'cause',
          'tmdb call for criteria 123 returned '
              'error:The resource you requested could not be found.',
        ),
      );
      final actualOutput =
          QueryTMDBPersonDetails(criteria).myConvertWebTextToTraversableTree(
        jsonSampleEmpty,
      );
      expect(actualOutput, expectedOutput);
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results',
        () async {
      final expectedOutput = throwsA(
        isA<WebConvertException>().having(
          (e) => e.cause,
          'cause',
          'tmdb call for criteria 123 returned '
              'error:Invalid API key: You must be granted a valid key.',
        ),
      );
      final actualOutput =
          QueryTMDBPersonDetails(criteria).myConvertWebTextToTraversableTree(
        jsonSampleError,
      );
      expect(actualOutput, expectedOutput);
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
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryTMDBPersonDetails integration tests', () async {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () async {
      final testClass = QueryTMDBPersonDetails(criteria);
      await testClass.myClearCache();
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
      final testClass = QueryTMDBPersonDetails(criteria);
      await testClass.myClearCache();
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
      final testClass = QueryTMDBPersonDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result\
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryTMDBPersonDetails
////////////////////////////////////////////////////////////////////////////////

  group('tmdb search query', () {
    // Read tmdb search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBPersonDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: streamTmdbJsonOfflineData)
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

    // Read tmdb search results from a simulated byte stream
    // and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBPersonDetails(criteria);
      const expectedException =
          '[tmdbPerson] Error in tmdbPerson with criteria 123 '
          'convert error interpreting web text as a map '
          ':Invalid json returned from web call not valid json';

      // Invoke the functionality.
      await testClass
          .readList(source: _emitInvalidJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read tmdb search results from a simulated byte stream
    // and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[tmdbPerson] Error in tmdbPerson with criteria 123 '
          'convert error interpreting web text as a map '
          ':tmdb results data not detected for criteria '
          '123 in json:[{"hello":"world"}]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBPersonDetails(criteria);

      // Invoke the functionality.
      await testClass
          .readList(source: _emitUnexpectedJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
