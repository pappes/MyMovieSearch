import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/tmdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/tmdb.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

import 'package:universal_io/io.dart' show HttpHeaders;

/// Implements [WebFetchBase] for searching the The Movie Database (TMDB).
///
/// The OMDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryTMDBMovies().readList(criteria, limit: 10)
/// ```
class QueryTMDBMovies extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://api.themoviedb.org/3/search/movie?api_key=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return DataSourceType.tmdbSearch.name;
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamTmdbJsonOfflineData;

  /// Convert TMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) return TmdbMovieSearchConverter.dtoFromCompleteJsonMap(map);
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.toPrintableString();
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryTMDBMovies] $message',
        DataSourceType.tmdbSearch,
      );

  /// API call to TMDB returning the top 10 matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final omdbKey = dotenv
        .env['TMDB_KEY']; // From the file assets/.env (not source controlled)
    return Uri.parse(
      '$_baseURL$omdbKey&query=$searchCriteria&page=$pageNumber',
    );
  }

  // Add authorization token for compatability with the TMDB V4 API.
  @override
  void myConstructHeaders(HttpHeaders headers) {
    headers.add('Authorization', ' Bearer ${dotenv.env['TMDB_KEY']}');
  }
}
