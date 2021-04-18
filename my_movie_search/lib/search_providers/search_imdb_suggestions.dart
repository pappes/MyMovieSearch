import 'package:my_movie_search/search_providers/search_provider.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/jsonp_transformer.dart';
import 'package:my_movie_search/search_providers/search_imdb_suggestion_converter.dart';
import 'package:my_movie_search/search_providers/temp_search_imdb_suggestions_data.dart';

import 'imdb_redirect.dart';

/// Implements [SearchProvider] for the IMDB search suggestions API.
/// Search suggestions are used by the lookup bar in the IMDB web page.
class QueryIMDBSuggestions extends SearchProvider<MovieResultDTO> {
  static final baseURL = 'https://sg.media-imdb.com/suggests';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamImdbJsonPOfflineData;
  }

  // Remove JsonP from API response and convert to a map of MovieResultDTO.
  @override
  Stream<List<MovieResultDTO>> transformStream(Stream<String> str) {
    return str
        .transform(JsonPDecoder())
        .transform(json.decoder)
        .map((event) => transformMapSafe(event as Map<dynamic, dynamic>?));
  }

  // Convert OMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> transformMap(Map map) =>
      ImdbSuggestionConverter.dtoFromCompleteJsonMap(map);

  // Include entire map in the movie title when an error occurs.
  @override
  List<MovieResultDTO> constructError(String message) {
    var error = MovieResultDTO();
    error.title = "[${this.runtimeType}] $message";
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    error.uniqueId = "-${error.source}";
    return [error];
  }

  // API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    final searchSuffix = '/${searchText.substring(0, 1)}/$searchText.json';
    var url = '$baseURL$searchSuffix';
    return IMDBRedirect.constructURI(url);
  }
}
