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
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    final resultsMatched = map[outerElementSearchSuccess] ?? "";
    if (resultsMatched == "True") {
      map[outerElementResultsCollection]
          .forEach((movie) => searchResults.add(dtoFromMap(movie as Map)));
    } else {
      final error = MovieResultDTO();
      error.title = map[outerElementFailureReason]?.toString() ??
          "No failure reason provided in results ${map.toString()}";
      searchResults.add(error);
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.omdb;
    movie.uniqueId = map[innerElementIdentity]?.toString() ?? movie.uniqueId;
    movie.title = map[innerElementTitle]?.toString() ?? movie.title;

    final year = getYear(map[innerElementYear]?.toString());
    if (null != year) {
      movie.year = year;
    } else {
      movie.yearRange = map[innerElementYear]?.toString() ?? movie.yearRange;
      movie.year = movie.maxYear();
    }

    movie.imageUrl = map[innerElementImage]?.toString() ?? movie.imageUrl;
    switch (map[innerElementType]) {
      case omdbResultTypeMovie:
        movie.type = MovieContentType.movie;
        break;
      case omdbResultTypeSeries:
        movie.type = MovieContentType.series;
        break;
      case omdbResultTypeEpisode:
        movie.type = MovieContentType.episode;
        break;
      default:
        movie.type = MovieContentType.none;
        break;
    }

    return movie;
  }
}
