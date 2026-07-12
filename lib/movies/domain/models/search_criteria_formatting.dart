import 'package:my_movie_search/movies/domain/models/move_result_comparison.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_formatting.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';

/// Extension methods for converting [SearchCriteriaDTO] to printable forms.
extension FormatSearchResultDTOHelpers on SearchCriteriaDTO {
  /// Create a human readable version of [SearchCriteriaDTO].
  String toPrintableString() {
    if (criteriaList.isEmpty) return criteriaTitle;
    return criteriaList.toJson();
  }

  /// Create a query for google.
  String toQuery() {
    if (criteriaList.isEmpty) return criteriaTitle;
    final query = StringBuffer();
    for (final movie in criteriaList) {
      query.write('${movie.uniqueId} OR ');
    }
    return query.toString().removeLast(3);
  }

  /// Create an ID search for [SearchCriteriaDTO].
  String? toIds() {
    final ids = <String>[];
    for (final dto in criteriaList) {
      if (!dto.isMessage()) ids.add(dto.uniqueId);
    }
    if (ids.isEmpty) return criteriaContext?.uniqueId;
    if (ids.length == 1) return ids.first;
    return ids.join(',');
  }

  /// Create an ID or text search for [SearchCriteriaDTO] if available.
  String toPrintableIdOrText() => toIds() ?? criteriaTitle;

  /// Create a unique string that represents this search.
  String toUniqueReference() => toIds() ?? '$criteriaType:$criteriaTitle';
}
