import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

const outer_element_identity_element = 'id';

const outer_element_official_title = 'name';
const outer_element_common_title = 'alternateName';
const outer_element_description = 'description';
const outer_element_keywords = 'keywords';
const outer_element_genre = 'genre';
const outer_element_year = 'datePublished';
const outer_element_duration = 'duration';
const outer_element_censor_rating = 'contentRating';
const outer_element_rating = 'aggregateRating';
const inner_element_rating_value = 'ratingValue';
const inner_element_rating_count = 'ratingCount';
const outer_element_type = '@type';
const outer_element_image = 'image';
const outer_element_language = 'language';
const outer_element_languages = 'languages';
const outer_element_related = 'related';
const outer_element_actors = 'actor';
const outer_element_director = 'director';
const outer_element_link = 'url';

const related_movies_label = 'Suggestions';
const related_actors_label = 'Actors';
const related_directors_label = 'Directors';

class ImdbMoviePageConverter {
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

    try {
      movie.year = DateTime.parse(map[outer_element_year] ?? '').year;
    } catch (e) {
      movie.yearRange = map[outer_element_year] ?? movie.yearRange;
    }
    try {
      movie.runTime = Duration().fromIso8601(map[outer_element_duration]);
    } catch (e) {
      movie.runTime = Duration(hours: 0, minutes: 0, seconds: 0);
    }
    movie.type = getImdbMovieContentType(
          map[outer_element_type],
          movie.runTime.inMinutes,
        ) ??
        movie.type;

    getRelated(movie, map[outer_element_related]);
    getPeople(movie, map[outer_element_actors], related_actors_label);
    getPeople(movie, map[outer_element_director], related_directors_label);

    return movie;
  }

  static getRelated(MovieResultDTO movie, dynamic suggestions) {
    if (null != suggestions) {
      for (var relatedMap in suggestions) {
        MovieResultDTO dto = dtoFromMap(relatedMap);
        movie.addRelated(related_movies_label, dto);
      }
    }
  }

  static getPeople(MovieResultDTO movie, dynamic people, String label) {
    if (null != people) {
      for (var relatedMap in people) {
        MovieResultDTO? dto = dtoFromPersonMap(relatedMap);
        if (null != dto) {
          movie.addRelated(label, dto);
        }
      }
    }
  }

  static MovieResultDTO? dtoFromPersonMap(Map map) {
    var id = getIdFromNameLink(map[outer_element_link]);
    if (map[outer_element_type] != 'Person' || id == '') {
      return null;
    }
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdbSuggestions;
    movie.uniqueId = id;
    movie.title = map[outer_element_official_title] ?? movie.title;

    return movie;
  }
}
