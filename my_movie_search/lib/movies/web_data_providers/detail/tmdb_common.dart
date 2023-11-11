import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

import 'package:universal_io/io.dart'
    show HttpClientResponse, HttpHeaders; // limit inclusions to reduce size

const tmdbPosterPathPrefix = 'https://image.tmdb.org/t/p/w500';

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

  QueryTMDBCommon(super.criteria);

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
  String myDataSourceName() => source.name;

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableString();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[${source.name}] $message',
        source,
      );

  /// API call to TMDB returning the movie details for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    // Get key from the file assets/secrets.json (not source controlled)
    final omdbKey = Settings.singleton().get('TMDB_KEY');
    return Uri.parse('$baseURL$searchCriteria$midURL$omdbKey');
  }

  // Add authorization token for compatability with the TMDB V4 API.
  @override
  void myConstructHeaders(HttpHeaders headers) {
    // Get key from the file assets/secrets.json (not source controlled)
    final omdbKey = Settings.singleton().get('TMDB_KEY');
    headers.add('Authorization', ' Bearer $omdbKey');
  }

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains(
      'movie_results":[],"person_results":[],"tv_results":[],"tv_episode_results":[],"tv_season_results":[]',
    )) {
      return [];
    }
    dynamic tree;
    try {
      // Assume text is json encoded.
      tree = jsonDecode(webText);
    } catch (jsonException) {
      throw 'Invalid json returned from web call $webText';
    }

    if (tree is Map) {
      if (tree.containsKey('movie_results') || tree.containsKey('imdb_id')) {
        return [tree];
      }
      if (tree.containsKey('status_message')) {
        throw 'tmdb call for criteria $getCriteriaText returned error:${tree['status_message']}';
      }
    }

    throw 'tmdb results data not detected for criteria $getCriteriaText in json:$webText';
  }

  /// Allow response parsing for http 404
  @override
  Stream<String>? myHttpError(
    Uri address,
    int statusCode,
    HttpClientResponse response,
  ) =>
      (404 == statusCode)
          ? null
          // ignore: invalid_use_of_visible_for_testing_member
          : super.myHttpError(
              address,
              statusCode,
              response,
            );
}
