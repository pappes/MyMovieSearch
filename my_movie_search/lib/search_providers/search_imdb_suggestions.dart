import 'dart:async';
import 'dart:convert';

import 'package:universal_io/io.dart'; // universla_io did not help to circumvent CORS

import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/data_model/search_criteria_dto.dart';
import 'package:my_movie_search/search_providers/jsonp_transformer.dart';
import 'package:my_movie_search/search_providers/online_offline_search.dart';
import 'package:my_movie_search/search_providers/search_imdb_suggestion_converter.dart';
import 'package:my_movie_search/search_providers/temp_search_imdb_suggestions_data.dart';

class QueryIMDBSuggestions {
  static final String baseURL = "https://sg.media-imdb.com/suggests";

  static executeQuery(
      StreamController<MovieResultDTO> sc, SearchCriteriaDTO criteria,
      {source = _streamResult}) async {
    source = OnlineOffline.dataSourceFn(source, emitImdbJsonOfflineData);
    Stream<String> result = await source(criteria.criteriaTitle);
    result
        .transform(JsonPDecoder())
        .transform(json.decoder)
        .map((event) => MovieSuggestionConverter.dtoFromCompleteJsonMap(event))
        .expand((element) =>
            element) // Emit each element from the dto list as a seperate dto.
        .pipe(sc);
  }

  static Uri _constructURI(String searchText) {
    final String url = "$baseURL/${searchText.substring(0, 1)}/$searchText";
    return Uri.parse(url);
  }

  static Future<Stream<String>> _streamResult(String criteria) async {
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
    final request = await client.getUrl(_constructURI(criteria));
    _constructHeaders(request.headers);

    // Change response type
    if (request is BrowserHttpClientRequest) {
      request.responseType = BrowserHttpClientResponseType.text;
      //request.credentialsMode = BrowserHttpClientCredentialsMode.include; //Credentials mode did not help to circumvent CORS
    }

    // Stream chunks
    final response = await request.close();
    return response.asBroadcastStream().transform(utf8.decoder);
  }

  static _constructHeaders(HttpHeaders headers) {
    headers.contentType = ContentType.json;
    headers.set(HttpHeaders.acceptHeader, ContentType.json);
  }
}
