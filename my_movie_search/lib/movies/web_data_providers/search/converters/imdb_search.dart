// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

class ImdbSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdbSearch;
    movie.uniqueId = map[outerElementIdentity]?.toString() ?? movie.uniqueId;
    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;
    movie.imageUrl = map[outerElementImage]?.toString() ?? movie.imageUrl;
    movie.yearRange = map[outerElementYear]?.toString() ?? movie.yearRange;
    movie.year = movie.maxYear();

    final movieType = map[outerElementType];
    if (movieType is MovieContentType) {
      movie.type = movieType;
    }

    return movie;
  }
}
