import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_json_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(_) => Future.value(
  Stream.value(
    '{{['
    ']}}',
  ),
);

Future<Stream<String>> _emitInvalidJsonSample(_) =>
    Future.value(Stream.value('not valid json'));

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBJsonDetails unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      final criteria = SearchCriteriaDTO();
      expect(
        QueryIMDBJsonPaginatedFilmographyDetails(criteria).myDataSourceName(),
        'imdb_Json-FilmographyV2Pagination',
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
      final input =
          SearchCriteriaDTO()
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
        'title':
            '[imdb_Json-FilmographyV2Pagination] '
            'new query',
        'type': 'MovieContentType.error',
      };
      final criteria = SearchCriteriaDTO();
      // Invoke the functionality.
      final actualResult =
          QueryIMDBJsonPaginatedFilmographyDetails(
              criteria,
            ).myYieldError('new query').toMap()
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
      final actualResult = ImdbJsonConverter().dtoFromCompleteJsonMap(
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
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap() filtered', () {
      // Invoke the functionality and collect results.
      final actualResult = ImdbJsonConverter().dtoFromCompleteJsonMap(
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
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
  });

  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryIMDBJsonDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expected =
          'https://www.imdb.com/name/1234/';
      final criteria = SearchCriteriaDTO();

      // Invoke the functionality.
      final actualResult =
          QueryIMDBJsonPaginatedFilmographyDetails(
            criteria,
          ).myConstructURI('1234').toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
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
      final actualResult = testClass.myConvertTreeToOutputType(
        imdbJsonInnerPaginatedSample,
      );

      // Check the results.
      expect(
        actualResult,
        completion(MovieResultDTOListMatcher(expectedValue)),
        reason:
            'Emitted DTO list ${(await actualResult).toPrintableString()} '
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
/* requires native android device
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
        reason:
            'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
      // Explicitly check related because MovieResultDTOListMatcher won't
      expect(
        queryResult.first.related.length,
        1,
        reason: 'Related should contain a list on movies with the label Actor:',
      );
      expect(
        queryResult.first.related['Actor:']!.length,
        3,
        reason: 'Related should list 3 movies',
      );
    });

    // Read imdb search results from a simulated byte stream
    // and report error due to invalid html.
    test('invalid json', () async {
      // Set up the test data.
      const expectedException =
          '[imdb_Json-FilmographyV2Pagination] Error in '
          'imdb_Json-FilmographyV2Pagination '
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
      const expectedException =
          '[imdb_Json-FilmographyV2Pagination] Error in '
          'imdb_Json-FilmographyV2Pagination '
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
  });*/
}
