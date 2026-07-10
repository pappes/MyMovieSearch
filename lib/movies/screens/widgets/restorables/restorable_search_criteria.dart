import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/data/search_criteria_mappers.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_formatting.dart';
import 'package:my_movie_search/movies/domain/models/search_criteria_transformation.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/widgets/restorables/restorable_movie_result.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

/// Persist search criteria to help with restoration after app restarts.
class RestorableSearchCriteria extends RestorableValue<SearchCriteriaDTO> {
  RestorableSearchCriteria([SearchCriteriaDTO? def]) {
    if (def != null) defaultVal = def;
  }

  static int nextId = 0;
  SearchCriteriaDTO defaultVal = SearchCriteriaDTO();
  @override
  SearchCriteriaDTO createDefaultValue() => defaultVal;

  /// Notifies listeners if the value has changed.
  @override
  void didUpdateValue(SearchCriteriaDTO? oldValue) {
    if (oldValue == null ||
        oldValue.searchId != value.searchId ||
        oldValue.criteriaTitle != value.criteriaTitle ||
        oldValue.criteriaType != value.criteriaType ||
        oldValue.criteriaContext != value.criteriaContext ||
        oldValue.criteriaList.toPrintableString() !=
            value.criteriaList.toPrintableString()) {
      notifyListeners();
    }
  }

  static Map<String, Object?> _getMap(GoRouterState state) {
    final criteria = state.extra;
    if (criteria != null && criteria is Map<String, Object?>) return criteria;
    return {};
  }

  static Map<String, Object> routeState(SearchCriteriaDTO criteriaDto) =>
      // Condense movieDTO contentes to prevent crashing on restoration.
      {'id': nextId++, 'dto': criteriaDto.clone(condensed: true)};

  static SearchCriteriaDTO getDto(GoRouterState state) {
    final input = _getMap(state);
    if (input.containsKey('dto')) {
      final criteria = input['dto'];
      if (criteria != null && criteria is SearchCriteriaDTO) {
        // Return a clone to prevent unintentional inflation of data.
        return criteria.clone(inflate: true);
      }
      return dtoFromPrimitives(criteria);
    }
    return SearchCriteriaDTO();
  }

  /// Get a unique identifier for this data.
  ///
  /// Will generate a unique if if none supplied.
  /// Will update the next id if it is out of sync.
  static String getRestorationId(GoRouterState state) {
    final input = _getMap(state);
    if (input.containsKey('id')) {
      final criteriaRestorationId = input['id'];
      if (criteriaRestorationId != null && criteriaRestorationId is int) {
        if (criteriaRestorationId >= nextId) nextId = criteriaRestorationId + 1;
        return 'RestorableSearchCriteria$criteriaRestorationId';
      }
    }
    return 'RestorableSearchCriteria${nextId++}';
  }

  @override
  @factory
  // Linter does not understand that fromPrimitives is a factory method.
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO fromPrimitives(Object? data) => dtoFromPrimitives(data);
  @factory
  static SearchCriteriaDTO dtoFromPrimitives(Object? data) {
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        // Restore nextId if it is out of sync.
        if (decoded.containsKey('nextId')) {
          final storedId = IntHelper.fromText(decoded['nextId']) ?? nextId;
          if (storedId > nextId) {
            nextId = storedId + 1;
          }
        }
        return decoded.toSearchCriteriaDTO();
      }
    }
    return SearchCriteriaDTO();
  }

  /// Convert the SearchCriteriaDTO to a serializable object.
  @override
  Object toPrimitives() => dtoToPrimitives(value);

  /// Convert the SearchCriteriaDTO to a serializable object.
  Object dtoToPrimitives(SearchCriteriaDTO value) => jsonEncode(
    value.toMap(condensed: true)..addAll({'nextId': '${nextId + 1}'}),
  )..observe();
}

/// Restore movie DTO list within search criteria.
extension SearchCriteriaDTORestorableHelpers on SearchCriteriaDTO {
  static List<MovieResultDTO> getMovieList(Object? inputString) {
    final converter = RestorableMovieList();
    final stringList = DynamicHelper.toString_(inputString);
    return converter.fromPrimitives(stringList);
  }
}
