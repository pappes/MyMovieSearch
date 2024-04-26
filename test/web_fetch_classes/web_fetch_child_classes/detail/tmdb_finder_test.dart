// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_finder.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(_) =>
    Future.value(Stream.value('[{"hello":"world"}]'));

Future<Stream<String>> _emitInvalidJsonSample(_) =>
    Future.value(Stream.value('not valid json'));

final criteria = SearchCriteriaDTO().fromString('ttImdbId123');

void main() {
  // Wait for api key to be initialised
  setUpAll(() async => Settings().init());
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('tmdb finder unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryTMDBFinder(criteria).myDataSourceName(), 'QueryTMDBFinder');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryTMDBFinder(criteria).myFormatInputAsText(),
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
        QueryTMDBFinder(input).myFormatInputAsText(),
        '',
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.tmdbFinder',
        'title': '[tmdbFinder] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryTMDBFinder(criteria)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          QueryTMDBFinder(criteria).myConvertWebTextToTraversableTree(
        jsonSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () async {
      final expectedOutput = <void>[];
      final actualOutput =
          QueryTMDBFinder(criteria).myConvertWebTextToTraversableTree(
        jsonSampleEmpty,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results',
        () async {
      final expectedOutput = throwsA(
        isA<WebConvertException>().having(
          (e) => e.cause,
          'cause',
          startsWith('tmdb call for criteria '
              '${criteria.toPrintableIdOrText()} '
              'returned error:The resource you requested could not be found.'),
        ),
      );
      final actualOutput =
          QueryTMDBFinder(criteria).myConvertWebTextToTraversableTree(
        jsonSampleError,
      );
      expect(actualOutput, expectedOutput);
    });
  });

  group('TmdbFinderConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          TmdbFinderConverter.dtoFromCompleteJsonMap(map as Map, 'ttImdbId123'),
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

  group('QueryTMDBFinder integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expected =
          'https://api.themoviedb.org/3/find/1234?language=en-US&external_source=imdb_id&api_key=';
      final criteria = SearchCriteriaDTO().fromString('1234');

      // Invoke the functionality.
      final actualResult =
          QueryTMDBFinder(criteria).myConstructURI('1234').toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryTMDBFinder
////////////////////////////////////////////////////////////////////////////////

  group('QueryTMDBFinder integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final testClass = QueryTMDBFinder(criteria);
      final expectedValue = expectedDTOList;
      final actualResult = <MovieResultDTO>[];

      testClass.imdbId = 'ttImdbId123';
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
      final testClass = QueryTMDBFinder(criteria);

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryTMDBFinder
////////////////////////////////////////////////////////////////////////////////

  group('tmdb search query', () {
    // Read tmdb search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBFinder(criteria);
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
    // and report error due to invalid json.
    test('invalid json', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBFinder(criteria);
      await testClass.myClearCache();
      const expectedException =
          '[tmdbFinder] Error in QueryTMDBFinder with criteria ttImdbId123 '
          'convert error interpreting web text as a map '
          ':Invalid json returned from web call not valid json';

      // Invoke the functionality.
      await testClass
          .readList(source: _emitInvalidJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read tmdb search results from a simulated byte stream
    // and report error due to unexpected json.
    test('unexpected json contents', () async {
      // Set up the test data.
      const expectedException =
          '[tmdbFinder] Error in QueryTMDBFinder with criteria ttImdbId123 '
          'convert error interpreting web text as a map '
          ':tmdb results data not detected for criteria ttImdbId123'
          ' in json:[{"hello":"world"}]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBFinder(criteria);
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: _emitUnexpectedJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
