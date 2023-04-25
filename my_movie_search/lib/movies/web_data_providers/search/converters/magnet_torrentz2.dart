// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrentz2.dart';

class Torrentz2SearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    return MovieResultDTO().init(
      bestSource: DataSourceType.torrentz2,
      type: MovieContentType.download.toString(),
      uniqueId: map[jsonMagnetKey]?.toString(),
      title: map[jsonNameKey]?.toString(),
      charactorName: map[jsonCategoryKey]?.toString(),
      description: map[jsonDescriptionKey]?.toString(),
      imageUrl: map[jsonMagnetKey]?.toString(),
      creditsOrder: map[jsonSeedersKey]?.toString(),
      userRatingCount: map[jsonLeechersKey]?.toString(),
    );
  }
}