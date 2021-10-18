import 'dart:convert' show json;
import 'package:flutter/foundation.dart' show describeEnum;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/web_data/jsonp_transformer.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb_suggestion.dart';
import 'offline/imdb_suggestions.dart';

const _defaultSearchResultsLimit = 10;

/// Implements [WebFetchBase] for the IMDB search suggestions API.
/// Search suggestions are used by the lookup bar in the IMDB web page.
class QueryIMDBSuggestions
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://sg.media-imdb.com/suggests';

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return describeEnum(DataSourceType.imdbSuggestions);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbJsonPOfflineData;
  }

  /// Remove JsonP from API response and convert to a map of MovieResultDTO.
  /// Limit results to 10 most relevant by default.
  @override
  Stream<MovieResultDTO> baseTransformTextStreamToOutput(
    Stream<String> str,
  ) async* {
    List<MovieResultDTO> fnFromMapToListOfOutputType(decodedMap) {
      return baseTransformMapToOutputHandler(
        decodedMap as Map<dynamic, dynamic>?,
      );
    }

    searchResultsLimit ??= _defaultSearchResultsLimit;

    yield* str
        .transform(JsonPDecoder())
        .transform(json.decoder)
        .map(fnFromMapToListOfOutputType)
        .expand((element) => element);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      ImdbSuggestionConverter.dtoFromCompleteJsonMap(map);

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.criteriaTitle;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO();
    error.title = '[QueryIMDBSuggestions] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdbSuggestions;
    return error;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final prefix =
        searchCriteria.isEmpty ? 'U' : searchCriteria.substring(0, 1);
    final url = '$_baseURL/$prefix/$searchCriteria.json';
    return WebRedirect.constructURI(url);
  }
}
