// Raw data in code is generated from an external source.
// ignore_for_file: unnecessary_raw_strings

import 'dart:convert';

Future<Stream<String>> streamHtmlOfflineData(_) =>
    Future.value(Stream.value(jsonSample));

const jsonSampleEmpty =
    '{"imdb_id":"93443470","torrents_count":0,"limit":100,"page":1}';
const jsonSampleTooMany =
    '{"imdb_id":"93443470","torrents_count":1027471,"limit":100,"page":1}';
const jsonSampleInvalid =
    'NOT VALID JSON';

final jsonSample = jsonEncode(intermediateMapList);

const htmlSampleError = '''
{
  "torrents_count": 1027471,
  "limit": 100,
  "page": 1,
  "torrents": [
    {
      "id": 3071560,
      "hash": "331dcfb21899583a6f7890bcfdc21c7f068190ac",
      "filename": "Neighbors.2026.S01E06.XviD-AFG[EZTVx.to].avi",
      "magnet_url": "magnet:?xt=urn:btih:331dcfb21899583a6f7890bcfdc21c7f068190ac&dn=Neighbors.2026.S01E06.XviD-AFG%5Beztvx.to%5D&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://tracker.dler.org:6969/announce&tr=https://tracker.moeblog.cn:443/announce&tr=https://tracker.zhuqiy.com:443/announce&tr=udp://open.dstud.io:6969/announce",
      "title": "Neighbors 2026 S01E06 XviD-AFG EZTV",
      "imdb_id": "39398809",
      "season": "1",
      "episode": "6",
      "small_screenshot": "",
      "large_screenshot": "",
      "seeds": 3,
      "peers": 3,
      "date_released_unix": 1774056973,
      "size_bytes": "589195680"
    }
  ]
}
''';

const intermediateMapList = 
  {
    'imdb_id': '13443470',
    'torrents_count': 80,
    'limit': 100,
    'page': 1,
    'torrents': [
      {
        'id': 2770161,
        'hash': '482EAC3D9670A10ECC2BDA2FB7A920F1B65958CA',
        'filename': '',
        'magnet_url':
            'magnet:?xt=urn:btih:482EAC3D9670A10ECC2BDA2FB7A920F1B65958CA&dn=Wednesday.S02.1080p.x265-ELiTE&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.darkness.services:6969/announce&tr=https://tracker.bjut.jp:443/announce&tr=http://tracker.bt4g.com:2095/announce&tr=udp://open.demonii.com:1337/announce&tr=udp://open.tracker.cl:1337/announce&tr=udp://tracker.dler.org:6969/announce&tr=udp://p4p.arenabg.com:1337/announce',
        'title': 'Wednesday S02 1080p x265-ELiTE EZTV',
        'imdb_id': '13443470',
        'season': '2',
        'episode': '0',
        'small_screenshot': '',
        'large_screenshot': '',
        'seeds': 54,
        'peers': 8,
        'date_released_unix': 1757016035,
        'size_bytes': '7086696038',
      },
      {
        'id': 2770160,
        'hash': 'F327685EE0AC43C993A19902067F31E2AF86F784',
        'filename': '',
        'magnet_url':
            'magnet:?xt=urn:btih:F327685EE0AC43C993A19902067F31E2AF86F784&dn=Wednesday.S02.720p.x264-FENiX&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://explodie.org:6969/announce&tr=udp://tracker.darkness.services:6969/announce&tr=https://tracker.bjut.jp:443/announce&tr=http://tracker.bt4g.com:2095/announce&tr=udp://open.demonii.com:1337/announce&tr=udp://open.tracker.cl:1337/announce&tr=udp://tracker.dler.org:6969/announce&tr=udp://p4p.arenabg.com:1337/announce',
        'title': 'Wednesday S02 720p x264-FENiX EZTV',
        'imdb_id': '13443470',
        'season': '2',
        'episode': '0',
        'small_screenshot': '',
        'large_screenshot': '',
        'seeds': 20,
        'peers': 4,
        'date_released_unix': 1757016020,
        'size_bytes': '5476083302',
      },
      {
        'id': 2745084,
        'hash': '1fcbe8fef901b7214c311967a1317470f338cfc2',
        'filename':
            'Wednesday S02E03 Call of the Woe 720p NF WEB-DL DDP5 1 Atmos H 264-FLUX[EZTVx.to].mkv',
        'magnet_url':
            'magnet:?xt=urn:btih:1fcbe8fef901b7214c311967a1317470f338cfc2&dn=Wednesday+S02E03+Call+of+the+Woe+720p+NF+WEB-DL+DDP5+1+Atmos+H+264-FLUX%5Beztvx.to%5D&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://tracker.dler.org:6969/announce&tr=https://tracker.moeblog.cn:443/announce&tr=https://tracker.zhuqiy.com:443/announce&tr=udp://open.dstud.io:6969/announce',
        'title':
            'Wednesday S02E03 Call of the Woe 720p NF WEB-DL DDP5 1 Atmos H 264-FLUX EZTV',
        'imdb_id': '13443470',
        'season': '2',
        'episode': '3',
        'small_screenshot': '',
        'large_screenshot': '',
        'seeds': 13,
        'peers': 0,
        'date_released_unix': 1754858538,
        'size_bytes': '1001395257',
      },
    ],
  }
;
