// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

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
    if (resultCollection is Iterable<Map>) {
      for (final Map innerJson in resultCollection) {
        allSuggestions.add(dtoFromMap(innerJson));
      }
    }
    return allSuggestions;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final uniqueId = map[innerElementIdentity]?.toString();
    final movieType = MovieResultDTOHelpers.getMovieContentType(
      map[innerElementType],
      null, // Unknown duration.
      uniqueId ?? '',
    )?.toString();

    final movie = MovieResultDTO().init(
        bestSource: DataSourceType.imdbSuggestions,
        uniqueId: map[innerElementIdentity]?.toString(),
        title: map[innerElementTitle]?.toString(),
        imageUrl: _getImage(map[innerElementImage]),
        year: map[innerElementYear]?.toString(),
        yearRange: map[innerElementYearRange]?.toString(),
        type: movieType);
    return movie;
  }

  static String? _getImage(imageData) {
    if (imageData is List) return imageData.first as String;
    if (imageData is String) return imageData;
    return null;
  }
}
