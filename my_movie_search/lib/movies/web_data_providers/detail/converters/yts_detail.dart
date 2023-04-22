// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

class YtsDetailConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    final dtos = <MovieResultDTO>[];
    for (final entry in map.keys) {
      final dto = MovieResultDTO().init(
        bestSource: DataSourceType.ytsDetails,
        uniqueId: entry.toString(),
        title: entry.toString(),
      );
      dto.type = MovieContentType.download;
      dtos.add(dto);
    }
    return dtos;
  }
}
