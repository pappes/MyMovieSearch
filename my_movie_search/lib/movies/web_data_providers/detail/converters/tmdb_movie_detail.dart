// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_common.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

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
const innerElementTypeVideo = 'video';
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
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    final failureIndicator = map[outerElementFailureIndicator];
    if (null == failureIndicator) {
      searchResults.add(dtoFromMap(map));
    } else {
      final error = map[outerElementFailureReason]?.toString() ??
          'No failure reason provided in results $map';
      searchResults.add(
        MovieResultDTO().error(
          '[TmdbMovieDetailConverter] $error',
          DataSourceType.omdb,
        ),
      );
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map<dynamic, dynamic> map) {
    final movie = MovieResultDTO().setSource(
      newSource: DataSourceType.tmdbMovie,
      newUniqueId: '${map[innerElementIdentity]}',
    );
    // Set the dto uniqueId to the IMDBID and the source ID to the TMDBID
    // no longer need to have alternateId field
    movie.uniqueId = map[innerElementImdbId]?.toString() ?? movie.uniqueId;

    final title = map[innerElementCommonTitle]?.toString();
    final originalTitle = map[innerElementOriginalTitle]?.toString();
    movie.title = title ?? originalTitle ?? '';
    if (title != originalTitle) {
      movie.alternateTitle = originalTitle ?? '';
    }

    final year =
        DateTime.tryParse(map[innerElementYear]?.toString() ?? '')?.year;
    if (null != year) {
      movie.year = year;
    } else {
      movie.yearRange = map[innerElementYear]?.toString() ?? movie.yearRange;
    }
    final mins = IntHelper.fromText(map[innerElementRuntime]);
    movie
      ..runTime = _getDuration(mins) ?? movie.runTime
      ..description = map[innerElementOverview]?.toString() ?? movie.description
      ..userRating = DoubleHelper.fromText(
        map[innerElementVoteAverage],
        nullValueSubstitute: movie.userRating,
      )!
      ..userRatingCount = IntHelper.fromText(
        map[innerElementVoteCount],
        nullValueSubstitute: movie.userRatingCount,
      )!
      ..languages.combineUnique(
        map.deepSearch(
          'english_name',
          multipleMatch: true,
        ),
      )
      ..getContentType()
      ..getLanguageType();
    for (final genre in map[innerElementGenres] as Iterable) {
      if (genre is Map) {
        movie.genres.combineUnique(genre['name'] as String);
      }
    }

    final poster = map[innerElementPosterPath];
    if (null != poster) {
      movie.imageUrl = '$tmdbPosterPathPrefix$poster';
    }

    if ('true' == map[innerElementTypeVideo]) {
      movie.type = MovieContentType.short;
    }
    if ('true' == map[innerElementAdult]) {
      movie.censorRating = CensorRatingType.adult;
    }
    return movie;
  }

  static Duration? _getDuration(int? mins) {
    if (null == mins) {
      return null;
    }
    return Duration(minutes: mins);
  }
}
