// Raw data in code is generated from an external source.
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

Future<Stream<String>> streamhtmlOfflineData(_) =>
    Future.value(Stream.value(jsonTextSimple));

final jsonTextSimple = jsonEncode(jsonSampleSimple);
final jsonTextNotFound = jsonEncode(jsonSampleNotFound);

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
  },
];

const jsonSampleNotFound = {
  'status': 'ok',
  'status_message': 'Query was successful',
  'data': {
    'movie': {
      'id': 0,
      'url': 'https://yts.bz/movies/',
      'imdb_code': 'tt',
      'title': null,
      'title_english': null,
      'title_long': ' ()',
      'slug': null,
      'year': 0,
      'rating': 0,
      'runtime': 0,
      'genres': ['Action', 'Adventure', '...', 'Western'],
      'like_count': 0,
      'description_intro': null,
      'description_full': null,
      'yt_trailer_code': null,
      'language': null,
      'mpa_rating': null,
    },
  },
  '@meta': {'api_version': 2, 'execution_time': '0 ms'},
};

const jsonSampleSimple = {
  'status': 'ok',
  'status_message': 'Query was successful',
  'data': {
    'movie': {
      'id': 24,
      'url': 'https://yts.bz/movies/2001-a-space-odyssey-1968',
      'imdb_code': 'tt0062622',
      'title': '2001: A Space Odyssey',
      'title_english': '2001: A Space Odyssey',
      'title_long': '2001: A Space Odyssey (1968)',
      'slug': '2001-a-space-odyssey-1968',
      'year': 1968,
      'rating': 8.3,
      'runtime': 149,
      'genres': ['Action', 'Adventure', 'Mystery', 'Sci-Fi'],
      'like_count': 336,
      'description_intro':
          'When a mysterious artifact is uncovered on the Moon, a spacecraft manned by two humans and one supercomputer is sent to Jupiter to find its origins.',
      'description_full':
          'When a mysterious artifact is uncovered on the Moon, a spacecraft manned by two humans and one supercomputer is sent to Jupiter to find its origins.',
      'yt_trailer_code': 'kR2r-A9H3Kg',
      'language': 'en',
      'mpa_rating': '',
      'background_image':
          'https://yts.bz/assets/images/movies/2001_A_Space_Odyssey_1968/background.jpg',
      'background_image_original':
          'https://yts.bz/assets/images/movies/2001_A_Space_Odyssey_1968/background.jpg',
      'small_cover_image':
          'https://yts.bz/assets/images/movies/2001_A_Space_Odyssey_1968/small-cover.jpg',
      'medium_cover_image':
          'https://yts.bz/assets/images/movies/2001_A_Space_Odyssey_1968/medium-cover.jpg',
      'large_cover_image':
          'https://yts.bz/assets/images/movies/2001_A_Space_Odyssey_1968/large-cover.jpg',
      'torrents': [
        {
          'url':
              'https://yts.bz/torrent/download/E3529DBC0CE47429A8A9B411AB381C893BFEF575',
          'hash': 'E3529DBC0CE47429A8A9B411AB381C893BFEF575',
          'quality': '720p',
          'type': 'bluray',
          'is_repack': '0',
          'video_codec': 'x264',
          'bit_depth': '8',
          'audio_channels': '2.0',
          'seeds': 48,
          'peers': 12,
          'size': '853.57 MB',
          'size_bytes': 895033016,
          'date_uploaded': '2015-10-31 20:49:09',
          'date_uploaded_unix': 1446320949,
        },
        {
          'url':
              'https://yts.bz/torrent/download/A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7',
          'hash': 'A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7',
          'quality': '1080p',
          'type': 'bluray',
          'is_repack': '0',
          'video_codec': 'x264',
          'bit_depth': '8',
          'audio_channels': '2.0',
          'seeds': 100,
          'peers': 75,
          'size': '2.38 GB',
          'size_bytes': 2555505541,
          'date_uploaded': '2018-05-06 21:03:07',
          'date_uploaded_unix': 1525633387,
        },
        {
          'url':
              'https://yts.bz/torrent/download/35EB8826EA87E7D655949F8A715CD36FEB0730F3',
          'hash': '35EB8826EA87E7D655949F8A715CD36FEB0730F3',
          'quality': '2160p',
          'type': 'bluray',
          'is_repack': '0',
          'video_codec': 'x265',
          'bit_depth': '10',
          'audio_channels': '5.1',
          'seeds': 100,
          'peers': 45,
          'size': '7.02 GB',
          'size_bytes': 7537667604,
          'date_uploaded': '2020-11-26 17:35:24',
          'date_uploaded_unix': 1606408524,
        },
      ],
      'date_uploaded': '2015-10-31 20:49:09',
      'date_uploaded_unix': 1446320949,
    },
  },
  '@meta': {'api_version': 2, 'execution_time': '0 ms'},
};
