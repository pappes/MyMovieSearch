// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"magnet:?xt=urn:btih:AC8C26D936B1DA5CE94D415FB07A71384DB7CB80&dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5BTGx%5D&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.tiny-vps.com:6969/announce&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.cyberia.is:6969/announce&tr=udp://ipv4.tracker.harry.lu:80/announce&tr=udp://p4p.arenabg.com:1337/announce&tr=udp://tracker.birkenwald.de:6969/announce&tr=udp://tracker.moeking.me:6969/announce&tr=udp://opentor.org:2710/announce&tr=udp://tracker.dler.org:6969/announce&tr=udp://9.rarbg.me:2970/announce&tr=https://tracker.foreverpirates.co:443/announce&tr=http://vps02.net.orel.ru:80/announce","bestSource":"DataSourceType.gloTorrents","title":"Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS[TGx]","type":"MovieContentType.download",
      "description":"857.09 MB","imageUrl":"magnet:?xt=urn:btih:AC8C26D936B1DA5CE94D415FB07A71384DB7CB80&dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5BTGx%5D&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.tiny-vps.com:6969/announce&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.cyberia.is:6969/announce&tr=udp://ipv4.tracker.harry.lu:80/announce&tr=udp://p4p.arenabg.com:1337/announce&tr=udp://tracker.birkenwald.de:6969/announce&tr=udp://tracker.moeking.me:6969/announce&tr=udp://opentor.org:2710/announce&tr=udp://tracker.dler.org:6969/announce&tr=udp://9.rarbg.me:2970/announce&tr=https://tracker.foreverpirates.co:443/announce&tr=http://vps02.net.orel.ru:80/announce","sources":{"DataSourceType.gloTorrents":"magnet:?xt=urn:btih:AC8C26D936B1DA5CE94D415FB07A71384DB7CB80&dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5BTGx%5D&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.tiny-vps.com:6969/announce&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.cyberia.is:6969/announce&tr=udp://ipv4.tracker.harry.lu:80/announce&tr=udp://p4p.arenabg.com:1337/announce&tr=udp://tracker.birkenwald.de:6969/announce&tr=udp://tracker.moeking.me:6969/announce&tr=udp://opentor.org:2710/announce&tr=udp://tracker.dler.org:6969/announce&tr=udp://9.rarbg.me:2970/announce&tr=https://tracker.foreverpirates.co:443/announce&tr=http://vps02.net.orel.ru:80/announce"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamHtmlOfflineData(_) =>
    Future.value(Stream.value(htmlSampleFull));

const htmlSampleFull = '$gtHtmlSampleStart$gtSampleMid$gtHtmlSampleEnd';
const htmlSampleEmpty = '$gtHtmlSampleStart$gtSampleMidEmpty$gtHtmlSampleEnd';
const htmlSampleError = '$gtHtmlSampleStart$gtHtmlSampleEnd';
const gtHtmlSampleStart = '''

<!DOCTYPE html>
<html
    xmlns:snip=true>
    
    </snip>
  
  <body id="styleguide-v2" class="fixed">
  
   <div class="lister-list">''';
const gtHtmlSampleEnd = '''

</div>
    
  
  </body>
  </html>
''';
const gtSampleMidEmpty = r'''
<div class="f-border"><div class="f-cat" width="100%">Nothing Found</div><div>No torrents were found based on your search criteria.</div></div>
''';

const intermediateMapList = [
  {
    'magnet':
        'magnet:?xt=urn:btih:AC8C26D936B1DA5CE94D415FB07A71384DB7CB80&dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5BTGx%5D&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.tiny-vps.com:6969/announce&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.cyberia.is:6969/announce&tr=udp://ipv4.tracker.harry.lu:80/announce&tr=udp://p4p.arenabg.com:1337/announce&tr=udp://tracker.birkenwald.de:6969/announce&tr=udp://tracker.moeking.me:6969/announce&tr=udp://opentor.org:2710/announce&tr=udp://tracker.dler.org:6969/announce&tr=udp://9.rarbg.me:2970/announce&tr=https://tracker.foreverpirates.co:443/announce&tr=http://vps02.net.orel.ru:80/announce',
    'name': 'Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS[TGx]',
    'description': '857.09 MB',
    'seeders': 0.0,
    'leechers': 0.0,
  }
];

const gtSampleMid = r'''
<table class="ttable_headinner">
    <tbody>
        <tr class="t-row">
            <td class="ttable_col1" align="center" valign="middle"></td>
            <td class="ttable_col2" nowrap="nowrap"><a
                    title="Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS[TGx]"
                    href="/space-babes-from-outer-space-2017-bdrip-x264-pegasus-tgx-f-11862334.html"><b>Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS[TG...</b></a>
            </td>
            <td class="ttable_col1" align="center"></td>
            <td class="ttable_col2" align="center"><a rel="nofollow"
                    href="magnet:?xt=urn:btih:AC8C26D936B1DA5CE94D415FB07A71384DB7CB80&amp;dn=Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5BTGx%5D&amp;tr=udp://open.stealth.si:80/announce&amp;tr=udp://tracker.tiny-vps.com:6969/announce&amp;tr=udp://tracker.opentrackr.org:1337/announce&amp;tr=udp://tracker.torrent.eu.org:451/announce&amp;tr=udp://explodie.org:6969/announce&amp;tr=udp://tracker.cyberia.is:6969/announce&amp;tr=udp://ipv4.tracker.harry.lu:80/announce&amp;tr=udp://p4p.arenabg.com:1337/announce&amp;tr=udp://tracker.birkenwald.de:6969/announce&amp;tr=udp://tracker.moeking.me:6969/announce&amp;tr=udp://opentor.org:2710/announce&amp;tr=udp://tracker.dler.org:6969/announce&amp;tr=udp://9.rarbg.me:2970/announce&amp;tr=https://tracker.foreverpirates.co:443/announce&amp;tr=http://vps02.net.orel.ru:80/announce"><img
                        src="/images/magnetdl.png" border="0" alt="Magnet Download"></a></td>
            <td class="ttable_col1" align="center">857.09 MB</td>
            <td class="ttable_col2" align="center">
                <font color="green"><b>0</b></font>
            </td>
            <td class="ttable_col1" align="center">
                <font color="#ff0000"><b>0</b></font>
            </td>
            <td class="ttable_col2" align="center"></td>
            <td class="ttable_col1" align="center"></td>
        </tr>
    </tbody>
</table>
''';
