import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

const outer_element_identity_element = 'id';
const outer_element_official_title = 'name';
const outer_element_alternate_title = 'alternateTitle';

const outer_element_related = 'related';
const outer_element_link = 'url';

class ImdbCastConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [_dtoFromMap(map)];
  }

  static MovieResultDTO _dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId =
        map[outer_element_identity_element]?.toString() ?? movie.uniqueId;

    if (map.length > 0) {
      for (var category in map.entries) {
        _getMovies(
          movie,
          category.key.toString(),
          category.value,
        );
      }
    }

    return movie;
  }

  static _getMovies(MovieResultDTO movie, String label, dynamic movies) {
    if (null != movies && movies is List) {
      for (var relatedMap in movies) {
        if (relatedMap is Map) {
          MovieResultDTO? dto = dtoFromRelatedMap(relatedMap);
          if (null != dto) {
            movie.addRelated(label, dto);
          }
        }
      }
    }
  }

  static MovieResultDTO? dtoFromRelatedMap(Map map) {
    var id = getIdFromIMDBLink(map[outer_element_link]?.toString());
    if (id == '') {
      return null;
    }
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdbSuggestions;
    movie.uniqueId = id;
    movie.title = map[outer_element_official_title]?.toString() ?? movie.title;
    movie.alternateTitle =
        map[outer_element_alternate_title]?.toString() ?? movie.alternateTitle;

    return movie;
  }
}
