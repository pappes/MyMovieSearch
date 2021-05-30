import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/provider_controller.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/omdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/omdb.dart';

/// Implements [SearchProvider] for searching the Open Movie Database.
/// The OMDb API is a free web service to obtain movie information.
class QueryOMDBMovies extends ProviderController<MovieResultDTO> {
  static final baseURL = "http://www.omdbapi.com/?apikey=";

  /// Describe where the data is comming from.
  @override
  String dataSourceName() {
    return describeEnum(DataSourceType.omdb);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamOmdbJsonOfflineData;
  }

  /// Convert OMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> transformMap(Map map) =>
      OmdbMovieSearchConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO constructError(String message) {
    var error = MovieResultDTO();
    error.title = "[${this.runtimeType}] $message";
    error.type = MovieContentType.custom;
    error.source = DataSourceType.omdb;
    return error;
  }

  /// API call to OMDB returning the top 10 matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    final omdbKey =
        env["OMDB_KEY"]; // From the file assets/.env (not source controlled)
    return Uri.parse("$baseURL$omdbKey&s=$searchText&page=$pageNumber");
  }
}
