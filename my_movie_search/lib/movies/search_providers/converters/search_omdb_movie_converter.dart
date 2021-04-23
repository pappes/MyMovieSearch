import 'package:my_movie_search/movies/data_model/movie_result_dto.dart';

//query string http://www.omdbapi.com/?apikey=<key>&s=wonder+woman
//json format
//Title = title/name
//imdbID = unique key
//Year = year
//Type = title type
//Poster = image url)

const outer_element_results_collection = 'Search';
const outer_element_search_success = 'Response';
const outer_element_failure_reason = 'Error';
const inner_element_identity_element = 'imdbID';
const inner_element_title_element = 'Title';
const inner_element_year_element = 'Year';
const inner_element_type_element = 'Type';
const inner_element_image_element = 'Poster';
const OMDB_RESULT_TYPE_MOVIE = "movie";
const OMDB_RESULT_TYPE_SERIES = "series";
const OMDB_RESULT_TYPE_EPISODE = "episode";

class OmdbMovieSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    List<MovieResultDTO> searchResults = [];

    final resultsMatched = map[outer_element_search_success] ?? "";
    if (resultsMatched == "True") {
      map[outer_element_results_collection]
          .forEach((movie) => searchResults.add(dtoFromMap(movie)));
    } else {
      final error = MovieResultDTO();
      error.title = map[outer_element_failure_reason] ??
          "No failure reason provided in results ${map.toString()}";
      searchResults.add(error);
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.omdb;
    movie.uniqueId = map[inner_element_identity_element] ?? movie.uniqueId;
    movie.title = map[inner_element_title_element] ?? movie.title;
    try {
      movie.year = int.parse(map[inner_element_year_element] ?? "");
    } catch (e) {
      movie.yearRange = map[inner_element_year_element] ?? movie.yearRange;
      movie.year = movie.maxYear();
    }
    movie.imageUrl = map[inner_element_image_element] ?? movie.imageUrl;
    switch (map[inner_element_type_element]) {
      case OMDB_RESULT_TYPE_MOVIE:
        movie.type = MovieContentType.movie;
        break;
      case OMDB_RESULT_TYPE_SERIES:
        movie.type = MovieContentType.series;
        break;
      case OMDB_RESULT_TYPE_EPISODE:
        movie.type = MovieContentType.episode;
        break;
      default:
        movie.type = MovieContentType.none;
        break;
    }

    return movie;
  }
}
