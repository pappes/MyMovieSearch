import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http
    show get, Client, Request; // limit inclusions to reduce size

import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/data_model/search_criteria_dto.dart';
import 'package:my_movie_search/search_providers/jsonp_transformer.dart';
import 'package:my_movie_search/search_providers/search_imdb_suggestion_converter.dart';
import 'package:my_movie_search/search_providers/temp_search_imdb_suggestions_data.dart';

class QueryIMDBSuggestions {
  static final String baseURL = "https://sg.media-imdb.com/suggests";

  static executeQuery(
      StreamController<MovieResultDTO> sc, SearchCriteriaDTO criteria,
      //{source = _streamResult}) async {
      {source = emitImdbJsonPSample}) async {
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
    final client = http.Client();
    final request = http.Request('get', _constructURI(criteria));
    request.headers.addAll(_constructHeaders());
    final streamResponse = await client.send(request);
    return streamResponse.stream.transform(utf8.decoder);
  }

  static Map _constructHeaders() {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    return requestHeaders;
  }
}
