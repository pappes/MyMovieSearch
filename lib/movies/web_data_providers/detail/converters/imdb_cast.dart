// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

class ImdbCastConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) =>
      [_dtoFromMap(map)];

  static MovieResultDTO _dtoFromMap(Map<dynamic, dynamic> map) {
    final movie = MovieResultDTO().init(
      bestSource: DataSourceType.imdbSuggestions,
      uniqueId: map[outerElementIdentity]?.toString(),
    );

    for (final category in map.entries) {
      _getMovies(
        movie,
        category.key.toString(),
        category.value,
      );
    }

    return movie;
  }

  static void _getMovies(MovieResultDTO movie, String label, dynamic movies) {
    var creditsOrder = 100;
    if (null != movies && movies is List) {
      for (final relatedMap in movies) {
        if (relatedMap is Map) {
          final dto = dtoFromRelatedMap(relatedMap);
          if (null != dto) {
            if (0 < creditsOrder) {
              dto.creditsOrder = creditsOrder--;
            }
            movie.addRelated(label, dto);
          }
        }
      }
    }
  }

  static MovieResultDTO? dtoFromRelatedMap(Map<dynamic, dynamic> map) {
    final id = getIdFromIMDBLink(map[outerElementLink]?.toString());
    if (id == '') {
      return null;
    }
    final movie = MovieResultDTO().init(
      bestSource: DataSourceType.imdbSuggestions,
      uniqueId: id,
      title: map[outerElementOfficialTitle]?.toString(),
      alternateTitle: map[outerElementAlternateTitle]?.toString(),
      charactorName: map[outerElementCharactorName]?.toString(),
    );

    return movie;
  }
}
