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
const outer_element_censor_rating = 'contentRating';
const outer_element_rating = 'aggregateRating';
const inner_element_rating_value = 'ratingValue';
const inner_element_rating_count = 'ratingCount';
const outer_element_language = 'language';
const outer_element_languages = 'languages';
const outer_element_related = 'related';

class ImdbNamePageConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[outer_element_identity_element] ?? movie.uniqueId;
    movie.title = map[outer_element_official_title] ?? movie.title;
    if (null != map[outer_element_common_title])
      movie.title += ' (${map[outer_element_common_title]})';
    movie.description = map[outer_element_description] ?? movie.title;
    movie.description += '\nGenres: ${map[outer_element_genre]}';
    movie.description += '\nKeywords: ${map[outer_element_keywords]}';
    movie.description += '\nLanguages: ${map[outer_element_languages]}';
    movie.imageUrl = map[outer_element_image] ?? movie.imageUrl;
    movie.language = map[outer_element_language] ?? movie.language;
    movie.censorRating = getImdbCensorRating(
          map[outer_element_censor_rating],
        ) ??
        movie.censorRating;

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
        ) ??
        movie.type;

    /*for (var relatedMap in map[outer_element_related]) {
      MovieResultDTO dto = dtoFromMap(relatedMap);
      movie.addRelated('Suggestions', dto);
    }*/

    return movie;
  }
}
