// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"magnet:?xt=urn:btih:ac8c26d936b1da5ce94d415fb07a71384db7cb80&dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS+%5BTGx%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","bestSource":"DataSourceType.magnetDl","title":"Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS [TGx]","charactorName":"Movie","type":"MovieContentType.download","creditsOrder":"1",
      "description":"857.10 MB","imageUrl":"magnet:?xt=urn:btih:ac8c26d936b1da5ce94d415fb07a71384db7cb80&dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS+%5BTGx%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969","sources":{"DataSourceType.magnetDl":"magnet:?xt=urn:btih:ac8c26d936b1da5ce94d415fb07a71384db7cb80&dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS+%5BTGx%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamHtmlOfflineData(dynamic dummy) {
  return Future.value(_emitHtmlSample(dummy));
}

Stream<String> _emitHtmlSample(_) async* {
  yield mdlSampleFull;
}

const mdlSampleFull = '$mdlHtmlSampleStart$mdlSampleMid$mdlHtmlSampleEnd';
const mdlHtmlSampleStart = '''

<!DOCTYPE html>
<html
    xmlns:snip=true>
    
    </snip>
  
  <body id="styleguide-v2" class="fixed">
  
   <div class="lister-list">''';
const mdlHtmlSampleEnd = '''

</div>
    
  
  </body>
  </html>
''';

const intermediateMapList = [
  {
    'category': 'Movie',
    'magnet':
        'magnet:?xt=urn:btih:ac8c26d936b1da5ce94d415fb07a71384db7cb80&dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS+%5BTGx%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337&tr=udp%3A%2F%2Fexodus.desync.com%3A6969',
    'name': 'Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS [TGx]',
    'description': '857.10 MB',
    'seeders': '1',
    'leechers': '0',
  }
];

const mdlSampleMid = r'''
<table class="download">
    <tbody>
        <tr>
            <td class="m"><a
                    href="magnet:?xt=urn:btih:ac8c26d936b1da5ce94d415fb07a71384db7cb80&amp;dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS+%5BTGx%5D&amp;tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&amp;tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451&amp;tr=udp%3A%2F%2Ftracker.moeking.me%3A6969&amp;tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969&amp;tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337&amp;tr=udp%3A%2F%2Fexodus.desync.com%3A6969"
                    title="Direct Download" rel="nofollow"><img src="/img/m.gif" alt="Magnet Link" width="14"
                        height="17"></a></td>
            <td class="n"><a href="/file/5251387/space.babes.from.outer.space.2017.bdrip.x264-pegasus-tgx/"
                    title="Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS [TGx]"><b>Space.Babes</b>.From.Outer.<b>Space</b>.2017.BDRip.x264-PEGASUS
                    [TGx]</a></td>
            <td>11 months</td>
            <td class="t2">Movie</td>
            <td>4</td>
            <td>857.10 MB</td>
            <td class="s">1</td>
            <td class="l">0</td>
        </tr>
    </tbody>
</table>
''';
