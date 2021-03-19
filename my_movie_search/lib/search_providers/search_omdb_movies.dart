import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/search_providers/search_provider.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/temp_search_omdb_movies_data.dart';
import 'package:my_movie_search/search_providers/search_omdb_movie_converter.dart';

class QueryOMDBMovies extends SearchProvider<MovieResultDTO> {
  static final baseURL = "http://www.omdbapi.com/?apikey=";

  @override
  DataSourceFn offlineData() {
    return streamOmdbJsonOfflineData;
  }

  @override
  Stream<List<MovieResultDTO>> transformStream(Stream<String> str) {
    return str
        .transform(json.decoder)
        .map((event) => OmdbMovieSearchConverter.dtoFromCompleteJsonMap(event));
  }

  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    final omdbKey =
        env["OMDB_KEY"]; // From the file assests/.env (not source controlled)
    return Uri.parse("$baseURL$omdbKey&s=$searchText&page=$pageNumber");
  }
}
