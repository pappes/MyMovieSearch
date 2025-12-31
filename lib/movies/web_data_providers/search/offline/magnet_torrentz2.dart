// Raw data in code is generated from an external source.
// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG","bestSource":"DataSourceType.torrentz2","title":"Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG","type":"MovieContentType.download","creditsOrder":"19",
      "description":"1.36 GB","userRatingCount":"14","imageUrl":"magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:C84EF9E1D665729C7BC899BD37652572D84B03C1&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5Brarbg%5D","bestSource":"DataSourceType.torrentz2","title":"Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS[rarbg]","type":"MovieContentType.download","creditsOrder":"13",
      "description":"880 MB","userRatingCount":"12","imageUrl":"magnet:?xt=urn:btih:C84EF9E1D665729C7BC899BD37652572D84B03C1&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5Brarbg%5D","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:C84EF9E1D665729C7BC899BD37652572D84B03C1&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5Brarbg%5D"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamHtmlOfflineData(_) =>
    Future.value(Stream.value(htmlSampleFull));

const htmlSampleFull = '$htmlSampleStart$htmlSampleMid$htmlSampleEnd';
const htmlSampleError = '$htmlSampleStart$htmlSampleEnd';
const htmlSampleEmpty = '$htmlSampleStart$htmlSampleEmptyMid$htmlSampleEnd';
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
    'name': 'Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG',
    'magnet':
        // Generated code.
        // ignore: lines_longer_than_80_chars
        'magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG',
    'description': '1.36 GB',
    'seeders': '19',
    'leechers': '14',
  },
  {
    'name': 'Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS[rarbg]',
    'magnet':
        // Generated code.
        // ignore: lines_longer_than_80_chars
        'magnet:?xt=urn:btih:C84EF9E1D665729C7BC899BD37652572D84B03C1&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5Brarbg%5D',
    'description': '880 MB',
    'seeders': '13',
    'leechers': '12',
  }
];

const htmlSampleEmptyMid = '<h2>0+ Torrents </h2>';

const htmlSampleMid = r'''
<div class="results">
    <dl>
        <dt><a href="http://solidtorrents.to/torrents/space-babes-from-outer-space-2017-1080p-bluray-x26-714eb/6287c8eb8fe14ca928dd7182/"
                target="_blank">Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG</a></dt>
        <dd><span><a href="magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&amp;tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&amp;tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&amp;dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG">
        <i class="fa-solid fa-magnet"></i></a></span><span title="1586352627">a year</span><span>1.36 GB</span><span>19</span><span>14</span></dd>
    </dl>
    <dl>
        <dt><a href="http://solidtorrents.to/torrents/space-babes-from-outer-space-2017-bdrip-x264-pegas-13f94/6287be8d8fe14ca928d93cda/"
                target="_blank">Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS[rarbg]</a></dt>
        <dd><span><a href="magnet:?xt=urn:btih:C84EF9E1D665729C7BC899BD37652572D84B03C1&amp;tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&amp;tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&amp;dn=%5BBitsearch.to%5D+Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5Brarbg%5D">
        <iclass="fa-solid fa-magnet"></i></a></span><span title="1586352627">a year</span><span>880 MB</span><span>13</span><span>12</span></dd>
    </dl>

</div>
''';
