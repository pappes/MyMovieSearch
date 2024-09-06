import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(_) =>
    Future.value(Stream.value('{{[' ']}}'));

Future<Stream<String>> _emitInvalidJsonSample(_) =>
    Future.value(Stream.value('not valid json'));

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

  group('QueryIMDBJsonDetails unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      final criteria = SearchCriteriaDTO();
      expect(
        QueryIMDBJsonPaginatedFilmographyDetails(criteria).myDataSourceName(),
        'imdb_Json-NameMainFilmographyPaginatedCredits-ImdbJsonSource.actor',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO()..criteriaTitle = 'nmtesting';
      expect(
        QueryIMDBJsonPaginatedFilmographyDetails(input).myFormatInputAsText(),
        'nmtesting',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO()
        ..criteriaList = [
          makeResultDTO('nmtest1'),
          makeResultDTO('nmtest2'),
        ];
      expect(
        QueryIMDBJsonPaginatedFilmographyDetails(input).myFormatInputAsText(),
        '',
      );
      expect(
        QueryIMDBJsonPaginatedFilmographyDetails(input).myFormatInputAsText(),
        '',
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.imdb',
        'title': '[imdb_Json-'
            'NameMainFilmographyPaginatedCredits-ImdbJsonSource.actor] '
            'new query',
        'type': 'MovieContentType.error',
      };
      final criteria = SearchCriteriaDTO();
      // Invoke the functionality.
      final actualResult = QueryIMDBJsonPaginatedFilmographyDetails(criteria)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree() paginated', () async {
      final expectedOutput = [imdbJsonInnerPaginatedSample];
      final criteria = SearchCriteriaDTO().fromString('nm1913125');
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        jsonEncode(imdbJsonWrappedPaginatedSample),
      );
      expect(actualOutput, completion(expectedOutput));
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree() filtered', () async {
      final expectedOutput = [imdbJsonInnerFilteredSample];
      final criteria = SearchCriteriaDTO().fromString('nm1913125');
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        jsonEncode(imdbJsonWrappedFilteredSample),
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('ImdbJsonConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap() paginated', () {
      // Invoke the functionality and collect results.
      final actualResult = ImdbWebScraperConverter().dtoFromCompleteJsonMap(
        imdbJsonInnerPaginatedSample,
        DataSourceType.imdbJson,
      );

      // Uncomment this line to update expectedDTOList if sample data changes
      // printTestData(actualResult);

      final expectedValue = expectedDTOList;
      expectedValue.first.uniqueId = 'nm1913125';
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
    test('Run dtoFromCompleteJsonMap() filtered', () {
      // Invoke the functionality and collect results.
      final actualResult = ImdbWebScraperConverter().dtoFromCompleteJsonMap(
        imdbJsonInnerFilteredSample,
        DataSourceType.imdbJson,
      );

      // Uncomment this line to update expectedDTOList if sample data changes
      // printTestData(actualResult);

      final expectedValue = expectedDTOList;
      expectedValue.first.uniqueId = 'nm1913125';
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
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
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
      final criteria = SearchCriteriaDTO().fromString('nm1913125');
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
      await testClass.clearThreadedCache();
      // ignore: unused_result
      await testClass.readPrioritisedCachedList(
        source: streamImdbHtmlOfflinePaginatedData,
      );
      final listResult = await testClass.readPrioritisedCachedList(
        source: StaticJsonGenerator.stuff,
        // Return some random junk
        // that will not get used do to caching
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
      final criteria = SearchCriteriaDTO().fromString('nm1913125');
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
      await testClass.clearThreadedCache();
      // ignore: unused_result
      await testClass.readPrioritisedCachedList(
        source: streamImdbHtmlOfflinePaginatedData,
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
      final criteria = SearchCriteriaDTO().fromString('nm1913125');
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
      await testClass.clearThreadedCache();
      // ignore: unused_result
      await testClass.readPrioritisedCachedList(
        source: streamImdbHtmlOfflinePaginatedData,
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

  group('QueryIMDBJsonDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expected = 'https://caching.graphql.imdb.com/?'
          'operationName=NameMainFilmographyPaginatedCredits'
          '&variables='
          '%7B%22after%22%3A%22MTIzNA%3D%3D%22%2C%22id%22%3A%221234%22%2C%22'
          'includeUserRating%22%3Afalse%2C%22locale%22%3A%22en-GB%22%7D'
          '&extensions='
          '%7B%22persistedQuery%22%3A%7B%22sha256Hash%22%3A%22'
          '4faf04583fbf1fbc7a025e5dffc7abc3486e9a04571898a27a5a1ef59c2965f3'
          '%22%2C%22version%22%3A1%7D%7D';
      final criteria = SearchCriteriaDTO();

      // Invoke the functionality.
      final actualResult = QueryIMDBJsonPaginatedFilmographyDetails(criteria)
          .myConstructURI('1234')
          .toString();

      // Check the results.
      expect(actualResult, expected);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryIMDBJsonDetails
////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBJsonDetails integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final criteria = SearchCriteriaDTO();
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
      final expectedValue = expectedDTOList;
      await testClass.myClearCache();

      // Invoke the functionality and collect results.
      final actualResult =
          testClass.myConvertTreeToOutputType(imdbJsonInnerPaginatedSample);

      // Check the results.
      expect(
        actualResult,
        completion(MovieResultDTOListMatcher(expectedValue)),
        reason: 'Emitted DTO list ${(await actualResult).toPrintableString()} '
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
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
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
  /// Integration tests using WebFetchBase, env and QueryIMDBJsonDetails
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read imdb search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final criteria = SearchCriteriaDTO().fromString('nm1913125');
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: streamImdbHtmlOfflinePaginatedData)
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
      // Explicitly check related because MovieResultDTOListMatcher won't
      expect(
        queryResult.first.related.length,
        1,
        reason: 'Related should contain a list on movies with the label Actor',
      );
      expect(
        queryResult.first.related['Actor']!.length,
        3,
        reason: 'Related should list 3 movies',
      );
    });

    // Read imdb search results from a simulated byte stream
    // and report error due to invalid html.
    test('invalid json', () async {
      // Set up the test data.
      const expectedException = '[imdb_Json-'
          'NameMainFilmographyPaginatedCredits-ImdbJsonSource.actor] Error in '
          'imdb_Json-NameMainFilmographyPaginatedCredits-ImdbJsonSource.actor '
          'with criteria nm123 convert error interpreting web text as a map '
          ':Invalid json FormatException: '
          'Unexpected character (at character 1)\n'
          'not valid json\n'
          '^\n';
      final queryResult = <MovieResultDTO>[];
      final criteria = SearchCriteriaDTO().fromString('nm123');
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: _emitInvalidJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read imdb search results from a simulated byte stream
    // and report error due to unexpected html.
    test('unexpected json contents', () async {
      // Set up the test data.
      const expectedException = '[imdb_Json-'
          'NameMainFilmographyPaginatedCredits-ImdbJsonSource.actor] Error in '
          'imdb_Json-NameMainFilmographyPaginatedCredits-ImdbJsonSource.actor '
          'with criteria nm123 convert error interpreting web text as a map '
          ':Invalid json FormatException: '
          'Unexpected character (at character 2)\n'
          '{{[]}}\n'
          ' ^\n';
      final queryResult = <MovieResultDTO>[];
      final criteria = SearchCriteriaDTO().fromString('nm123');
      final testClass = QueryIMDBJsonPaginatedFilmographyDetails(criteria);
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
