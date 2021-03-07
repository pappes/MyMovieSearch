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
    StreamController<MovieResultDTO> sc,
    SearchCriteriaDTO criteria,
  ) async {
    //TODO: proxy web connections.
    /*var client = http.Client();

    var request = http.Request('get', constructURI(criteria.criteriaTitle));
    request.headers.addAll(constructHeaders());

    var streamResponse = await client.send(request);

    final response =
        await http.get('https://sg.media-imdb.com/suggests/w/wonder');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    streamResponse.stream.transform(utf8.decoder)*/
    emitImdbJsonPSample() // TODO: use response stream to populate suggestions.
        .transform(JsonPDecoder())
        .transform(json.decoder)
        .map((outerMap) => (outerMap as Map)[
            outer_element_results_collection]) // Pull the inner collection out of the map.
        .expand((element) =>
            element) // Emit each element from the list as a seperate stream event.
        .map((event) => MovieSuggestionConverter.dtoFromMap(event))
        .pipe(sc);
  }

  static Uri constructURI(String searchText) {
    final String url = "$baseURL/${searchText.substring(0, 1)}/$searchText";
    print(url);
    return Uri.parse(url);
  }

  static Map constructHeaders() {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    return requestHeaders;
  }
}
