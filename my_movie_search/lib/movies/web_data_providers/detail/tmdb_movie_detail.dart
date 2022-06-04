import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_movie_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_movie_detail.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

import 'package:universal_io/io.dart' show HttpHeaders;

/// Implements [WebFetchBase] for searching The Movie Database (TMDB).
///
/// The TMDb API is a free web service to obtain movie information.
class QueryTMDBMovieDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://api.themoviedb.org/3/movie/';
  static const _midURL = '?api_key=';

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return DataSourceType.tmdbMovie.name;
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
    final criteria = contents as SearchCriteriaDTO;
    return criteria.criteriaTitle;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO();
    error.title = '[QueryTMDBDetails] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.tmdbMovie;
    return error;
  }

  /// API call to TMDB returning the movie details for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final omdbKey = dotenv
        .env['TMDB_KEY']; // From the file assets/.env (not source controlled)
    return Uri.parse('$_baseURL$searchCriteria$_midURL$omdbKey');
  }

  // Add authorization token for compatability with the TMDB V4 API.
  @override
  void myConstructHeaders(HttpHeaders headers) {
    headers.add('Authorization', ' Bearer ${dotenv.env['TMDB_KEY']}');
  }
}
