import 'package:my_movie_search/data_model/movie_result_dto.dart';

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
    List<MovieResultDTO> allResults = [];

    final success = map[outer_element_search_success];
    if (success == "True") {
      final resultCollection = map[outer_element_results_collection];
      resultCollection.forEach((movie) => allResults.add(dtoFromMap(movie)));
    } else {
      final error = MovieResultDTO();
      error.title = map[outer_element_failure_reason];
      allResults.add(error);
    }
    return allResults;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.uniqueId = map[inner_element_identity_element];
    movie.title = map[inner_element_title_element];
    try {
      movie.year = int.parse(map[inner_element_year_element]);
    } catch (e) {
      movie.yearRange = map[inner_element_year_element];
    }
    movie.imageUrl = map[inner_element_image_element];
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
