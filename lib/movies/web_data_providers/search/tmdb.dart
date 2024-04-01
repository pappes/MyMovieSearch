import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/tmdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/tmdb.dart';
import 'package:my_movie_search/utilities/settings.dart';
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
  QueryTMDBMovies(super.criteria);

  static const _baseURL = 'https://api.themoviedb.org/3/search/movie?api_key=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.tmdbSearch.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamTmdbJsonOfflineData;

  /// Convert TMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) return TmdbMovieSearchConverter.dtoFromCompleteJsonMap(map);
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableString();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryTMDBMovies] $message',
        DataSourceType.tmdbSearch,
      );

  /// API call to TMDB returning the top 10 matching results
  /// for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    // Get key from the file assets/secrets.json (not source controlled)
    final tmdbKey = Settings.singleton().get('TMDB_KEY');
    return Uri.parse(
      '$_baseURL$tmdbKey&query=$searchCriteria&page=$pageNumber',
    );
  }

  // Add authorization token for compatability with the TMDB V4 API.
  @override
  void myConstructHeaders(HttpHeaders headers) {
    // Get key from the file assets/secrets.json (not source controlled)
    final tmdbKey = Settings.singleton().get('TMDB_KEY');
    headers.add('Authorization', ' Bearer $tmdbKey');
  }

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('The resource you requested could not be found')) {
      return [];
    }
    try {
      // Assume text is json encoded.
      final tree = jsonDecode(webText);
      return [tree];
    } on FormatException {
      throw WebConvertException('Invalid json returned from web call $webText');
    }
  }
}
