import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/fishpond_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/fishpond_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/fishpond_barcode.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(_) =>
    Future.value(Stream.value('<html><body>stuff</body></html>'));

Future<Stream<String>> _emitInvalidHtmlSample(_) =>
    Future.value(Stream.value('not valid html'));

final criteria = SearchCriteriaDTO().fromString('dream');

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('FishpondBarcode search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryFishpondBarcodeSearch(criteria).myDataSourceName(),
        'fishpondBarcode',
      );
    });

    // Confirm simple criteria is displayed as expected.
    test('Run myFormatInputAsText() for simple keyword', () {
      expect(
        QueryFishpondBarcodeSearch(criteria).myFormatInputAsText(),
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
        QueryFishpondBarcodeSearch(input).myFormatInputAsText(),
        'test1,test2',
      );
      expect(
        QueryFishpondBarcodeSearch(input).myFormatInputAsText(),
        'test1,test2',
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult =
          'https://www.mightyape.com.au/search?s=new%20query+';

      // Invoke the functionality.
      final actualResult = QueryFishpondBarcodeSearch(criteria)
          .myConstructURI('new query')
          .toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.fishpondBarcode',
        'title': '[QueryFishpondBarcodeSearch] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryFishpondBarcodeSearch(criteria)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm web text is parsed as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      const expectedOutput = intermediateMapList;
      final testClass = QueryFishpondBarcodeSearch(criteria)
        ..criteria = criteria;
      final actualOutput =
          testClass.myConvertWebTextToTraversableTree(htmlSampleFull);
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () {
      final expectedOutput = <void>[];
      final actualOutput = QueryFishpondBarcodeSearch(criteria)
          .myConvertWebTextToTraversableTree(htmlSampleEmpty);
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results', () {
      final expectedOutput = throwsA(isA<WebConvertException>().having(
        (e) => e.cause,
        'cause',
        contains('results data not detected log'),
      ));
      final actualOutput = QueryFishpondBarcodeSearch(criteria)
          .myConvertWebTextToTraversableTree(htmlSampleError);
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualOutput, expectedOutput);
    });
  });
  group('FishpondBarcodeSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          FishpondBarcodeSearchConverter.dtoFromCompleteJsonMap(map, criteria),
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
  /// Integration tests using FishpondBarcodeSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('FishpondBarcodeSearchConverter integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final webfetch = QueryFishpondBarcodeSearch(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          await webfetch.myConvertTreeToOutputType(map),
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
      final expectedOutput = throwsA(isA<TreeConvertException>().having(
          (e) => e.cause,
          'cause',
          startsWith(
            'expected map got String unable to interpret data wrongData',
          )));
      final webfetch = QueryFishpondBarcodeSearch(criteria);

      // Invoke the functionality and collect results.
      final actualResult = webfetch.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase
  ///  and ScrapeFishpondBarcodeSearchDetails
  ///  and FishpondBarcodeSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('FishpondBarcode search query', () {
    // Read search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final webfetch = QueryFishpondBarcodeSearch(criteria);

      // Invoke the functionality.
      await webfetch
          .readList(
            source: streamHtmlOfflineData,
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
        MovieResultDTOListMatcher(expectedValue, related: false),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Read search results from a simulated byte stream
    // and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final expectedException =
          '[QueryFishpondBarcodeSearch] Error in fishpondBarcode '
          'with criteria '
          '${criteria.toPrintableIdOrText().toLowerCase()} convert error '
          'interpreting web text as a map :FishpondBarcode results data '
          'not detected log: resultSelector found 0 result\n '
          'for criteria ${criteria.toPrintableIdOrText().toLowerCase()} in '
          'html:not valid html';
      final queryResult = <MovieResultDTO>[];
      final webfetch = QueryFishpondBarcodeSearch(criteria);

      // Invoke the functionality.
      await webfetch
          .readList(
            source: _emitInvalidHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read search results from a simulated byte stream
    // and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      final expectedException =
          '[QueryFishpondBarcodeSearch] Error in fishpondBarcode '
          'with criteria '
          '${criteria.toPrintableIdOrText().toLowerCase()} convert error '
          'interpreting web text as a map :FishpondBarcode results data '
          'not detected log: resultSelector found 0 result\n '
          'for criteria ${criteria.toPrintableIdOrText().toLowerCase()} in '
          'html:<html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final webfetch = QueryFishpondBarcodeSearch(criteria);

      // Invoke the functionality.
      await webfetch
          .readList(
            source: _emitUnexpectedHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
