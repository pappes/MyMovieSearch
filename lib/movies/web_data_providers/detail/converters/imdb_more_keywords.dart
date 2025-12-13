// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';

class ImdbMoreKeywordsConverter extends ImdbConverterBase {
  @override
  Iterable<MovieResultDTO> dtoFromMap(Map<dynamic, dynamic> map
  ) {
    final dtos = <MovieResultDTO>[];
    for (final entry in map.keys) {
      dtos.add(
        MovieResultDTO().init(
          bestSource: DataSourceType.imdbKeywords,
          uniqueId: entry.toString(),
          title: entry.toString(),
          type: MovieContentType.keyword.toString(),
        ),
      );
    }
    return dtos;
  }
}
