import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

//query string https://api.themoviedb.org/3/movie/{movieID}?api_key={api_key}
//json format
//adult = indicator of adult content (true/false)
//genres =list containing  map of id:## name:XXX
//id = tmdbid
//imdb_id = unique key
//title = common title/name
//original_title = official title/name
//original_title = previous title assigned to the movie
//overview = synopsis of the movie plot
//popularity = raking to indcate how popular the movie is e.g. "280.151",
//poster_path = image url fragment
//release_date = date the movie was released e.g. "2019-06-28",
//runtime = number of minutes the movie plays for
//original_language = language spoken during the movie e.g. en
//spoken_languages = optional collection of languages present in the movie
//video = indicator of low quality movie (true/false)
//vote_average = User rating
//vote_count =  Count of users that have rated

const outer_element_failure_indicator = 'success';
const outer_element_failure_reason = 'status_message';
const inner_element_identity = 'id';
const inner_element_imdb_id = 'imdb_id';
const inner_element_image = 'logo_path';
const inner_element_year = 'release_date';
const inner_element_type = 'video';
const inner_element_adult = 'adult';
const inner_element_genres = 'genres';
const inner_element_common_title = 'title';
const inner_element_original_title = 'original_title';
const inner_element_overview = 'overview';
const inner_element_poster_path = 'poster_path';
const inner_element_release_date = 'release_date';
const inner_element_runtime = 'runtime';
const inner_element_original_language = 'original_language';
const inner_element_spoken_languages = 'spoken_languages';
const inner_element_vote_count = 'vote_count';
const inner_element_vote_average = 'vote_average';

class TmdbMovieDetailConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    List<MovieResultDTO> searchResults = [];

    var failureIndicator = map[outer_element_failure_indicator];
    if (null == failureIndicator) {
      searchResults.add(dtoFromMap(map));
    } else {
      final error = MovieResultDTO();
      error.title = map[outer_element_failure_reason]?.toString() ??
          'No failure reason provided in results ${map.toString()}';
      searchResults.add(error);
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.tmdb;
    movie.uniqueId = '${map[inner_element_identity]}';
    movie.alternateId =
        map[inner_element_imdb_id]?.toString() ?? movie.alternateId;
    if (null != map[inner_element_common_title] &&
        null != map[inner_element_original_title]) {
      movie.title = '${map[inner_element_original_title]} '
          '(${map[inner_element_common_title]}';
    } else {
      movie.imageUrl = map[inner_element_image]?.toString() ??
          map[inner_element_common_title]?.toString() ??
          movie.imageUrl;
    }

    var year =
        DateTime.tryParse(map[inner_element_year]?.toString() ?? '')?.year;
    if (null != year) {
      movie.year = year;
    } else {
      movie.yearRange = map[inner_element_year]?.toString() ?? movie.yearRange;
    }

    movie.imageUrl =
        map[inner_element_poster_path]?.toString() ?? movie.imageUrl;
    if ('true' == map[inner_element_type]) {
      movie.type = MovieContentType.short;
    }
    if ('true' == map[inner_element_adult]) {
      movie.censorRating = CensorRatingType.adult;
    }
    movie.description =
        map[inner_element_overview]?.toString() ?? movie.description;

    movie.userRating = DoubleHelper.fromText(
      map[inner_element_vote_average],
      nullValueSubstitute: movie.userRating,
    )!;
    movie.userRatingCount = IntHelper.fromText(
      map[inner_element_vote_count],
      nullValueSubstitute: movie.userRatingCount,
    )!;

    int? mins = IntHelper.fromText(map[inner_element_runtime]);
    movie.runTime = _getDuration(mins) ?? movie.runTime;

    movie.languages.combineUnique(map[inner_element_original_language]);
    movie.languages.combineUnique(map[inner_element_spoken_languages]);
    for (Map genre in map[inner_element_genres]) {
      movie.genres.combineUnique(genre['name'] as String);
    }
    /*TODO
    const inner_element_poster_path = 'poster_path';
    movie.uniqueId = map[inner_element_poster_path] ?? movie.uniqueId;*/

    return movie;
  }

  static Duration? _getDuration(int? mins) {
    if (null == mins) {
      return null;
    }
    try {
      return Duration(minutes: mins);
    } catch (e) {
      return null;
    }
  }
}
