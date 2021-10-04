// ignore_for_file: avoid_classes_with_only_static_members

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

const outerElementFailureIndicator = 'success';
const outerElementFailureReason = 'status_message';
const innerElementIdentity = 'id';
const innerElementImdbId = 'imdb_id';
const innerElementImage = 'logo_path';
const innerElementYear = 'release_date';
const innerElementType = 'video';
const innerElementAdult = 'adult';
const innerElementGenres = 'genres';
const innerElementCommonTitle = 'title';
const innerElementOriginalTitle = 'original_title';
const innerElementOverview = 'overview';
const innerElementPosterPath = 'poster_path';
const innerElementReleaseDate = 'release_date';
const innerElementRuntime = 'runtime';
const innerElementOriginalLanguage = 'original_language';
const innerElementSpokenLanguages = 'spoken_languages';
const innerElementVoteCount = 'vote_count';
const innerElementVoteAverage = 'vote_average';

class TmdbMovieDetailConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    final failureIndicator = map[outerElementFailureIndicator];
    if (null == failureIndicator) {
      searchResults.add(dtoFromMap(map));
    } else {
      final error = MovieResultDTO();
      error.title = map[outerElementFailureReason]?.toString() ??
          'No failure reason provided in results ${map.toString()}';
      searchResults.add(error);
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.tmdb;
    movie.uniqueId = '${map[innerElementIdentity]}';
    movie.alternateId =
        map[innerElementImdbId]?.toString() ?? movie.alternateId;
    if (null != map[innerElementCommonTitle] &&
        null != map[innerElementOriginalTitle]) {
      movie.title = '${map[innerElementOriginalTitle]} '
          '(${map[innerElementCommonTitle]}';
    } else {
      movie.imageUrl = map[innerElementImage]?.toString() ??
          map[innerElementCommonTitle]?.toString() ??
          movie.imageUrl;
    }

    final year =
        DateTime.tryParse(map[innerElementYear]?.toString() ?? '')?.year;
    if (null != year) {
      movie.year = year;
    } else {
      movie.yearRange = map[innerElementYear]?.toString() ?? movie.yearRange;
    }

    movie.imageUrl = map[innerElementPosterPath]?.toString() ?? movie.imageUrl;
    if ('true' == map[innerElementType]) {
      movie.type = MovieContentType.short;
    }
    if ('true' == map[innerElementAdult]) {
      movie.censorRating = CensorRatingType.adult;
    }
    movie.description =
        map[innerElementOverview]?.toString() ?? movie.description;

    movie.userRating = DoubleHelper.fromText(
      map[innerElementVoteAverage],
      nullValueSubstitute: movie.userRating,
    )!;
    movie.userRatingCount = IntHelper.fromText(
      map[innerElementVoteCount],
      nullValueSubstitute: movie.userRatingCount,
    )!;

    final mins = IntHelper.fromText(map[innerElementRuntime]);
    movie.runTime = _getDuration(mins) ?? movie.runTime;

    movie.languages.combineUnique(map[innerElementOriginalLanguage]);
    movie.languages.combineUnique(map[innerElementSpokenLanguages]);
    for (final Map genre in map[innerElementGenres]) {
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
