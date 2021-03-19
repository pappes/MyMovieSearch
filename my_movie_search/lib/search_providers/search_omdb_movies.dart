import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http
    show Client, Request; // limit inclusions to reduce size

import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/data_model/search_criteria_dto.dart';
import 'package:my_movie_search/search_providers/online_offline_search.dart';
import 'package:my_movie_search/search_providers/search_omdb_movie_converter.dart';
import 'package:my_movie_search/search_providers/temp_search_omdb_movies_data.dart';

final omdbKey =
    env["OMDB_KEY"]; // From the file assests/.env (not source controlled)

class QueryOMDBMovies {
  static final String baseURL = "http://www.omdbapi.com/?apikey=";

  static executeQuery(
      StreamController<MovieResultDTO> sc, SearchCriteriaDTO criteria,
      {source = _streamResult}) async {
    //TODO: use BloC patterns to test the stream processing
    source = OnlineOffline.dataSourceFn(source, emitOmdbJsonOfflineData);
    Stream<String> result = await source(criteria.criteriaTitle);
    result
        .transform(json.decoder)
        .map((event) => OmdbMovieSearchConverter.dtoFromCompleteJsonMap(event))
        .expand((element) =>
            element) // Emit each element from the dto list as a seperate dto.
        .pipe(sc);
  }

  static Future<Stream<String>> _streamResult(String criteria) async {
    final client = http.Client();
    final request = http.Request('get', _constructURI(criteria));
    final streamResponse = await client.send(request);
    return streamResponse.stream.transform(utf8.decoder);
  }

  static Uri _constructURI(String searchText, {int pageNumber = 1}) {
    final encoded = Uri.encodeQueryComponent(searchText);
    return Uri.parse("$baseURL$omdbKey&s=$encoded&page=$pageNumber");
  }
}
