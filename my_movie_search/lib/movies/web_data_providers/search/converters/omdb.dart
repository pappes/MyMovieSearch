import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

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
          .forEach((movie) => searchResults.add(dtoFromMap(movie as Map)));
    } else {
      final error = MovieResultDTO();
      error.title = map[outer_element_failure_reason]?.toString() ??
          "No failure reason provided in results ${map.toString()}";
      searchResults.add(error);
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.omdb;
    movie.uniqueId =
        map[inner_element_identity_element]?.toString() ?? movie.uniqueId;
    movie.title = map[inner_element_title_element]?.toString() ?? movie.title;

    var year = getYear(map[inner_element_year_element]?.toString());
    if (null != year) {
      movie.year = year;
    } else {
      movie.yearRange =
          map[inner_element_year_element]?.toString() ?? movie.yearRange;
      movie.year = movie.maxYear();
    }

    movie.imageUrl =
        map[inner_element_image_element]?.toString() ?? movie.imageUrl;
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
