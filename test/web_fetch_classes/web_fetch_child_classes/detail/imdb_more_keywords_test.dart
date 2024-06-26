import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_more_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_more_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_more_keywords.dart';
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
}

void main() {
  // Wait for api key to be initialised
  setUpAll(() async => lockWebFetchTreadedCache);
  tearDownAll(() async => lockWebFetchTreadedCache);
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBMoreKeywordsDetails unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      final criteria = SearchCriteriaDTO();
      expect(
        QueryIMDBMoreKeywordsDetails(criteria).myDataSourceName(),
        'imdb_more_keywords',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO()..criteriaTitle = 'tttesting';
      expect(
        QueryIMDBMoreKeywordsDetails(input).myFormatInputAsText(),
        'tttesting',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO()
        ..criteriaList = [
          makeResultDTO('tttest1'),
          makeResultDTO('tttest2'),
        ];
      expect(
        QueryIMDBMoreKeywordsDetails(input).myFormatInputAsText(),
        '',
      );
      expect(
        QueryIMDBMoreKeywordsDetails(input).myFormatInputAsText(),
        '',
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.imdb',
        'title': '[QueryIMDBMoreKeywordsDetails] new query',
        'type': 'MovieContentType.error',
      };
      final criteria = SearchCriteriaDTO();
      // Invoke the functionality.
      final actualResult = QueryIMDBMoreKeywordsDetails(criteria)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      const expectedOutput = intermediateMapList;
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        imdbHtmlSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('ImdbMoreKeywordsConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          ImdbMoreKeywordsConverter.dtoFromCompleteJsonMap(map),
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
  /// Integration tests using WebFetchThreadedCache
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchThreadedCache unit tests', () {
    test('empty cache', () async {
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
      await testClass.clearThreadedCache();
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
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
      await testClass.clearThreadedCache();
      // ignore: unused_result
      await testClass.readPrioritisedCachedList(
        source: streamImdbHtmlOfflineData,
      );
      final listResult = await testClass.readPrioritisedCachedList(
        source: StaticJsonGenerator.stuff,
        // Return some random junk that will not get used do to caching
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
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
      await testClass.clearThreadedCache();
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
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
      await testClass.clearThreadedCache();
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
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBMoreKeywordsDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expected = 'https://www.imdb.com/title/1234/keywords/';
      final criteria = SearchCriteriaDTO();

      // Invoke the functionality.
      final actualResult = QueryIMDBMoreKeywordsDetails(criteria)
          .myConstructURI('1234')
          .toString();

      // Check the results.
      expect(actualResult, expected);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryIMDBMoreKeywordsDetails
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBMoreKeywordsDetails integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final criteria = SearchCriteriaDTO();
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
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
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
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
  /// Integration tests using WebFetchBase, env and QueryIMDBMoreKeywordsDetails
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read imdb search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(
            source: streamImdbHtmlOfflineData,
          )
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
          '[QueryIMDBMoreKeywordsDetails] Error in imdb_more_keywords '
          'with criteria tt123 convert error interpreting web text as a map '
          ':imdb more keywords data not detected for criteria tt123';
      final queryResult = <MovieResultDTO>[];
      final criteria = SearchCriteriaDTO().fromString('tt123');
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(
            source: _emitInvalidHtmlSample,
          )
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read imdb search results from a simulated byte stream
    // and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBMoreKeywordsDetails] Error in imdb_more_keywords with '
          'criteria tt123 convert error interpreting web text as a map '
          ':imdb more keywords data not detected for criteria tt123';
      final queryResult = <MovieResultDTO>[];
      final criteria = SearchCriteriaDTO().fromString('tt123');
      final testClass = QueryIMDBMoreKeywordsDetails(criteria);
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
