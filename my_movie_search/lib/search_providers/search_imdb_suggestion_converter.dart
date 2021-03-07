import 'package:my_movie_search/data_model/movie_result_dto.dart';

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

class MovieSuggestionConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    var resultCollection = map[outer_element_results_collection];

    List<MovieResultDTO> allSuggestions = [];
    var suggestion = MovieResultDTO();
    for (Map innerJson in resultCollection) {
      suggestion = dtoFromMap(innerJson);
      allSuggestions.add(suggestion);
    }
    return allSuggestions;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    var x = MovieResultDTO();
    x.uniqueId = map[inner_element_identity_element];
    x.title = map[inner_element_title_element];
    x.year = map[inner_element_year_element];
    x.yearRange = map[inner_element_year_range_element];
    return x;
  }
}
