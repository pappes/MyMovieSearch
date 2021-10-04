// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

const innerElementIdentity = 'AnchorAddress';
const innerElementTitle = 'Title';
const innerElementImage = 'Image';
const innerElementInfo = 'Info';

class ImdbSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdbSearch;
    movie.uniqueId = getID(map[innerElementIdentity]) ?? movie.uniqueId;
    movie.title = map[innerElementInfo]?.toString() ?? movie.title;
    movie.imageUrl = map[innerElementImage]?.toString() ?? movie.imageUrl;
    movie.yearRange = getYearRange(map[innerElementInfo]) ?? movie.yearRange;
    movie.year = movie.maxYear();
    movie.type = getImdbMovieContentType(
          map[innerElementInfo],
          movie.runTime.inMinutes,
          movie.uniqueId,
        ) ??
        movie.type;
    return movie;
  }

  // Determine unique ID from '/title/tt13722802/?ref_=fn_tt_tt_6'
  static String? getID(Object? identifier) {
    if (identifier == null) return null;
    final id = identifier.toString();
    final lastSlash = id.lastIndexOf('/');
    if (lastSlash == -1) return null;
    final secondLastSlash = id.lastIndexOf('/', lastSlash - 1);
    if (secondLastSlash == -1) return null;
    return id.substring(secondLastSlash + 1, lastSlash);
  }

  // Extract year range from 'title 123 (1988–1993) (TV Series) aka title 123'
  static String? getYearRange(Object? info) {
    if (info == null) return null;
    final String title = info.toString();
    final lastClose = title.lastIndexOf(')');
    if (lastClose == -1) return null;
    final dates = title.lastIndexOf(RegExp('[0-9]'), lastClose);
    if (dates == -1) return null;
    final yearOpen = title.lastIndexOf('(', dates);
    final yearClose = title.indexOf(')', dates);
    if (yearOpen == -1 || yearClose == -1) return null;

    final yearRange = title.substring(yearOpen + 1, yearClose);
    final filter = RegExp('[0-9].*[0-9]');
    final numerics = filter.stringMatch(yearRange);
    return numerics;
  }
}
