// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

// query string https://yts.mx/ajax/search?query=tt6644286
// json format
// status = 'ok' or 'false'
// data = message envelope
// data/url = details page http address
// data/img = small image url
// data/title = movie title
// data/year = year of release
// message = 'a message' or 'No results found.'

const outerElementResultsCollection = 'data';
const innerElementUrl = 'url';
const innerElementTitle = 'title';
const innerElementImage = 'img';
const innerElementYear = 'year';
const innerElementType = 'q';
const innerElementYearRange = 'yr';

class YtsSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) {
    // deserialise outer json from map then iterate inner json
    final resultCollection = map[outerElementResultsCollection];

    final allSuggestions = <MovieResultDTO>[];
    if (resultCollection is Iterable) {
      for (final innerJson in resultCollection) {
        if (innerJson is Map) {
          allSuggestions.add(dtoFromMap(innerJson));
        }
      }
    }
    return allSuggestions;
  }

  static MovieResultDTO dtoFromMap(Map<dynamic, dynamic> map) {
    final detailsPage = MovieResultDTO().init(
      bestSource: DataSourceType.ytsSearch,
      uniqueId: map[innerElementUrl]?.toString(),
      title: map[innerElementTitle]?.toString(),
      year: map[innerElementYear]?.toString(),
      type: MovieContentType.information.toString(),
    );
    return detailsPage;
  }
}
