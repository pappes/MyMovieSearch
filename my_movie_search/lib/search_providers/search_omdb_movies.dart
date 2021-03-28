import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/search_providers/search_provider.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/temp_search_omdb_movies_data.dart';
import 'package:my_movie_search/search_providers/search_omdb_movie_converter.dart';

/// Implements [SearchProvider] for searching the Open Movie Database.
/// The OMDb API is a free web service to obtain movie information.
class QueryOMDBMovies extends SearchProvider<MovieResultDTO> {
  static final baseURL = "http://www.omdbapi.com/?apikey=";

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamOmdbJsonOfflineData;
  }

  // Convert OMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> transformMap(Map map) =>
      OmdbMovieSearchConverter.dtoFromCompleteJsonMap(map);

  // Include entire map in the movie title when an error occurs.
  @override
  List<MovieResultDTO> constructError(Map map) {
    var error = MovieResultDTO();
    error.title =
        "[${this.runtimeType}] Could not interpret response ${map.toString()}";
    error.type = MovieContentType.custom;
    error.source = DataSourceType.omdb;
    error.uniqueId = "-${error.source}";
    return [error];
  }

  /// API call to OMDB returning the top 10 matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    final omdbKey =
        env["OMDB_KEY"]; // From the file assets/.env (not source controlled)
    return Uri.parse("$baseURL$omdbKey&s=$searchText&page=$pageNumber");
  }
}
