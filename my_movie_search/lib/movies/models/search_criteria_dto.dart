import 'dart:convert';

import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';

class SearchRequest extends Equatable {
  const SearchRequest(this.title);

  final String title;

  @override
  List<Object> get props => [title];

  static const empty = SearchRequest('-');
}

enum SearchStatus { awaitingInput, searching, cacheDirty, displayingResults }

enum SearchCriteriaType {
  none,
  movieTitle,
  moviesForKeyword,
  moreKeywords,
  movieDTOList,
  downloadSimple,
  downloadAdvanced,
  barcode,
  custom,
}

class SearchCriteriaDTO {
  String searchId = '';
  String criteriaTitle = '';
  SearchCriteriaType criteriaType = SearchCriteriaType.none;
  List<MovieResultDTO> criteriaList = [];
}

// member variable names
const String movieCriteriaDTOSearchId = 'searchId';
const String movieCriteriaDTOCriteriaTitle = 'criteriaTitle';
const String movieCriteriaDTOCriteriaType = 'criteriaType';
const String movieCriteriaDTOCriteriaList = 'criteriaList';

class RestorableSearchCriteria extends RestorableValue<SearchCriteriaDTO> {
  @override
  SearchCriteriaDTO createDefaultValue() => SearchCriteriaDTO();

  @override
  void didUpdateValue(SearchCriteriaDTO? oldValue) {
    if (oldValue == null ||
        oldValue.searchId != value.searchId ||
        oldValue.criteriaTitle != value.criteriaTitle ||
        oldValue.criteriaType != value.criteriaType ||
        oldValue.criteriaList.toPrintableString() !=
            value.criteriaList.toPrintableString()) notifyListeners();
  }

  @override
  SearchCriteriaDTO fromPrimitives(Object? data) => dtoFromPrimitives(data);
  SearchCriteriaDTO dtoFromPrimitives(Object? data) {
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        return decoded.toSearchCriteriaDTO();
      }
    }
    return SearchCriteriaDTO();
  }

  SearchCriteriaDTO getDTO(Map<String, String> map) {
    final result = SearchCriteriaDTO();
    result
      ..searchId = map[movieCriteriaDTOSearchId] ?? result.searchId
      ..criteriaTitle =
          map[movieCriteriaDTOCriteriaTitle] ?? result.criteriaTitle
      ..criteriaType = getEnumValue<SearchCriteriaType>(
            map[movieCriteriaDTOCriteriaType],
            SearchCriteriaType.values,
          ) ??
          result.criteriaType
      ..criteriaList = SearchCriteriaDTOHelpers.getMovieList(
        map[movieCriteriaDTOCriteriaList],
      );
    return result;
  }

  /// Get a unique ideintifier for this data.
  ///
  static String getRestorationId(GoRouterState state) {
    final criteria = state.extra;
    String? id;
    if (criteria != null && criteria is SearchCriteriaDTO) {
      id = criteria.toPrintableIdOrText();
    }
    return '_${state.fullPath}$id';
  }

  @override
  Object toPrimitives() => dtoToPrimitives(value);
  Object dtoToPrimitives(SearchCriteriaDTO value) => jsonEncode(value.toMap());
}

extension SearchCriteriaDTOHelpers on SearchCriteriaDTO {
  /// Create a human readable version of [SearchCriteriaDTO].
  String toPrintableString() {
    if (criteriaList.isEmpty) return criteriaTitle;
    return criteriaList.toJson();
  }

  /// Create an ID search for [SearchCriteriaDTO].
  String? toIds() {
    final ids = <String>[];
    for (final dto in criteriaList) {
      if (!dto.uniqueId.startsWith(movieDTOMessagePrefix)) {
        ids.add(dto.uniqueId);
      }
    }
    if (ids.isEmpty) return null;
    if (ids.length == 1) return ids.first;
    return ids.join(',');
  }

  /// Create an ID or text search for [SearchCriteriaDTO] if available.
  String toPrintableIdOrText() {
    return toIds() ?? criteriaTitle;
  }

  /// Create a unique string that represents this search.
  String toUniqueReference() {
    return toIds() ?? '$criteriaType:$criteriaTitle';
  }

  /// Convert a [Map] into a [SearchCriteriaDTO] object.
  ///
  Map<String, String> toMap() => <String, String>{
        movieCriteriaDTOSearchId: searchId,
        movieCriteriaDTOCriteriaTitle: criteriaTitle,
        movieCriteriaDTOCriteriaType: criteriaType.toString(),
        movieCriteriaDTOCriteriaList: criteriaList.toJson(),
      };

  static List<MovieResultDTO> getMovieList(dynamic inputString) {
    final converter = RestorableMovieList();
    final stringList = DynamicHelper.toString_(inputString);
    return converter.dtoFromPrimitives(stringList);
  }

  SearchCriteriaDTO fromString(String criteria) {
    return SearchCriteriaDTO()
      ..criteriaTitle = criteria
      ..criteriaType = SearchCriteriaType.movieTitle;
  }

  SearchCriteriaDTO init(
    SearchCriteriaType source, {
    String title = "",
    List<MovieResultDTO> list = const [],
  }) {
    criteriaType = source;
    criteriaTitle = title;
    criteriaList = list;
    return this;
  }

  @factory
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO clone() => toMap().toSearchCriteriaDTO();
}

extension MapCriteriaDTOConversion on Map<dynamic, dynamic> {
  /// Convert a [Map] into a [SearchCriteriaDTO] object.
  ///
  @factory
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO toSearchCriteriaDTO() {
    final dto = SearchCriteriaDTO()
      ..searchId = dynamicToString(this[movieCriteriaDTOSearchId])
      ..criteriaTitle = dynamicToString(this[movieCriteriaDTOCriteriaTitle]);

    dto
      ..criteriaType = getEnumValue<SearchCriteriaType>(
            this[movieCriteriaDTOCriteriaType],
            SearchCriteriaType.values,
          ) ??
          dto.criteriaType
      ..criteriaList = SearchCriteriaDTOHelpers.getMovieList(
        this[movieCriteriaDTOCriteriaList],
      );
    return dto;
  }
}
