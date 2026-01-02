import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_torrent_download_detail.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real TorrentDownload endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryTorrentDownloadDetail test', () {
    // Search for a rare movie.
    test(
      'Run a search on TorrentDownload that is likely to have static results',
      () async {
        final criteria = SearchCriteriaDTO().fromString(
          'https://www.torrentdownload.info/B9F89CFDF8E74E9ACE0E58528932FCC437AD0D0E/Space-Jam-A-New-Legacy-+2021+-+1080p+-+WEBRip+-+5-1+-+YTS-MX+',
        );
        final actualOutput = await QueryTorrentDownloadDetail(
          criteria,
        ).readList(limit: 10);
        actualOutput.clearCopyrightedData();

        // Uncomment this line to update expectedOutput if sample data changes
        //writeTestData(actualOutput);

        // Check the results.
        final expectedOutput = readTestData();
        expect(
          actualOutput,
          MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 60),
          reason:
              'Emitted DTO list ${actualOutput.toPrintableString()} '
              'needs to match expected DTO list '
              '${expectedOutput.toPrintableString()}',
        );
      },
    );
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryTorrentDownloadDetail(
        criteria,
      ).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(expectedOutput),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
  });
}
