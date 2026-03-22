// allow test to do things production code should not
// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/magnet_eztv_api.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_eztv_api.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/magnet_eztv_api.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(_) =>
    Future.value(Stream.value('<html><body>stuff</body></html>'));

Future<Stream<String>> _emitInvalidHtmlSample(_) =>
    Future.value(Stream.value('not valid html'));

final criteria = SearchCriteriaDTO().fromString('dream');

final fullCriteria = SearchCriteriaDTO()
  ..init(
    SearchCriteriaType.downloadSimple,
    list: [MovieResultDTO().init(uniqueId: 'tt1234')],
  );

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
  ////////////////////////////////////////////////////////////////////////////////

  group('magnetEztvApi search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryMagnetEztvApiSearch(criteria).myDataSourceName(), 'eztvApi');
    });

    // Confirm simple criteria is displayed as expected.
    test('Run myFormatInputAsText() for simple keyword', () {
      expect(
        QueryMagnetEztvApiSearch(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO()
        ..criteriaTitle = 'List of errors'
        ..criteriaList = [
          MovieResultDTO().init(uniqueId: 'test1'),
          MovieResultDTO().init(uniqueId: 'test2'),
        ];
      expect(
        QueryMagnetEztvApiSearch(input).myFormatInputAsText(),
        'test1,test2',
      );
      expect(
        QueryMagnetEztvApiSearch(input).myFormatInputAsText(),
        'test1,test2',
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult = 'https://eztv.yt/api/get-torrents?imdb_id=1234';

      // Invoke the functionality.
      final testClass = QueryMagnetEztvApiSearch(fullCriteria)
        ..criteria = fullCriteria;
      final actualResult = testClass
          .myConstructURI(testClass.myFormatInputAsText())
          .toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'title': '[QueryMagnetEztvApiSearch] new query',
        'bestSource': 'DataSourceType.eztvApi',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryMagnetEztvApiSearch(
        criteria,
      ).myYieldError('new query').toMap()..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });

    test('Run myConvertWebTextToTraversableTree()', () {
      const expectedOutput = intermediateMapList;
      final testClass = QueryMagnetEztvApiSearch(criteria)..criteria = criteria;
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        jsonSample,
      );
      expect(actualOutput, completion([expectedOutput]));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () async {
      final actualOutput = QueryMagnetEztvApiSearch(
        criteria,
      ).myConvertWebTextToTraversableTree(jsonSampleEmpty);
      // actualOutput should be a list with a single map 
      // which contains 'torrents_count': 0
      final list = await actualOutput;
      expect(list.length, 1);
      expect(list[0], containsPair('torrents_count', 0));
    });
    test(
      'Run myConvertWebTextToTraversableTree() for too many results',
      () async {
        final actualOutput = QueryMagnetEztvApiSearch(
          criteria,
        ).myConvertWebTextToTraversableTree(jsonSampleTooMany);
        // actualOutput should be a list with a single map 
        // which contains 'torrents_count': 0
        final list = await actualOutput;
        expect(list.length, 1);
        expect(list[0], containsPair('torrents_count', 1027471));
      },
    );
    test('Run myConvertWebTextToTraversableTree() for invalid results', () {
      final expectedOutput = throwsA(
        isA<WebConvertException>().having(
          (e) => e.cause,
          'cause',
          contains('Invalid json FormatException: '),
        ),
      );
      final actualOutput = QueryMagnetEztvApiSearch(
        criteria,
      ).myConvertWebTextToTraversableTree(jsonSampleInvalid);
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualOutput, expectedOutput);
    });
  });
  group('MagnetEztvSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = MagnetEztvApiSearchConverter.dtoFromCompleteJsonMap(
        intermediateMapList,
      );

      // Uncomment this line to update expectedDTOList if sample data changes
      // writeTestData(actualResult);

      final expectedValue = readTestData();
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
  /// Integration tests using MagnetEztvSearchConverter
  ////////////////////////////////////////////////////////////////////////////////

  group('MagnetEztvSearchConverter integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final magnetEztvSearch = QueryMagnetEztvApiSearch(criteria);

      // Invoke the functionality and collect results.
      final actualResult = await magnetEztvSearch.myConvertTreeToOutputType(
        intermediateMapList,
      );
      // Uncomment this line to update expectedDTOList if sample data changes
      //writeTestData(actualResult);

      // Check the results.
      final expectedValue = readTestData();
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () {
      final expectedOutput = throwsA(
        isA<TreeConvertException>().having(
          (e) => e.cause,
          'cause',
          startsWith(
            'expected map got String unable to interpret data wrongData',
          ),
        ),
      );
      final magnetEztvSearch = QueryMagnetEztvApiSearch(criteria);

      // Invoke the functionality and collect results.
      final actualResult = magnetEztvSearch.myConvertTreeToOutputType(
        'wrongData',
      );

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType() empty', () async {
      final magnetEztvSearch = QueryMagnetEztvApiSearch(criteria);

      final tree = await magnetEztvSearch.myConvertWebTextToTraversableTree(
        jsonSampleEmpty,
      );

      // Invoke the functionality and collect results.
      final actualResult = await magnetEztvSearch.myConvertTreeToOutputType(
        tree.first,
      );

      // Check the results.
      final expectedValue = <MovieResultDTO>[];
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
    test('Run myConvertTreeToOutputType() Too Many', () async {
      final magnetEztvSearch = QueryMagnetEztvApiSearch(criteria);

      final tree = await magnetEztvSearch.myConvertWebTextToTraversableTree(
        jsonSampleTooMany,
      );

      // Invoke the functionality and collect results.
      final actualResult = await magnetEztvSearch.myConvertTreeToOutputType(
        tree.first,
      );

      // Check the results.
      final expectedValue = <MovieResultDTO>[];
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
  /// Integration tests using WebFetchBase and QueryMagnetEztvApiSearch
  ////////////////////////////////////////////////////////////////////////////////

  group('magnetEztvApi search query', () {
    // Read search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final magnetEztvSearch = QueryMagnetEztvApiSearch(criteria);

      // Invoke the functionality.
      await magnetEztvSearch
          .readList(source: streamHtmlOfflineData)
          .then(queryResult.addAll)
          .onError(
            // Print any errors encountered during processing.
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );
      // printTestData(queryResult);

      // Check the results.
      final expectedValue = readTestData();
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue, related: false),
        reason:
            'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    test('Run readList() large results', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final magnetEztvSearch = QueryMagnetEztvApiSearch(criteria);

      // Invoke the functionality.
      await magnetEztvSearch
          .readList(source: streamHtmlOfflineDataLarge)
          .then(queryResult.addAll)
          .onError(
            // Print any errors encountered during processing.
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );
      // writeTestData(queryResult, testName: 'large');

      // Check the results.
      final expectedValue = readTestData(testName: 'large');
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue, related: false),
        reason:
            'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Read search results from a simulated byte stream
    // and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final magnetEztvSearch = QueryMagnetEztvApiSearch(criteria);
      final expectedException =
          '[QueryMagnetEztvApiSearch] Error in eztvApi with criteria '
          '${criteria.toPrintableIdOrText().toLowerCase()} convert error '
          'interpreting web text as a map '
          ':Invalid json FormatException: Unexpected character (at character 1)'
          '\nnot valid html\n^\n';

      // Invoke the functionality.
      await magnetEztvSearch
          .readList(source: _emitInvalidHtmlSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read search results from a simulated byte stream
    // and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      final expectedException =
          '[QueryMagnetEztvApiSearch] Error in eztvApi with criteria '
          '${criteria.toPrintableIdOrText().toLowerCase()} convert error '
          'translating page map to objects :expected map got Document '
          'unable to interpret data #document';
      final queryResult = <MovieResultDTO>[];
      final magnetEztvSearch = QueryMagnetEztvApiSearch(criteria);

      // Invoke the functionality.
      await magnetEztvSearch
          .readList(source: _emitUnexpectedHtmlSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
