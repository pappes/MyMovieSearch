import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';

class ImdbMoreKeywordsConverter extends ImdbConverterBase {
  @override
  /// Break [data] up into one Map per keyword.
  Iterable<Map<Object?, Object?>> getMovieDataList(Map<Object?, Object?> data) {
    final keywords = <Map<Object?, Object?>>[];
    for (final entry in data.keys) {
      keywords.add({entry.toString(): entry.toString()});
    }
    return keywords;
  }

  @override
  /// convert the keyword to a dto.
  Object? getMovieOrPerson(MovieResultDTO dto, Map<Object?, Object?> data) {
    dto
      ..uniqueId = data.values.first.toString()
      ..title = data.values.first.toString()
      ..type = MovieContentType.keyword;
    // Empty retrun value as we have finsihed extracting all the keyword
    // data we can get from this map.
    return null;
  }

  @override
  void getRelatedMovies(RelatedMovieCategories related, Object? data) {
    // TODO: implement getRelatedMovies
  }

  @override
  void getRelatedPeople(RelatedMovieCategories related, Object? data) {}
}
