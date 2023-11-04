import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_magnet_dl.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real MagnetDb endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"magnet:?xt=urn:btih:01c07d77c19df09d178a3ba4a0d71c4d197d8c2d&dn=Tenacious+D+Pick+Of+Destiny+Movie+And+Soundtrack+++The+Rize+Of+T&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","bestSource":"DataSourceType.magnetDl","title":"Tenacious D Pick Of Destiny Movie And Soundtrack + The Rize Of T","type":"MovieContentType.download","sources":{"DataSourceType.magnetDl":"magnet:?xt=urn:btih:01c07d77c19df09d178a3ba4a0d71c4d197d8c2d&dn=Tenacious+D+Pick+Of+Destiny+Movie+And+Soundtrack+++The+Rize+Of+T&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:09ddd0777bfcc2826174e7bf1b1d57be63b1f47d&dn=Cat+Bell:+Rize+Up+2019&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","bestSource":"DataSourceType.magnetDl","title":"Cat Bell: Rize Up 2019","type":"MovieContentType.download","sources":{"DataSourceType.magnetDl":"magnet:?xt=urn:btih:09ddd0777bfcc2826174e7bf1b1d57be63b1f47d&dn=Cat+Bell:+Rize+Up+2019&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:3c80476bbeaf054d4d66f4d60ad6cf31cc686a3b&dn=085+Alex+M.O.R.P.H.+Universal+Nation+(Den+Rize)+(ita+Trance+State&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","bestSource":"DataSourceType.magnetDl","title":"085 Alex M.O.R.P.H. Universal Nation (Den Rize) (ita Trance Stat..","type":"MovieContentType.download","sources":{"DataSourceType.magnetDl":"magnet:?xt=urn:btih:3c80476bbeaf054d4d66f4d60ad6cf31cc686a3b&dn=085+Alex+M.O.R.P.H.+Universal+Nation+(Den+Rize)+(ita+Trance+State&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:3e0ccd3841a5d4ab453436699d81278f3aa5f041&dn=Rize.2005.1080p.WEBRip.x264-RARBG&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","bestSource":"DataSourceType.magnetDl","title":"Rize.2005.1080p.WEBRip.x264-RARBG","charactorName":"Movie","type":"MovieContentType.download","sources":{"DataSourceType.magnetDl":"magnet:?xt=urn:btih:3e0ccd3841a5d4ab453436699d81278f3aa5f041&dn=Rize.2005.1080p.WEBRip.x264-RARBG&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:7621a998ef436b9ea631456554a9c05015f4ee14&dn=Tenacious+D:+Rize+Of+The+Fen+Feria+Tantoco+Robeniol+Law+Offices&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","bestSource":"DataSourceType.magnetDl","title":"Tenacious D: Rize Of The Fen Feria Tantoco Robeniol Law Offices","type":"MovieContentType.download","sources":{"DataSourceType.magnetDl":"magnet:?xt=urn:btih:7621a998ef436b9ea631456554a9c05015f4ee14&dn=Tenacious+D:+Rize+Of+The+Fen+Feria+Tantoco+Robeniol+Law+Offices&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:7a8bb540f8dffaca1df8e07272288d5defa3d33f&dn=Rize+Of+The+Zombie+(2013):+DVDRip:+1CD:+ESubs:+5.1:+Hindi+M&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","bestSource":"DataSourceType.magnetDl","title":"Rize Of The Zombie (2013): DVDRip: 1CD: ESubs: 5.1: Hindi M","charactorName":"Movie","type":"MovieContentType.download","sources":{"DataSourceType.magnetDl":"magnet:?xt=urn:btih:7a8bb540f8dffaca1df8e07272288d5defa3d33f&dn=Rize+Of+The+Zombie+(2013):+DVDRip:+1CD:+ESubs:+5.1:+Hindi+M&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:811acea7732e7502456b143d8483ff74afd4f121&dn=Hot+Rize:+When+Im+Free+%5B2014%5D+%5BFLAC%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","bestSource":"DataSourceType.magnetDl","title":"Hot Rize: When Im Free [2014] [FLAC]","type":"MovieContentType.download","sources":{"DataSourceType.magnetDl":"magnet:?xt=urn:btih:811acea7732e7502456b143d8483ff74afd4f121&dn=Hot+Rize:+When+Im+Free+%5B2014%5D+%5BFLAC%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:9c7b296d0a073a68421295fd2fe5f3be4cd72449&dn=CJ.Arthur.vs.Den.Rize-Helen-ARC011-WEB-2013-TBM&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","bestSource":"DataSourceType.magnetDl","title":"CJ.Arthur.vs.Den.Rize-Helen-ARC011-WEB-2013-TBM","type":"MovieContentType.download","sources":{"DataSourceType.magnetDl":"magnet:?xt=urn:btih:9c7b296d0a073a68421295fd2fe5f3be4cd72449&dn=CJ.Arthur.vs.Den.Rize-Helen-ARC011-WEB-2013-TBM&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryMagnetDlSearch test', () {
    // Search for a rare movie.
    test('Run a search on Tpb that is likely to have static results', () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QueryMagnetDlSearch(criteria).readList(limit: 10);
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
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryMagnetDlSearch(criteria).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(
          expectedOutput,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
