import 'package:my_movie_search/data_model/movie_result_dto.dart';

//query string https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=wonder+woman
//json format
//name = title/name
//id = unique key
//logo_path = image url

const outer_element_results_collection = 'results';
const outer_element_search_success = 'total_results';
const outer_element_failure_reason = 'status_message';
const inner_element_identity_element = 'id';
const inner_element_title_element = 'name';
const inner_element_image_element = 'logo_path';

class TmdbMovieSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    List<MovieResultDTO> searchResults = [];

    final int resultsMatched = map[outer_element_search_success];
    print(resultsMatched);
    if (resultsMatched > 0) {
      map[outer_element_results_collection]
          .forEach((movie) => searchResults.add(dtoFromMap(movie)));
    } else {
      final error = MovieResultDTO();
      error.title = map[outer_element_failure_reason];
      searchResults.add(error);
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.uniqueId = map[inner_element_identity_element].toString();
    movie.title = map[inner_element_title_element];
    movie.imageUrl = map[inner_element_image_element];

    return movie;
  }
}
