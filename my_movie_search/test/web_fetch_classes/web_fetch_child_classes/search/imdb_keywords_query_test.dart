import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_keywords.dart';

import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('<html><body>stuff</body></html>'));
}

Future<Stream<String>> _emitInvalidHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('not valid html'));
}

Future<Stream<String>> _emitUnexpectedJsonSample(dynamic dummy) {
  final unexpectedJson = imdbKeywordsHtmlSampleFull.replaceAll(
    '"results"',
    '"found"',
  );
  return Future.value(Stream.value(unexpectedJson));
}

Future<Stream<String>> _emitEmtpyJsonSample(dynamic dummy) {
  const emptyJson = '$imdbKeywordsHtmlSampleStart{}$imdbKeywordsHtmlSampleEnd';
  return Future.value(Stream.value(emptyJson));
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryIMDBKeywords().myDataSourceName(), 'imdbKeywords');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryIMDBKeywords().myFormatInputAsText(input),
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
        QueryIMDBKeywords().myFormatInputAsText(input),
        contains('test1'),
      );
      expect(
        QueryIMDBKeywords().myFormatInputAsText(input),
        contains('test2'),
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult =
          'https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=new%20query';

      // Invoke the functionality.
      final actualResult =
          QueryIMDBKeywords().myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.imdbKeywords',
        'title': '[QueryIMDBKeywords] new query',
        'type': 'MovieContentType.error',
        'related': {}
      };

      // Invoke the functionality.
      final actualResult =
          QueryIMDBKeywords().myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    test('Run myConvertWebTextToTraversableTree()', () {
      const expectedOutput = intermediateMapList;
      final actualOutput =
          QueryIMDBKeywords().myConvertWebTextToTraversableTree(
        imdbKeywordsHtmlSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });
  group('ImdbSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          ImdbKeywordsConverter.dtoFromCompleteJsonMap(map),
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
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using ImdbSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('ImdbSearchConverter integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final imdbKeywords = QueryIMDBKeywords();
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          await imdbKeywords.myConvertTreeToOutputType(map),
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
      final imdbKeywords = QueryIMDBKeywords();

      // Invoke the functionality and collect results.
      final actualResult = imdbKeywords.myConvertTreeToOutputType('map');

      // Check the results.
      //NOTE: Using expect on an async result only works as the last line of the test!
      expect(
        actualResult,
        throwsA('expected map got String unable to interpret data map'),
      );
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and ScrapeIMDBSearchDetails and ImdbSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read IMDB search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final imdbKeywords = QueryIMDBKeywords();

      // Invoke the functionality.
      await imdbKeywords
          .readList(
            SearchCriteriaDTO().fromString('123'),
            source: streamImdbKeywordsHtmlOfflineData,
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

    // Read IMDB search results from a simulated byte stream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final imdbKeywords = QueryIMDBKeywords();
      const expectedException = '[QueryIMDBKeywords] Error in imdbKeywords '
          'with criteria 123 interpreting web text as a map '
          ':imdb keyword data not detected for criteria 123';

      // Invoke the functionality.
      await imdbKeywords
          .readList(
            SearchCriteriaDTO().fromString('123'),
            source: _emitInvalidHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read IMDB search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException = '[QueryIMDBKeywords] Error in imdbKeywords '
          'with criteria 123 interpreting web text as a map '
          ':imdb keyword data not detected for criteria 123';
      final queryResult = <MovieResultDTO>[];
      final imdbKeywords = QueryIMDBKeywords();

      // Invoke the functionality.
      await imdbKeywords
          .readList(
            SearchCriteriaDTO().fromString('123'),
            source: _emitUnexpectedHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
