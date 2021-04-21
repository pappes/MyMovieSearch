import 'package:universal_io/io.dart'
    show HttpHeaders; // limit inclusions to reduce size

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/search_providers/search_provider.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/offline/temp_search_tmdb_movies_data.dart';
import 'package:my_movie_search/search_providers/converters/search_tmdb_movie_converter.dart';

/// Implements [SearchProvider] for searching the The Movie Database (TMDB).
/// The OMDb API is a free web service to obtain movie information.
class QueryTMDBMovies extends SearchProvider<MovieResultDTO> {
  static final baseURL = 'https://api.themoviedb.org/3/search/movie?api_key=';

  // Static snapshot of data for offline operation.
  // Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() => streamTmdbJsonOfflineData;

  // Convert TMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> transformMap(Map map) =>
      TmdbMovieSearchConverter.dtoFromCompleteJsonMap(map);

  // Include entire map in the movie title when an error occurs.
  @override
  List<MovieResultDTO> constructError(String message) {
    var error = MovieResultDTO();
    error.title = '[${this.runtimeType}] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.tmdb;
    error.uniqueId = '-${error.source}';
    return [error];
  }

  // API call to TMDB returning the top 10 matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    final omdbKey =
        env['TMDB_KEY']; // From the file assets/.env (not source controlled)
    return Uri.parse('$baseURL$omdbKey&query=$searchText&page=$pageNumber');
  }

  // Add authorization token for compatability with the TMDB V4 API.
  void constructHeaders(HttpHeaders headers) {
    headers.add('Authorization', ' Bearer ${env['TMDB_KEY']}');
  }
}
