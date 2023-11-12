// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

//query string http://www.omdbapi.com/?apikey=<key>&s=wonder+woman
//json format
//Title = title/name
//imdbID = unique key
//Year = year
//Type = title type
//Poster = image url

// TODO: scrape additional omdb fields & use api for detail (free account is limited to 100/day)
//Rated = "N/A",
//Released = "01 Jun 2002",
//Runtime = "127 min",
//Genre = "Comedy",
//Plot = "Three men, each with their own special needs, all fall in love with the same woman.",
//Language = "Telugu",
//Poster = "https://m.media-amazon.com/images/M/MV5BMTcxNTI2OTctODAyYS00OGI3LTljZGEtOWFjODQyMjBkODNkXkEyXkFqcGdeQXVyODE1NTg0MjE@._V1_SX300.jpg",
//imdbRating = "5.7",
//imdbVotes = "76",

const outerElementResultsCollection = 'Search';
const outerElementSearchSuccess = 'Response';
const outerElementFailureReason = 'Error';
const innerElementIdentity = 'imdbID';
const innerElementTitle = 'Title';
const innerElementYear = 'Year';
const innerElementType = 'Type';
const innerElementImage = 'Poster';
const omdbResultTypeMovie = "movie";
const omdbResultTypeSeries = "series";
const omdbResultTypeEpisode = "episode";

class OmdbMovieSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    final resultsMatched = map[outerElementSearchSuccess] ?? "";
    if (resultsMatched == "True") {
      for (final movie in map[outerElementResultsCollection] as Iterable) {
        searchResults.add(dtoFromMap(movie as Map));
      }
    } else {
      final error = map[outerElementFailureReason]?.toString() ??
          "No failure reason provided in results $map";
      searchResults.add(
        MovieResultDTO().error(
          '[OmdbMovieSearchConverter] $error',
          DataSourceType.omdb,
        ),
      );
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map<dynamic, dynamic> map) {
    final movie = MovieResultDTO().init(
      bestSource: DataSourceType.omdb,
      uniqueId: map[innerElementIdentity]?.toString(),
      title: map[innerElementTitle]?.toString(),
      imageUrl: map[innerElementImage]?.toString(),
    );

    switch (map[innerElementType]) {
      case omdbResultTypeMovie:
        movie.type = MovieContentType.movie;
      case omdbResultTypeSeries:
        movie.type = MovieContentType.series;
      case omdbResultTypeEpisode:
        movie.type = MovieContentType.episode;
      default:
        movie.type = MovieContentType.none;
    }

    final year = getYear(map[innerElementYear]?.toString());
    movie.year = year ?? movie.year;
    final yearRange = map[innerElementYear]?.toString();
    if (null != yearRange && yearRange.length > 4) {
      movie.yearRange = yearRange;
      movie.year = movie.maxYear();
      movie.type = MovieContentType.series;
    }

    return movie;
  }
}
