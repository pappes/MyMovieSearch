import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tpb_search.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real Tpb endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma Discography (1990-2010)","charactorName":"Audio(Music)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma - The Platinum Collection (2CD)(2009)[FLAC]","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma Love Sensuality Devotion Greatest Hits and Remixes 2CD","charactorName":"Audio(Music)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"The Enigma of Kaspar Hauser, Werner Herzog, 1974","charactorName":"Video(Movies)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Harry Potter e o Enigma Do Principe (2009) 1080p Dublado","charactorName":"Video(HD - Movies)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma - The Fall Of A Rebel Angel ( Limited D.S.E.) [2016]","charactorName":"Audio(Music)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"BBC Secrets of World War II Set 1 07of14 The Enigma Secret x264","charactorName":"Video(TV shows)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Stratovarius - Enigma Intermission 2[WEB][FLAC]eNJoY-iT","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma - Fall of a Rebel Angel [Japan SHM-CD] (2016) FLAC","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Alan Turing_ The Enigma by Andrew Hodges EPUB","charactorName":"Other(E-books)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"The.Enigma.of.Kaspar.Hauser.1974.1080p.Bluray.DTS.x264-GCJM","charactorName":"Video(HD - Movies)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Alan Turing : The Enigma - Andew Hodges (mobi)","charactorName":"Other(E-books)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Epica - The Quantum Enigma (2014) Flac","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma - The Fall Of A Rebel Angel [LP] (2016) WavPack","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma Discography","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma Discography","charactorName":"Audio(Music)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma - Platinum Collection [2009] [EAC - FLAC](oan)","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"BBC.Heroes.and.Weapons.of.WWII.04of20.The.Men.Who.Cracked.Enigma","charactorName":"Video(TV shows)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma - Le Roi Est Mort, Vive Le Roi! (1996) (FLAC-EAC)","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma - A Posteriori (2006) [24-88.2]-was95","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma - Best Hits Of The Enigma (2019) SHINNOBU (256k) [DJ] h","charactorName":"Audio(Music)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"The Enigma of Clarence Thomas by Corey Robin EPUB","charactorName":"Other(E-books)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Carlos Castaneda Enigma Of a sorcerer.avi","charactorName":"Video(Movies)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma.2001.1080p.BluRay.H264.AAC","charactorName":"Video(HD - Movies)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Ch5 The Stonehenge Enigma 1080p HDTV x265-MVGroup","charactorName":"Video(HD - TV shows)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Elgar - Cello concerto, Enigma, Serenade (Sinopoli) [1994]  FLAC","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma - MCMXC a.D (1990) Flac[24 Bit 96KHz Vinyl]","charactorName":"Audio(FLAC)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"How the Universe Works Series 6 The Quasar Enigma 720p x264 AAC","charactorName":"Video(HD - TV shows)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"Enigma Recovery Professional v3.5.0 + Crack - [haxNode]","charactorName":"Applications(Windows)","sources":{"DataSourceType.tpb":"123"}}
''',
  r'''
{"uniqueId":"123","bestSource":"DataSourceType.tpb","title":"V.S. Naipaul - The enigma of arrival [eBook] PDF","charactorName":"Other(E-books)","sources":{"DataSourceType.tpb":"123"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryTpbSearch test', () {
    // Search for a rare movie.
    test('Run a search on Tpb that is likely to have static results', () async {
      final criteria = SearchCriteriaDTO().fromString('enigma');
      final actualOutput = await QueryTpbSearch(criteria).readList(limit: 10);
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
