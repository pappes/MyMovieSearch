import 'package:html_unescape/html_unescape_small.dart';
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
  static final htmlDecode = HtmlUnescape();

  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [_dtoFromMap(map)];
  }

  static MovieResultDTO _dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId =
        map[outer_element_identity_element]?.toString() ?? movie.uniqueId;
    movie.title = map[outer_element_official_title]?.toString() ?? movie.title;
    movie.alternateTitle =
        map[outer_element_common_title]?.toString() ?? movie.alternateTitle;
    movie.description =
        map[outer_element_description]?.toString() ?? movie.title;
    movie.imageUrl = map[outer_element_image]?.toString() ?? movie.imageUrl;

    movie.year = getYear(map[outer_element_born]?.toString()) ?? movie.year;
    String deathDate =
        getYear(map[outer_element_died]?.toString())?.toString() ?? '';
    movie.yearRange = movie.year.toString() + '-' + deathDate;
    movie.type = getImdbMovieContentType(
          map[outer_element_type],
          movie.runTime.inMinutes,
          movie.uniqueId,
        ) ??
        movie.type;

    final categories = map[outer_element_related];
    if (categories is List && categories.length > 0) {
      for (var category in categories) {
        if (category is Map) {
          _getMovies(
            movie,
            category.values.first,
            category.keys.first.toString(),
          );
        }
      }
    }

    movie.title = htmlDecode.convert(movie.title);
    movie.alternateTitle = htmlDecode.convert(movie.alternateTitle);
    movie.description = htmlDecode.convert(movie.description);
    return movie;
  }

  static _getMovies(MovieResultDTO movie, dynamic movies, String label) {
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

    return movie;
  }
}
