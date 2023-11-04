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
{"uniqueId":"magnet:?xt=urn:btih:0AE580C35F7A236D0BCD41FF4067F675BC337CF2&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Tenacious+D+-+Rize+of+the+Fenix%2C+2012+(FLAC)","bestSource":"DataSourceType.solidTorrents","title":"Tenacious D - Rize of the Fenix, 2012 (FLAC)","charactorName":"Other/Image","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:0AE580C35F7A236D0BCD41FF4067F675BC337CF2&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Tenacious+D+-+Rize+of+the+Fenix%2C+2012+(FLAC)"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:1F9878713A030BCE75076FB23FE0231D49DBEDE5&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Rize+and+the+Magic+Cream+Pie+%5BEnglish%5D.rar","bestSource":"DataSourceType.solidTorrents","title":"Rize and the Magic Cream Pie [English].rar","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:1F9878713A030BCE75076FB23FE0231D49DBEDE5&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Rize+and+the+Magic+Cream+Pie+%5BEnglish%5D.rar"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:2037FE480FA4162831DC300F6D431E0FCDAC7519&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5Bwww.Cpasbien.com%5D+Tenacious+D+-+Rize+of+the+Fenix+(2012)","bestSource":"DataSourceType.solidTorrents","title":"[www.Cpasbien.com] Tenacious D - Rize of the Fenix (2012) ✅","charactorName":"Music/Album","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:2037FE480FA4162831DC300F6D431E0FCDAC7519&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5Bwww.Cpasbien.com%5D+Tenacious+D+-+Rize+of+the+Fenix+(2012)"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:2258F32CE2EFEF41E8B4BE42535535CB280B06EA&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru","charactorName":"Other/Image","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:2258F32CE2EFEF41E8B4BE42535535CB280B06EA&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:33C48834B2D65340B7FA838067847EB738137E96&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+%5BCheeseyeast+(Naka)%5D+(Sharo+or+Sharo)+and+Rize+(Gochuumon+wa+Usagi+desu+ka+)+%5BKorean%5D+%5BDigital%5D.zip","bestSource":"DataSourceType.solidTorrents","title":"[Cheeseyeast (Naka)] (Sharo or Sharo) and Rize (Gochuumon wa Usagi desu ka ) [Korean] [Digital].zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:33C48834B2D65340B7FA838067847EB738137E96&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+%5BCheeseyeast+(Naka)%5D+(Sharo+or+Sharo)+and+Rize+(Gochuumon+wa+Usagi+desu+ka+)+%5BKorean%5D+%5BDigital%5D.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:33FCEA6C95C340BD57EAB287AA8406CA898A2422&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.1080p.WEBRip.x265-RARBG","bestSource":"DataSourceType.solidTorrents","title":"Rize.2005.1080p.WEBRip.x265-RARBG","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:33FCEA6C95C340BD57EAB287AA8406CA898A2422&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.1080p.WEBRip.x265-RARBG"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:3DB77B616E35ED9D9D077F5782F794BA6E252529&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize+(2005)+%5B720p%5D+%5BWEBRip%5D+%5BYTS.MX%5D","bestSource":"DataSourceType.solidTorrents","title":"Rize (2005) [720p] [WEBRip] [YTS.MX]","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:3DB77B616E35ED9D9D077F5782F794BA6E252529&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize+(2005)+%5B720p%5D+%5BWEBRip%5D+%5BYTS.MX%5D"}}
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
{"uniqueId":"magnet:?xt=urn:btih:66C0D4BDEF47FA47DE867C80C893D9B3D7C8BC67&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&dn=%5BBitsearch.to%5D+Tenacious+D-Rize+Of+The+Fenix+(2012)+320Kbit(mp3)+DMT","bestSource":"DataSourceType.solidTorrents","title":"Tenacious D-Rize Of The Fenix (2012) 320Kbit(mp3) DMT ✅","charactorName":"Music/mp3","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:66C0D4BDEF47FA47DE867C80C893D9B3D7C8BC67&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&dn=%5BBitsearch.to%5D+Tenacious+D-Rize+Of+The+Fenix+(2012)+320Kbit(mp3)+DMT"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:6C6D4DEBFC65FFB440EF16FA750C9DFDA73A568D&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Ksatria+Wanita+Rize+Malam+Ini+Sedang+Dipeluk+Pria+Lain+%5BIndonesian%5D+%5BGagak_Ireng%5D.zip","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Ksatria Wanita Rize Malam Ini Sedang Dipeluk Pria Lain [Indonesian] [Gagak_Ireng].zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:6C6D4DEBFC65FFB440EF16FA750C9DFDA73A568D&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Ksatria+Wanita+Rize+Malam+Ini+Sedang+Dipeluk+Pria+Lain+%5BIndonesian%5D+%5BGagak_Ireng%5D.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:7002E7177C1286648B880D5682A828302ABD6AC6&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BChinese%5D","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru [Chinese]","charactorName":"Other/Image","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:7002E7177C1286648B880D5682A828302ABD6AC6&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BChinese%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:9CA3DFE2393D51B7F02DF356FBEC5CBF7DE02D50&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+RJ256426+-+Rize+and+the+Magic+Cream+Pie+tl+v1.00.7z","bestSource":"DataSourceType.solidTorrents","title":"RJ256426 - Rize and the Magic Cream Pie tl v1.00.7z","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:9CA3DFE2393D51B7F02DF356FBEC5CBF7DE02D50&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+RJ256426+-+Rize+and+the+Magic+Cream+Pie+tl+v1.00.7z"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:B1205E7260D03663D20B69278DFE287D45C1BD29&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+movies+-+rize+(get+crump!).avi","bestSource":"DataSourceType.solidTorrents","title":"movies - rize (get crump!).avi","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:B1205E7260D03663D20B69278DFE287D45C1BD29&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+movies+-+rize+(get+crump!).avi"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:BD0F254C42A94D2FF30A97107B8F341CD0A21D38&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.1080p.AMZN.WEBRip.DDP5.1.x264-SKiZOiD","bestSource":"DataSourceType.solidTorrents","title":"Rize.2005.1080p.AMZN.WEBRip.DDP5.1.x264-SKiZOiD","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:BD0F254C42A94D2FF30A97107B8F341CD0A21D38&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.1080p.AMZN.WEBRip.DDP5.1.x264-SKiZOiD"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:D72C4BD693045839172DC1FEA2C260D58733AD43&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BChinese%5D.zip","bestSource":"DataSourceType.solidTorrents","title":"[Akirerushoujo (Akire)] Onna-kishi Rize wa Koyoi mo Maotoko ni Idakareru [Chinese].zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:D72C4BD693045839172DC1FEA2C260D58733AD43&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BAkirerushoujo+(Akire)%5D+Onna-kishi+Rize+wa+Koyoi+mo+Maotoko+ni+Idakareru+%5BChinese%5D.zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:E5966022004321878A7DA3F3A01A084EF725F033&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.WEBRip.x264-ION10","bestSource":"DataSourceType.solidTorrents","title":"Rize.2005.WEBRip.x264-ION10","charactorName":"Other/Video","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:E5966022004321878A7DA3F3A01A084EF725F033&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Rize.2005.WEBRip.x264-ION10"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:EAEDD32BDAB4F05BA75EF4D80270172ED59FCF12&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BToketou%5D+Gochiusa+Rize+(Gochuumon+wa+Usagi+desu+ka)+(2333463).zip","bestSource":"DataSourceType.solidTorrents","title":"[Toketou] Gochiusa Rize (Gochuumon wa Usagi desu ka) (2333463).zip","charactorName":"Other/Archive","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:EAEDD32BDAB4F05BA75EF4D80270172ED59FCF12&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+%5BToketou%5D+Gochiusa+Rize+(Gochuumon+wa+Usagi+desu+ka)+(2333463).zip"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:FD57BFDC9BAD9D2A72295D4E8041A30D9E3B2FF2&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+Rize_Of_The_Fenix_FLAC.tar.xz","bestSource":"DataSourceType.solidTorrents","title":"Rize_Of_The_Fenix_FLAC.tar.xz","charactorName":"Other","type":"MovieContentType.download","sources":{"DataSourceType.solidTorrents":"magnet:?xt=urn:btih:FD57BFDC9BAD9D2A72295D4E8041A30D9E3B2FF2&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+Rize_Of_The_Fenix_FLAC.tar.xz"}}
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
