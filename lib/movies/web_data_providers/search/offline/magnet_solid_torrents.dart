// Raw data in code is generated from an external source.
// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG","bestSource":"DataSourceType.solidTorrents","title":"Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG","characterName":"Other/Video","type":"MovieContentType.download","creditsOrder":"19",
      "description":"125 1.36 GB 19 14 May 20, 2022","userRatingCount":"14","imageUrl":"magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamHtmlOfflineData(_) =>
    Future.value(Stream.value(htmlSampleFull));

const htmlSampleFull = '$htmlSampleStart$htmlSampleMid$htmlSampleEnd';
const htmlSampleEmpty = '$htmlSampleStart$htmlSampleMidEmpty$htmlSampleEnd';
const htmlSampleError = '$htmlSampleStart$htmlSampleEnd';
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
    'description': '125 1.36 GB 19 14 May 20, 2022',
    'category': 'Other/Video',
    'magnet':
        // Generated code.
        // ignore: lines_longer_than_80_chars
        'magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG',
    'name': 'Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG',
    'seeders': '19',
    'leechers': '14',
  },
];
const htmlSampleMidEmpty =
    'Found <span class="font-semibold">0</span> results in '
    '<span class="font-semibold">73ms</span> for '
    '<span class="font-semibold">"therearenoresultszzzz"</span>';

const htmlSampleMid = r'''
        <li class="card search-result my-2">
                    <h5 class="title w-100 truncate"><a
                            href="/torrents/space-babes-from-outer-space-2017-1080p-bluray-x26-714eb/6287c8eb8fe14ca928dd7182/"
                            data-token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoidG9ycmVudHMiLCJhY3Rpb24iOiJ2aWV3IiwiaWRzIjpbIjYyODdjOGViOGZlMTRjYTkyOGRkNzE4MiJdLCJpYXQiOjE2ODI0MDE1MjAsImV4cCI6MTY4MzY5NzUyMH0.76rBFSEj9Y4f-e14VgqTXn773fQo145ckHEXhb7EQoo">Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG</a>
                    </h5>
                        <a class="category">Other/Video</a>
                        <div class="stats">
                            <div>125</div>
                            <div>1.36 GB</div>
                            <div>19</div>
                            <div>14</div>
                            <div>May 20,
                                2022</div>
                        </div>
                <a href="magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&amp;tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&amp;tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&amp;dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG"
                    data-token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoidG9ycmVudHMiLCJhY3Rpb24iOiJkb3dubG9hZCIsImlkcyI6WyI2Mjg3YzhlYjhmZTE0Y2E5MjhkZDcxODIiXSwiaWF0IjoxNjgyNDAxNTIwLCJleHAiOjE2ODM2OTc1MjB9.0SVgaoV_BtbMdWELkKB5ytkK_0K7itV1WR3QpwCpUPs"
                    class="dl-magnet"><img src="/icons/download-magnet.svg" alt="Magnet" title="Magnet Link"></a>
        </li>
''';
