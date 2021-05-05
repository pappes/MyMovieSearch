import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart'
    show HttpHeaders; // limit inclusions to reduce size

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/utilities/provider_controller.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/providers/search/offline/tmdb.dart';
import 'package:my_movie_search/movies/providers/search/converters/tmdb.dart';

/// Implements [SearchProvider] for searching the The Movie Database (TMDB).
/// The OMDb API is a free web service to obtain movie information.
class QueryTMDBMovies extends ProviderController<MovieResultDTO> {
  static final baseURL = 'https://api.themoviedb.org/3/search/movie?api_key=';

  /// Describe where the data is comming from.
  @override
  String dataSourceName() {
    return describeEnum(DataSourceType.tmdb);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() => streamTmdbJsonOfflineData;

  /// Convert TMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> transformMap(Map map) =>
      TmdbMovieSearchConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO constructError(String message) {
    var error = MovieResultDTO();
    error.title = '[${this.runtimeType}] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.tmdb;
    return error;
  }

  /// API call to TMDB returning the top 10 matching results for [searchText].
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
