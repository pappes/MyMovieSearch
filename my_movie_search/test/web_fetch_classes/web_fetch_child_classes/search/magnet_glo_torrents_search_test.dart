import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/magnet_glo_torrents.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_glo_torrents.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/magnet_glo_torrents.dart';

import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('<html><body>stuff</body></html>'));
}

Future<Stream<String>> _emitInvalidHtmlSample(dynamic dummy) {
  return Future.value(Stream.value('not valid html'));
}

final criteria = SearchCriteriaDTO().fromString('dream');

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('GloTorrents search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryGloTorrentsSearch(criteria).myDataSourceName(),
        'gloTorrents',
      );
    });

    // Confirm simple criteria is displayed as expected.
    test('Run myFormatInputAsText() for simple keyword', () {
      expect(
        QueryGloTorrentsSearch(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'List of errors';
      input.criteriaList = [
        MovieResultDTO().error('test1'),
        MovieResultDTO().error('test2'),
      ];
      expect(
        QueryGloTorrentsSearch(input).myFormatInputAsText(),
        input.criteriaTitle.toLowerCase(),
      );
      expect(
        QueryGloTorrentsSearch(input).myFormatInputAsText(),
        input.criteriaTitle.toLowerCase(),
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult =
          'https://www.gtdb.to/search_results.php?search=new%20query&sort=seeders&order=desc&page=0';

      // Invoke the functionality.
      final actualResult = QueryGloTorrentsSearch(criteria)
          .myConstructURI('new query')
          .toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.gloTorrents',
        'title': '[QueryGloTorrentsSearch] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult =
          QueryGloTorrentsSearch(criteria).myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });

    test('Run myConvertWebTextToTraversableTree()', () {
      const expectedOutput = intermediateMapList;
      final testClass = QueryGloTorrentsSearch(criteria);
      testClass.criteria = criteria;
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        gtSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
  });
  group('GloTorrentsSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          GloTorrentsSearchConverter.dtoFromCompleteJsonMap(map),
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
  /// Integration tests using GloTorrentsSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('GloTorrentsSearchConverter integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final gloTorrentsSearch = QueryGloTorrentsSearch(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          await gloTorrentsSearch.myConvertTreeToOutputType(map),
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
      final gloTorrentsSearch = QueryGloTorrentsSearch(criteria);

      // Invoke the functionality and collect results.
      final actualResult = gloTorrentsSearch.myConvertTreeToOutputType('map');

      // Check the results.
      //NOTE: Using expect on an async result only works as the last line of the test!
      expect(
        actualResult,
        throwsA('expected map got String unable to interpret data map'),
      );
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and ScrapeGloTorrentsSearchDetails and GloTorrentsSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('gloTorrents search query', () {
    // Read search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final gloTorrentsSearch = QueryGloTorrentsSearch(criteria);

      // Invoke the functionality.
      await gloTorrentsSearch
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
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });

    // Read search results from a simulated byte stream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final gloTorrentsSearch = QueryGloTorrentsSearch(criteria);
      const expectedException = '[QueryGloTorrentsSearch] Error in gloTorrents '
          'with criteria dream convert error interpreting web text as a map '
          ':gloTorrents results data not detected for criteria dream in html:not valid html';

      // Invoke the functionality.
      await gloTorrentsSearch
          .readList(
            source: _emitInvalidHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException = '[QueryGloTorrentsSearch] Error in gloTorrents '
          'with criteria dream convert error interpreting web text as a map '
          ':gloTorrents results data not detected for criteria dream in html:<html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final gloTorrentsSearch = QueryGloTorrentsSearch(criteria);

      // Invoke the functionality.
      await gloTorrentsSearch
          .readList(
            source: _emitUnexpectedHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
