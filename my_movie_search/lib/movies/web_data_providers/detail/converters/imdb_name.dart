import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

const outer_element_identity_element = 'id';

const outer_element_type = '@type';
const outer_element_official_title = 'name';
const outer_element_image = 'image';
const outer_element_description = 'description';
const outer_element_year = 'birthDate';

const outer_element_yearrange = 'duration';
const outer_element_common_title = 'alternateName';
const outer_element_keywords = 'keywords';
const outer_element_genre = 'genre';
const odeuter_element_censor_rating = 'contentRating';
const outer_element_rating = 'aggregateRating';
const inner_element_rating_value = 'ratingValue';
const inner_element_rating_count = 'ratingCount';
const outer_element_language = 'language';
const outer_element_languages = 'languages';
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
    movie.language = map[outer_element_language] ?? movie.language;

    movie.userRating = DoubleHelper.fromText(
      map[outer_element_rating]?[inner_element_rating_value],
      nullValueSubstitute: movie.userRating,
    )!;
    movie.userRatingCount = IntHelper.fromText(
      map[outer_element_rating]?[inner_element_rating_count],
      nullValueSubstitute: movie.userRatingCount,
    )!;

    movie.yearRange = map[outer_element_yearrange] ?? movie.yearRange;
    try {
      movie.year = DateTime.parse(map[outer_element_year] ?? '').year;
    } catch (e) {
      movie.yearRange = map[outer_element_year] ?? movie.yearRange;
    }
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
