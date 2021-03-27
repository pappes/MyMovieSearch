import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/search_providers/search_provider.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/temp_search_tmdb_movies_data.dart';
import 'package:my_movie_search/search_providers/search_tmdb_movie_converter.dart';

/// Implements [SearchProvider] for searching the Open Movie Database.
/// The OMDb API is a free web service to obtain movie information.
class QueryTMDBMovies extends SearchProvider<MovieResultDTO> {
  static final baseURL = "https://api.themoviedb.org/3/search/movie?api_key=";

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamTmdbJsonOfflineData;
  }

  /// Convert from [json] [Stream] to
  /// a stream containing a [List] of [MovieResultDTO].
  @override
  Stream<List<MovieResultDTO>> transformStream(Stream<String> str) {
    return str
        .transform(json.decoder)
        .map((event) => TmdbMovieSearchConverter.dtoFromCompleteJsonMap(event));
  }

  /// API call to OMDB returning the top 10 matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    final omdbKey =
        env["TMDB_KEY"]; // From the file assets/.env (not source controlled)
    return Uri.parse("$baseURL$omdbKey&query=$searchText&page=$pageNumber");
  }

  /// Define custom headers for this search provider.
  Map constructHeaders() {
    Map headers = {};
    headers["Authorization"] = " Bearer ${env["TMDB_KEY"]}";
    return headers;
  }
}
