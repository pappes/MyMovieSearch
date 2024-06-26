import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_movies_for_keyword.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_movies_for_keyword.dart';
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

  group('imdb search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryIMDBMoviesForKeyword(criteria).myDataSourceName(),
        'imdbKeywords',
      );
    });

    // Confirm simple criteria is displayed as expected.
    test('Run myFormatInputAsText() for simple keyword', () {
      expect(
        QueryIMDBMoviesForKeyword(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm dto criteria is displayed as expected.
    /*test('Run myFormatInputAsText() for encoded keyword', () {
      const expectedKeyword = '''
testing and punctuation 
'' "" <> {} [] Tabs -> 			<-
      ''';
      const expectedPage = 200;
      const expectedUrl = 'http://somewhere';

      final input = SearchCriteriaDTO();
      final jsonText = QueryIMDBMoviesForKeyword.encodeJson(
        expectedKeyword,
        expectedPage.toString(),
        expectedUrl,
      );
      input.criteriaContext = MovieResultDTO().init(description: jsonText);
      expect(
        QueryIMDBMoviesForKeyword(input).myFormatInputAsText(),
        expectedKeyword,
      );
      expect(
        QueryIMDBMoviesForKeyword(input).myGetPageNumber(),
        expectedPage,
      );
    });*/

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO()
        ..criteriaList = [
          MovieResultDTO().error('test1'),
          MovieResultDTO().error('test2'),
        ];
      expect(
        QueryIMDBMoviesForKeyword(input).myFormatInputAsText(),
        contains('test1'),
      );
      expect(
        QueryIMDBMoviesForKeyword(input).myFormatInputAsText(),
        contains('test2'),
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult =
          'https://www.imdb.com/search/title/?keywords=new%20query&explore=keywords';

      // Invoke the functionality.
      final actualResult = QueryIMDBMoviesForKeyword(criteria)
          .myConstructURI('new query')
          .toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.imdbKeywords',
        'title': '[QueryIMDBMoviesForKeyword] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryIMDBMoviesForKeyword(criteria)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      const expectedOutput = intermediateMapList;
      final testClass = QueryIMDBMoviesForKeyword(criteria)
        ..criteria = criteria;
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        imdbHtmlSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () async {
      const expectedOutput = intermediateEmptyMapList;
      final actualOutput =
          QueryIMDBMoviesForKeyword(criteria).myConvertWebTextToTraversableTree(
        imdbHtmlSampleEmpty,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results',
        () async {
      final expectedOutput = throwsA(
        isA<WebConvertException>().having(
          (e) => e.cause,
          'cause',
          contains('data not detected for criteria '
              '${criteria.toPrintableIdOrText().toLowerCase()}'),
        ),
      );
      final actualOutput =
          QueryIMDBMoviesForKeyword(criteria).myConvertWebTextToTraversableTree(
        'htmlSampleError',
      );
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualOutput, expectedOutput);
    });
  });
  group('ImdbSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run empty dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateEmptyMapList) {
        actualResult.addAll(
          ImdbWebScraperConverter().dtoFromCompleteJsonMap(
            map,
            DataSourceType.imdbKeywords,
          ),
        );
      }

      final expectedValue = <MovieResultDTO>[];
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
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          ImdbWebScraperConverter().dtoFromCompleteJsonMap(
            map,
            DataSourceType.imdbKeywords,
          ),
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
  /// Integration tests using ImdbSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('ImdbSearchConverter integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final imdbKeywords = QueryIMDBMoviesForKeyword(criteria);
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
      final imdbKeywords = QueryIMDBMoviesForKeyword(criteria);

      // Invoke the functionality and collect results.
      final actualResult = imdbKeywords.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and ScrapeIMDBSearchDetails
  /// and ImdbSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read IMDB search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final imdbKeywords = QueryIMDBMoviesForKeyword(criteria);

      // Invoke the functionality.
      await imdbKeywords
          .readList(source: streamImdbKeywordsHtmlOfflineData)
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

    // Read IMDB search results from a simulated byte stream
    // and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final imdbKeywords = QueryIMDBMoviesForKeyword(criteria);
      const expectedException =
          '[QueryIMDBMoviesForKeyword] Error in imdbKeywords '
          'with criteria dream convert error interpreting web text as a map '
          ':imdb web scraper data not detected for criteria dream in '
          'not valid html';

      // Invoke the functionality.
      await imdbKeywords
          .readList(source: _emitInvalidHtmlSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read IMDB search results from a simulated byte stream
    // and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBMoviesForKeyword] Error in imdbKeywords '
          'with criteria dream convert error interpreting web text as a map '
          ':imdb web scraper data not detected for criteria dream in '
          '<html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final imdbKeywords = QueryIMDBMoviesForKeyword(criteria);

      // Invoke the functionality.
      await imdbKeywords
          .readList(source: _emitUnexpectedHtmlSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
