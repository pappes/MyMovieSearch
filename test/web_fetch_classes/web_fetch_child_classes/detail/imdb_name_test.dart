import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/cache/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_name.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(_) =>
    Future.value(Stream.value('<html><body>stuff</body></html>'));

Future<Stream<String>> _emitInvalidHtmlSample(_) =>
    Future.value(Stream.value('not valid html'));

// ignore: avoid_classes_with_only_static_members
class StaticJsonGenerator {
  static Future<Stream<String>> stuff(_) =>
      Future.value(Stream.value('"stuff"'));

  // Insert artificial delay to allow tests to observe prior processing.
  static Future<Stream<String>> stuffDelayed(dynamic criteria) =>
      Future<void>.delayed(const Duration(milliseconds: 3000))
          .then((_) => stuff(criteria));
}

void main() {
  // Wait for api key to be initialised
  setUpAll(() async => lockWebFetchTreadedCache);
  tearDownAll(() async => lockWebFetchTreadedCache);
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBNameDetails unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      final input = SearchCriteriaDTO();
      expect(QueryIMDBNameDetails(input).myDataSourceName(), 'imdb_person');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO()..criteriaTitle = 'nmtesting';
      expect(
        QueryIMDBNameDetails(input).myFormatInputAsText(),
        'nmtesting',
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
        QueryIMDBNameDetails(input).myFormatInputAsText(),
        '',
      );
      expect(
        QueryIMDBNameDetails(input).myFormatInputAsText(),
        '',
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      final criteria = SearchCriteriaDTO();
      const expectedResult = {
        'bestSource': 'DataSourceType.imdb',
        'title': '[QueryIMDBNameDetails] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryIMDBNameDetails(criteria)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      const expectedOutput = intermediateMapList;
      final criteria = SearchCriteriaDTO();
      final testClass = QueryIMDBNameDetails(criteria);
      criteria.criteriaTitle = 'nm0123456';
      testClass.criteria = criteria;
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        imdbHtmlSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('ImdbNamePageConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          ImdbWebScraperConverter()
              .dtoFromCompleteJsonMap(map, DataSourceType.imdb),
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
  /// Integration tests using ThreadedCacheIMDBNameDetails
////////////////////////////////////////////////////////////////////////////////

  group('ThreadedCacheIMDBNameDetails unit tests', () {
    test('cache queueing', () async {
      await QueryIMDBNameDetails(SearchCriteriaDTO()).clearThreadedCache();
      expect(ThreadedCacheIMDBNameDetails.normalQueue.length, 0);
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 0);
      for (var iteration = 0; iteration < 100; iteration++) {
        final criteria = SearchCriteriaDTO().fromString(iteration.toString());
        // Enqueue requests but do not wait for result.
        QueryIMDBNameDetails(criteria)
            .initialiseThreadCacheRequest(ThreadRunner.slow, null);
      }
      expect(ThreadedCacheIMDBNameDetails.normalQueue.length, 100);
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 0);
      for (var iteration = 0; iteration < 10; iteration++) {
        final criteria = SearchCriteriaDTO().fromString(iteration.toString());
        // Enqueue requests but do not wait for result.
        QueryIMDBNameDetails(criteria)
            .initialiseThreadCacheRequest(ThreadRunner.slow, null);
      }
      expect(ThreadedCacheIMDBNameDetails.normalQueue.length, 100);
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 0);
      for (var iteration = 0; iteration < 10; iteration++) {
        final criteria = SearchCriteriaDTO().fromString(iteration.toString());
        // Enqueue requests but do not wait for result.
        QueryIMDBNameDetails(criteria)
            .completeThreadCacheRequest(ThreadRunner.slow);
      }
      expect(ThreadedCacheIMDBNameDetails.normalQueue.length, 90);
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 0);
    });
    test('empty cache', () async {
      await QueryIMDBNameDetails(SearchCriteriaDTO()).clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final testClass = QueryIMDBNameDetails(criteria);
      final listResult = await testClass.readCachedList(
        source: (_) => Future.value(Stream.value('Polo')),
      );
      expect(listResult, <MovieResultDTO>[]);
      final resultIsCached = await testClass.isThreadedResultCached();
      expect(resultIsCached, false);
      final resultIsStale = testClass.isThreadedCacheStale();
      expect(resultIsStale, false);
    });

    test('add to cache via readPrioritisedCachedList', () async {
      await QueryIMDBNameDetails(SearchCriteriaDTO()).clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('nm0123456');
      final testClass = QueryIMDBNameDetails(criteria);
      // ignore: unused_result
      await testClass.readPrioritisedCachedList(
        source: streamImdbHtmlOfflineData,
      );
      // Return some random junk that will not get used do to caching
      final listResult = await testClass.readPrioritisedCachedList(
        source: StaticJsonGenerator.stuff,
      );
      expect(
        listResult,
        MovieResultDTOListMatcher(expectedDTOList),
        reason: 'Emitted DTO list ${listResult.toPrintableString()} '
            'needs to match expected DTO List'
            '${expectedDTOList.toPrintableString()}',
      );
      final resultIsCached = await testClass.isThreadedResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.isThreadedCacheStale();
      expect(resultIsStale, false);
    });

    test('fetch result from cache', () async {
      await QueryIMDBNameDetails(SearchCriteriaDTO()).clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('nm0123456');
      final testClass = QueryIMDBNameDetails(criteria);
      // ignore: unused_result
      await testClass.readPrioritisedCachedList(
        source: streamImdbHtmlOfflineData,
      );
      final listResult =
          await testClass.fetchResultFromThreadedCache().toList();
      expect(listResult, MovieResultDTOListMatcher(expectedDTOList));
      final resultIsCached = await testClass.isThreadedResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.isThreadedCacheStale();
      expect(resultIsStale, false);
    });

    test('clear cache', () async {
      await QueryIMDBNameDetails(SearchCriteriaDTO()).clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('nm0123456');
      final testClass = QueryIMDBNameDetails(criteria);
      // ignore: unused_result
      await testClass.readPrioritisedCachedList(
        source: streamImdbHtmlOfflineData,
      );
      await testClass.clearThreadedCache();
      final resultIsCached = await testClass.isThreadedResultCached();
      expect(resultIsCached, false);
      final resultIsStale = testClass.isThreadedCacheStale();
      expect(resultIsStale, false);
    });

    test('cache prioitisation', () async {
      await QueryIMDBNameDetails(SearchCriteriaDTO()).clearThreadedCache();
      for (var iteration = 0; iteration < 100; iteration++) {
        final criteria = SearchCriteriaDTO().fromString('nm$iteration');
        // Enqueue requests but do not wait for result.
        // ignore: unused_result
        unawaited(
          QueryIMDBNameDetails(criteria).readPrioritisedCachedList(
            source: StaticJsonGenerator.stuffDelayed,
          ),
        );
      }
      // Wait for queued requests to be intitialised but not completed.
      await Future<void>.delayed(const Duration(milliseconds: 2000));
      final queueLength = ThreadedCacheIMDBNameDetails.normalQueue.length;
      expect(queueLength, greaterThanOrEqualTo(1));
      expect(queueLength, lessThanOrEqualTo(5));
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 95);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBNameDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expected = 'https://www.imdb.com/name/1234?showAllCredits=true';
      final criteria = SearchCriteriaDTO();
      final testClass = QueryIMDBNameDetails(criteria);

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI('1234').toString();

      // Check the results.
      expect(actualResult, expected);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryIMDBNameDetails
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBNameDetails integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final criteria = SearchCriteriaDTO();
      final testClass = QueryIMDBNameDetails(criteria);
      await testClass.clearThreadedCache();
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
      final criteria = SearchCriteriaDTO();
      final testClass = QueryIMDBNameDetails(criteria);
      await testClass.clearThreadedCache();

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryIMDBNameDetails
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read imdb search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final criteria = SearchCriteriaDTO().fromString('nm0123456');
      final testClass = QueryIMDBNameDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: streamImdbHtmlOfflineData)
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

    // Read imdb search results from a simulated byte stream
    // and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBNameDetails] Error in imdb_person with criteria '
          'nm7602562 convert error interpreting web text as a map '
          ':imdb web scraper data not detected for criteria '
          'nm7602562 in not valid html';
      final queryResult = <MovieResultDTO>[];
      final criteria = SearchCriteriaDTO().fromString('nm7602562');
      final testClass = QueryIMDBNameDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: _emitInvalidHtmlSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read imdb search results from a simulated byte stream
    // and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBNameDetails] Error in imdb_person with criteria '
          'nm7602562 convert error interpreting web text as a map '
          ':imdb web scraper data not detected for criteria '
          'nm7602562 in <html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final criteria = SearchCriteriaDTO().fromString('nm7602562');
      final testClass = QueryIMDBNameDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: _emitUnexpectedHtmlSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
