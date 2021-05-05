import 'package:my_movie_search/movies/models/movie_result_dto.dart';

const inner_element_identity_element = 'id';
const inner_element_rating_value = 'ratingvalue';
const inner_element_rating_count = 'ratingcount';

class ImdbSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[inner_element_identity_element] ?? movie.uniqueId;
    movie.userRating = map[inner_element_rating_value] ?? movie.userRating;
    movie.userRatingCount = getRatingCount(map) ?? movie.userRatingCount;
    return movie;
  }

  static int? getRatingCount(Map map) {
    var text = map[inner_element_rating_count]?.replaceAll(',', '');
    var count = int.parse(text ?? '0');
    return count == 0 ? null : count;
  }
}
