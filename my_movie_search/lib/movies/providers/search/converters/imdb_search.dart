import 'package:my_movie_search/movies/models/movie_result_dto.dart';

const outer_element_results_collection = 'd';
const inner_element_identity_element = 'id';
const inner_element_title_element = 'l';
const inner_element_year_element = 'y';
const inner_element_year_range_element = 'yr';

class ImdbSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    final resultCollection = map[outer_element_results_collection];

    List<MovieResultDTO> allSearchs = [];
    for (Map innerJson in resultCollection) {
      allSearchs.add(dtoFromMap(innerJson));
    }
    return allSearchs;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[inner_element_identity_element] ?? movie.uniqueId;
    movie.title = map[inner_element_title_element] ?? movie.title;
    movie.year = map[inner_element_year_element] ?? movie.year;
    movie.yearRange = map[inner_element_year_range_element] ?? movie.yearRange;
    return movie;
  }
}
