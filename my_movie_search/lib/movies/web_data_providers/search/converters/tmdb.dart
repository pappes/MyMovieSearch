import 'package:my_movie_search/movies/models/movie_result_dto.dart';

//query string https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=wonder+woman
//json format
//name = title/name
//id = unique key
//logo_path = image url

//query string https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=wonder+woman
//json format
//title = title/name
//id = unique key
//release_date = date the moive was released e.g. "2019-06-28",
//vote_average = User rating
//vote_count =  Count of users taht have rated
//poster_path = image url fragment
//backdrop_path = alternate image url fragment
//video = indicator of low quality movie (true/false)
//adult = indicator of adult content (true/false)
//genre_ids = list of numeric ids that need to be correlated with aonthed  web service call e.g. [28, 12, 878]
//original_language = language spoken during the movie e.g. en
//original_title = previous title assigned tot he movie
//overview = synopsis of the movie plot
//popularity = raking to indcate how popular the movie is e.g. "280.151",

const outer_element_results_collection = 'results';
const outer_element_search_success = 'total_results';
const outer_element_failure_reason = 'status_message';
const inner_element_identity_element = 'id';
const inner_element_title_element = 'title';
const inner_element_image_element = 'logo_path';
const inner_element_year_element = 'release_date';
const inner_element_type_element = 'video';

class TmdbMovieSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    List<MovieResultDTO> searchResults = [];

    final int resultsMatched = map[outer_element_search_success] ?? 0;
    if (resultsMatched > 0) {
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
    movie.source = DataSourceType.tmdb;
    movie.uniqueId =
        map[inner_element_identity_element]?.toString() ?? movie.uniqueId;
    movie.title = map[inner_element_title_element] ?? movie.title;
    movie.imageUrl = map[inner_element_image_element] ?? movie.imageUrl;
    try {
      movie.year = DateTime.parse(map[inner_element_year_element] ?? "").year;
    } catch (e) {
      movie.yearRange = map[inner_element_year_element] ?? movie.yearRange;
    }
    return movie;
  }
}
