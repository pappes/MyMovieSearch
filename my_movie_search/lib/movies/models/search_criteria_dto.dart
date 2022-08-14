import 'dart:convert';

import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart';
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

enum SearchCriteriaSource {
  none,
  google,
  imdb,
  tpb,
  lime,
  custom,
}

class SearchCriteriaDTO {
  String searchId = '';
  String criteriaTitle = '';
  SearchCriteriaSource criteriaSource = SearchCriteriaSource.none;
  List<MovieResultDTO> criteriaList = [];
}

// member variable names
const String movieCriteriaDTOSearchId = 'searchId';
const String movieCriteriaDTOCriteriaTitle = 'criteriaTitle';
const String movieCriteriaDTOCriteriaSource = 'criteriaSource';
const String movieCriteriaDTOCriteriaList = 'criteriaList';

class RestorableSearchCriteria extends RestorableValue<SearchCriteriaDTO> {
  @override
  SearchCriteriaDTO createDefaultValue() => SearchCriteriaDTO();

  @override
  void didUpdateValue(SearchCriteriaDTO? oldValue) {
    if (oldValue == null ||
        oldValue.searchId != value.searchId ||
        oldValue.criteriaTitle != value.criteriaTitle ||
        oldValue.criteriaSource != value.criteriaSource ||
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
    final retVal = SearchCriteriaDTO();
    retVal.searchId = map[movieCriteriaDTOSearchId] ?? retVal.searchId;
    retVal.criteriaTitle =
        map[movieCriteriaDTOCriteriaTitle] ?? retVal.criteriaTitle;

    retVal.criteriaSource = getEnumValue<SearchCriteriaSource>(
          map[movieCriteriaDTOCriteriaSource],
          SearchCriteriaSource.values,
        ) ??
        retVal.criteriaSource;

    retVal.criteriaList = SearchCriteriaDTOHelpers.getMovieList(
      map[movieCriteriaDTOCriteriaList],
    );
    return retVal;
  }

  @override
  Object toPrimitives() => dtoToPrimitives(value);
  Object dtoToPrimitives(SearchCriteriaDTO value) => jsonEncode(value.toMap());
}

extension SearchCriteriaDTOHelpers on SearchCriteriaDTO {
  /// Create a human readable version of SearchCriteriaDTO.
  String toPrintableString() {
    if (criteriaList.isEmpty) return criteriaTitle;
    return criteriaList.toJson();
  }

  /// Convert a [Map] into a [SearchCriteriaDTO] object.
  ///
  Map<String, String> toMap() {
    return <String, String>{
      movieCriteriaDTOSearchId: searchId,
      movieCriteriaDTOCriteriaTitle: criteriaTitle,
      movieCriteriaDTOCriteriaSource: criteriaSource.toString(),
      movieCriteriaDTOCriteriaList: criteriaList.toJson(),
    };
  }

  static List<MovieResultDTO> getMovieList(dynamic inputString) {
    final converter = RestorableMovieList();
    final stringList = DynamicHelper.dynamicToString_(inputString);
    return converter.dtoFromPrimitives(stringList);
  }

  SearchCriteriaDTO fromString(String criteria) {
    final dto = SearchCriteriaDTO();
    dto.criteriaTitle = criteria;
    return dto;
  }
}

extension MapCriteriaDTOConversion on Map {
  /// Convert a [Map] into a [SearchCriteriaDTO] object.
  ///
  SearchCriteriaDTO toSearchCriteriaDTO() {
    final dto = SearchCriteriaDTO();
    dto.searchId = dynamicToString(this[movieCriteriaDTOSearchId]);
    dto.criteriaTitle = dynamicToString(this[movieCriteriaDTOCriteriaTitle]);

    dto.criteriaSource = getEnumValue<SearchCriteriaSource>(
          this[movieCriteriaDTOCriteriaSource],
          SearchCriteriaSource.values,
        ) ??
        dto.criteriaSource;

    dto.criteriaList = SearchCriteriaDTOHelpers.getMovieList(
      this[movieCriteriaDTOCriteriaList],
    );
    return dto;
  }
}
