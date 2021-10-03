import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

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
const inner_element_identity = 'id';
const inner_element_title = 'l';
const inner_element_image = 'i';
const inner_element_year = 'y';
const inner_element_type = 'q';
const inner_element_year_range = 'yr';

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
    movie.source = DataSourceType.imdbSuggestions;
    movie.uniqueId = map[inner_element_identity]?.toString() ?? movie.uniqueId;
    movie.title = map[inner_element_title]?.toString() ?? movie.title;
    movie.imageUrl = _getImage(map[inner_element_image]) ?? movie.imageUrl;
    movie.year = map[inner_element_year] as int? ?? movie.year;
    movie.yearRange =
        map[inner_element_year_range]?.toString() ?? movie.yearRange;
    movie.type = getImdbMovieContentType(
          map[inner_element_type],
          movie.runTime.inMinutes,
          movie.uniqueId,
        ) ??
        movie.type;
    return movie;
  }

  static String? _getImage(imageData) {
    if (imageData is List<String>) return imageData.first;
  }
}
