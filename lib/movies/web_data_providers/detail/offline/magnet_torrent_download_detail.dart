// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://address","bestSource":"DataSourceType.torrentDownloadDetail","type":"MovieContentType.download",
      "description":"Torrent Files Size: 2.13 GB Space Jam A New Legacy (2021) [1080p] [WEBRip] [5.1] [YTS.MX] Space.Jam.A.New.Legacy.2021.1080p.WEBRip.x264.AAC5.1-[YTS.MX].mp4 - 2.13 GB Space.Jam.A.New.Legacy.2021.1080p.WEBRip.x264.AAC5.1-[YTS.MX].srt - 137.77 KB /div> www.YTS.MX.jpg - 51.98 KB/div> Subs English [SDH].eng.srt - 169.9 KB English.eng.srt - 137.77 KB","imageUrl":"magnet:?xt=urn:btih:B9F89CFDF8E74E9ACE0E58528932FCC437AD0D0E&dn=&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=http%3A%2F%2Ftracker.ipv6tracker.ru%3A80%2Fannounce&tr=udp%3A%2F%2Fretracker.hotplug.ru%3A2710%2Fannounce&tr=https%3A%2F%2Ftracker.fastdownload.xyz%3A443%2Fannounce&tr=https%3A%2F%2Fopentracker.xyz%3A443%2Fannounce&tr=http%3A%2F%2Fopen.trackerlist.xyz%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.birkenwald.de%3A6969%2Fannounce&tr=https%3A%2F%2Ft.quic.ws%3A443%2Fannounce&tr=https%3A%2F%2Ftracker.parrotsec.org%3A443%2Fannounce&tr=udp%3A%2F%2Ftracker.supertracker.net%3A1337%2Fannounce&tr=http%3A%2F%2Fgwp2-v19.rinet.ru%3A80%2Fannounce&tr=udp%3A%2F%2Fbigfoot1942.sektori.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fcarapax.net%3A6969%2Fannounce&tr=udp%3A%2F%2Fretracker.akado-ural.ru%3A80%2Fannounce&tr=udp%3A%2F%2Fretracker.maxnet.ua%3A80%2Fannounce&tr=udp%3A%2F%2Fbt.dy20188.com%3A80%2Fannounce&tr=http%3A%2F%2F0d.kebhana.mx%3A443%2Fannounce&tr=http%3A%2F%2Ftracker.files.fm%3A6969%2Fannounce&tr=http%3A%2F%2Fretracker.joxnet.ru%3A80%2Fannounce&tr=http%3A%2F%2Ftracker.moxing.party%3A6969%2Fannounce","sources":{"DataSourceType.torrentDownloadDetail":"https://address"}}
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
    'url':
        // ignore: lines_longer_than_80_chars
        'magnet:?xt=urn:btih:B9F89CFDF8E74E9ACE0E58528932FCC437AD0D0E&dn=&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=http%3A%2F%2Ftracker.ipv6tracker.ru%3A80%2Fannounce&tr=udp%3A%2F%2Fretracker.hotplug.ru%3A2710%2Fannounce&tr=https%3A%2F%2Ftracker.fastdownload.xyz%3A443%2Fannounce&tr=https%3A%2F%2Fopentracker.xyz%3A443%2Fannounce&tr=http%3A%2F%2Fopen.trackerlist.xyz%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.birkenwald.de%3A6969%2Fannounce&tr=https%3A%2F%2Ft.quic.ws%3A443%2Fannounce&tr=https%3A%2F%2Ftracker.parrotsec.org%3A443%2Fannounce&tr=udp%3A%2F%2Ftracker.supertracker.net%3A1337%2Fannounce&tr=http%3A%2F%2Fgwp2-v19.rinet.ru%3A80%2Fannounce&tr=udp%3A%2F%2Fbigfoot1942.sektori.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fcarapax.net%3A6969%2Fannounce&tr=udp%3A%2F%2Fretracker.akado-ural.ru%3A80%2Fannounce&tr=udp%3A%2F%2Fretracker.maxnet.ua%3A80%2Fannounce&tr=udp%3A%2F%2Fbt.dy20188.com%3A80%2Fannounce&tr=http%3A%2F%2F0d.kebhana.mx%3A443%2Fannounce&tr=http%3A%2F%2Ftracker.files.fm%3A6969%2Fannounce&tr=http%3A%2F%2Fretracker.joxnet.ru%3A80%2Fannounce&tr=http%3A%2F%2Ftracker.moxing.party%3A6969%2Fannounce',
    'description':
        'Torrent Files Size: 2.13 GB Space Jam A New Legacy (2021) [1080p] [WEBRip] [5.1] [YTS.MX] Space.Jam.A.New.Legacy.2021.1080p.WEBRip.x264.AAC5.1-[YTS.MX].mp4 - 2.13 GB Space.Jam.A.New.Legacy.2021.1080p.WEBRip.x264.AAC5.1-[YTS.MX].srt - 137.77 KB /div> www.YTS.MX.jpg - 51.98 KB/div> Subs English [SDH].eng.srt - 169.9 KB English.eng.srt - 137.77 KB',
  }
];

const htmlSampleMidEmpty = '<b>TOP torrents last week</b>';
const htmlSampleMid = r'''
<a class="tosa" href="magnet:?xt=urn:btih:B9F89CFDF8E74E9ACE0E58528932FCC437AD0D0E&dn=&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=http%3A%2F%2Ftracker.ipv6tracker.ru%3A80%2Fannounce&tr=udp%3A%2F%2Fretracker.hotplug.ru%3A2710%2Fannounce&tr=https%3A%2F%2Ftracker.fastdownload.xyz%3A443%2Fannounce&tr=https%3A%2F%2Fopentracker.xyz%3A443%2Fannounce&tr=http%3A%2F%2Fopen.trackerlist.xyz%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.birkenwald.de%3A6969%2Fannounce&tr=https%3A%2F%2Ft.quic.ws%3A443%2Fannounce&tr=https%3A%2F%2Ftracker.parrotsec.org%3A443%2Fannounce&tr=udp%3A%2F%2Ftracker.supertracker.net%3A1337%2Fannounce&tr=http%3A%2F%2Fgwp2-v19.rinet.ru%3A80%2Fannounce&tr=udp%3A%2F%2Fbigfoot1942.sektori.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fcarapax.net%3A6969%2Fannounce&tr=udp%3A%2F%2Fretracker.akado-ural.ru%3A80%2Fannounce&tr=udp%3A%2F%2Fretracker.maxnet.ua%3A80%2Fannounce&tr=udp%3A%2F%2Fbt.dy20188.com%3A80%2Fannounce&tr=http%3A%2F%2F0d.kebhana.mx%3A443%2Fannounce&tr=http%3A%2F%2Ftracker.files.fm%3A6969%2Fannounce&tr=http%3A%2F%2Fretracker.joxnet.ru%3A80%2Fannounce&tr=http%3A%2F%2Ftracker.moxing.party%3A6969%2Fannounce"> STUFF </a>



      <table class="table3 torrentcontent" cellspacing="0">
        <tr>
          <th class="thleft">
            <div class="left"><b>Torrent Files</b></div>
            <div class="right">Size: 2.13 GB</div>
          </th>
        </tr>
        <tr>
          <td>
            <div class="fileline"> Space Jam A New Legacy (2021) [1080p] [WEBRip]
              [5.1] [YTS.MX] 
              Space.Jam.A.New.Legacy.2021.1080p.WEBRip.x264.AAC5.1-[YTS.MX].mp4 -  2.13 GB
              </div>
            <div class="fileline">
              Space.Jam.A.New.Legacy.2021.1080p.WEBRip.x264.AAC5.1-[YTS.MX].srt -  137.77 KB
               /div>
            <div class="fileline"> www.YTS.MX.jpg - 51.98 KB/div>
            <div class="fileline">
              Subs
              English [SDH].eng.srt - 169.9 KB</div>
            <div class="fileline"> English.eng.srt - 137.77 KB
            </div>
          </td>
        </tr>
      </table>

''';
