import 'dart:convert';

import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/blocs/repositories/barcode_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/more_keywords_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movies_for_keyword_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/tor_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

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

  /// Convert a [MovieResultDTO] to a json [String].
  ///
  String toJson({bool includeRelated = true}) =>
      // ignore: unnecessary_this
      jsonEncode(this.toMap());
}

// member variable names
const String movieCriteriaDTOSearchId = 'searchId';
const String movieCriteriaDTOCriteriaTitle = 'criteriaTitle';
const String movieCriteriaDTOCriteriaType = 'criteriaType';
const String movieCriteriaDTOCriteriaList = 'criteriaList';

class RestorableSearchCriteria extends RestorableValue<SearchCriteriaDTO> {
  RestorableSearchCriteria([SearchCriteriaDTO? def]) {
    if (def != null) defaultVal = def;
  }

  static int nextId = 0;
  SearchCriteriaDTO defaultVal = SearchCriteriaDTO();
  @override
  SearchCriteriaDTO createDefaultValue() => defaultVal;

  @override
  void didUpdateValue(SearchCriteriaDTO? oldValue) {
    if (oldValue == null ||
        oldValue.searchId != value.searchId ||
        oldValue.criteriaTitle != value.criteriaTitle ||
        oldValue.criteriaType != value.criteriaType ||
        oldValue.criteriaList.toPrintableString() !=
            value.criteriaList.toPrintableString()) notifyListeners();
  }

  static Map<String, dynamic> _getMap(GoRouterState state) {
    final criteria = state.extra;
    if (criteria != null && criteria is Map<String, dynamic>) return criteria;
    return {};
  }

  static Map<String, dynamic> routeState(SearchCriteriaDTO dto) =>
      {'id': nextId++, 'dto': dto};

  static SearchCriteriaDTO getDto(GoRouterState state) {
    final input = _getMap(state);
    if (input.containsKey('dto')) {
      final criteria = input['dto'];
      if (criteria != null && criteria is SearchCriteriaDTO) {
        return criteria;
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
      final criteria = input['id'];
      if (criteria != null && criteria is int) {
        if (criteria > nextId) nextId = criteria + 1;
        return 'RestorableSearchCriteria$criteria';
      }
    }
    return 'RestorableSearchCriteria${nextId++}';
  }

  @override
  @factory
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO fromPrimitives(Object? data) => dtoFromPrimitives(data);
  @factory
  static SearchCriteriaDTO dtoFromPrimitives(Object? data) {
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        return decoded.toSearchCriteriaDTO();
      }
    }
    return SearchCriteriaDTO();
  }

  /*SearchCriteriaDTO getDTO(Map<String, String> map) {
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
  }*/

  @override
  Object toPrimitives() => dtoToPrimitives(value);
  Object dtoToPrimitives(SearchCriteriaDTO value) =>
      printSizeAndReturn(jsonEncode(value.toMap()));
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
      if (!dto.isMessage()) ids.add(dto.uniqueId);
    }
    if (ids.isEmpty) return null;
    if (ids.length == 1) return ids.first;
    return ids.join(',');
  }

  /// Create an ID or text search for [SearchCriteriaDTO] if available.
  String toPrintableIdOrText() => toIds() ?? criteriaTitle;

  /// Create a unique string that represents this search.
  String toUniqueReference() => toIds() ?? '$criteriaType:$criteriaTitle';

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
    return converter.fromPrimitives(stringList);
  }

  SearchCriteriaDTO fromString(String criteria) => SearchCriteriaDTO()
    ..criteriaTitle = criteria
    ..criteriaType = SearchCriteriaType.movieTitle;

  /// Construct route to Material user interface page
  /// as appropriate for the dto.
  ///
  /// Always chooses MovieSearchResultsNewPage.
  RouteInfo getDetailsPage() => RouteInfo(
        ScreenRoute.searchresults,
        RestorableSearchCriteria.routeState(this),
        toUniqueReference(),
      );

  /// Determine which WebFetch to use to gather data
  static BaseMovieRepository getDatasource(SearchCriteriaType criteriaType) {
    switch (criteriaType) {
      case SearchCriteriaType.downloadSimple:
      case SearchCriteriaType.downloadAdvanced:
        return TorRepository();
      case SearchCriteriaType.moviesForKeyword:
        return MoviesForKeywordRepository();
      case SearchCriteriaType.barcode:
        return BarcodeRepository();
      case SearchCriteriaType.moreKeywords:
        return MoreKeywordsRepository();
      case SearchCriteriaType.none:
      case SearchCriteriaType.custom:
      case SearchCriteriaType.movieDTOList:
      case SearchCriteriaType.movieTitle:
        return MovieSearchRepository();
    }
  }

  SearchCriteriaDTO init(
    SearchCriteriaType source, {
    String title = '',
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
