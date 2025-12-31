import 'dart:convert';
import 'dart:io';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/omdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/omdb.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const omdbJsonSearchEmpty = '{"Response":"False","Error":"Movie not found!"}';

/// Implements [WebFetchBase] for searching the Open Movie Database.
///
/// The OMDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryOMDBMovies().readList(criteria, limit: 10)
/// ```
class QueryOMDBMovies extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryOMDBMovies(super.criteria);

  static const _baseURL = 'https://www.omdbapi.com/?apikey=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.omdb.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamOmdbJsonOfflineData;

  /// Convert OMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) return OmdbMovieSearchConverter.dtoFromCompleteJsonMap(map);
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableString();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) =>
      MovieResultDTO().error('[QueryOMDBMovies] $message', DataSourceType.omdb);

  /// API call to OMDB returning the top 10 matching results
  /// for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    // Get key from the file assets/secrets.json (not source controlled)
    final omdbKey = Settings().omdbkey;
    return Uri.parse('$_baseURL$omdbKey&s=$searchCriteria&page=$pageNumber');
  }

  // Set YTS specific headers
  @override
  void myConstructHeaders(HttpHeaders headers) {
    super.myConstructHeaders(headers);
    // prevent invalid UTF encoding.
    headers
      ..set(
        'accept',
        'text/html,application/xhtml+xml,application/xml',
        // do not accept ;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7,
      )
      ..set('accept-encoding', 'text/plain');
  }

  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (omdbJsonSearchEmpty == webText) return [];
    try {
      // Assume text is json encoded.
      final tree = jsonDecode(webText);
      return [tree];
    } on FormatException {
      throw WebConvertException('Invalid json returned from web call $webText');
    }
  }
}
