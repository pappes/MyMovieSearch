import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

const outer_element_identity_element = 'id';

const outer_element_type = '@type';
const outer_element_official_title = 'name';
const outer_element_image = 'image';
const outer_element_description = 'description';
const outer_element_born = 'birthDate';

const outer_element_died = 'deathDate';
const outer_element_common_title = 'alternateName';
const outer_element_related = 'related';
const outer_element_link = 'url';

class ImdbNamePageConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[outer_element_identity_element] ?? movie.uniqueId;
    movie.title = map[outer_element_official_title] ?? movie.title;
    movie.alternateTitle =
        map[outer_element_common_title] ?? movie.alternateTitle;
    movie.description = map[outer_element_description] ?? movie.title;
    movie.imageUrl = map[outer_element_image] ?? movie.imageUrl;

    movie.year = getYear(map[outer_element_born]) ?? movie.year;
    String deathDate = getYear(map[outer_element_died])?.toString() ?? '';
    movie.yearRange = movie.year.toString() + '-' + deathDate;
    movie.type = getImdbMovieContentType(
          map[outer_element_type],
          movie.runTime.inMinutes,
          movie.uniqueId,
        ) ??
        movie.type;

    if (map.containsKey(outer_element_related) &&
        map[outer_element_related].length > 0) {
      for (var category in map[outer_element_related]) {
        getMovies(
          movie,
          category.values.first,
          category.keys.first,
        );
      }
    }

    return movie;
  }

  static getMovies(MovieResultDTO movie, dynamic movies, String label) {
    if (null != movies) {
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

    return movie;
  }
}
