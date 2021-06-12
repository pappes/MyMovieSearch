import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

const outer_element_identity_element = 'id';

const outer_element_title_element = 'name';
const outer_element_description = 'description';
const outer_element_keywords = 'keywords';
const outer_element_genre = 'genre';
const outer_element_year_element = 'datePublished';
const outer_element_duration = 'duration';
const outer_element_censor_rating = 'contentRating';
const outer_element_rating = 'aggregateRating';
const inner_element_rating_value = 'ratingValue';
const inner_element_rating_count = 'ratingCount';
const outer_element_type_element = '@type';
const outer_element_image_element = 'image';

class ImdbMoviePageConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[outer_element_identity_element] ?? movie.uniqueId;
    movie.title = map[outer_element_title_element] ?? movie.title;
    movie.description = map[outer_element_description] ?? movie.title;
    movie.description += '\ngenre: ${map[outer_element_genre]}';
    movie.description += '\nkeywords: ${map[outer_element_keywords]}';
    movie.imageUrl = map[outer_element_image_element] ?? movie.imageUrl;
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

    try {
      movie.year = DateTime.parse(map[outer_element_year_element] ?? "").year;
    } catch (e) {
      movie.yearRange = map[outer_element_year_element] ?? movie.yearRange;
    }
    try {
      movie.runTime = Duration().fromIso8601(map[outer_element_duration]);
    } catch (e) {
      movie.runTime = Duration(hours: 0, minutes: 0, seconds: 0);
    }
    movie.type = getImdbMovieContentType(
          map[outer_element_type_element],
          movie.runTime.inMinutes,
        ) ??
        movie.type;

    return movie;
  }
}
