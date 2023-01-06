import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/utilities/environment.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('<html><body>stuff</body></html>'));
}

Future<Stream<String>> _emitInvalidHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('not valid html'));
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb title details unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryIMDBTitleDetails().myDataSourceName(), 'imdb');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryIMDBTitleDetails().myFormatInputAsText(input),
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
        QueryIMDBTitleDetails().myFormatInputAsText(input),
        contains('test1'),
      );
      expect(
        QueryIMDBTitleDetails().myFormatInputAsText(input),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'source': 'DataSourceType.imdb',
        'title': '[QueryIMDBTitleDetails] new query',
        'type': 'MovieContentType.custom',
        'related': {}
      };

      // Invoke the functionality.
      final actualResult =
          QueryIMDBTitleDetails().myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      final expectedOutput = intermediateMapList;
      final testClass = QueryIMDBTitleDetails();
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = 'tt7602562';
      testClass.criteria = criteria;
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        imdbHtmlSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('ImdbTitleConverter unit tests', () {
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
      expectedValue.first.uniqueId = 'tt6123456';
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
  /// Integration tests using ThreadedCacheIMDBTitleDetails
////////////////////////////////////////////////////////////////////////////////

  group('ThreadedCacheIMDBTitleDetails unit tests', () {
    test('empty cache', () async {
      final testClass = QueryIMDBTitleDetails();
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final listResult = await testClass.readCachedList(
        criteria,
        source: (_) async => Stream.value('Polo'),
      );
      expect(listResult, []);
      final resultIsCached = testClass.myIsResultCached(criteria);
      expect(resultIsCached, false);
      final resultIsStale = testClass.myIsCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('manually add to cache', () async {
      final testClass = QueryIMDBTitleDetails();
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final dto = MovieResultDTO().testDto('Polo');
      await testClass.myAddResultToCache(criteria, dto);
      final listResult = await testClass.readCachedList(
        criteria,
        source: (_) async => Stream.value('Polo'),
      );
      expect(listResult, [dto]);
      final resultIsCached = testClass.myIsResultCached(criteria);
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('clear cache', () async {
      final testClass = QueryIMDBTitleDetails();
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final dto = MovieResultDTO().testDto('Polo');
      await testClass.myAddResultToCache(criteria, dto);
      testClass.myClearCache();
      final resultIsCached = testClass.myIsResultCached(criteria);
      expect(resultIsCached, false);
      final resultIsStale = testClass.myIsCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('read empty cache via readCachedList', () async {
      final testClass = QueryIMDBTitleDetails();
      testClass.myClearCache();
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final listResult = await testClass.readCachedList(
        criteria,
        source: (_) async => Stream.value('Who Is Marco?'),
      );
      expect(listResult, MovieResultDTOListMatcher([]));
      final resultIsCached = testClass.myIsResultCached(criteria);
      expect(resultIsCached, false);
      final resultIsStale = testClass.myIsCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('read populated cache via readCachedList', () async {
      final testClass = QueryIMDBTitleDetails();
      testClass.myClearCache();
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final dto = MovieResultDTO().testDto('Polo');
      await testClass.myAddResultToCache(criteria, dto);
      final listResult = await testClass.readCachedList(
        criteria,
        source: (_) async => Stream.value('Who Is Marco?'),
      );
      expect(listResult, MovieResultDTOListMatcher([dto]));
      final resultIsCached = testClass.myIsResultCached(criteria);
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('read populated cache via readList', () async {
      final testClass = QueryIMDBTitleDetails();
      testClass.myClearCache();
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      await testClass.readList(
        criteria,
        source: streamImdbHtmlOfflineData,
      );
      final listResult = await testClass.readList(
        criteria,
        source: (_) async => Stream.value('"Dummy HTML"'),
      );
      expect(listResult, MovieResultDTOListMatcher(expectedDTOList));
      final resultIsCached = testClass.myIsResultCached(criteria);
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('fetch result from cache', () async {
      final testClass = QueryIMDBTitleDetails();
      testClass.myClearCache();
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final dto = MovieResultDTO().testDto('Polo');
      await testClass.myAddResultToCache(criteria, dto);
      final listResult =
          await testClass.myFetchResultFromCache(criteria).toList();
      expect(listResult, MovieResultDTOListMatcher([dto]));
      final resultIsCached = testClass.myIsResultCached(criteria);
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale(criteria);
      expect(resultIsStale, false);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBTitleDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expected = 'https://www.imdb.com/title/1234/?ref_=fn_tt_tt_1';

      // Invoke the functionality.
      final actualResult =
          QueryIMDBTitleDetails().myConstructURI('1234').toString();

      // Check the results.
      expect(actualResult, expected);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryIMDBTitleDetails
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBTitleDetails integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final testClass = QueryIMDBTitleDetails();
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
      final testClass = QueryIMDBTitleDetails();
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
  /// Integration tests using WebFetchBase and env and QueryIMDBTitleDetails
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read imdb search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBTitleDetails();
      testClass.myClearCache();
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = 'tt7602562';

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
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBTitleDetails();
      testClass.myClearCache();
      const expectedException =
          '[QueryIMDBTitleDetails] Error in imdb with criteria  interpreting web text as a map :imdb web scraper data not detected for criteria  in not valid html';

      // Invoke the functionality.
      await testClass
          .readList(SearchCriteriaDTO(), source: _emitInvalidHtmlSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read imdb search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBTitleDetails] Error in imdb with criteria  interpreting web text as a map :imdb web scraper data not detected for criteria  in <html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBTitleDetails();
      testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(SearchCriteriaDTO(), source: _emitUnexpectedHtmlSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
