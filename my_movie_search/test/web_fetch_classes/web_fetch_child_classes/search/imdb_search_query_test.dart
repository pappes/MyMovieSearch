import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_name.dart'
    as person_data;
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart'
    as title_data;
import 'package:my_movie_search/movies/web_data_providers/search/imdb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_search.dart';

import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(_) =>
    Future.value(Stream.value('<html><body>stuff</body></html>'));

Future<Stream<String>> _emitInvalidHtmlSample(_) =>
    Future.value(Stream.value('not valid html'));

Future<Stream<String>> _emitUnexpectedJsonSample(_) {
  final unexpectedJson = htmlSampleFull.replaceAll(
    '"results"',
    '"found"',
  );
  return Future.value(Stream.value(unexpectedJson));
}

Future<Stream<String>> _emitEmtpyJsonSample(_) {
  const emptyJson = '$htmlSampleStart{}$htmlSampleEnd';
  return Future.value(Stream.value(emptyJson));
}

final criteria = SearchCriteriaDTO().fromString('123');

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryIMDBSearch(criteria).myDataSourceName(), 'imdbSearch');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryIMDBSearch(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO()
        ..criteriaList = [
          MovieResultDTO().error('test1'),
          MovieResultDTO().error('test2'),
        ];
      expect(
        QueryIMDBSearch(input).myFormatInputAsText(),
        contains('test1'),
      );
      expect(
        QueryIMDBSearch(input).myFormatInputAsText(),
        contains('test2'),
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult =
          'https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=new%20query';

      // Invoke the functionality.
      final actualResult =
          QueryIMDBSearch(criteria).myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.imdbSearch',
        'title': '[QueryIMDBSearch] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryIMDBSearch(criteria)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    test('Run myConvertWebTextToTraversableTree()', () {
      const expectedOutput = intermediateMapList;
      final actualOutput =
          QueryIMDBSearch(criteria).myConvertWebTextToTraversableTree(
        htmlSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () {
      const expectedOutput = <void>[];
      final actualOutput =
          QueryIMDBSearch(criteria).myConvertWebTextToTraversableTree(
        htmlSampleEmpty,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results', () {
      final expectedOutput =
          throwsA(startsWith('No search results found in html'));
      final actualOutput =
          QueryIMDBSearch(criteria).myConvertWebTextToTraversableTree(
        htmlSampleError,
      );
      //NOTE: Using expect on an async result only works as the last line of the test!
      expect(actualOutput, expectedOutput);
    });
  });
  group('ImdbSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          ImdbWebScraperConverter()
              .dtoFromCompleteJsonMap(map, DataSourceType.imdbSearch),
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
      final imdbSearch = QueryIMDBSearch(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          await imdbSearch.myConvertTreeToOutputType(map),
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
      final imdbSearch = QueryIMDBSearch(criteria);

      // Invoke the functionality and collect results.
      final actualResult = imdbSearch.myConvertTreeToOutputType('map');

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
      final imdbSearch = QueryIMDBSearch(criteria);

      // Invoke the functionality.
      await imdbSearch
          .readList(
            source: streamImdbSearchHtmlOfflineData,
          )
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });

    // Read IMDB suggestions from a simulated byte stream and convert JSON to dtos.
    test('empty readList()', () async {
      // Set up the test data.
      final expectedValue = <MovieResultDTO>[];
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSearch(criteria);

      // Invoke the functionality.
      await imdbSuggestions
          .readList(
            source: emitEmptyImdbSearchSample,
          )
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
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
      final imdbSearch = QueryIMDBSearch(criteria);
      const expectedException = '[QueryIMDBSearch] Error in imdbSearch '
          'with criteria 123 convert error interpreting web text as a map '
          ':No search results found in html:not valid html';

      // Invoke the functionality.
      await imdbSearch
          .readList(
            source: _emitInvalidHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read IMDB search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException = '[QueryIMDBSearch] Error in imdbSearch '
          'with criteria 123 convert error interpreting web text as a map '
          ':No search results found in html:<html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final imdbSearch = QueryIMDBSearch(criteria);

      // Invoke the functionality.
      await imdbSearch
          .readList(
            source: _emitUnexpectedHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });

  // Read IMDB search results from a simulated byte stream and report error due to unexpected json.
  test('unexpected json contents', () async {
    // Set up the test data.
    const expectedException = '[QueryIMDBSearch] Error in imdbSearch '
        'with criteria 123 convert error interpreting web text as a map '
        ':Possible IMDB site update, no search result found for search query, '
        'json contents:[{props: {pageProps: {nameResults: {found: [{id: nm0152436, displayNameText:';
    final queryResult = <MovieResultDTO>[];
    final imdbSearch = QueryIMDBSearch(criteria);

    // Invoke the functionality.
    await imdbSearch
        .readList(
          source: _emitUnexpectedJsonSample,
        )
        .then((values) => queryResult.addAll(values));
    expect(queryResult.first.title, startsWith(expectedException));

    // Check the results.
  });

  // Read IMDB search results from a simulated byte stream and report error due to unexpected json.
  test('no json results', () async {
    // Set up the test data.
    const expectedException = '[QueryIMDBSearch] Error in imdbSearch '
        'with criteria 123 convert error interpreting web text as a map '
        ':Possible IMDB site update, no search result found for search query, '
        'json contents:{}';
    final queryResult = <MovieResultDTO>[];
    final imdbSearch = QueryIMDBSearch(criteria);

    // Invoke the functionality.
    await imdbSearch
        .readList(
          source: _emitEmtpyJsonSample,
        )
        .then((values) => queryResult.addAll(values));
    expect(queryResult.first.title, expectedException);

    // Check the results.
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration redirect tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb search redirect', () {
    test('Run QueryIMDBTitleDetails myConvertWebTextToTraversableTree()', () {
      const expectedOutput = title_data.intermediateMapList;

      final imdbSearch = QueryIMDBSearch(criteria);
      final actualOutput = imdbSearch.myConvertWebTextToTraversableTree(
        title_data.imdbHtmlSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });

    // Run IMDB search for a single movie
    // causing the query to return the movie details page
    // instead of the search results page.
    test('Run readList() for a specific movie', () async {
      // Set up the test data.
      final expectedValue = title_data.expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final imdbSearch = QueryIMDBSearch(criteria);

      // steal expectedValue from imdb_name test data but source is really imdbSearch
      expectedValue[0].setSource(newSource: DataSourceType.imdbSearch);

      // Invoke the functionality.
      await imdbSearch
          .readList(
            source: title_data.streamImdbHtmlOfflineData,
          )
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });

    test('Run QueryIMDBNameDetails myConvertWebTextToTraversableTree()',
        () async {
      const expectedOutput = person_data.intermediateMapList;

      final imdbSearch = QueryIMDBSearch(criteria);
      final actualOutput = imdbSearch.myConvertWebTextToTraversableTree(
        person_data.imdbHtmlSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    // Run IMDB search for a single person
    // causing the query to return the person details page
    // instead of the search results page.
    test('Run readList()for a specific person', () async {
      // Set up the test data.
      final expectedValue = person_data.expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final imdbSearch = QueryIMDBSearch(criteria);

      // steal expectedValue from imdb_name test data but source is really imdbSearch
      expectedValue[0].setSource(newSource: DataSourceType.imdbSearch);

      // Invoke the functionality.
      await imdbSearch
          .readList(
            source: person_data.streamImdbHtmlOfflineData,
          )
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });
  });
}
