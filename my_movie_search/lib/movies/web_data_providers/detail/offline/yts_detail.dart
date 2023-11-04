// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

const htmlSampleStart = ' <!DOCTYPE html> <html     <head>'
    ' </head> <body id="styleguide-v2" class="fixed">';
const htmlSampleEnd = ' </body> </html>';
const htmlSampleFull = '$htmlSampleStart $htmlSampleInner $htmlSampleEnd';

Future<Stream<String>> streamhtmlOfflineData(_) {
  return Future.value(emitHtmlSample(_));
}

Stream<String> emitHtmlSample(_) async* {
  yield htmlSampleFull;
}

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"magnet:?xt=urn:btih:35EB8826EA87E7D655949F8A715CD36FEB0730F3&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B2160p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce","bestSource":"DataSourceType.ytsDetails","title":"2001: A Space Odyssey","type":"MovieContentType.download","year":"1968","creditsOrder":"68",
      "description":"7.02 GB 3840*1746 English 5.1 NR","userRatingCount":"17","imageUrl":"magnet:?xt=urn:btih:35EB8826EA87E7D655949F8A715CD36FEB0730F3&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B2160p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce","sources":{"DataSourceType.ytsDetails":"magnet:?xt=urn:btih:35EB8826EA87E7D655949F8A715CD36FEB0730F3&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B2160p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce","bestSource":"DataSourceType.ytsDetails","title":"2001: A Space Odyssey","type":"MovieContentType.download","year":"1968","creditsOrder":"383",
      "description":"2.38 GB 1920*864 English 2.0 NR","userRatingCount":"39","imageUrl":"magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce","sources":{"DataSourceType.ytsDetails":"magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:E3529DBC0CE47429A8A9B411AB381C893BFEF575&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B720p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce","bestSource":"DataSourceType.ytsDetails","title":"2001: A Space Odyssey","type":"MovieContentType.download","year":"1968","creditsOrder":"48",
      "description":"853.57 MB 1280*720 English 2.0 NR","userRatingCount":"9","imageUrl":"magnet:?xt=urn:btih:E3529DBC0CE47429A8A9B411AB381C893BFEF575&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B720p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce","sources":{"DataSourceType.ytsDetails":"magnet:?xt=urn:btih:E3529DBC0CE47429A8A9B411AB381C893BFEF575&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B720p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce"}}
''',
];

const intermediateMapList = [
  {
    'name': '2001: A Space Odyssey',
    'year': '1968',
    'image':
        'https://img.yts.mx/assets/images/movies/2001_A_Space_Odyssey_1968/medium-cover.jpg',
    'size': '853.57 MB',
    'magnet':
        'magnet:?xt=urn:btih:E3529DBC0CE47429A8A9B411AB381C893BFEF575&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B720p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce',
    'description': '853.57 MB 1280*720 English 2.0 NR',
    'leechers': 9,
    'seeders': 48,
  },
  {
    'name': '2001: A Space Odyssey',
    'year': '1968',
    'image':
        'https://img.yts.mx/assets/images/movies/2001_A_Space_Odyssey_1968/medium-cover.jpg',
    'size': '2.38 GB',
    'magnet':
        'magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce',
    'description': '2.38 GB 1920*864 English 2.0 NR',
    'leechers': 39,
    'seeders': 383,
  },
  {
    'name': '2001: A Space Odyssey',
    'year': '1968',
    'image':
        'https://img.yts.mx/assets/images/movies/2001_A_Space_Odyssey_1968/medium-cover.jpg',
    'size': '7.02 GB',
    'magnet':
        'magnet:?xt=urn:btih:35EB8826EA87E7D655949F8A715CD36FEB0730F3&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B2160p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce',
    'description': '7.02 GB 3840*1746 English 5.1 NR',
    'leechers': 17,
    'seeders': 68,
  }
];

const htmlSampleInner = '''


                <div id="mobile-movie-info" class="visible-xs col-xs-20">
                    <h1 itemprop="name">2001: A Space Odyssey</h1>
                    <h2>1968</h2>
                    <h2>Action / Adventure / Mystery / Sci-Fi</h2>
                </div>

                <div id="movie-poster" class="col-xs-10 col-sm-6 col-lg-5">
                    <img class="img-responsive" itemprop="image"
                        src="https://img.yts.mx/assets/images/movies/2001_A_Space_Odyssey_1968/medium-cover.jpg"
                        alt="2001: A Space Odyssey (1968) download" />
                </div>

                            <div class="modal-torrent">
                                <div class="modal-quality" id="modal-quality-720p"><span>720p</span></div>
                                <p class="quality-size">853.57 MB</p>
                                <a data-torrent-id="51"
                                    href="magnet:?xt=urn:btih:E3529DBC0CE47429A8A9B411AB381C893BFEF575&amp;dn=2001%3A+A+Space+Odyssey+%281968%29+%5B720p%5D+%5BYTS.MX%5D&amp;tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&amp;tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&amp;tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&amp;tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&amp;tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&amp;tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce"
                                    class="magnet-download download-torrent magnet"
                                    rel="nofollow"><span>Magnet</span></a>
                            </div>
                            <div class="modal-torrent">
                                <div class="modal-quality" id="modal-quality-1080p"><span>1080p</span></div>
                                <p class="quality-size">2.38 GB</p>
                                <a data-torrent-id="14429"
                                    href="magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&amp;dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.MX%5D&amp;tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&amp;tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&amp;tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&amp;tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&amp;tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&amp;tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce"
                                    class="magnet-download download-torrent magnet"
                                    rel="nofollow"><span>Magnet</span></a>
                            </div>
                            <div class="modal-torrent">
                                <div class="modal-quality" id="modal-quality-2160p"><span>2160p</span></div>
                                <p class="quality-size">7.02 GB</p>
                                <a data-torrent-id="49212"
                                    href="magnet:?xt=urn:btih:35EB8826EA87E7D655949F8A715CD36FEB0730F3&amp;dn=2001%3A+A+Space+Odyssey+%281968%29+%5B2160p%5D+%5BYTS.MX%5D&amp;tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&amp;tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&amp;tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&amp;tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&amp;tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&amp;tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce"
                                    class="magnet-download download-torrent magnet"
                                    rel="nofollow"><span>Magnet</span></a>
                            </div>


            <div id="movie-tech-specs" class="row">
                <h3 class="hidden-xs hidden-sm col-md-5">Tech specs</h3>
                <div class="tech-spec-info col-xs-20 ">
                    <div class="row">
                        <div class="tech-spec-element"><span title="File Size"
                                class="icon-folder"></span> 853.57 MB <div></div>
                        </div>
                        <div class="tech-spec-element"> <span title="Resolution"
                                class="icon-expand"></span> 1280*720 <div></div>
                        </div>
                        <div class="tech-spec-element"> <span title="Language"
                                class="icon-volume-medium"></span> English 2.0 <div></div>
                        </div>
                        <div class="tech-spec-element"> <span title="MPA Rating"
                                class="icon-eye"></span> NR <div></div>
                        </div>
                    </div>
                    <div class="row">
                        <div > <span title="Peers & Seeds"
                                class="tech-peers-seeds">P/S</span> 9 / 48 </div>
                    </div>
                </div>
                <div class="tech-spec-info col-xs-20 hidden-tech-info">
                    <div class="row">
                        <div class="tech-spec-element"><span title="File Size"
                                class="icon-folder"></span> 2.38 GB <div></div>
                        </div>
                        <div class="tech-spec-element"> <span title="Resolution"
                                class="icon-expand"></span> 1920*864 <div></div>
                        </div>
                        <div class="tech-spec-element"> <span title="Language"
                                class="icon-volume-medium"></span> English 2.0 <div></div>
                        </div>
                        <div class="tech-spec-element"> <span title="MPA Rating"
                                class="icon-eye"></span> NR <div></div>
                        </div>
                    </div>
                    <div class="row">
                        <div > <span title="Peers & Seeds"
                                class="tech-peers-seeds">P/S</span> 39 / 383 </div>
                    </div>
                </div>
                <div class="tech-spec-info col-xs-20 hidden-tech-info">
                    <div class="row">
                        <div class="tech-spec-element"><span title="File Size"
                                class="icon-folder"></span> 7.02 GB <div></div>
                        </div>
                        <div class="tech-spec-element"> <span title="Resolution"
                                class="icon-expand"></span> 3840*1746 <div></div>
                        </div>
                        <div class="tech-spec-element"> <span title="Language"
                                class="icon-volume-medium"></span> English 5.1 <div></div>
                        </div>
                        <div class="tech-spec-element"> <span title="MPA Rating"
                                class="icon-eye"></span> NR <div></div>
                        </div>
                    </div>
                    <div class="row">
                        <div > <span title="Peers & Seeds"
                                class="tech-peers-seeds">P/S</span> 17 / 68 </div>
                    </div>
                </div>
            </div>

''';
