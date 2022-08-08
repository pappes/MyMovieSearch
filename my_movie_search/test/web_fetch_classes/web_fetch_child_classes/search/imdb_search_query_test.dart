import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_search.dart';
import '../../../test_helper.dart';

Future<Stream<String>> emitUnexpectedHTMLSample(dynamic dummy) {
  return Future.value(Stream.value('<html><body>stuff</body></html>'));
}

Future<Stream<String>> emitInvalidHtmlSample(dynamic dummy) {
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
        reason: 'Emmitted DTO list ${actualResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
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
        'related': '{}'
      };

      // Invoke the functionality.
      final actualResult = QueryIMDBSearch().myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read IMDB search results from a simulated bytestream and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final imdbSearch = QueryIMDBSearch();

      // Invoke the functionality.
      await imdbSearch
          .readList(SearchCriteriaDTO(),
              source: streamImdbSearchHtmlOfflineData)
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, ${stackTrace.toString()}'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emmitted DTO list ${queryResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });

    // Read IMDB search results from a simulated bytestream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final imdbSearch = QueryIMDBSearch();
      const expectedException =
          '[QueryIMDBSearch] Error in imdbSearch with criteria  intepreting web text as a map :no search results found in not valid html';

      // Invoke the functionality.
      await imdbSearch
          .readList(SearchCriteriaDTO(), source: emitInvalidHtmlSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read IMDB search results from a simulated bytestream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBSearch] Error in imdbSearch with criteria  intepreting web text as a map :no search results found in <html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final imdbSearch = QueryIMDBSearch();

      // Invoke the functionality.
      await imdbSearch
          .readList(SearchCriteriaDTO(), source: emitUnexpectedHTMLSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
