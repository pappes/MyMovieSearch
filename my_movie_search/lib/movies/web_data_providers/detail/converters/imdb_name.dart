// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

const outerElementIdentity = 'id';

const outerElementType = '@type';
const outerElementOfficialTitle = 'name';
const outerElementImage = 'image';
const outerElementDescription = 'description';
const outerElementBorn = 'birthDate';
const outerElementDied = 'deathDate';
const outerElementCommonTitle = 'alternateName';
const outerElementRelated = 'related';
const outerElementLink = 'url';

class ImdbNamePageConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [_dtoFromMap(map)];
  }

  static MovieResultDTO _dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[outerElementIdentity]?.toString() ?? movie.uniqueId;
    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;
    movie.alternateTitle =
        map[outerElementCommonTitle]?.toString() ?? movie.alternateTitle;
    movie.description = map[outerElementDescription]?.toString() ?? movie.title;
    movie.imageUrl = map[outerElementImage]?.toString() ?? movie.imageUrl;

    movie.year = getYear(map[outerElementBorn]?.toString()) ?? movie.year;
    final deathDate =
        getYear(map[outerElementDied]?.toString())?.toString() ?? '';
    movie.yearRange = '${movie.year}-$deathDate';
    movie.type = MovieContentType.person;

    for (final category in map[outerElementRelated]) {
      if (category is Map) {
        _getMovies(
          movie,
          category.values.first,
          category.keys.first.toString(),
        );
      }
    }
    return movie;
  }

  static void _getMovies(MovieResultDTO movie, dynamic movies, String label) {
    if (null != movies && movies is List) {
      for (final relatedMap in movies) {
        if (relatedMap is Map) {
          final dto = dtoFromRelatedMap(relatedMap);
          if (null != dto) {
            movie.addRelated(label, dto);
          }
        }
      }
    }
  }

  static MovieResultDTO? dtoFromRelatedMap(Map map) {
    final id = getIdFromIMDBLink(map[outerElementLink]?.toString());
    if (id == '') {
      return null;
    }
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdbSuggestions;
    movie.uniqueId = id;
    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;

    return movie;
  }
}
