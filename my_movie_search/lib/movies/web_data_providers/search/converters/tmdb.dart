// ignore_for_file: avoid_classes_with_only_static_members
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_common.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

//query string https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=wonder+woman
//json format
//name = title/name
//id = unique key
//poster_path = image url fragment

//logo_path = image url
//query string https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=wonder+woman
//json format
//title = title/name
//id = unique key
//release_date = date the movie was released e.g. "2019-06-28",
//vote_average = User rating
//vote_count =  Count of users taht have rated
//backdrop_path = alternate image url fragment
//video = indicator of low quality movie (true/false)
//adult = indicator of adult content (true/false)
//genre_ids = list of numeric ids that need to be correlated
//            with another web service call e.g. [28, 12, 878]
//original_language = language spoken during the movie e.g. en
//original_title = previous title assigned to the movie
//overview = synopsis of the movie plot
//popularity = raking to indicate how popular the movie is e.g. "280.151",

const outerElementResultsCollection = 'results';
const outerElementSearchSuccess = 'total_results';
const outerElementFailureReason = 'status_message';
const innerElementIdentity = 'id';
const innerElementTitle = 'title';
const innerElementImage = 'poster_path';
const innerElementYear = 'release_date';
const innerElementType = 'video';

class TmdbMovieSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    final resultsMatched = map[outerElementSearchSuccess];
    if (resultsMatched == 0) {
      return [];
    } else if (IntHelper.fromText(resultsMatched, nullValueSubstitute: 0)! >
        0) {
      for (final movie in map[outerElementResultsCollection] as Iterable) {
        searchResults.add(dtoFromMap(movie as Map));
      }
    } else {
      final error = map[outerElementFailureReason]?.toString() ??
          "No failure reason provided in results $map";
      searchResults.add(
        MovieResultDTO().error(
          '[TmdbMovieSearchConverter] $error',
          DataSourceType.omdb,
        ),
      );
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map<dynamic, dynamic> map) {
    final movie = MovieResultDTO().init(
      bestSource: DataSourceType.tmdbSearch,
      uniqueId: '${map[innerElementIdentity]}',
      title: map[innerElementTitle]?.toString(),
    );

    final poster = map[innerElementImage];
    if (null != poster) {
      movie.imageUrl = '$tmdbPosterPathPrefix$poster';
    }

    final year = getYear(map[innerElementYear]?.toString());
    if (null != year) {
      movie.year = year;
    } else {
      movie.yearRange = map[innerElementYear]?.toString() ?? movie.yearRange;
    }
    movie.getContentType();

    return movie;
  }
}
