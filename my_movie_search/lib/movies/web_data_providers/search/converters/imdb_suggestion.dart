// ignore_for_file: avoid_classes_with_only_static_members

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
//i = image with dimensions

const outerElementResultsCollection = 'd';
const innerElementIdentity = 'id';
const innerElementTitle = 'l';
const innerElementImage = 'i';
const innerElementYear = 'y';
const innerElementType = 'q';
const innerElementYearRange = 'yr';

class ImdbSuggestionConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    final resultCollection = map[outerElementResultsCollection];

    final allSuggestions = <MovieResultDTO>[];
    for (final Map innerJson in resultCollection) {
      allSuggestions.add(dtoFromMap(innerJson));
    }
    return allSuggestions;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdbSuggestions;
    movie.uniqueId = map[innerElementIdentity]?.toString() ?? movie.uniqueId;
    movie.title = map[innerElementTitle]?.toString() ?? movie.title;
    movie.imageUrl = _getImage(map[innerElementImage]) ?? movie.imageUrl;
    movie.year = map[innerElementYear] as int? ?? movie.year;
    movie.yearRange = map[innerElementYearRange]?.toString() ?? movie.yearRange;
    movie.type = getImdbMovieContentType(
          map[innerElementType],
          movie.runTime.inMinutes,
          movie.uniqueId,
        ) ??
        movie.type;

    print('URL for ${movie.uniqueId} is ${movie.imageUrl}');
    return movie;
  }

  static String? _getImage(imageData) {
    if (imageData is List) return imageData.first as String;
    return null;
  }
}
