import 'dart:convert' show json;
import 'package:flutter/foundation.dart' show describeEnum;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'package:my_movie_search/utilities/web_data/jsonp_transformer.dart';
import 'offline/imdb_suggestions.dart';
import 'converters/imdb_suggestion.dart';

const _DEFAULT_SEARCH_RESULTS_LIMIT = 10;

/// Implements [WebFetchBase] for the IMDB search suggestions API.
/// Search suggestions are used by the lookup bar in the IMDB web page.
class QueryIMDBSuggestions
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://sg.media-imdb.com/suggests';

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
      Stream<String> str) async* {
    var fnFromMapToListOfOutputType = (decodedMap) =>
        baseTransformMapToOutputHandler(decodedMap as Map<dynamic, dynamic>?);
    if (getSearchResultsLimit == null)
      setSearchResultsLimit(_DEFAULT_SEARCH_RESULTS_LIMIT);
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
    return contents!.criteriaTitle;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    var error = MovieResultDTO();
    error.title = "[${this.runtimeType}] $message";
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdbSuggestions;
    return error;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    var prefix =
        searchCriteria.length > 0 ? searchCriteria.substring(0, 1) : 'U';
    var url = '$baseURL/$prefix/$searchCriteria.json';
    return WebRedirect.constructURI(url);
  }
}
