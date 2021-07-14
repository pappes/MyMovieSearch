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
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[outer_element_identity_element] ?? movie.uniqueId;

    if (map.length > 0) {
      for (var category in map.entries) {
        getMovies(
          movie,
          category.key,
          category.value,
        );
      }
    }

    return movie;
  }

  static getMovies(MovieResultDTO movie, String label, dynamic movies) {
    if (null != movies && movies is List) {
      for (var relatedMap in movies) {
        MovieResultDTO? dto = dtoFromRelatedMap(relatedMap);
        if (null != dto) {
          movie.addRelated(label, dto);
        }
      }
    }
  }

  static MovieResultDTO? dtoFromRelatedMap(Map map) {
    var id = getIdFromIMDBLink(map[outer_element_link]);
    if (id == '') {
      return null;
    }
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdbSuggestions;
    movie.uniqueId = id;
    movie.title = map[outer_element_official_title] ?? movie.title;
    movie.alternateTitle =
        map[outer_element_alternate_title] ?? movie.alternateTitle;

    return movie;
  }
}
