import 'dart:convert';

import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/blocs/repositories/application_statistics_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/barcode_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/more_keywords_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_meilisearch_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movies_for_keyword_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/tor_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

class SearchRequest extends Equatable {
  const SearchRequest(this._title);

  final String _title;

  @override
  List<Object> get props => [_title];

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
  dvdLocations,
  meilisearch,
  statistics,
  error,
  custom,
}

class SearchCriteriaDTO {
  String searchId = '';
  String criteriaTitle = '';
  SearchCriteriaType criteriaType = SearchCriteriaType.none;
  MovieResultDTO? criteriaContext;
  List<MovieResultDTO> criteriaList = [];

  /// Convert a [MovieResultDTO] to a json [String].
  ///
  String toJson({bool includeRelated = true}) => jsonEncode(toMap());
}

// member variable names
const String movieCriteriaDTOSearchId = 'searchId';
const String movieCriteriaDTOCriteriaTitle = 'criteriaTitle';
const String movieCriteriaDTOCriteriaType = 'criteriaType';
const String movieCriteriaDTOCriteriaContext = 'criteriaContext';
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
        oldValue.criteriaContext != value.criteriaContext ||
        oldValue.criteriaList.toPrintableString() !=
            value.criteriaList.toPrintableString()) {
      notifyListeners();
    }
  }

  static Map<String, dynamic> _getMap(GoRouterState state) {
    final criteria = state.extra;
    if (criteria != null && criteria is Map<String, dynamic>) return criteria;
    return {};
  }

  static Map<String, dynamic> routeState(SearchCriteriaDTO criteriaDto) =>
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

  @override
  Object toPrimitives() => dtoToPrimitives(value);
  Object dtoToPrimitives(SearchCriteriaDTO value) => jsonEncode(
    value.toMap(condensed: true)..addAll({'nextId': '${nextId + 1}'}),
  )..observe();
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
    if (ids.isEmpty) return criteriaContext?.uniqueId;
    if (ids.length == 1) return ids.first;
    return ids.join(',');
  }

  /// Create an ID or text search for [SearchCriteriaDTO] if available.
  String toPrintableIdOrText() => toIds() ?? criteriaTitle;

  /// Create a unique string that represents this search.
  String toUniqueReference() => toIds() ?? '$criteriaType:$criteriaTitle';

  /// Convert a [Map] into a [SearchCriteriaDTO] object.
  ///
  Map<String, String> toMap({bool condensed = false}) => <String, String>{
    movieCriteriaDTOSearchId: searchId,
    movieCriteriaDTOCriteriaTitle: criteriaTitle,
    movieCriteriaDTOCriteriaType: criteriaType.toString(),
    movieCriteriaDTOCriteriaContext: jsonEncode(criteriaContext?.toJson()),
    movieCriteriaDTOCriteriaList: criteriaList.toJson(condensed: condensed),
  };

  static List<MovieResultDTO> getMovieList(dynamic inputString) {
    final converter = RestorableMovieList();
    final stringList = DynamicHelper.toString_(inputString);
    return converter.fromPrimitives(stringList);
  }
  @factory
  // Linter does not understand that fromString is a factory method.
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO fromString(String criteria) => SearchCriteriaDTO()
    ..criteriaTitle = criteria
    ..criteriaType = SearchCriteriaType.movieTitle;

  /// Construct route to the search results page MovieSearchResultsNewPage
  /// as appropriate for the dto.
  ///
  RouteInfo getSearchResultsPage() => RouteInfo(
    ScreenRoute.searchresults,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
  );

  /// Construct route to the search criteria page MovieSearchCriteriaPage
  /// as appropriate for the dto.
  ///
  /// Always chooses MovieSearchResultsNewPage.
  RouteInfo getSearchCriteriaPage() => RouteInfo(
    ScreenRoute.search,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
  );

  /// Construct route to the about page.
  ///
  /// Always chooses AboutPage.
  RouteInfo getAboutPage() => RouteInfo(
    ScreenRoute.about,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
  );

  /// Construct route to the error details page.
  ///
  /// Always chooses ErrorDetailsPage.
  RouteInfo getErrorPage() => RouteInfo(
    ScreenRoute.errordetails,
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
      case SearchCriteriaType.moreKeywords:
        return MoreKeywordsRepository();
      case SearchCriteriaType.barcode:
        return BarcodeRepository();
      case SearchCriteriaType.meilisearch:
        return MovieMeiliSearchRepository();
      case SearchCriteriaType.error:
      case SearchCriteriaType.statistics:
        return ApplicationStatisticsRepository();
      case SearchCriteriaType.dvdLocations:
      case SearchCriteriaType.none:
      case SearchCriteriaType.custom:
      case SearchCriteriaType.movieDTOList:
      case SearchCriteriaType.movieTitle:
        return MovieSearchRepository();
    }
  }

  void init(
    SearchCriteriaType source, {
    String title = '',
    MovieResultDTO? context,
    List<MovieResultDTO> list = const [],
  }) {
    criteriaTitle = title;
    criteriaType = source;
    criteriaContext = context;
    criteriaList = list;
  }

  @factory
  // Linter does not understand that fromJson is a factory method.
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO clone({bool condensed = false, bool inflate = false}) =>
      toMap(condensed: condensed).toSearchCriteriaDTO(inflate: inflate);
}

extension MapCriteriaDTOConversion on Map<dynamic, dynamic> {
  /// Convert a [Map] into a [SearchCriteriaDTO] object.
  ///
  @factory
  // Linter does not understand that toSearchCriteriaDTO is a factory method.
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO toSearchCriteriaDTO({bool inflate = false}) {
    final dto = SearchCriteriaDTO()
      ..searchId = dynamicToString(this[movieCriteriaDTOSearchId])
      ..criteriaTitle = dynamicToString(this[movieCriteriaDTOCriteriaTitle])
      ..criteriaList = SearchCriteriaDTOHelpers.getMovieList(
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
