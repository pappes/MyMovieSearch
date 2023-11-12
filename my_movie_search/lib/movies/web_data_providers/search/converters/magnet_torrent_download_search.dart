// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrent_download_search.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';

class TorrentDownloadSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) =>
      [dtoFromMap(map)];

  static MovieResultDTO dtoFromMap(Map<dynamic, dynamic> map) {
    // TorrentDownloadSearch always overestimates the number of seeders
    // Need to artifically reduce TDS in the results
    final reducedSeeders = DynamicHelper.toInt_(map[jsonSeedersKey]) / 100;
    return MovieResultDTO().init(
      bestSource: DataSourceType.torrentDownloadSearch,
      type: MovieContentType.download.toString(),
      uniqueId: map[jsonDetailLink]?.toString(),
      title: map[jsonNameKey]?.toString(),
      charactorName: map[jsonCategoryKey]?.toString(),
      description: 'placeholder: ${map[jsonDescriptionKey]}',
      creditsOrder: reducedSeeders.toString(),
      userRatingCount: map[jsonLeechersKey]?.toString(),
    );
  }
}
