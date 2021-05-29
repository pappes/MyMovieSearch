import 'package:my_movie_search/movies/models/movie_result_dto.dart';

MovieContentType? getImdbMovieContentType(Object? info, int? duration) {
  if (info == null) return null;
  final String title = info.toString();
  if (title.lastIndexOf('TV Mini-Series') > -1)
    return MovieContentType.miniseries;
  if (title.lastIndexOf('TV Episode') > -1) return MovieContentType.episode;
  if (title.lastIndexOf('TV Series') > -1) return MovieContentType.series;
  if (title.lastIndexOf('TV Special') > -1) return MovieContentType.series;
  if (title.lastIndexOf('Short') > -1) return MovieContentType.short;
  if (duration != null && duration < 50 && duration > 0)
    return MovieContentType.short;
  if (title.lastIndexOf('TV Movie') > -1) return MovieContentType.movie;
  if (title.lastIndexOf('Video') > -1) return MovieContentType.movie;
  if (title.lastIndexOf('video') > -1) return MovieContentType.movie;
  if (title.lastIndexOf('feature') > -1) return MovieContentType.movie;
  print('Unknown Imdb MoveContentType $title');
  return MovieContentType.movie;
}
