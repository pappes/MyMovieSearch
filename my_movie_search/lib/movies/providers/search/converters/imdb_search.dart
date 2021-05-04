import 'package:my_movie_search/movies/models/movie_result_dto.dart';

const inner_element_identity_element = 'AnchorAddress';
const inner_element_title_element = 'Title';
const inner_element_image_element = 'Image';
const inner_element_info_element = 'Info';

class ImdbSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId =
        getID(map[inner_element_identity_element]) ?? movie.uniqueId;
    movie.title = map[inner_element_info_element] ?? movie.title;
    movie.imageUrl = map[inner_element_image_element] ?? movie.imageUrl;
    movie.yearRange =
        getYearRange(map[inner_element_info_element]) ?? movie.yearRange;
    movie.year = movie.maxYear();
    movie.type = getType(map[inner_element_info_element]) ?? movie.type;
    return movie;
  }

  // Determine unique ID from '/title/tt13722802/?ref_=fn_tt_tt_6'
  static String? getID(Object? identifier) {
    if (identifier == null) return null;
    var id = identifier.toString();
    final lastSlash = id.lastIndexOf('/');
    if (lastSlash == -1) return null;
    final secondLastSlash = id.lastIndexOf('/', lastSlash - 1);
    if (secondLastSlash == -1) return null;
    return id.substring(secondLastSlash + 1, lastSlash);
  }

  // Extract year range from 'title (1988–1993) (TV Series)'
  static String? getYearRange(Object? info) {
    if (info == null) return null;
    final String title = info.toString();
    final dates = title.lastIndexOf(RegExp(r'[0-9]'));
    final lastOpen = title.lastIndexOf('(', dates);
    final lastClose = title.indexOf(')', dates);
    if (lastOpen == -1 || lastClose == -1) return null;

    final yearRange = title.substring(lastOpen + 1, lastClose);
    final filter = RegExp(r'[0-9].*[0-9]');
    final numerics = filter.stringMatch(yearRange);
    return numerics;
  }

  static MovieContentType? getType(Object? info) {
    if (info == null) return null;
    final String title = info.toString();
    if (title.lastIndexOf('TV Movie') > -1) return MovieContentType.movie;
    if (title.lastIndexOf('TV Mini-Series') > -1)
      return MovieContentType.miniseries;
    if (title.lastIndexOf('Short') > -1) return MovieContentType.short;
    if (title.lastIndexOf('Video') > -1) return MovieContentType.short;
    if (title.lastIndexOf('TV Episode') > -1) return MovieContentType.episode;
    if (title.lastIndexOf('TV Series') > -1) return MovieContentType.series;
    if (title.lastIndexOf('TV Special') > -1) return MovieContentType.series;
    return MovieContentType.movie;
    return null;
  }
}
