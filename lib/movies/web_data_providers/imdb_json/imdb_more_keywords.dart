// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';

class ImdbMoreKeywordsConverter extends ImdbConverterBase {
  @override
  /// Break [data] up into one Map per keyword.
  Iterable<Map<dynamic, dynamic>> getMovieDataList(Map<dynamic, dynamic> data) {
    final keywords = <Map<dynamic, dynamic>>[];
    for (final entry in data.keys) {
      keywords.add({entry.toString(): entry.toString()});
    }
    return keywords;
  }

  @override
  /// convert the keyword to a dto.
  dynamic getMovieOrPerson(MovieResultDTO dto, Map<dynamic, dynamic> data) {
    dto
      ..uniqueId = data.values.first.toString()
      ..title = data.values.first.toString()
      ..type = MovieContentType.keyword;
    return null;
  }

  @override
  void getRelatedMovies(RelatedMovieCategories related, dynamic data) {
    // TODO: implement getRelatedMovies
  }

  @override
  void getRelatedPeople(RelatedMovieCategories related, dynamic data) {}
}
