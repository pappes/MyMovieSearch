import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrentz2.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real MagnetDb endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"magnet:?xt=urn:btih:0442122852B3252723D9E7F49A7FAD72FDEA067B&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.1080p.WEBRip.x264-RARBG","bestSource":"DataSourceType.torrentz2","title":"Shark.Side.Of.The.Moon.2022.1080p.WEBRip.x264-RARBG","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:0442122852B3252723D9E7F49A7FAD72FDEA067B&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.1080p.WEBRip.x264-RARBG"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:196A7B60BA15E50544FE30F62A3E6EAB2A81B3E9&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Shark+Side+of+the+Moon+(2022)+WEBDL+1080p+LAT+-+ZeiZ","bestSource":"DataSourceType.torrentz2","title":"Shark Side of the Moon (2022) WEBDL 1080p LAT - ZeiZ","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:196A7B60BA15E50544FE30F62A3E6EAB2A81B3E9&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Shark+Side+of+the+Moon+(2022)+WEBDL+1080p+LAT+-+ZeiZ"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:214D767D97A57BB70EAF2A0442D8A0FD466830CC&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Shark+Side+Of+The+Moon+(2022)+%5B1080p%5D+%5BWEBRip%5D+%5BYTS.MX%5D","bestSource":"DataSourceType.torrentz2","title":"Shark Side Of The Moon (2022) [1080p] [WEBRip] [YTS.MX]","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:214D767D97A57BB70EAF2A0442D8A0FD466830CC&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Shark+Side+Of+The+Moon+(2022)+%5B1080p%5D+%5BWEBRip%5D+%5BYTS.MX%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:2205932A17D5E8D6537C5E79CAB1FC949441E428&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.of.the.Moon.2022.1080p.WEB-DL.Rus.Eng.%5Bsub.Eng%5D-BLUEBIRD.mkv","bestSource":"DataSourceType.torrentz2","title":"Shark.Side.of.the.Moon.2022.1080p.WEB-DL.Rus.Eng.[sub.Eng]-BLUEBIRD.mkv","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:2205932A17D5E8D6537C5E79CAB1FC949441E428&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.of.the.Moon.2022.1080p.WEB-DL.Rus.Eng.%5Bsub.Eng%5D-BLUEBIRD.mkv"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:2F470963059A9C13227A24246067F10B2FA6E6E9&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.side.of.the.moon.2022.P.WEB-DLRip.7OOMB.avi","bestSource":"DataSourceType.torrentz2","title":"Shark.side.of.the.moon.2022.P.WEB-DLRip.7OOMB.avi","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:2F470963059A9C13227A24246067F10B2FA6E6E9&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.side.of.the.moon.2022.P.WEB-DLRip.7OOMB.avi"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:388337A5AC915365FC882FA91A602CF7EA3E8DBA&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.1080p.WEBRip.1400MB.DD2.0.x264-GalaxyRG%5BTGx%5D","bestSource":"DataSourceType.torrentz2","title":"Shark.Side.Of.The.Moon.2022.1080p.WEBRip.1400MB.DD2.0.x264-GalaxyRG[TGx]","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:388337A5AC915365FC882FA91A602CF7EA3E8DBA&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.1080p.WEBRip.1400MB.DD2.0.x264-GalaxyRG%5BTGx%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:7F9ACB0692DBA6B3C4C561ED34D0482DB6087B46&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.720p.WEB.h264-PFa%5Brarbg%5D","bestSource":"DataSourceType.torrentz2","title":"Shark.Side.Of.The.Moon.2022.720p.WEB.h264-PFa[rarbg]","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:7F9ACB0692DBA6B3C4C561ED34D0482DB6087B46&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.720p.WEB.h264-PFa%5Brarbg%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:89FFBB335A40DDE3805B2EDEB239134AC58252D7&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+%5BEx-torrenty.org%5DShark.Side.Of.The.Moon.2022.PL.WEB-DL.XviD-GR4PE","bestSource":"DataSourceType.torrentz2","title":"[Ex-torrenty.org]Shark.Side.Of.The.Moon.2022.PL.WEB-DL.XviD-GR4PE","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:89FFBB335A40DDE3805B2EDEB239134AC58252D7&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+%5BEx-torrenty.org%5DShark.Side.Of.The.Moon.2022.PL.WEB-DL.XviD-GR4PE"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:9CB894B90AF179743E2A86841E1501EFF4759FBF&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.1080p.WEBRip.x265-RARBG","bestSource":"DataSourceType.torrentz2","title":"Shark.Side.Of.The.Moon.2022.1080p.WEBRip.x265-RARBG","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:9CB894B90AF179743E2A86841E1501EFF4759FBF&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.1080p.WEBRip.x265-RARBG"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:9DFEE20DFBC703E3633A287472EE4B6AF1FA3EA3&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.side.of.the.moon.2022.P.WEB-DLRip.14OOMB.avi","bestSource":"DataSourceType.torrentz2","title":"Shark.side.of.the.moon.2022.P.WEB-DLRip.14OOMB.avi","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:9DFEE20DFBC703E3633A287472EE4B6AF1FA3EA3&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.side.of.the.moon.2022.P.WEB-DLRip.14OOMB.avi"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:A6F2F20A2DF86CC1B1A4059245E74A7E60CA743F&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+%5BEX-TORRENTY.ORG%5D+Shark.Side.of.the.Moon.2022.PL.1080p.HDTV.50FPS.x264.DD2.0-FOX","bestSource":"DataSourceType.torrentz2","title":"[EX-TORRENTY.ORG] Shark.Side.of.the.Moon.2022.PL.1080p.HDTV.50FPS.x264.DD2.0-FOX","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:A6F2F20A2DF86CC1B1A4059245E74A7E60CA743F&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+%5BEX-TORRENTY.ORG%5D+Shark.Side.of.the.Moon.2022.PL.1080p.HDTV.50FPS.x264.DD2.0-FOX"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:A9536612A100F7A422646788CF93440FB94EA3CE&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.WEBRip.x264-ION10","bestSource":"DataSourceType.torrentz2","title":"Shark.Side.Of.The.Moon.2022.WEBRip.x264-ION10","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:A9536612A100F7A422646788CF93440FB94EA3CE&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.WEBRip.x264-ION10"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:C77D13A428848327D15B2E253AB98E9DC43ED342&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.of.the.Moon.2022.1080p.WEB-DL.Rus.Eng.%5Bsub.Eng%5D-BLUEBIRD.mkv","bestSource":"DataSourceType.torrentz2","title":"Shark.Side.of.the.Moon.2022.1080p.WEB-DL.Rus.Eng.[sub.Eng]-BLUEBIRD.mkv","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:C77D13A428848327D15B2E253AB98E9DC43ED342&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.of.the.Moon.2022.1080p.WEB-DL.Rus.Eng.%5Bsub.Eng%5D-BLUEBIRD.mkv"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:CC7430153406339BDC3794DF239342BAE271E47F&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Shark.side.of.the.moon.2022.P.WEB-DL.1O8Op.mkv","bestSource":"DataSourceType.torrentz2","title":"Shark.side.of.the.moon.2022.P.WEB-DL.1O8Op.mkv","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:CC7430153406339BDC3794DF239342BAE271E47F&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+Shark.side.of.the.moon.2022.P.WEB-DL.1O8Op.mkv"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:D07B6D6AFCDDFB0EA4F1F078379A66BDFEE31D40&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Shark+Side+Of+The+Moon+(2022)+%5B720p%5D+%5BWEBRip%5D+%5BYTS.MX%5D","bestSource":"DataSourceType.torrentz2","title":"Shark Side Of The Moon (2022) [720p] [WEBRip] [YTS.MX]","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:D07B6D6AFCDDFB0EA4F1F078379A66BDFEE31D40&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Shark+Side+Of+The+Moon+(2022)+%5B720p%5D+%5BWEBRip%5D+%5BYTS.MX%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:E47E1BD08726FBE7ED9320E7FF9E5A0996E5DE61&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.1080p.WEB.h264-PFa%5Brarbg%5D","bestSource":"DataSourceType.torrentz2","title":"Shark.Side.Of.The.Moon.2022.1080p.WEB.h264-PFa[rarbg]","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:E47E1BD08726FBE7ED9320E7FF9E5A0996E5DE61&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.1080p.WEB.h264-PFa%5Brarbg%5D"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:E5FE8F107FAB492EBB1CF2A727BC15043D8725D2&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+www.Torrenting.com+++-++++Shark.Side.Of.The.Moon.2022.720p.WEB.h264-PFa","bestSource":"DataSourceType.torrentz2","title":"www.Torrenting.com - Shark.Side.Of.The.Moon.2022.720p.WEB.h264-PFa","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:E5FE8F107FAB492EBB1CF2A727BC15043D8725D2&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ffe.dealclub.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&dn=%5BBitsearch.to%5D+www.Torrenting.com+++-++++Shark.Side.Of.The.Moon.2022.720p.WEB.h264-PFa"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:F11B0CD6DF10B4F91E818F30151B2AE4325F4AD8&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Shark+Side+of+the+Moon+2022+720p+WEB-DL+x264+ESubs+-+MkvHub.Com.mkv","bestSource":"DataSourceType.torrentz2","title":"Shark Side of the Moon 2022 720p WEB-DL x264 ESubs - MkvHub.Com.mkv","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:F11B0CD6DF10B4F91E818F30151B2AE4325F4AD8&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&dn=%5BBitsearch.to%5D+Shark+Side+of+the+Moon+2022+720p+WEB-DL+x264+ESubs+-+MkvHub.Com.mkv"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:F2D8573CCB906496A617C516A994A6694658AC96&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5BDevil-Torrents.PL%5D.Rekiny+na+Ksi%C4%99%C5%BCycu-Shark+Side+of+the+Moon.2022","bestSource":"DataSourceType.torrentz2","title":"[Devil-Torrents.PL].Rekiny na Księżycu-Shark Side of the Moon.2022","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:F2D8573CCB906496A617C516A994A6694658AC96&tr=udp%3A%2F%2Ftracker2.dler.com%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+%5BDevil-Torrents.PL%5D.Rekiny+na+Ksi%C4%99%C5%BCycu-Shark+Side+of+the+Moon.2022"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:F3F95DB7197575A46CBEB56F3B2421E6018355B8&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.720p.WEBRip.800MB.x264-GalaxyRG%5BTGx%5D","bestSource":"DataSourceType.torrentz2","title":"Shark.Side.Of.The.Moon.2022.720p.WEBRip.800MB.x264-GalaxyRG[TGx]","type":"MovieContentType.download","sources":{"DataSourceType.torrentz2":"magnet:?xt=urn:btih:F3F95DB7197575A46CBEB56F3B2421E6018355B8&tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&dn=%5BBitsearch.to%5D+Shark.Side.Of.The.Moon.2022.720p.WEBRip.800MB.x264-GalaxyRG%5BTGx%5D"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryTorrentz2Search test', () {
    // Search for a rare movie.
    test(
      'Run a search on Torrentz2 that is likely to have static results',
      () async {
      final criteria = SearchCriteriaDTO().fromString('shark.side.of.the.moon');
      final actualOutput =
          await QueryTorrentz2Search(criteria).readList(limit: 10);
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
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
      },
      skip: true,
    );
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryTorrentz2Search(criteria).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(
          expectedOutput,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
  }, skip: true);
}
