// Helper to convert YTS API torrent search results.
// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_helper.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

//query string https://movies-api.accel.li/api/v2/movie_details.json?imdb_id=0062622
// status = ok
// status_message = Query was successful
// data = movie object {"movie":{id:, URL:, }}
// movie.id = numeric yts id
// movie.url = yts url
// movie.imdb_code = full imdbid with the tt prefix as a string
// movie.title = display name
// movie.title_english = translated display name
// movie.slug = dashed_name-year
// movie.year = numeric year
// movie.rating = numeric rating
// movie.runtime = numeric runtime in minutes
// movie.genres = list of genres
// movie.like_count = numeric like count
// movie.description_full = description
// movie.language = iso language e,g, en
// movie.mpa_rating = censor rating
// movie.medium_cover_image = movie poster
// movie.torrents = torrents object { [ {url:, hash:, quality:}, ]}
// torrents.url = magnet url fragment
// torrents.hash = hash
// torrents.quality = 720p 1080p, etc
// torrents.type = source E.G. blueray, web, etc
// torrents.audio_channels = 2.0 5.1, etc
// torrents.seeds = numeric seeds
// torrents.peers = numeric peers
// torrents.size = size of file as a string with units e.g. 2.38 GB
// torrents.size_bytes = size of file in bytes

// {
//   "status": "ok",
//   "status_message": "Query was successful",
//   "data": {
//     "movie": {
//       "id": 24,
//       "url": "https://yts.bz/movies/2001-a-space-odyssey-1968",
//       "imdb_code": "tt0062622",
//       "title": "2001: A Space Odyssey",
//       "title_english": "2001: A Space Odyssey",
//       "slug": "2001-a-space-odyssey-1968",
//       "year": 1968,
//       "rating": 8.3,
//       "runtime": 149,
//       "genres": [
//         "Action",
//         "Adventure",
//         "Mystery",
//         "Sci-Fi"
//       ],
//       "like_count": 336,
// ignore: lines_longer_than_80_chars
//       "description_full": "When a mysterious artifact is uncovered on the Moon, a spacecraft manned by two humans and one supercomputer is sent to Jupiter to find its origins.",
//       "language": "en",
//       "mpa_rating": "",
//       "medium_cover_image": "https://yts.bz/assets/images/movies/2001_A_Space_Odyssey_1968/medium-cover.jpg",
//       "torrents": [
//         {
//           "url": "https://yts.bz/torrent/download/A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7",
//           "hash": "A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7",
//           "quality": "1080p",
//           "type": "bluray",
//           "is_repack": "0",
//           "video_codec": "x264",
//           "bit_depth": "8",
//           "audio_channels": "2.0",
//           "seeds": 100,
//           "peers": 75,
//           "size": "2.38 GB",
//           "size_bytes": 2555505541,
//           "date_uploaded": "2018-05-06 21:03:07",
//           "date_uploaded_unix": 1525633387
//         }
//       ],
//       "date_uploaded": "2015-10-31 20:49:09",
//       "date_uploaded_unix": 1446320949
//     }
//   },
//   "@meta": {
//     "api_version": 2,
//     "execution_time": "0 ms"
//   }
// }

const magnetFragment1 = 'magnet:?xt=urn:btih:';
const magnetFragment2 = '&dn=';
const magnetFragment3 = '&tr=';
const statusSuccess = 'ok';
const sourceBluray = 'bluray';
const outerElementStatus = 'status';
const outerElementResults = 'data';
const outerElementMovie = 'movie';
const outerElementTorrents = 'torrents';

//movie elements
const elementId = 'id';
// const elementUrl = 'url';
// const elementImdbCode = 'imdb_code';
const elementTitle = 'title';
// const elementTitleEnglish = 'title_english';
// const elementSlug = 'slug';
const elementYear = 'year';
// const elementRating = 'rating';
// const elementRuntime = 'runtime';
// const elementGenres = 'genres';
// const elementLikeCount = 'like_count';
// const elementDescriptionFull = 'description_full';
// const elementLanguage = 'language';
// const elementMpaRating = 'mpa_rating';
// const elementMediumCoverImage = 'medium_cover_image';

//torrent elements
const elementHash = 'hash';
const elementUrlFragment = 'url';
const elementQuality = 'quality';
const elementSource = 'type';
const elementAudioChannels = 'audio_channels';
const elementSeeds = 'seeds';
const elementPeers = 'peers';
const elementSize = 'size';

class YtsDetailApiConverter {

  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    try {
      final status = map[outerElementStatus]?.toString();
      if (status == statusSuccess) {
        // Single movie result.
        // ignore: avoid_dynamic_calls
        final movieresults = map[outerElementResults][outerElementMovie] as Map;
        final movieid = movieresults[elementId] as int;
        if (movieid == 0) {
          // When nothing is matched, a dummy record is returned.
          return searchResults;
        }
        final title = movieresults[elementTitle] as String;
        final year = movieresults[elementYear] as int;
        final suffix = (year > 0) ? ' ($year)' : '';
        final description = '$title$suffix';
        final torrents = movieresults[outerElementTorrents] as Iterable;
        if (torrents.isNotEmpty) {
          searchResults.addAll(dtoFromList(torrents, description));
        }
      }
      return searchResults;
    } catch (e) {
      throw WebConvertException('Failed to convert YTS API JSON, cause: $e');
    }
  }

  static List<MovieResultDTO> dtoFromList(
    Iterable<dynamic> maps,
    String description,
  ) {
    final searchResults = <MovieResultDTO>[];
    for (final map in maps) {
      if (map is Map) {
        searchResults.add(dtoFromMap(map, description));
      }
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(
    Map<dynamic, dynamic> map,
    String description,
  ) {
    final keywords = <String>[];
    if (map[elementSource] == sourceBluray) {
      keywords.add(sourceBluray);
    }
    final title =
        '$description '
        '${map[elementQuality]} ${map[elementAudioChannels]} '
        '${map[elementSource]} (YTS)';

    final movie = MovieResultDTO().init(
      bestSource: DataSourceType.ytsDetailApi,
      type: MovieContentType.download.toString(),
      title: title,
      uniqueId: map[elementUrlFragment]?.toString(),
      creditsOrder: map[elementSeeds]?.toString(),
      userRatingCount: map[elementPeers]?.toString(),
      description: map[elementSize]?.toString(),
      imageUrl: getFullMagnetUrl(map[elementHash]!.toString(), title),
      keywords: jsonEncode(keywords),
    );

    return movie;
  }

  static String getFullMagnetUrl(String hash, String fragment) {
    //magnet:?xt=urn:btih:TORRENT_HASH&dn=Url+Encoded+Movie+Name&tr=https://tracker.one:1234/announce&tr=udp://tracker.two:80
    // stuff<TORRENT_HASH>stuff<Url+Encoded+Movie+Name>&tr=<trr1>&tr=<trr2>
    // e.g. https://yts.bz/torrent/download/A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7
    // ignore: lines_longer_than_80_chars
    // becomes magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.BZ%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=https%3A%2F%2Ftracker.moeblog.cn%3A443%2Fannounce&dk=s4-_709HihG3TI-TNJRe3v_R6XqbQXhW_JH7sl5QMLOMCA&tr=https%3A%2F%2Ftracker.zhuqiy.com%3A443%2Fannounce
    final urlEncoded = Uri.encodeComponent(fragment);
    final buffer = StringBuffer(magnetFragment1)
      ..writeAll([hash, magnetFragment2, urlEncoded]);

    // add trackers
    return MagnetHelper.addTrackers(buffer.toString());
  }
}
