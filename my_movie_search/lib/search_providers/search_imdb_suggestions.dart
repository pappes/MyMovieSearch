import 'package:universal_io/io.dart'; // Note: universal_io did not help to circumvent CORS

import 'package:my_movie_search/search_providers/search_provider.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/jsonp_transformer.dart';
import 'package:my_movie_search/search_providers/search_imdb_suggestion_converter.dart';
import 'package:my_movie_search/search_providers/temp_search_imdb_suggestions_data.dart';

/// Implements [SearchProvider] for the IMDB search suggestions API.
/// Search suggestions are used by the lookup bar in the IMDB web page.
class QueryIMDBSuggestions extends SearchProvider<MovieResultDTO> {
  static final baseURL = "https://sg.media-imdb.com/suggests";

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
    final url = "$baseURL/${searchText.substring(0, 1)}/$searchText";
    return Uri.parse(url);
  }

  // Override online functionality to force offline functionality
  // until CORS safeguards can be defeated.
  @override
  Future<Stream<String>> streamResult(String criteria) async {
    return streamImdbJsonPOfflineData(criteria);
  }

  // Add authorization token for compatability with the TMDB V4 API.
  Map constructHeaders() {
    Map headers = {};
    headers[HttpHeaders.contentTypeHeader] = ContentType.json;
    headers[HttpHeaders.acceptHeader] = ContentType.json;
    return headers;
  }

  /// Custom code to cirumvent CORS security.

  /*  
  Future<Stream<String>> streamResult(String criteria) async {
    /*
    final response =
        await http.get('https://sg.media-imdb.com/suggests/w/wonder');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load suggestions');
    }*/

    //TODO: proxy web connections.
    final client = HttpClient();
    final request = await client.getUrl(constructURI(criteria));
    _constructHeaders(request.headers);

    // Change response type
    if (request is BrowserHttpClientRequest) {
      request.responseType = BrowserHttpClientResponseType.text;
      //request.credentialsMode = BrowserHttpClientCredentialsMode.include; //Credentials mode did not help to circumvent CORS
    }

    // Stream chunks
    final response = await request.close();
    return response.asBroadcastStream().transform(utf8.decoder);
  }*/

}
