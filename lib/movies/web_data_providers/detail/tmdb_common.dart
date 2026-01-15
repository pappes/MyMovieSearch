import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

import 'package:universal_io/io.dart'
    show HttpClientResponse, HttpHeaders; // limit inclusions to reduce size

const tmdbPosterPathPrefix = 'https://image.tmdb.org/t/p/w500';
const requestsPerSecond = 30;

/// Implements [WebFetchBase] for searching The Movie Database (TMDB).
///
/// The TMDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryTMDBMovieDetails().readList(criteria);
/// ```
abstract class QueryTMDBCommon
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryTMDBCommon(super.criteria);

  late DataSourceType source;
  late String baseURL;
  String midURL = '?api_key=';
  static DateTime lastRequestTime = DateTime.now();

  /// Must be overridden by child classes.
  /// Static snapshot of data for offline operation.
  @override
  DataSourceFn myOfflineData();

  /// Must be overridden by child classes.
  /// Convert TMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(dynamic map);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => source.name;

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableString();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) =>
      MovieResultDTO().error('[${source.name}] $message', source);

  /// API call to TMDB returning the movie details for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    // Get key from the file assets/secrets.json (not source controlled)
    final tmdbKey = Settings().tmdbkey;
    return Uri.parse('$baseURL$searchCriteria$midURL$tmdbKey');
  }

  // Add authorization token for compatability with the TMDB V4 API.
  @override
  void myConstructHeaders(HttpHeaders headers) {
    // Get key from the file assets/secrets.json (not source controlled)
    final tmdbKey = Settings().tmdbkey;
    headers.add('Authorization', ' Bearer $tmdbKey');
  }

  /// Delay request so that a maximum of 10 requests are sent per second
  @override
  Future<void> myDelayRequest() {
    final nextRequestTime = lastRequestTime.add(
      // flutter lints thinks this = 0
      // ignore: use_named_constants
      const Duration(milliseconds: millisecondsPerSecond ~/ requestsPerSecond),
    );
    lastRequestTime = DateTime.now();
    final delay = nextRequestTime.difference(lastRequestTime);
    if (!delay.isNegative) {
      return Future.delayed(delay);
    }
    return Future.value();
  }

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains(
      'movie_results":[],"person_results":[],'
      '"tv_results":[],"tv_episode_results":[],"tv_season_results":[]',
    )) {
      return [];
    }
    dynamic tree;
    try {
      // Assume text is json encoded.
      tree = jsonDecode(webText);
    } on FormatException {
      throw WebConvertException('Invalid json returned from web call $webText');
    }

    if (tree is Map) {
      if (tree.containsKey('movie_results') || tree.containsKey('imdb_id')) {
        return [tree];
      }
      if (tree.containsKey('status_message')) {
        throw WebConvertException(
          'tmdb call for criteria $getCriteriaText '
          'returned error:${tree['status_message']}',
        );
      }
    }

    throw WebConvertException(
      'tmdb results data not detected '
      'for criteria $getCriteriaText in json:$webText',
    );
  }

  /// Allow response parsing for http 404
  @override
  @visibleForTesting // and for override!
  Stream<String>? myHttpError(
    Uri address,
    int statusCode,
    HttpClientResponse response,
  ) => (404 == statusCode)
      ? null
      // Cascade clear to parent class.
      // ignore: invalid_use_of_visible_for_testing_member
      : super.myHttpError(address, statusCode, response);
}
