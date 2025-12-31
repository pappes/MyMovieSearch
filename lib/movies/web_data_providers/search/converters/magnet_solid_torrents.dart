// Helper to convert SolidTorrents search results.
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_solid_torrents.dart';

class SolidTorrentsSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) => [
    MovieResultDTO().init(
      bestSource: DataSourceType.solidTorrents,
      type: MovieContentType.download.toString(),
      uniqueId: map[jsonMagnetKey]?.toString(),
      title: map[jsonNameKey]?.toString(),
      characterName: map[jsonCategoryKey]?.toString(),
      description: map[jsonDescriptionKey]?.toString(),
      imageUrl: map[jsonMagnetKey]?.toString(),
      creditsOrder: map[jsonSeedersKey]?.toString(),
      userRatingCount: map[jsonLeechersKey]?.toString(),
    ),
  ];
}
