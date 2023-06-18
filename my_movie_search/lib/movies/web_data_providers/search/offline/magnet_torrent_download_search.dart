// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://www.torrentdownload.info/A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7/2001-A-Space-Odyssey-+1968+-+BluRay+-+1080p+-+YTS-AM+","bestSource":"DataSourceType.torrentDownloadSearch","title":"2001 A Space Odyssey (1968) [BluRay] [1080p] [YTS AM] � Movies","type":"MovieContentType.download","creditsOrder":"578",
      "description":"placeholder: 2.38 GB","userRatingCount":"248","sources":{"DataSourceType.torrentDownloadSearch":"https://www.torrentdownload.info/A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7/2001-A-Space-Odyssey-+1968+-+BluRay+-+1080p+-+YTS-AM+"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamHtmlOfflineData(dynamic dummy) {
  return Future.value(_emitHtmlSample(dummy));
}

Stream<String> _emitHtmlSample(_) async* {
  yield htmlSampleFull;
}

const htmlSampleFull = '$htmlSampleStart$htmlSampleMid$htmlSampleEnd';
const htmlSampleStart = '''

<!DOCTYPE html>
<html
    xmlns:snip=true>
    
    </snip>
  
  <body id="styleguide-v2" class="fixed">
  
   <div class="lister-list">''';
const htmlSampleEnd = '''

</div>
    
  
  </body>
  </html>
''';

const intermediateMapList = [
  {
    'name': '2001 A Space Odyssey (1968) [BluRay] [1080p] [YTS AM] � Movies',
    'url':
        'https://www.torrentdownload.info/A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7/2001-A-Space-Odyssey-+1968+-+BluRay+-+1080p+-+YTS-AM+',
    'description': '2.38 GB',
    'seeders': '578',
    'leechers': '248'
  }
];

const htmlSampleMid = r'''
<table class="table2" cellspacing="0">
    <tbody>
        <tr>
            <td class="tdleft">
                <div class="tt-name"><a
                        href="/A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7/2001-A-Space-Odyssey-+1968+-+BluRay+-+1080p+-+YTS-AM+">2001
                        A <span class="na">Space</span> Odyssey (1968) [BluRay] [1080p] [YTS AM]</a> <span
                        class="smallish"> � Movies</span></div>
                <div class="tt-options"></div>
            </td>
            <td class="tdnormal">1 Year+</td>
            <td class="tdnormal">2.38 GB</td>
            <td class="tdseed">578</td>
            <td class="tdleech">248</td>
        </tr>
    </tbody>
</table>
''';
