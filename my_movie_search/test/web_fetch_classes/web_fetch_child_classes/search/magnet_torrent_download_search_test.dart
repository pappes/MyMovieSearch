import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/magnet_torrent_download_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrent_download_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/magnet_torrent_download_search.dart';

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

  group('TorrentDownload search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryTorrentDownloadSearch(criteria).myDataSourceName(),
        'torrentDownloadSearch',
      );
    });

    // Confirm simple criteria is displayed as expected.
    test('Run myFormatInputAsText() for simple keyword', () {
      expect(
        QueryTorrentDownloadSearch(criteria).myFormatInputAsText(),
        '${criteria.criteriaType}:${criteria.criteriaTitle}'.toLowerCase(),
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'List of errors';
      input.criteriaList = [
        MovieResultDTO().init(uniqueId: 'test1'),
        MovieResultDTO().init(uniqueId: 'test2'),
      ];
      expect(
        QueryTorrentDownloadSearch(input).myFormatInputAsText(),
        'test1,test2',
      );
      expect(
        QueryTorrentDownloadSearch(input).myFormatInputAsText(),
        'test1,test2',
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult =
          'https://www.torrentdownload.info/search?q=new%20query&p=1';

      // Invoke the functionality.
      final actualResult = QueryTorrentDownloadSearch(criteria)
          .myConstructURI('new query')
          .toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.torrentDownloadSearch',
        'title': '[QueryTorrentDownloadSearch] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryTorrentDownloadSearch(criteria)
          .myYieldError('new query')
          .toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });

    test('Run myConvertWebTextToTraversableTree()', () {
      const expectedOutput = intermediateMapList;
      final testClass = QueryTorrentDownloadSearch(criteria);
      testClass.criteria = criteria;
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        htmlSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () {
      final expectedOutput = <void>[];
      final actualOutput = QueryTorrentDownloadSearch(criteria)
          .myConvertWebTextToTraversableTree(
        htmlSampleEmpty,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results', () {
      final expectedOutput = throwsA(
        startsWith(
          'TorrentDownload results data not detected for criteria '
          '${criteria.toSearchId().toLowerCase()} in html:',
        ),
      );
      final actualOutput = QueryTorrentDownloadSearch(criteria)
          .myConvertWebTextToTraversableTree(
        htmlSampleError,
      );
      //NOTE: Using expect on an async result only works as the last line of the test!
      expect(actualOutput, expectedOutput);
    });
  });
  group('TorrentDownloadSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          TorrentDownloadSearchConverter.dtoFromCompleteJsonMap(map),
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
  /// Integration tests using TorrentDownloadSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('TorrentDownloadSearchConverter integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final torrentDownloadSearch = QueryTorrentDownloadSearch(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          await torrentDownloadSearch.myConvertTreeToOutputType(map),
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
      final torrentDownloadSearch = QueryTorrentDownloadSearch(criteria);

      // Invoke the functionality and collect results.
      final actualResult =
          torrentDownloadSearch.myConvertTreeToOutputType('map');

      // Check the results.
      //NOTE: Using expect on an async result only works as the last line of the test!
      expect(
        actualResult,
        throwsA('expected map got String unable to interpret data map'),
      );
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and ScrapeTorrentDownloadSearchDetails and TorrentDownloadSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('TorrentDownload search query', () {
    // Read search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final torrentDownloadSearch = QueryTorrentDownloadSearch(criteria);

      // Invoke the functionality.
      await torrentDownloadSearch
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

    // Read search results from a simulated byte stream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final torrentDownloadSearch = QueryTorrentDownloadSearch(criteria);
      final expectedException =
          '[QueryTorrentDownloadSearch] Error in torrentDownloadSearch '
          'with criteria ${criteria.toSearchId().toLowerCase()} convert error '
          'interpreting web text as a map :TorrentDownload results data not '
          'detected for criteria ${criteria.toSearchId().toLowerCase()} in '
          'html:not valid html';

      // Invoke the functionality.
      await torrentDownloadSearch
          .readList(
            source: _emitInvalidHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      final expectedException =
          '[QueryTorrentDownloadSearch] Error in torrentDownloadSearch '
          'with criteria ${criteria.toSearchId().toLowerCase()} convert error '
          'interpreting web text as a map :TorrentDownload results data not '
          'detected for criteria ${criteria.toSearchId().toLowerCase()} in '
          'html:<html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final torrentDownloadSearch = QueryTorrentDownloadSearch(criteria);

      // Invoke the functionality.
      await torrentDownloadSearch
          .readList(
            source: _emitUnexpectedHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
