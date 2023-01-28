import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/cache/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_name.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/thread.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('<html><body>stuff</body></html>'));
}

Future<Stream<String>> _emitInvalidHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('not valid html'));
}

// ignore: avoid_classes_with_only_static_members
class StaticJsonGenerator {
  static Future<Stream<String>> stuff(_) =>
      Future.value(Stream.value('"stuff"'));

  static Future<Stream<String>> stuffDelayed(dynamic criteria) {
    // Insert artificial delay to allow tests to observe prior processing.
    return Future.delayed(const Duration(milliseconds: 300))
        .then((_) => stuff(criteria));
  }
}

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings.singleton().init());
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBNameDetails unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryIMDBNameDetails().myDataSourceName(), 'imdb_person');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'nmtesting';
      expect(
        QueryIMDBNameDetails().myFormatInputAsText(input),
        'nmtesting',
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
        QueryIMDBNameDetails().myFormatInputAsText(input),
        '',
      );
      expect(
        QueryIMDBNameDetails().myFormatInputAsText(input),
        '',
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.imdb',
        'title': '[QueryIMDBNameDetails] new query',
        'type': 'MovieContentType.error',
        'related': {}
      };

      // Invoke the functionality.
      final actualResult =
          QueryIMDBNameDetails().myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      final expectedOutput = intermediateMapList;
      final testClass = QueryIMDBNameDetails();
      final criteria = SearchCriteriaDTO();
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
          ImdbWebScraperConverter(DataSourceType.imdb)
              .dtoFromCompleteJsonMap(map),
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
  /// Integration tests using ThreadedCacheIMDBNameDetails
////////////////////////////////////////////////////////////////////////////////

  group('ThreadedCacheIMDBNameDetails unit tests', () {
    test('cache queueing', () {
      final testClass = QueryIMDBNameDetails();
      testClass.clearThreadedCache();
      expect(ThreadedCacheIMDBNameDetails.normalQueue.length, 0);
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 0);
      for (var iteration = 0; iteration < 100; iteration++) {
        final criteria = SearchCriteriaDTO().fromString(iteration.toString());
        // Enqueue requests but do not wait for result.
        testClass.initialiseThreadCacheRequest(
          criteria,
          ThreadRunner.slow,
          null,
        );
      }
      expect(ThreadedCacheIMDBNameDetails.normalQueue.length, 100);
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 0);
      for (var iteration = 0; iteration < 10; iteration++) {
        final criteria = SearchCriteriaDTO().fromString(iteration.toString());
        // Enqueue requests but do not wait for result.
        testClass.initialiseThreadCacheRequest(
          criteria,
          ThreadRunner.slow,
          null,
        );
      }
      expect(ThreadedCacheIMDBNameDetails.normalQueue.length, 100);
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 0);
      for (var iteration = 0; iteration < 10; iteration++) {
        final criteria = SearchCriteriaDTO().fromString(iteration.toString());
        // Enqueue requests but do not wait for result.
        testClass.completeThreadCacheRequest(
          criteria,
          ThreadRunner.slow,
        );
      }
      expect(ThreadedCacheIMDBNameDetails.normalQueue.length, 90);
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 0);
    });
    test('empty cache', () async {
      final testClass = QueryIMDBNameDetails();
      testClass.clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final listResult = await testClass.readCachedList(
        criteria,
        source: (_) => Future.value(Stream.value('Polo')),
      );
      expect(listResult, []);
      final resultIsCached = testClass.isThreadedResultCached(criteria);
      expect(resultIsCached, false);
      final resultIsStale = testClass.isThreadedCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('add to cache via readPrioritisedCachedList', () async {
      final testClass = QueryIMDBNameDetails();
      testClass.clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('nm0123456');
      await testClass.readPrioritisedCachedList(
        criteria,
        source: streamImdbHtmlOfflineData,
      );
      // Return some random junk that will not get used do to caching
      final listResult = await testClass.readPrioritisedCachedList(
        criteria,
        source: StaticJsonGenerator.stuff,
      );
      expect(
        listResult,
        MovieResultDTOListMatcher(expectedDTOList),
        reason: 'Emitted DTO list ${listResult.toPrintableString()} '
            'needs to match expected DTO List${expectedDTOList.toPrintableString()}',
      );
      final resultIsCached = testClass.isThreadedResultCached(criteria);
      expect(resultIsCached, true);
      final resultIsStale = testClass.isThreadedCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('fetch result from cache', () async {
      final testClass = QueryIMDBNameDetails();
      testClass.clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('nm0123456');
      await testClass.readPrioritisedCachedList(
        criteria,
        source: streamImdbHtmlOfflineData,
      );
      final listResult =
          await testClass.fetchResultFromThreadedCache(criteria).toList();
      expect(listResult, MovieResultDTOListMatcher(expectedDTOList));
      final resultIsCached = testClass.isThreadedResultCached(criteria);
      expect(resultIsCached, true);
      final resultIsStale = testClass.isThreadedCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('clear cache', () async {
      final testClass = QueryIMDBNameDetails();
      testClass.clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('nm0123456');
      await testClass.readPrioritisedCachedList(
        criteria,
        source: streamImdbHtmlOfflineData,
      );
      testClass.clearThreadedCache();
      final resultIsCached = testClass.isThreadedResultCached(criteria);
      expect(resultIsCached, false);
      final resultIsStale = testClass.isThreadedCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('cache prioitisation', () async {
      final testClass = QueryIMDBNameDetails();
      testClass.clearThreadedCache();
      for (var iteration = 0; iteration < 100; iteration++) {
        final criteria =
            SearchCriteriaDTO().fromString('nm${iteration.toString()}');
        // Enqueue requests but do not wait for result.
        testClass.readPrioritisedCachedList(
          criteria,
          source: StaticJsonGenerator.stuffDelayed,
        );
      }
      // Wait for queued requests to be intitialised but not completed.
      await Future.delayed(const Duration(milliseconds: 100));
      expect(ThreadedCacheIMDBNameDetails.normalQueue.length, 5);
      expect(ThreadedCacheIMDBNameDetails.verySlowQueue.length, 95);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBNameDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expected = 'https://www.imdb.com/name/1234';

      // Invoke the functionality.
      final actualResult =
          QueryIMDBNameDetails().myConstructURI('1234').toString();

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
      final testClass = QueryIMDBNameDetails();
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
    test('myConvertTreeToOutputType() errors', () {
      final testClass = QueryIMDBNameDetails();
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
  /// Integration tests using WebFetchBase and env and QueryIMDBNameDetails
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read imdb search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBNameDetails();
      testClass.myClearCache();
      final criteria = SearchCriteriaDTO().fromString('nm0123456');

      // Invoke the functionality.
      await testClass
          .readList(
            criteria,
            source: streamImdbHtmlOfflineData,
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

    // Read imdb search results from a simulated byte stream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      const expectedException = '[QueryIMDBNameDetails] Error in imdb_person '
          'with criteria nm7602562 interpreting web text as a map '
          ':imdb web scraper data not detected for criteria nm7602562 in not valid html';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBNameDetails();
      testClass.myClearCache();
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = 'nm7602562';

      // Invoke the functionality.
      await testClass
          .readList(criteria, source: _emitInvalidHtmlSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read imdb search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException = '[QueryIMDBNameDetails] Error in imdb_person '
          'with criteria nm7602562 interpreting web text as a map '
          ':imdb web scraper data not detected for criteria nm7602562 in <html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBNameDetails();
      testClass.myClearCache();
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = 'nm7602562';

      // Invoke the functionality.
      await testClass
          .readList(criteria, source: _emitUnexpectedHtmlSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
