import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_torrent_download_detail.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real MagnetDb endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://www.torrentdownload.info/B9F89CFDF8E74E9ACE0E58528932FCC437AD0D0E/Space-Jam-A-New-Legacy-+2021+-+1080p+-+WEBRip+-+5-1+-+YTS-MX+","bestSource":"DataSourceType.torrentDownloadDetail","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadDetail":"https://www.torrentdownload.info/B9F89CFDF8E74E9ACE0E58528932FCC437AD0D0E/Space-Jam-A-New-Legacy-+2021+-+1080p+-+WEBRip+-+5-1+-+YTS-MX+"}}
''',
];

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
      final actualOutput =
          await QueryTorrentDownloadDetail(criteria).readList(limit: 10);
      final expectedOutput = expectedDTOList;
      expectedDTOList.clearCopyrightedData();
      actualOutput.clearCopyrightedData();

      // Uncomment this line to update expectedOutput if sample data changes
      // printTestData(actualOutput);

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          percentMatch: 60,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
