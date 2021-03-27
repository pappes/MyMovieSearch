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

  /// Convert from JsonP [Stream] to
  /// a stream containing a [List] of [MovieResultDTO].
  @override
  Stream<List<MovieResultDTO>> transformStream(Stream<String> str) {
    return str
        .transform(JsonPDecoder())
        .transform(json.decoder)
        .map((event) => MovieSuggestionConverter.dtoFromCompleteJsonMap(event));
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    final url = "$baseURL/${searchText.substring(0, 1)}/$searchText";
    return Uri.parse(url);
  }

  /// Fetches and [utf8] decodes online data matching [criteria].
  ///
  /// The criteria does not need to be Uri encoded for safe searching.
  @override
  Future<Stream<String>> streamResult(String criteria) async {
    return streamImdbJsonPOfflineData(criteria);
  }

  /// Custom code to cirumvent CORS security.

  /*
  
  static _constructHeaders(HttpHeaders headers) {
    headers.contentType = ContentType.json;
    headers.set(HttpHeaders.acceptHeader, ContentType.json);
  }
  
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
