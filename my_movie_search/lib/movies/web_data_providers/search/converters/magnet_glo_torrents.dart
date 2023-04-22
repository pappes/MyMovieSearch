// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_glo_torrents.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

class GloTorrentsSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    // Compensate for gloTorrents overrestimation
    final seeders = DoubleHelper.fromText(map[jsonSeedersKey]) ?? 0 / 10;
    final leechers = DoubleHelper.fromText(map[jsonLeechersKey]) ?? 0 / 10;
    return MovieResultDTO().init(
      bestSource: DataSourceType.gloTorrents,
      type: MovieContentType.download.toString(),
      uniqueId: map[jsonMagnetKey]?.toString(),
      title: map[jsonNameKey]?.toString(),
      charactorName: map[jsonCategoryKey]?.toString(),
      description: map[jsonDescriptionKey]?.toString(),
      imageUrl: map[jsonMagnetKey]?.toString(),
      creditsOrder: seeders.toString(),
      userRatingCount: leechers.toString(),
    );
  }
}
