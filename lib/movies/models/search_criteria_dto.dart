import 'dart:convert';

import 'package:equatable/equatable.dart' show Equatable;
import 'package:my_movie_search/movies/blocs/repositories/application_statistics_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/barcode_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/more_keywords_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_meilisearch_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movies_for_keyword_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/tor_repository.dart';
import 'package:my_movie_search/movies/data/search_criteria_mappers.dart';
import 'package:my_movie_search/movies/domain/models/search_criteria_enums.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

class SearchRequest extends Equatable {
  const SearchRequest(this._title);

  final String _title;

  @override
  List<Object> get props => [_title];

  static const empty = SearchRequest('-');
}

enum SearchStatus { awaitingInput, searching, cacheDirty, displayingResults }

class SearchCriteriaDTO {
  String searchId = '';
  String criteriaTitle = '';
  SearchCriteriaType criteriaType = .none;
  MovieResultDTO? criteriaContext;
  List<MovieResultDTO> criteriaList = [];

  /// Convert a [MovieResultDTO] to a json [String].
  ///
  String toJson({bool includeRelated = true}) => jsonEncode(toMap());
}

// member variable names
const movieCriteriaDTOSearchId = 'searchId';
const movieCriteriaDTOCriteriaTitle = 'criteriaTitle';
const movieCriteriaDTOCriteriaType = 'criteriaType';
const movieCriteriaDTOCriteriaContext = 'criteriaContext';
const movieCriteriaDTOCriteriaList = 'criteriaList';

/// Methods to interpret DTO contents.
extension SearchCriteriaDTOHelpers on SearchCriteriaDTO {
  /// Determine which WebFetch to use to gather data
  static BaseMovieRepository getDatasource(SearchCriteriaType criteriaType) {
    switch (criteriaType) {
      case .downloadSimple:
      case .downloadAdvanced:
        return TorRepository();
      case .moviesForKeyword:
        return MoviesForKeywordRepository();
      case .moreKeywords:
        return MoreKeywordsRepository();
      case .barcode:
        return BarcodeRepository();
      case .meilisearch:
        return MovieMeiliSearchRepository();
      case .error:
      case .statistics:
      case .settings:
      case .navigationHistory:
        return ApplicationStatisticsRepository();
      case .dvdLocations:
      case .none:
      case .custom:
      case .movieDTOList:
      case .movieTitle:
        return MovieSearchRepository();
    }
  }
}
