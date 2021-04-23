import 'package:my_movie_search/movies/data_model/movie_result_dto.dart';

//query string https://sg.media-imdb.com/suggests/w/wonder%20woman.json
//json format
//1 = title/name
//id = unique  key (tt=tile/nm=name/vi=video)
//s = supplimentary info (biography, actors or trailer duration
//y = year
//yr = year range for series
//q = title type
//i = image with dimentions)

const outer_element_results_collection = 'd';
const inner_element_identity_element = 'id';
const inner_element_title_element = 'l';
const inner_element_year_element = 'y';
const inner_element_year_range_element = 'yr';

class ImdbSuggestionConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    final resultCollection = map[outer_element_results_collection];

    List<MovieResultDTO> allSuggestions = [];
    for (Map innerJson in resultCollection) {
      allSuggestions.add(dtoFromMap(innerJson));
    }
    return allSuggestions;
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
