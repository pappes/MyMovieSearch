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

Future<Stream<String>> _emitUnexpectedHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('<html><body>stuff</body></html>'));
}

Future<Stream<String>> _emitInvalidHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('not valid html'));
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () async {
      expect(QueryIMDBSearch().myDataSourceName(), 'imdbSearch');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () async {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryIMDBSearch().myFormatInputAsText(input),
        'testing',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList',
        () async {
      final input = SearchCriteriaDTO();
      input.criteriaList = [
        MovieResultDTO().error('test1'),
        MovieResultDTO().error('test2'),
      ];
      expect(
        QueryIMDBSearch().myFormatInputAsText(input),
        contains('test1'),
      );
      expect(
        QueryIMDBSearch().myFormatInputAsText(input),
        contains('test2'),
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () async {
      const expectedResult =
          'https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=new%20query';

      // Invoke the functionality.
      final actualResult =
          QueryIMDBSearch().myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () async {
      const expectedResult = {
        'source': 'DataSourceType.imdbSearch',
        'title': '[QueryIMDBSearch] new query',
        'type': 'MovieContentType.custom',
        'related': {}
      };

      // Invoke the functionality.
      final actualResult = QueryIMDBSearch().myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    test('Run myConvertWebTextToTraversableTree()', () async {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          await QueryIMDBSearch().myConvertWebTextToTraversableTree(
        imdbSearchHtmlSampleFull,
      );
      expect(actualOutput, expectedOutput);
    });
  });
  group('ImdbSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () async {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          ImdbWebScraperConverter(DataSourceType.imdbSearch)
              .dtoFromCompleteJsonMap(map),
        );
      }

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
      final imdbSearch = QueryIMDBSearch();
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
      final imdbSearch = QueryIMDBSearch();

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
      final imdbSearch = QueryIMDBSearch();

      // Invoke the functionality.
      await imdbSearch
          .readList(
            SearchCriteriaDTO(),
            source: streamImdbSearchHtmlOfflineData,
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
      final imdbSearch = QueryIMDBSearch();
      const expectedException =
          '[QueryIMDBSearch] Error in imdbSearch with criteria  interpreting web text as a map :no search results found in not valid html';

      // Invoke the functionality.
      await imdbSearch
          .readList(SearchCriteriaDTO(), source: _emitInvalidHtmlSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read IMDB search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBSearch] Error in imdbSearch with criteria  interpreting web text as a map :no search results found in <html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final imdbSearch = QueryIMDBSearch();

      // Invoke the functionality.
      await imdbSearch
          .readList(SearchCriteriaDTO(), source: _emitUnexpectedHtmlSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration redirect tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb search redirect', () {
    test('Run QueryIMDBTitleDetails myConvertWebTextToTraversableTree()',
        () async {
      final expectedOutput = title_data.intermediateMapList;

      final imdbSearch = QueryIMDBSearch();
      imdbSearch.criteria = SearchCriteriaDTO().fromString('tt7602562');
      final actualOutput = await imdbSearch.myConvertWebTextToTraversableTree(
        title_data.imdbHtmlSampleFull,
      );
      expect(actualOutput, expectedOutput);
    });

    // Run IMDB search for a single movie
    // causing the query to return the movie details page
    // instead of the search results page.
    test('Run readList() for a specific movie', () async {
      // Set up the test data.
      final expectedValue = title_data.expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final imdbSearch = QueryIMDBSearch();

      // Invoke the functionality.
      await imdbSearch
          .readList(
            SearchCriteriaDTO().fromString('tt7602562'),
            source: title_data.streamImdbHtmlOfflineData,
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

    test('Run QueryIMDBNameDetails myConvertWebTextToTraversableTree()',
        () async {
      final expectedOutput = person_data.intermediateMapList;

      final imdbSearch = QueryIMDBSearch();
      imdbSearch.criteria = SearchCriteriaDTO().fromString('nm7602562');
      final actualOutput = await imdbSearch.myConvertWebTextToTraversableTree(
        person_data.imdbHtmlSampleFull,
      );
      expect(actualOutput, expectedOutput);
    });
    // Run IMDB search for a single person
    // causing the query to return the person details page
    // instead of the search results page.
    test('Run readList()for a specific person', () async {
      // Set up the test data.
      final expectedValue = person_data.expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final imdbSearch = QueryIMDBSearch();

      // steal expectedValue from imdb_name test data but source is really imdbSearch
      expectedValue[0].source = DataSourceType.imdbSearch;
      final related = expectedValue[0].related['Actor']!;
      related['tt0012370']!.source = DataSourceType.imdbSearch;
      related['tt0123580']!.source = DataSourceType.imdbSearch;

      // Invoke the functionality.
      await imdbSearch
          .readList(
            SearchCriteriaDTO().fromString('nm7602562'),
            source: person_data.streamImdbHtmlOfflineData,
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
  });
}
