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
{"uniqueId":"https://www.torrentdownload.info/06BF2D5444B30B7F425BF8C25C129F0EEA568A7C/Rize--KO-rar","bestSource":"DataSourceType.torrentDownloadSearch","title":"Rize KO rar » Anime","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/06BF2D5444B30B7F425BF8C25C129F0EEA568A7C/Rize--KO-rar"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/09DDD0777BFCC2826174E7BF1B1D57BE63B1F47D/Cat-Bell-Rize-Up-2019","bestSource":"DataSourceType.torrentDownloadSearch","title":"Cat Bell Rize Up 2019 » Other","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/09DDD0777BFCC2826174E7BF1B1D57BE63B1F47D/Cat-Bell-Rize-Up-2019"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/1ACDD7068D21E5685BEAB599E06309ABB8E45A0C/Outlaw+-South-is-on-the-Rize","bestSource":"DataSourceType.torrentDownloadSearch","title":"Outlaw/ South is on the Rize » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/1ACDD7068D21E5685BEAB599E06309ABB8E45A0C/Outlaw+-South-is-on-the-Rize"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/2037FE480FA4162831DC300F6D431E0FCDAC7519/Tenacious-D-Rize-of-the-Fenix-+2012+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize of the Fenix (2012) » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/2037FE480FA4162831DC300F6D431E0FCDAC7519/Tenacious-D-Rize-of-the-Fenix-+2012+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/3D246CDC3E014C207E5D710707FEB417D7ED6583/The-Hobbit+-An-Unexpected-Journey-+2012+-DVDRip-XviD-RIZE","bestSource":"DataSourceType.torrentDownloadSearch","title":"The Hobbit: An Unexpected Journey (2012) DVDRip XviD RIZE » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/3D246CDC3E014C207E5D710707FEB417D7ED6583/The-Hobbit+-An-Unexpected-Journey-+2012+-DVDRip-XviD-RIZE"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/3D7EA094E485BDD92AF9487C50C68D749074EA18/Tenacious-D--Rize-Of-The-Fenix-+Deluxe-Edition+-320Kb+s-CBR--2012","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix [Deluxe Edition] 320Kb/s CBR 2012 » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/3D7EA094E485BDD92AF9487C50C68D749074EA18/Tenacious-D--Rize-Of-The-Fenix-+Deluxe-Edition+-320Kb+s-CBR--2012"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/3DB77B616E35ED9D9D077F5782F794BA6E252529/Rize-+2005+-+720p+-+WEBRip+-+YTS-MX+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Rize (2005) [720p] [WEBRip] [YTS MX] » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/3DB77B616E35ED9D9D077F5782F794BA6E252529/Rize-+2005+-+720p+-+WEBRip+-+YTS-MX+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/3E0CCD3841A5D4AB453436699D81278F3AA5F041/Rize-2005-1080p-WEBRip-x264-RARBG","bestSource":"DataSourceType.torrentDownloadSearch","title":"Rize 2005 1080p WEBRip x264 RARBG » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/3E0CCD3841A5D4AB453436699D81278F3AA5F041/Rize-2005-1080p-WEBRip-x264-RARBG"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/42A9D16CB93A67611B18068B8CF8DA19315A83EB/Tenacious-D-Rize-of-the-Fenix-+2012+-Explicit-+MP3-320+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize of the Fenix (2012) Explicit [MP3 320] » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/42A9D16CB93A67611B18068B8CF8DA19315A83EB/Tenacious-D-Rize-of-the-Fenix-+2012+-Explicit-+MP3-320+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/4F34BABF85763C48C9B722580B26035275BC8B82/Tenacious-D-Rize-of-the-Fenix-480p-WEB-DL-AAC2+0-H-264","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize of the Fenix 480p WEB DL AAC2.0 H 264 » Video","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/4F34BABF85763C48C9B722580B26035275BC8B82/Tenacious-D-Rize-of-the-Fenix-480p-WEB-DL-AAC2+0-H-264"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/4F908658A4E0937BD85470E1131C222FE240CE6C/TDE--All-Rize-To-Tha-Top-+Mixed-By-September-7th+-2009-MIXFIEND","bestSource":"DataSourceType.torrentDownloadSearch","title":"TDE All Rize To Tha Top (Mixed By September 7th) 2009 MIXFIEND » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/4F908658A4E0937BD85470E1131C222FE240CE6C/TDE--All-Rize-To-Tha-Top-+Mixed-By-September-7th+-2009-MIXFIEND"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/4ccc232982e9941c4439e38504cd0a309a1332a7/Tenacious-D-Rize-of-the-Fenix-2012-Album-SW+torrent","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize of the Fenix 2012 Album SW.torrent » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/4ccc232982e9941c4439e38504cd0a309a1332a7/Tenacious-D-Rize-of-the-Fenix-2012-Album-SW+torrent"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/4cf696b8ceb06c98808232c8cb17c0158f567921/Tenacious-D--Rize-Of-The-Fenix+torrent","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix.torrent » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/4cf696b8ceb06c98808232c8cb17c0158f567921/Tenacious-D--Rize-Of-The-Fenix+torrent"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/4f214538273f97a9aa33182ae0e9a96337c09640/Tenacious-D-Rize-of-the-Fenix-NEW-ALBUM-2012+torrent","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize of the Fenix NEW ALBUM 2012.torrent » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/4f214538273f97a9aa33182ae0e9a96337c09640/Tenacious-D-Rize-of-the-Fenix-NEW-ALBUM-2012+torrent"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/4f817578ad056c13fb297ac517163017a2299b5e/Tenacious-D-Rize-Of-The-Fenix-2012+torrent","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix 2012.torrent » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/4f817578ad056c13fb297ac517163017a2299b5e/Tenacious-D-Rize-Of-The-Fenix-2012+torrent"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/52EAF8BA8E44837A01E9525BFBF5B7E668F097CA/RIZE-avi","bestSource":"DataSourceType.torrentDownloadSearch","title":"RIZE avi » Other","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/52EAF8BA8E44837A01E9525BFBF5B7E668F097CA/RIZE-avi"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/587D23D91E5EFE9C8FB52418A5EEB2150D016AD4/Tenacious-D--Rize-Of-The-Fenix-+2012+-MP3-V0","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix (2012) MP3 V0 » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/587D23D91E5EFE9C8FB52418A5EEB2150D016AD4/Tenacious-D--Rize-Of-The-Fenix-+2012+-MP3-V0"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/5CDED09410188B65918A48E4B4E5B5A082A01585/RJ256426-Rize-and-the-Magic-Cream-Pie","bestSource":"DataSourceType.torrentDownloadSearch","title":"RJ256426 Rize and the Magic Cream Pie » Other","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/5CDED09410188B65918A48E4B4E5B5A082A01585/RJ256426-Rize-and-the-Magic-Cream-Pie"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/5D74170ECD9829AF0A36E9A19A828053AB8EC5DB/Rize-+2005+-+1080p+-+WEBRip+-+5-1+-+YTS-MX+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Rize (2005) (1080p) [WEBRip] [5 1] [YTS MX] » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/5D74170ECD9829AF0A36E9A19A828053AB8EC5DB/Rize-+2005+-+1080p+-+WEBRip+-+5-1+-+YTS-MX+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/5D914C24D2297229B75B0B6811CCBE83EBE520E4/Seventh-Rize--Full-Moon-+2009+-+mp3+320+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Seventh Rize Full Moon (2009) [[email protected]] » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/5D914C24D2297229B75B0B6811CCBE83EBE520E4/Seventh-Rize--Full-Moon-+2009+-+mp3+320+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/63b75e0c0c9f568784e00c36bf2d5afbfcc925eb/Tenacious-D-Rize-Of-The-Fenix-2012-320Kbit-mp3-DMT+torrent","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix 2012 320Kbit mp3 DMT.torrent » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/63b75e0c0c9f568784e00c36bf2d5afbfcc925eb/Tenacious-D-Rize-Of-The-Fenix-2012-320Kbit-mp3-DMT+torrent"}}
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
{"uniqueId":"https://www.torrentdownload.info/787AF9D0E797EB191A55F459339086B4968AA49A/Hip-Hop-Rap-2003-Rize-Strategie-da-Palcoscenico","bestSource":"DataSourceType.torrentDownloadSearch","title":"Hip Hop Rap 2003 Rize Strategie da Palcoscenico » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/787AF9D0E797EB191A55F459339086B4968AA49A/Hip-Hop-Rap-2003-Rize-Strategie-da-Palcoscenico"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/811acea7732e7502456b143d8483ff74afd4f121/Hot-Rize--When-I++039+m-Free-+2014+-+FLAC+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Hot Rize When I'm Free [2014] [FLAC] » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/811acea7732e7502456b143d8483ff74afd4f121/Hot-Rize--When-I++039+m-Free-+2014+-+FLAC+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/952960168b886f354942d649ba3d1ef18e07f5d1/Tenacious-D-Rize-Of-The-Fenix-2012-Rock-mp3+torrent","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix 2012 Rock mp3.torrent » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/952960168b886f354942d649ba3d1ef18e07f5d1/Tenacious-D-Rize-Of-The-Fenix-2012-Rock-mp3+torrent"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/9c7b296d0a073a68421295fd2fe5f3be4cd72449/CJ-Arthur-vs-Den-Rize-Helen-ARC011-WEB-2013-TBM","bestSource":"DataSourceType.torrentDownloadSearch","title":"CJ Arthur vs Den Rize Helen ARC011 WEB 2013 TBM » Other","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/9c7b296d0a073a68421295fd2fe5f3be4cd72449/CJ-Arthur-vs-Den-Rize-Helen-ARC011-WEB-2013-TBM"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/9cc38109dd93712baab8902f268d091ced9ed84e/Tenacious-D--Rize-Of-The-Fenix-+2012+-Disnoxxio+torrent","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix (2012) Disnoxxio.torrent » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/9cc38109dd93712baab8902f268d091ced9ed84e/Tenacious-D--Rize-Of-The-Fenix-+2012+-Disnoxxio+torrent"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/AAEBF3E1B64179EEE532F3EC47B5410BD36D5181/Tenacious-D-Rize-of-the-Fenix-2012-320kbps-Mp3","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize of the Fenix 2012 320kbps Mp3 » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/AAEBF3E1B64179EEE532F3EC47B5410BD36D5181/Tenacious-D-Rize-of-the-Fenix-2012-320kbps-Mp3"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/B69DF083B6334043559FD7E1CB0F640725B94871/Hip-Hop+Rap-Ita+Rize+Giusto-Spessore","bestSource":"DataSourceType.torrentDownloadSearch","title":"Hip Hop_Rap Ita_Rize_Giusto Spessore » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/B69DF083B6334043559FD7E1CB0F640725B94871/Hip-Hop+Rap-Ita+Rize+Giusto-Spessore"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/BD0F254C42A94D2FF30A97107B8F341CD0A21D38/Rize-2005-1080p-AMZN-WEBRip-DDP5-1-x264-SKiZOiD","bestSource":"DataSourceType.torrentDownloadSearch","title":"Rize 2005 1080p AMZN WEBRip DDP5 1 x264 SKiZOiD » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/BD0F254C42A94D2FF30A97107B8F341CD0A21D38/Rize-2005-1080p-AMZN-WEBRip-DDP5-1-x264-SKiZOiD"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/BD454E420C1C401699CC012F457348A52EB7F8C4/Dwele--Rize-+Reissue+-2004-rare","bestSource":"DataSourceType.torrentDownloadSearch","title":"Dwele Rize (Reissue) 2004 rare » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/BD454E420C1C401699CC012F457348A52EB7F8C4/Dwele--Rize-+Reissue+-2004-rare"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/D524AB75593B57EF044ED5C0D511D176D401CDBA/Tenacious-D--Rize-Of-The-Fenix-+Deluxe-Edition+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix (Deluxe Edition) » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/D524AB75593B57EF044ED5C0D511D176D401CDBA/Tenacious-D--Rize-Of-The-Fenix-+Deluxe-Edition+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/D72E395CAB59E42D1327999C476AE4BDB4F24405/Tenacious-D-Rize-of-the-Fenix-+2012-Album++SW+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize of the Fenix [2012 Album][SW] » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/D72E395CAB59E42D1327999C476AE4BDB4F24405/Tenacious-D-Rize-of-the-Fenix-+2012-Album++SW+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/E6F6DD31E5D03A186030B0748598837FA09A8F2B/+Shin-S+-Gochuumon-wa-Usagi-Desu-ka-Special-CD-Vol-3--Rize-+Taneda-Risa+-zip","bestSource":"DataSourceType.torrentDownloadSearch","title":"[Shin S] Gochuumon wa Usagi Desu ka Special CD Vol 3 Rize [Taneda Risa] zip » Other","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/E6F6DD31E5D03A186030B0748598837FA09A8F2B/+Shin-S+-Gochuumon-wa-Usagi-Desu-ka-Special-CD-Vol-3--Rize-+Taneda-Risa+-zip"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/F426908AD80498DC2C499489747FEAC8186BF3D0/9th-Prince-ft-RZA--Im-on-The-Rize-+HOT+-+-Underground-Hip-Hop-Extras","bestSource":"DataSourceType.torrentDownloadSearch","title":"9th Prince ft RZA Im on The Rize (HOT) + Underground Hip Hop Extras » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/F426908AD80498DC2C499489747FEAC8186BF3D0/9th-Prince-ft-RZA--Im-on-The-Rize-+HOT+-+-Underground-Hip-Hop-Extras"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/a6052cd7634ef7acc8a2a7a85f26b1ec7effbfa6/Tenacious-D--Rize-Of-The-Fenix-+Clean-Version+","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious D Rize Of The Fenix [Clean Version] » Music","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/a6052cd7634ef7acc8a2a7a85f26b1ec7effbfa6/Tenacious-D--Rize-Of-The-Fenix-+Clean-Version+"}}
''',
  r'''
{"uniqueId":"https://www.torrentdownload.info/c2ebd41e20a9c306ae79f5ce1e854bc17cd3d747/Tenacious+d+rize+of+the+fenix-2012-+sd++torrent","bestSource":"DataSourceType.torrentDownloadSearch","title":"Tenacious.d.rize.of.the.fenix 2012 [sd).torrent » Movies","type":"MovieContentType.download","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/c2ebd41e20a9c306ae79f5ce1e854bc17cd3d747/Tenacious+d+rize+of+the+fenix-2012-+sd++torrent"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryTpbSearch test', () {
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
  });
}
