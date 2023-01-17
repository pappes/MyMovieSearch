import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

import 'package:universal_io/io.dart'
    show HttpHeaders; // limit inclusions to reduce size

/// Implements [WebFetchBase] for searching The Movie Database (TMDB).
///
/// The TMDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryTMDBMovieDetails().readList(criteria);
/// ```
abstract class QueryTMDBCommon
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  late DataSourceType source;
  late String baseURL;
  String midURL = '?api_key=';

  /// Must be orerridden by child classes.
  /// Static snapshot of data for offline operation.
  @override
  DataSourceFn myOfflineData();

  /// Must be orerridden by child classes.
  /// Convert TMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return source.name;
  }

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.toPrintableString();
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[${source.name}] $message',
        source,
      );

  /// API call to TMDB returning the movie details for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final omdbKey = dotenv
        .env['TMDB_KEY']; // From the file assets/.env (not source controlled)
    return Uri.parse('$baseURL$searchCriteria$midURL$omdbKey');
  }

  // Add authorization token for compatability with the TMDB V4 API.
  @override
  void myConstructHeaders(HttpHeaders headers) {
    headers.add('Authorization', ' Bearer ${dotenv.env['TMDB_KEY']}');
  }
}
