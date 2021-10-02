import 'package:flutter/foundation.dart' show describeEnum;
import 'package:universal_io/io.dart' show HttpHeaders;

import 'package:flutter_dotenv/flutter_dotenv.dart' show env;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'offline/tmdb.dart';
import 'converters/tmdb.dart';

/// Implements [WebFetchBase] for searching the The Movie Database (TMDB).
/// The OMDb API is a free web service to obtain movie information.
class QueryTMDBDetails extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://api.themoviedb.org/3/movie/';
  static final midURL = '?api_key=';

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return describeEnum(DataSourceType.tmdb);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamTmdbJsonOfflineData;

  /// Convert TMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      TmdbMovieDetailConverter.dtoFromCompleteJsonMap(map);

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    return contents!.criteriaTitle;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    var error = MovieResultDTO();
    error.title = '[${this.runtimeType}] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.tmdb;
    return error;
  }

  /// API call to TMDB returning the movie details for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final omdbKey =
        env['TMDB_KEY']; // From the file assets/.env (not source controlled)
    return Uri.parse('$baseURL$searchCriteria$midURL$omdbKey');
  }

  // Add authorization token for compatability with the TMDB V4 API.
  void myConstructHeaders(HttpHeaders headers) {
    headers.add('Authorization', ' Bearer ${env['TMDB_KEY']}');
  }
}
