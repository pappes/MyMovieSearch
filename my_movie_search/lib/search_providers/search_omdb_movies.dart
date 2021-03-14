import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http
    show get, Client, Request; // limit inclusions to reduce size

import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/data_model/search_criteria_dto.dart';
import 'package:my_movie_search/search_providers/search_omdb_movie_converter.dart';
import 'package:my_movie_search/search_providers/temp_search_omdb_movies_data.dart';

final zzzomdbKey = Platform.environment["OMDB_KEY"];
final omdbKey = "";

class QueryOMDBMovies {
  static final String baseURL = "http://www.omdbapi.com/?apikey=";

  static executeQuery(
    StreamController<MovieResultDTO> sc,
    SearchCriteriaDTO criteria,
  ) async {
    /*final response = await http.get(constructURI(criteria.criteriaTitle));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("BUGGER!");
      throw Exception('Failed to load album');
    }*/

    /*var client = http.Client();

    var request = http.Request('get', constructURI(criteria.criteriaTitle));
    //request.headers.addAll(constructHeaders());

    var streamResponse = await client.send(request);

    streamResponse.stream
        .transform(utf8.decoder)*/

    emitOmdbJsonSearch() // TODO: use response stream to populate suggestions.
        .transform(json.decoder)
        // TODO: move outerMap extraction down into
        .map((outerMap) => (outerMap as Map)[
            outer_element_results_collection]) // Pull the inner collection out of the map.
        .expand((element) =>
            element) // Emit each element from the list as a seperate stream event.
        .map((event) => OmdbMovieSearchConverter.dtoFromMap(event))
        .pipe(sc);
  }

  static Uri constructURI(String searchText, {int pageNumber = 1}) {
    final String url =
        "$baseURL$omdbKey&s=$searchText&page=$pageNumber"; // TODO: find out if we want t=(title search) or s= (paginated results)
    print(url);
    return Uri.parse(url);
  }

/*  static Map constructHeaders() {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    return requestHeaders;
  }*/
}
