import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_cast.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_cast.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_cast.dart';
import 'package:my_movie_search/utilities/environment.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('<html><body>stuff</body></html>'));
}

Future<Stream<String>> _emitInvalidHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('not valid html'));
}

// ignore: avoid_classes_with_only_static_members
class StaticJsonGenerator {
  static Future<Stream<String>> stuff(_) async => Stream.value('"stuff"');
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBCastDetails unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () async {
      expect(QueryIMDBCastDetails().myDataSourceName(), 'imdb_cast');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () async {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryIMDBCastDetails().myFormatInputAsText(input),
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
        QueryIMDBCastDetails().myFormatInputAsText(input),
        contains('test1'),
      );
      expect(
        QueryIMDBCastDetails().myFormatInputAsText(input),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () async {
      const expectedResult = {
        'source': 'DataSourceType.imdb',
        'title': '[QueryIMDBCastDetails] new query',
        'type': 'MovieContentType.custom',
        'related': {}
      };

      // Invoke the functionality.
      final actualResult =
          QueryIMDBCastDetails().myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      final expectedOutput = intermediateMapList;
      final testClass = QueryIMDBCastDetails();
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = 'tt7602562';
      testClass.criteria = criteria;
      final actualOutput = await testClass.myConvertWebTextToTraversableTree(
        imdbHtmlSampleFull,
      );
      expect(actualOutput, expectedOutput);
    });
  });

  group('ImdbCastConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () async {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          ImdbCastConverter.dtoFromCompleteJsonMap(map),
        );
      }

      final expectedValue = expectedDTOList;
      expectedValue.first.uniqueId = 'tt7602562';
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
  /// Integration tests using WebFetchThreadedCache
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchThreadedCache unit tests', () {
    test('empty cache', () async {
      final testClass = QueryIMDBCastDetails();
      await testClass.clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('Marco');
      final listResult = await testClass.readCachedList(
        criteria,
        source: (_) async => Stream.value('Polo'),
      );
      expect(listResult, []);
      final resultIsCached = await testClass.isThreadedResultCached(criteria);
      expect(resultIsCached, false);
      final resultIsStale = await testClass.isThreadedCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('add to cache via readPrioritisedCachedList', () async {
      final testClass = QueryIMDBCastDetails();
      await testClass.clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      await testClass.readPrioritisedCachedList(
        criteria,
        source: streamImdbHtmlOfflineData,
      );
      final listResult = await testClass.readPrioritisedCachedList(
        criteria,
        source: StaticJsonGenerator
            .stuff, // Return some random junk that will not get used do to caching
      );
      expect(
        listResult,
        MovieResultDTOListMatcher(expectedDTOList),
        reason: 'Emitted DTO list ${listResult.toPrintableString()} '
            'needs to match expected DTO List${expectedDTOList.toPrintableString()}',
      );
      final resultIsCached = await testClass.isThreadedResultCached(criteria);
      expect(resultIsCached, true);
      final resultIsStale = await testClass.isThreadedCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('fetch result from cache', () async {
      final testClass = QueryIMDBCastDetails();
      await testClass.clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      await testClass.readPrioritisedCachedList(
        criteria,
        source: streamImdbHtmlOfflineData,
      );
      final listResult =
          await testClass.fetchResultFromThreadedCache(criteria).toList();
      expect(listResult, MovieResultDTOListMatcher(expectedDTOList));
      final resultIsCached = await testClass.isThreadedResultCached(criteria);
      expect(resultIsCached, true);
      final resultIsStale = await testClass.isThreadedCacheStale(criteria);
      expect(resultIsStale, false);
    });

    test('clear cache', () async {
      final testClass = QueryIMDBCastDetails();
      await testClass.clearThreadedCache();
      final criteria = SearchCriteriaDTO().fromString('tt7602562');
      await testClass.readPrioritisedCachedList(
        criteria,
        source: streamImdbHtmlOfflineData,
      );
      await testClass.clearThreadedCache();
      final resultIsCached = await testClass.isThreadedResultCached(criteria);
      expect(resultIsCached, false);
      final resultIsStale = await testClass.isThreadedCacheStale(criteria);
      expect(resultIsStale, false);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBCastDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () async {
      await EnvironmentVars.init();
      const expected = 'https://www.imdb.com/title/1234/fullcredits/';

      // Invoke the functionality.
      final actualResult =
          QueryIMDBCastDetails().myConstructURI('1234').toString();

      // Check the results.
      expect(actualResult, expected);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryIMDBCastDetails
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBCastDetails integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final testClass = QueryIMDBCastDetails();
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
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () async {
      final testClass = QueryIMDBCastDetails();
      await testClass.myClearCache();

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
  /// Integration tests using WebFetchBase and env and QueryIMDBCastDetails
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read imdb search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBCastDetails();
      await testClass.myClearCache();
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
      // Explicitly check related because MovieResultDTOListMatcher won't
      expect(
        queryResult.first.related.length,
        3,
        reason: 'Related should list 1 director, 3 writers and 3 actors',
      );
      expect(
        queryResult.first.related['Writing Credits:']!.length,
        3,
        reason: 'Related should list 3 writers',
      );
    });

    // Read imdb search results from a simulated byte stream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBCastDetails();
      await testClass.myClearCache();
      const expectedException =
          '[QueryIMDBCastDetails] Error in imdb_cast with criteria  interpreting web text as a map :imdb cast data not detected for criteria ';

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
          '[QueryIMDBCastDetails] Error in imdb_cast with criteria  interpreting web text as a map :imdb cast data not detected for criteria ';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryIMDBCastDetails();
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(SearchCriteriaDTO(), source: _emitUnexpectedHtmlSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
