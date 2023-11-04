import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrent_download_search.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real MagnetDb endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://www.torrentdownload.info/3DB77B616E35ED9D9D077F5782F794BA6E252529/Rize-+2005+-+720p+-+WEBRip+-+YTS-MX+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Rize (2005) [720p] [WEBRip] [YTS MX] » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/3DB77B616E35ED9D9D077F5782F794BA6E252529/Rize-+2005+-+720p+-+WEBRip+-+YTS-MX+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/42A9D16CB93A67611B18068B8CF8DA19315A83EB/Tenacious-D-Rize-of-the-Fenix-+2012+-Explicit-+MP3-320+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize of the Fenix (2012) Explicit [MP3 320] » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/42A9D16CB93A67611B18068B8CF8DA19315A83EB/Tenacious-D-Rize-of-the-Fenix-+2012+-Explicit-+MP3-320+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/4F908658A4E0937BD85470E1131C222FE240CE6C/TDE--All-Rize-To-Tha-Top-+Mixed-By-September-7th+-2009-MIXFIEND","bestSource":"DataSourceType.torrentDownloadSearch","title":"TDE All Rize To Tha Top (Mixed By September 7th) 2009 MIXFIEND » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/4F908658A4E0937BD85470E1131C222FE240CE6C/TDE--All-Rize-To-Tha-Top-+Mixed-By-September-7th+-2009-MIXFIEND"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/5CDED09410188B65918A48E4B4E5B5A082A01585/RJ256426-Rize-and-the-Magic-Cream-Pie","bestSource":"DataSourceType.torrentDownloadSearch","title":"RJ256426 Rize and the Magic Cream Pie » Other","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/5CDED09410188B65918A48E4B4E5B5A082A01585/RJ256426-Rize-and-the-Magic-Cream-Pie"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/5D74170ECD9829AF0A36E9A19A828053AB8EC5DB/Rize-+2005+-+1080p+-+WEBRip+-+5-1+-+YTS-MX+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Rize (2005) (1080p) [WEBRip] [5 1] [YTS MX] » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/5D74170ECD9829AF0A36E9A19A828053AB8EC5DB/Rize-+2005+-+1080p+-+WEBRip+-+5-1+-+YTS-MX+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/6656DC5C6F329993D85231A331EDB7CDDE778E39/Tenacious-D-Rize-of-the-Fenix-+2012+-NewMp3Club","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize of the Fenix [2012] NewMp3Club » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/6656DC5C6F329993D85231A331EDB7CDDE778E39/Tenacious-D-Rize-of-the-Fenix-+2012+-NewMp3Club"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/66c0d4bdef47fa47de867c80c893d9b3d7c8bc67/Tenacious-D-Rize-Of-The-Fenix-+2012+-320Kbit+mp3+-DMT","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix (2012) 320Kbit(mp3) DMT » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/66c0d4bdef47fa47de867c80c893d9b3d7c8bc67/Tenacious-D-Rize-Of-The-Fenix-+2012+-320Kbit+mp3+-DMT"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/6b6b883d4b6e61e4ab69a37b850fededd5b90dda/Tenacious-D--2012--Rize-of-The-Fenix","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D 2012 Rize of The Fenix » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/6b6b883d4b6e61e4ab69a37b850fededd5b90dda/Tenacious-D--2012--Rize-of-The-Fenix"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/811acea7732e7502456b143d8483ff74afd4f121/Hot-Rize--When-I++039+m-Free-+2014+-+FLAC+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Hot Rize When I'm Free [2014] [FLAC] » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/811acea7732e7502456b143d8483ff74afd4f121/Hot-Rize--When-I++039+m-Free-+2014+-+FLAC+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/F426908AD80498DC2C499489747FEAC8186BF3D0/9th-Prince-ft-RZA--Im-on-The-Rize-+HOT+-+-Underground-Hip-Hop-Extras","bestSource":"DataSourceType.torrentDownloadSearch","title":"9th Prince ft RZA Im on The Rize (HOT) + Underground Hip Hop Extras » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/F426908AD80498DC2C499489747FEAC8186BF3D0/9th-Prince-ft-RZA--Im-on-The-Rize-+HOT+-+-Underground-Hip-Hop-Extras"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryTorrentDownloadSearch test', () {
    // Search for a rare movie.
    test('Run a search on Tpb that is likely to have static results', () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QueryTorrentDownloadSearch(criteria).readList(limit: 10);
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
          await QueryTorrentDownloadSearch(criteria).readList(limit: 10);
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
