import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_linux/path_provider_linux.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(_) =>
    Future.value(Stream.value('<html><body>stuff</body></html>'));

Future<Stream<String>> _emitInvalidHtmlSample(_) =>
    Future.value(Stream.value('not valid html'));

void main() {
  // Wait for api key to be initialised
  setUpAll(() async => Settings.singleton().init());
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb title details unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      final input = SearchCriteriaDTO();
      expect(QueryIMDBTitleDetails(input).myDataSourceName(), 'imdb');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO()..criteriaTitle = 'tttesting';
      expect(QueryIMDBTitleDetails(input).myFormatInputAsText(), 'tttesting');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO()
        ..criteriaList = [
          MovieResultDTO().error('test1'),
          MovieResultDTO().error('test2'),
        ];
      expect(QueryIMDBTitleDetails(input).myFormatInputAsText(), '');
      expect(QueryIMDBTitleDetails(input).myFormatInputAsText(), '');
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      final input = SearchCriteriaDTO();
      const expectedResult = {
        'bestSource': 'DataSourceType.imdb',
        'title': '[QueryIMDBTitleDetails] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryIMDBTitleDetails(input)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      final input = SearchCriteriaDTO();
      const expectedOutput = intermediateMapList;
      final testClass = QueryIMDBTitleDetails(input);
      final criteria = SearchCriteriaDTO()..criteriaTitle = 'tt7602562';
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
          ImdbWebScraperConverter()
              .dtoFromCompleteJsonMap(map, DataSourceType.imdb),
        );
      }

      // Uncomment this line to update expectedDTOList if sample data changes
      // printTestData(actualResult);

      final expectedValue = expectedDTOList;
      expectedValue.first.uniqueId = 'tt6123456';
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
  /// Integration tests using ThreadedCacheIMDBTitleDetails
////////////////////////////////////////////////////////////////////////////////

  group('ThreadedCacheIMDBTitleDetails unit tests', () {
    test('empty cache', () async {
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final testClass = QueryIMDBTitleDetails(criteria);
      final listResult = await testClass.readCachedList(
        source: (_) async => Stream.value('Polo'),
      );
      expect(listResult, <MovieResultDTO>[]);
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, false);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('manually add to cache', () async {
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final testClass = QueryIMDBTitleDetails(criteria);
      final dto = MovieResultDTO().testDto('Polo');
      await testClass.myAddResultToCache(dto);
      final listResult = await testClass.readCachedList(
        source: (_) async => Stream.value('Polo'),
      );
      expect(listResult, [dto]);
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('clear cache', () async {
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final testClass = QueryIMDBTitleDetails(criteria);
      final dto = MovieResultDTO().testDto('Polo');
      await testClass.myAddResultToCache(dto);
      await testClass.myClearCache();
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, false);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('read empty cache via readCachedList', () async {
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final testClass = QueryIMDBTitleDetails(criteria);
      await testClass.myClearCache();
      final listResult = await testClass.readCachedList(
        source: (_) async => Stream.value('Who Is Marco?'),
      );
      expect(listResult, MovieResultDTOListMatcher([]));
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, false);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('read populated cache via readCachedList', () async {
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final testClass = QueryIMDBTitleDetails(criteria);
      await testClass.myClearCache();
      final dto = MovieResultDTO().testDto('Polo');
      await testClass.myAddResultToCache(dto);
      final listResult = await testClass.readCachedList(
        source: (_) async => Stream.value('Who Is Marco?'),
      );
      expect(listResult, MovieResultDTOListMatcher([dto]));
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('read populated cache via readList', () async {
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      final testClass = QueryIMDBTitleDetails(criteria);
      await testClass.myClearCache();
      // ignore: unused_result
      await testClass.readList(
        source: streamImdbHtmlOfflineData,
      );
      final listResult = await testClass.readList(
        source: (_) async => Stream.value('"Dummy HTML"'),
      );
      expect(listResult, MovieResultDTOListMatcher(expectedDTOList));
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('fetch result from cache', () async {
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final testClass = QueryIMDBTitleDetails(criteria);
      await testClass.myClearCache();
      final dto = MovieResultDTO().testDto('Polo');
      await testClass.myAddResultToCache(dto);
      final listResult = testClass.myFetchResultFromCache();
      expect(listResult, MovieResultDTOListMatcher([dto]));
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('fetch multiple results from cache', () async {
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final testClass = QueryIMDBTitleDetails(criteria);
      await testClass.myClearCache();
      final dto1 = MovieResultDTO().testDto('Polo1');
      final dto2 = MovieResultDTO().testDto('Polo2');
      await testClass.myAddResultToCache(dto1);
      await testClass.myAddResultToCache(dto2);
      final listResult = testClass.myFetchResultFromCache();
      expect(listResult, MovieResultDTOListMatcher([dto1, dto2]));
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBTitleDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      final criteria = SearchCriteriaDTO();
      const expected = 'https://www.imdb.com/title/1234/?ref_=fn_tt_tt_1';

      // Invoke the functionality.
      final actualResult =
          QueryIMDBTitleDetails(criteria).myConstructURI('1234').toString();

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
      final criteria = SearchCriteriaDTO();
      final testClass = QueryIMDBTitleDetails(criteria);
      final expectedValue = expectedDTOList;
      final actualResult = <MovieResultDTO>[];
      await testClass.myClearCache();

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
      final testClass = QueryIMDBTitleDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryIMDBTitleDetails
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read imdb search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass =
          QueryIMDBTitleDetails(SearchCriteriaDTO().fromString('tt123'));
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
          '[QueryIMDBTitleDetails] Error in imdb with criteria '
          'tt123 convert error interpreting web text as a map '
          ':imdb web scraper data not detected for criteria '
          'tt123 in not valid html';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBTitleDetails(
        SearchCriteriaDTO().fromString('tt123'),
      );
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
          '[QueryIMDBTitleDetails] Error in imdb with criteria '
          'tt123 convert error interpreting web text as a map '
          ':imdb web scraper data not detected for criteria '
          'tt123 in <html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBTitleDetails(
        SearchCriteriaDTO().fromString('tt123'),
      );
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
