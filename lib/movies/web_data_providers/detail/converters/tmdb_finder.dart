// Helper class to convert TMDB search data to MovieResultDTO objects.
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

//query string https://api.themoviedb.org/3/find/{imdbID}?language=en-US&external_source=imdb_id&?api_key={api_key}

//movie_results
//  title = title/name
//  id = unique key
//  release_date = date the movie was released e.g. "2019-06-28",
//  vote_average = User rating
//  vote_count =  Count of users that have rated
//  poster_path = image url fragment
//  backdrop_path = alternate image url fragment
//  video = indicator of low quality movie (true/false)
//  adult = indicator of adult content (true/false)
//  genre_ids = list of numeric ids that need to be correlated
//              with another web service call e.g. [28, 12, 878]
//  original_language = language spoken during the movie (iso_639_1) e.g. "en"
//  original_title = previous title assigned to the movie
//  overview = synopsis of the movie plot
//  popularity = raking to indcate how popular the movie is e.g. "280.151",
//person_results
//  name = name of the person
//  id = unique key
//  profile_path = image url fragment
//  known for = movie the person is famous for in movie_results format
//  adult = indicator of adult content (true/false)
//  popularity = raking to indcate how popular the person is e.g. "280.151",

const outerElementFailureIndicator = 'success';
const outerElementFailureReason = 'status_message';
const outerElementMovies = 'movie_results';
const outerElementPeople = 'person_results';
const movieElementTMDBIdentity = 'id';
const movieElementImage = 'backdrop_path';
const movieElementYear = 'release_date';
const movieElementType = 'video';
const movieElementAdult = 'adult';
const movieElementGenres = 'genre_ids';
const movieElementCommonTitle = 'title';
const movieElementOriginalTitle = 'original_title';
const movieElementOverview = 'overview';
const movieElementPosterPath = 'poster_path';
const movieElementReleaseDate = 'release_date';
const movieElementOriginalLanguage = 'original_language';
const movieElementVoteCount = 'vote_count';
const movieElementVoteAverage = 'vote_average';
const personElementTMDBIdentity = 'id';
const personElementCommonTitle = 'name';
const personElementPosterPath = 'profile_path';
const personElementPopularity = 'popularity';

class TmdbFinderConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
    String imdbId,
  ) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    final failureIndicator = map[outerElementFailureIndicator];
    if (null == failureIndicator) {
      for (final movie in map[outerElementMovies] as Iterable) {
        searchResults.add(dtoFromMovieMap(movie as Map, imdbId));
      }
      for (final person in map[outerElementPeople] as Iterable) {
        searchResults.add(dtoFromPersonMap(person as Map, imdbId));
      }
    } else {
      final error = map[outerElementFailureReason]?.toString() ??
          'No failure reason provided in results $map';
      searchResults.add(
        MovieResultDTO().error(
          '[TmdbFinderConverter] $error',
          DataSourceType.omdb,
        ),
      );
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMovieMap(
    Map<dynamic, dynamic> map,
    String imdbId,
  ) {
    final movie = MovieResultDTO()
      ..setSource(
        newSource: DataSourceType.tmdbFinder,
        newUniqueId: map[movieElementTMDBIdentity]?.toString(),
      )
      // Set the dto uniqueId to the IMDBID and the source ID to the TMDBID
      // no longer need to have alternateId field
      ..uniqueId = imdbId;

    final title = map[movieElementCommonTitle]?.toString();
    final originalTitle = map[movieElementOriginalTitle]?.toString();
    movie.title = title ?? originalTitle ?? '';
    if (title != originalTitle) {
      movie.alternateTitle = originalTitle ?? '';
    }

    final year =
        DateTime.tryParse(map[movieElementYear]?.toString() ?? '')?.year;
    if (null != year) {
      movie.year = year;
    } else {
      movie.yearRange = map[movieElementYear]?.toString() ?? movie.yearRange;
    }

    // TODO expand partial URL to full url
    // e.g. movie.imageUrl =
    //      map[movieElementPosterPath]?.toString() ?? movie.imageUrl;
    if ('true' == map[movieElementType]) {
      movie.type = MovieContentType.short;
    }
    if ('true' == map[movieElementAdult]) {
      movie.censorRating = CensorRatingType.adult;
    }
    movie
      ..description = map[movieElementOverview]?.toString() ?? movie.description
      ..userRating = DoubleHelper.fromText(
        map[movieElementVoteAverage],
        nullValueSubstitute: movie.userRating,
      )!
      ..userRatingCount = IntHelper.fromText(
        map[movieElementVoteCount],
        nullValueSubstitute: movie.userRatingCount,
      )!
      ..languages.combineUnique(map[movieElementOriginalLanguage])
      ..getLanguageType()
      ..getContentType();

    return movie;
  }

  static MovieResultDTO dtoFromPersonMap(
    Map<dynamic, dynamic> map,
    String imdbId,
  ) =>
      MovieResultDTO()
        ..init(
          bestSource: DataSourceType.tmdbFinder,
          uniqueId: map[movieElementTMDBIdentity]?.toString(),
          title: map[personElementCommonTitle]?.toString(),
          userRatingCount: map[personElementPopularity]?.toString(),
          type: MovieContentType.person.toString(),
        )
        // Set the dto uniqueId to the IMDBID and the source ID to the TMDBID
        // no longer need to have alternateId field!
        ..uniqueId = imdbId;
  // TODO expand partial URL to full url
  // e.g. person.imageUrl =
  //      map[personElementPosterPath]?.toString() ?? person.imageUrl;
}
