import 'package:flutter/foundation.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/provider_controller.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'package:my_movie_search/utilities/web_data/jsonp_transformer.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_suggestions.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_suggestion.dart';

const _DEFAULT_SEARCH_RESULTS_LIMIT = 10;

/// Implements [SearchProvider] for the IMDB search suggestions API.
/// Search suggestions are used by the lookup bar in the IMDB web page.
class QueryIMDBSuggestions
    extends ProviderController<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://sg.media-imdb.com/suggests';

  /// Describe where the data is comming from.
  @override
  String dataSourceName() {
    return describeEnum(DataSourceType.imdbSuggestions);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamImdbJsonPOfflineData;
  }

  /// Remove JsonP from API response and convert to a map of MovieResultDTO.
  /// Limit results to 10 most relevant by default.
  @override
  Stream<List<MovieResultDTO>> transformStream(Stream<String> str) {
    if (getSearchResultsLimit == null)
      setSearchResultsLimit(_DEFAULT_SEARCH_RESULTS_LIMIT);
    return str
        .transform(JsonPDecoder())
        .transform(json.decoder)
        .map((event) => transformMapSafe(event as Map<dynamic, dynamic>?));
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> transformMap(Map map) =>
      ImdbSuggestionConverter.dtoFromCompleteJsonMap(map);

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String toText(dynamic contents) {
    return contents!.criteriaTitle;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO constructError(String message) {
    var error = MovieResultDTO();
    error.title = "[${this.runtimeType}] $message";
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdbSuggestions;
    return error;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri constructURI(String searchCriteria, {int pageNumber = 1}) {
    final searchSuffix =
        '/${searchCriteria.substring(0, 1)}/$searchCriteria.json';
    var url = '$baseURL$searchSuffix';
    return WebRedirect.constructURI(url);
  }
}
