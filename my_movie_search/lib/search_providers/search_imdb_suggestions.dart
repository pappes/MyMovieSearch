import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/data_model/search_criteria_dto.dart';

//query string https://sg.media-imdb.com/suggests/w/wonder%20woman.json
//json format
//1 = title/name
//id = unique  key (tt=tile/nm=name/vi=video)
//s = supplimentary info (biography, actors or trailer duration
//y = year
//yr = year range for series
//q = title type
//i = image with dimentions)

class QueryIMDBSuggestions {
  static final String baseURL = "https://sg.media-imdb.com/suggests/";

  static executeQuery(
      StreamController<MovieResultDTO> sc, SearchCriteriaDTO criteria) async {
    var client = new http.Client();

    var request = new http.Request('get', constructURI(criteria.criteriaTitle));
    // TODO add JSONP handling to prevent CORS error
    // ccess to XMLHttpRequest at 'https://...' from origin 'http://localhost:54571'
    // has been blocked by CORS policy:
    // No 'Access-Control-Allow-Origin' header is present on the requested resource.
    var streamResponse = await client.send(request);

    streamResponse.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((element) =>
            element) // expand each element and put them into a collection
        .map((map) => MovieSuggestionConverter.fromJsonMap(map))
        /*.transform(json.decoder)
        .expand((element) =>
            element) // expand each element and put them into a collection
        .map((map) => MovieResultConverter.fromJsonMap(map))*/
        .pipe(sc);
  }

  static Uri constructURI(String searchText) {
    final String url = "${baseURL}/${searchText.substring(0, 1)}/${searchText}";
    print(url);
    return Uri.parse(url);
  }
}

class MovieResultDTOFactory {
  static MovieResultDTO fromJsonMap(Map map) {
    var x = new MovieResultDTO();
    x.title = map['title'];
    //x.url = map['url'];
    return x;
  }
}

class MovieSuggestionConverter {
  static MovieResultDTO fromJsonMap(Map map) {
    // 2 phase converter in constructor - deserialise outer json from map
    // then deserialise inner json from map
    var resultCollection = map['d'];
    Map innerJson = json.decode(resultCollection);

    var x = new MovieResultDTO();
    x.uniqueId = innerJson['id'];
    x.title = innerJson['1'];
    x.year = innerJson['y'];
    x.yearRange = innerJson['yr'];
    x.title = innerJson['1'];
    return x;
  }
  /*Stream<int> count(int countTo) async* {
  for (int i = 1; i <= countTo; i++) {
    yield i;
    await Future.delayed(const Duration(seconds: 1));
  }
}

count(10).listen((int value) {
  print(value);
});*/
}
