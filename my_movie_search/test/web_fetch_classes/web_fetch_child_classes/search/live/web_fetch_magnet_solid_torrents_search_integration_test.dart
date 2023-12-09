import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_solid_torrents.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real MagnetDb endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"magnet:?xt=urn:btih:1C7108D22B1E82AE743FC80C49F78BB00E04E897&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+(Puniket+35)+%5B0000+(Akito.)%5D+Rize+Sensei+to+Himitsu+no+Jugyou+++Secret+Lessons+with+Rize-sensei+(Gochuumon+wa+Usagi+desu+ka+)+%5BEnglish%5D+%7BDoujins.com%7D.zip","bestSource":"DataSourceType.solidTorrents","title":"(Puniket 35) [0000 (Akito.)] Rize Sensei to Himitsu no Jugyou Secret Lessons with Rize-sensei (Gochuumon wa Usagi desu ka ) [English] {Doujins.com}.zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:1C7108D22B1E82AE743FC80C49F78BB00E04E897&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+(Puniket+35)+%5B0000+(Akito.)%5D+Rize+Sensei+to+Himitsu+no+Jugyou+++Secret+Lessons+with+Rize-sensei+(Gochuumon+wa+Usagi+desu+ka+)+%5BEnglish%5D+%7BDoujins.com%7D.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:1CAF2A14770C31AE34C74DD20D1FA498F8442C6F&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BEnglish%5D+%5Bhardcase8translates%5D","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru [English] [hardcase8translates]","charactorName":"Other/Image","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:1CAF2A14770C31AE34C74DD20D1FA498F8442C6F&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BEnglish%5D+%5Bhardcase8translates%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:1F9878713A030BCE75076FB23FE0231D49DBEDE5&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Rize+and+the+Magic+Cream+Pie+%5BEnglish%5D.rar","bestSource":"DataSourceType.solidTorrents","title":"Rize and the Magic Cream Pie [English].rar","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:1F9878713A030BCE75076FB23FE0231D49DBEDE5&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Rize+and+the+Magic+Cream+Pie+%5BEnglish%5D.rar"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:2258F32CE2EFEF41E8B4BE42535535CB280B06EA&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru","charactorName":"Other/Image","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:2258F32CE2EFEF41E8B4BE42535535CB280B06EA&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:33FCEA6C95C340BD57EAB287AA8406CA898A2422&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.1080p.WEBRip.x265-RARBG","bestSource":"DataSourceType.solidTorrents","title":"Rize.2005.1080p.WEBRip.x265-RARBG","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:33FCEA6C95C340BD57EAB287AA8406CA898A2422&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.1080p.WEBRip.x265-RARBG"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:3DB77B616E35ED9D9D077F5782F794BA6E252529&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize+(2005)+%5B720p%5D+%5BWEBRip%5D+%5BYTS.MX%5D","bestSource":"DataSourceType.solidTorrents","title":"Rize (2005) [720p] [WEBRip] [YTS.MX]","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:3DB77B616E35ED9D9D077F5782F794BA6E252529&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize+(2005)+%5B720p%5D+%5BWEBRip%5D+%5BYTS.MX%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:4F18A68A268B6E17A6046187DB3AFB03232A4C7D&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Morphia+-+Rize.zip","bestSource":"DataSourceType.solidTorrents","title":"Morphia - Rize.zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:4F18A68A268B6E17A6046187DB3AFB03232A4C7D&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Morphia+-+Rize.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:5D1D7410F0E29CFF5253BF3496FB2C9133AF56C6&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+hls-rize.avi","bestSource":"DataSourceType.solidTorrents","title":"hls-rize.avi","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:5D1D7410F0E29CFF5253BF3496FB2C9133AF56C6&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+hls-rize.avi"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:5D74170ECD9829AF0A36E9A19A828053AB8EC5DB&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.monitorit4.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize+(2005)+%5B1080p%5D+%5BWEBRip%5D+%5B5.1%5D+%5BYTS.MX%5D","bestSource":"DataSourceType.solidTorrents","title":"Rize (2005) [1080p] [WEBRip] [5.1] [YTS.MX]","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:5D74170ECD9829AF0A36E9A19A828053AB8EC5DB&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.monitorit4.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize+(2005)+%5B1080p%5D+%5BWEBRip%5D+%5B5.1%5D+%5BYTS.MX%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:6094DD628DEC9ED0EC8CF1261C2CD64B0E81FF90&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Katyuska+Moonfox+-+Rize.zip","bestSource":"DataSourceType.solidTorrents","title":"Katyuska Moonfox - Rize.zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:6094DD628DEC9ED0EC8CF1261C2CD64B0E81FF90&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Katyuska+Moonfox+-+Rize.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:63622F2C7694D66F2CACA70B9D9C1F256188E2F3&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Dakareru+%5Bkorean%5D.zip","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Dakareru [korean].zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:63622F2C7694D66F2CACA70B9D9C1F256188E2F3&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Dakareru+%5Bkorean%5D.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:7002E7177C1286648B880D5682A828302ABD6AC6&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BChinese%5D","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru [Chinese]","charactorName":"Other/Image","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:7002E7177C1286648B880D5682A828302ABD6AC6&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BChinese%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:78291BC4F49048951FDDB69AAD2360CAC467BB67&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+2","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru 2","charactorName":"Other/Image","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:78291BC4F49048951FDDB69AAD2360CAC467BB67&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+2"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:BD0F254C42A94D2FF30A97107B8F341CD0A21D38&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.1080p.AMZN.WEBRip.DDP5.1.x264-SKiZOiD","bestSource":"DataSourceType.solidTorrents","title":"Rize.2005.1080p.AMZN.WEBRip.DDP5.1.x264-SKiZOiD","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:BD0F254C42A94D2FF30A97107B8F341CD0A21D38&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.1080p.AMZN.WEBRip.DDP5.1.x264-SKiZOiD"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:C15EED93F3C4702B594BCA603426547B8D465E64&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+2+%5Bkorean%5D.zip","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru 2 [korean].zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:C15EED93F3C4702B594BCA603426547B8D465E64&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+2+%5Bkorean%5D.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:D3A2032EA6E23ACF2D41C42A4B98DEAD46696F0C&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5B0000+(Akito.)%5D+Rize+Sensei+to+Himitsu+no+Jugyou+(Gochuumon+wa+Usagi+desu+ka%3F)+%5BEnglish%5D+%7BHennojin%7D+%5BDigital%5D.zip","bestSource":"DataSourceType.solidTorrents","title":"[0000 (Akito.)] Rize Sensei to Himitsu no Jugyou (Gochuumon wa Usagi desu ka?) [English] {Hennojin} [Digital].zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:D3A2032EA6E23ACF2D41C42A4B98DEAD46696F0C&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5B0000+(Akito.)%5D+Rize+Sensei+to+Himitsu+no+Jugyou+(Gochuumon+wa+Usagi+desu+ka%3F)+%5BEnglish%5D+%7BHennojin%7D+%5BDigital%5D.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:E030CD9FE14824A76D0FFFEA6169B2667D12492C&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BEnglish%5D+%5Bhardcase8translates%5D.zip","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru [English] [hardcase8translates].zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:E030CD9FE14824A76D0FFFEA6169B2667D12492C&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BEnglish%5D+%5Bhardcase8translates%5D.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:E5966022004321878A7DA3F3A01A084EF725F033&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.WEBRip.x264-ION10","bestSource":"DataSourceType.solidTorrents","title":"Rize.2005.WEBRip.x264-ION10","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:E5966022004321878A7DA3F3A01A084EF725F033&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.WEBRip.x264-ION10"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:EAEDD32BDAB4F05BA75EF4D80270172ED59FCF12&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BToketou%5D+Gochiusa+Rize+(Gochuumon+wa+Usagi+desu+ka)+(2333463).zip","bestSource":"DataSourceType.solidTorrents","title":"[Toketou] Gochiusa Rize (Gochuumon wa Usagi desu ka) (2333463).zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:EAEDD32BDAB4F05BA75EF4D80270172ED59FCF12&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BToketou%5D+Gochiusa+Rize+(Gochuumon+wa+Usagi+desu+ka)+(2333463).zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:F8E7482EA8AB83BA07936244F147381F8ECADE8B&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BEnglish%5D+%5Bhardcase8translates%5D","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru [English] [hardcase8translates]","charactorName":"Other/Image","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:F8E7482EA8AB83BA07936244F147381F8ECADE8B&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BEnglish%5D+%5Bhardcase8translates%5D"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QuerySolidTorrentsSearch test', () {
    // Search for a rare movie.
    test('Run a search on Tpb that is likely to have static results', () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QuerySolidTorrentsSearch(criteria).readList(limit: 10);
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
          await QuerySolidTorrentsSearch(criteria).readList(limit: 10);
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
