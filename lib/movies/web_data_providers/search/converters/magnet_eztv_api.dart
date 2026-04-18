// Helper to convert Eztv API search results.
// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_helper.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

//query string https://eztv.yt/api/get-torrents?imdb_id=13443470&limit=100
// magnet_url = magnet:...
// title = display name without size
// imdb_id = numeric imdbid without the tt prefix as a string
// season = season #
// episode = episode # , '0' = full season
// seeds = numeric seeds
// peers = numeric peers
// date_released_unix = numeric unix timestamp
// size_bytes = size of file in bytes

// 'magnet_url': 'magnet:?xt=urn:btih:1fcbe8fef901b7214c311967a1317470f338cfc2&dn=Wednesday+S02E03+Call+of+the+Woe+720p+NF+WEB-DL+DDP5+1+Atmos+H+264-FLUX%5Beztvx.to%5D&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://tracker.dler.org:6969/announce&tr=https://tracker.moeblog.cn:443/announce&tr=https://tracker.zhuqiy.com:443/announce&tr=udp://open.dstud.io:6969/announce',
// 'title': 'Wednesday S02E03 Call of the Woe 720p NF WEB-DL DDP5 FLUX EZTV',
// 'imdb_id': '13443470',
// 'season': '2',
// 'episode': '3', // FYI episode '0' = full season
// 'seeds': 13,
// 'peers': 0,
// 'date_released_unix': 1754858538,
// 'size_bytes': '1001395257'

// 'imdb_id': '13443470',
// 'torrents_count': 80,
// 'limit': 100,
// 'page': 1,
// 'torrents': []

const tooManyTorrents = 100000;
const outerElementTorrents = 'torrents';
const outerElementTorrentsCount = 'torrents_count';
const outerElementLimit = 'limit';
const outerElementPage = 'page';

const elementMagnetUrl = 'magnet_url';
const elementName = 'title';
const elementImdbId = 'imdb_id';
const elementSeason = 'season';
const elementEpisode = 'episode';
const elementSeeds = 'seeds';
const elementPeers = 'peers';
const elementDate = 'date_released_unix';
const elementSize = 'size_bytes';

class MagnetEztvApiSearchConverter {

  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    final resultsMatched =
        IntHelper.fromText(map[outerElementTorrentsCount]) ?? 0;
    if (resultsMatched == 0 || resultsMatched > tooManyTorrents) {
      // API returns everything if it matches nothing!
      return searchResults;
    }
    for (final movie in map[outerElementTorrents] as Iterable) {
      searchResults.add(dtoFromMap(movie as Map));
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map<dynamic, dynamic> map) {
    // format size to giabytes with 2 decimal places with GB suffix
    final sizeBytes = IntHelper.fromText(map[elementSize]) ?? 0;
    final sizeGB = sizeBytes / 1024 / 1024 / 1024;
    final size = '${sizeGB.toStringAsFixed(2)} GB';

    final keywords = <String>[];
    if (map[elementEpisode] == '0') {
      keywords.add('Season ${map[elementSeason]}');
    }

    final movie = MovieResultDTO().init(
      bestSource: DataSourceType.eztvApi,
      type: MovieContentType.download.toString(),
      uniqueId: map[elementMagnetUrl]?.toString(),
      title: map[elementName]?.toString(),
      imageUrl: MagnetHelper.addTrackers(map[elementMagnetUrl]?.toString()),
      creditsOrder: map[elementSeeds]?.toString(),
      userRatingCount: map[elementPeers]?.toString(),
      description: size,
      keywords: jsonEncode(keywords),
    );

    return movie;
  }
}
