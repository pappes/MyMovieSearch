import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/yts_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/yts_search.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonPSample(_) =>
    Future.value(Stream.value('imdbJsonPFunction(null)'));

Future<Stream<String>> _emitInvalidJsonPSample(_) =>
    Future.value(Stream.value('imdbJsonPFunction({not valid json})'));

final fullCriteria = SearchCriteriaDTO().init(
  SearchCriteriaType.downloadSimple,
  list: [MovieResultDTO().init(uniqueId: 'tt123')],
);

final partialCriteria = SearchCriteriaDTO().init(
  SearchCriteriaType.downloadSimple,
  title: '123',
);

final ignoreCriteria = SearchCriteriaDTO().init(
  SearchCriteriaType.downloadSimple,
  title: 'ignore this',
);

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestions unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryYtsSearch(fullCriteria).myDataSourceName(),
        'ytsSearch',
      );
    });

    // Confirm dto criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO list', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryYtsSearch(fullCriteria).myFormatInputAsText(),
        fullCriteria.criteriaList.first.uniqueId,
      );
    });

    // Confirm text criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryYtsSearch(partialCriteria).myFormatInputAsText(),
        partialCriteria.criteriaTitle,
      );
    });

    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () {
      final expectedValue = expectedDTOList;
      final webfetch = QueryYtsSearch(ignoreCriteria);

      // Invoke the functionality and collect results.
      final actualResult =
          webfetch.myConvertTreeToOutputType(jsonDecode(jsonSampleFull));

      // Check the results.
      expect(
        actualResult,
        completion(MovieResultDTOListMatcher(expectedValue)),
      );
    });
    test('Run myConvertTreeToOutputType() with empty search results', () async {
      final expectedValue = <MovieResultDTO>[];
      final webfetch = QueryYtsSearch(ignoreCriteria);

      // Invoke the functionality and collect results.
      final actualResult =
          webfetch.myConvertTreeToOutputType(jsonDecode(jsonSampleEmpty));

      // Check the results.
      expect(
        actualResult,
        completion(MovieResultDTOListMatcher(expectedValue)),
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () async {
      final webfetch = QueryYtsSearch(ignoreCriteria);

      // Invoke the functionality and collect results.
      final actualResult = webfetch.myConvertTreeToOutputType('map');

      // Check the results.
      //NOTE: Using expect on an async result only works as the last line of the test!
      expect(
        actualResult,
        throwsA('expected map got String unable to interpret data map'),
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult = 'https://yts.mx/ajax/search?query=/new%20query';

      // Invoke the functionality.
      final actualResult =
          QueryYtsSearch(ignoreCriteria).myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'uniqueId': '-',
        'bestSource': 'DataSourceType.ytsSearch',
        'title': '[QueryYtsSearch] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult =
          QueryYtsSearch(ignoreCriteria).myYieldError('new query').toMap();
      // Exact id does not need to match as long as it is negative number
      actualResult['uniqueId'] =
          actualResult['uniqueId'].toString().substring(0, 1);

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          QueryYtsSearch(ignoreCriteria).myConvertWebTextToTraversableTree(
        jsonSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () {
      final expectedOutput = intermediateEmptyMapList;
      final actualOutput =
          QueryYtsSearch(ignoreCriteria).myConvertWebTextToTraversableTree(
        jsonSampleEmpty,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results', () {
      final expectedOutput =
          throwsA(startsWith('Invalid json returned from web call'));
      final actualOutput =
          QueryYtsSearch(ignoreCriteria).myConvertWebTextToTraversableTree(
        'imdbErrorSample',
      );
      expect(actualOutput, expectedOutput);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('yts suggestion query', () {
    // Read search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final webfetch = QueryYtsSearch(ignoreCriteria);

      // Invoke the functionality.
      await webfetch
          .readList(
            source: streamJsonOfflineData,
          )
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );
      // printTestData(queryResult);

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });

    // Read search results from a simulated byte stream and report error due to invalid html.
    test('invalid json', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final webfetch = QueryYtsSearch(fullCriteria);
      const expectedException =
          '[QueryYtsSearch] Error in ytsSearch with criteria tt123 '
          'convert error interpreting web text as a map '
          ':Invalid json returned from web call {not valid json}';

      // Invoke the functionality.
      await webfetch
          .readList(
            source: _emitInvalidJsonPSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read search results from a simulated byte stream and convert JSON to dtos.
    test('unexpected json contents', () async {
      // Set up the test data.
      const expectedException = '[QueryYtsSearch] Error in ytsSearch '
          'with criteria tt123 convert error translating page map to objects '
          ':expected map got Null unable to interpret data null';
      final queryResult = <MovieResultDTO>[];
      final webfetch = QueryYtsSearch(fullCriteria);

      // Invoke the functionality.
      await webfetch
          .readList(
            source: _emitUnexpectedJsonPSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
