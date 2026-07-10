import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/data/movie_result_mappers.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_formatting.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_transformation.dart';
import 'package:my_movie_search/movies/domain/models/search_criteria_enums.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/widgets/restorables/restorable_search_criteria.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';

/// Extension methods for converting between [SearchCriteriaDTO] and [Map].
extension SearchCriteriaDTOMapper on SearchCriteriaDTO {
  /// Convert a [Map] into a [SearchCriteriaDTO] object.
  ///
  Map<String, String> toMap({bool condensed = false}) => <String, String>{
    movieCriteriaDTOSearchId: searchId,
    movieCriteriaDTOCriteriaTitle: criteriaTitle,
    movieCriteriaDTOCriteriaType: criteriaType.toString(),
    movieCriteriaDTOCriteriaContext: jsonEncode(criteriaContext?.toJson()),
    movieCriteriaDTOCriteriaList: criteriaList.toJson(condensed: condensed),
  };

  @factory
  // Linter does not understand that fromString is a factory method.
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO fromString(String criteria) => SearchCriteriaDTO()
    ..criteriaTitle = criteria
    ..criteriaType = .movieTitle;
}

/// Extension methods for converting between [Map] and [SearchCriteriaDTO].
extension MapCriteriaDTOConversion on Map<Object?, Object?> {
  /// Convert a [Map] into a [SearchCriteriaDTO] object.
  ///
  @factory
  // Linter does not understand that toSearchCriteriaDTO is a factory method.
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO toSearchCriteriaDTO({bool inflate = false}) {
    final dto = SearchCriteriaDTO()
      ..searchId = dynamicToString(this[movieCriteriaDTOSearchId])
      ..criteriaTitle = dynamicToString(this[movieCriteriaDTOCriteriaTitle])
      ..criteriaList = SearchCriteriaDTORestorableHelpers.getMovieList(
        this[movieCriteriaDTOCriteriaList],
      );

    if (this[movieCriteriaDTOCriteriaContext] != 'null') {
      dto.criteriaContext = MovieResultDTO().fromJson(
        this[movieCriteriaDTOCriteriaContext],
      );
    }
    dto.criteriaType =
        SearchCriteriaType.values.byFullName(
          this[movieCriteriaDTOCriteriaType],
        ) ??
        dto.criteriaType;
    if (inflate) {
      for (final dto in dto.criteriaList) {
        dto.merge(dto.inflate());
      }
    }
    return dto;
  }
}
