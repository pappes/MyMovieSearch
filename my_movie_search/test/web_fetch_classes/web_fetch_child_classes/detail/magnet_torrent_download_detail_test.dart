import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/magnet_torrent_download_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_torrent_download_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/magnet_torrent_download_detail.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedHtmlSample(_) =>
    Future.value(Stream.value('<html><body>stuff</body></html>'));

Future<Stream<String>> _emitInvalidHtmlSample(_) =>
    Future.value(Stream.value('not valid html'));

final criteria = SearchCriteriaDTO().fromString('https://address');

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('TorrentDownload search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryTorrentDownloadDetail(criteria).myDataSourceName(),
        'torrentDownloadDetail',
      );
    });

    // Confirm simple criteria is displayed as expected.
    test('Run myFormatInputAsText() for simple keyword', () {
      expect(
        QueryTorrentDownloadDetail(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO().init(SearchCriteriaType.movieDTOList)
        ..criteriaTitle = 'List of errors'
        ..criteriaList = [
          MovieResultDTO().init(uniqueId: 'test1'),
          MovieResultDTO().init(uniqueId: 'test2'),
        ];
      expect(
        QueryTorrentDownloadDetail(input).myFormatInputAsText(),
        'test1,test2',
      );
      expect(
        QueryTorrentDownloadDetail(input).myFormatInputAsText(),
        'test1,test2',
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult = 'https://www.torrentdownload.info/new%20query';

      // Invoke the functionality.
      final actualResult = QueryTorrentDownloadDetail(criteria)
          .myConstructURI('new query')
          .toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.torrentDownloadDetail',
        'title': '[QueryTorrentDownloadDetail] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryTorrentDownloadDetail(criteria)
          .myYieldError('new query')
          .toMap()
        ..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });

    test('Run myConvertWebTextToTraversableTree()', () {
      const expectedOutput = intermediateMapList;
      final testClass = QueryTorrentDownloadDetail(criteria)
        ..criteria = criteria;
      final actualOutput =
          testClass.myConvertWebTextToTraversableTree(htmlSampleFull);
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () {
      final expectedOutput = <void>[];
      final actualOutput = QueryTorrentDownloadDetail(criteria)
          .myConvertWebTextToTraversableTree(htmlSampleEmpty);
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results', () {
      final expectedOutput = throwsA(isA<WebConvertException>().having(
        (e) => e.cause,
        'cause',
        startsWith('TorrentDownload results data not detected for criteria'),
      ));
      final actualOutput = QueryTorrentDownloadDetail(criteria)
          .myConvertWebTextToTraversableTree(htmlSampleError);
      expect(actualOutput, expectedOutput);
    });
  });
  group('TorrentDownloadDetailConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          TorrentDownloadDetailConverter.dtoFromCompleteJsonMap(map, criteria),
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
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryTorrentDownloadDetail integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expected =
          'https://www.torrentdownload.info/B9F89CFDF8E74E9ACE0E58528932FCC437AD0D0E/Space-Jam-A-New-Legacy-+2021+-+1080p+-+WEBRip+-+5-1+-+YTS-MX+';
      final criteria = SearchCriteriaDTO();

      // Invoke the functionality.
      final actualResult = QueryTorrentDownloadDetail(criteria)
          .myConstructURI(
            'https://www.torrentdownload.info/B9F89CFDF8E74E9ACE0E58528932FCC437AD0D0E/Space-Jam-A-New-Legacy-+2021+-+1080p+-+WEBRip+-+5-1+-+YTS-MX+',
          )
          .toString();

      // Check the results.
      expect(actualResult, expected);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using TorrentDownloadDetailConverter
////////////////////////////////////////////////////////////////////////////////

  group('TorrentDownloadDetailConverter integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final torrentDownloadDetail = QueryTorrentDownloadDetail(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          await torrentDownloadDetail.myConvertTreeToOutputType(map),
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
      final torrentDownloadDetail = QueryTorrentDownloadDetail(criteria);

      // Invoke the functionality and collect results.
      final actualResult =
          torrentDownloadDetail.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase
  ///  and ScrapeTorrentDownloadDetailDetails
  ///  and TorrentDownloadDetailConverter
////////////////////////////////////////////////////////////////////////////////

  group('TorrentDownload search query', () {
    // Read search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final torrentDownloadDetail = QueryTorrentDownloadDetail(criteria);

      // Invoke the functionality.
      await torrentDownloadDetail
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
      final queryResult = <MovieResultDTO>[];
      final torrentDownloadDetail = QueryTorrentDownloadDetail(criteria);
      final expectedException = '[QueryTorrentDownloadDetail] '
          'Error in torrentDownloadDetail with criteria '
          '${criteria.toPrintableIdOrText().toLowerCase()} convert error '
          'interpreting web text as a map :TorrentDownload results data not '
          'detected for criteria '
          '${criteria.toPrintableIdOrText().toLowerCase()} in '
          'html:not valid html';

      // Invoke the functionality.
      await torrentDownloadDetail
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
      final expectedException = '[QueryTorrentDownloadDetail] '
          'Error in torrentDownloadDetail with criteria '
          '${criteria.toPrintableIdOrText().toLowerCase()} convert error '
          'interpreting web text as a map :TorrentDownload results data not '
          'detected for criteria '
          '${criteria.toPrintableIdOrText().toLowerCase()} in '
          'html:<html><body>stuff</body></html>';
      final queryResult = <MovieResultDTO>[];
      final torrentDownloadDetail = QueryTorrentDownloadDetail(criteria);

      // Invoke the functionality.
      await torrentDownloadDetail
          .readList(
            source: _emitUnexpectedHtmlSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
