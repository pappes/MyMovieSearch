import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const tvdbApiPath = 'https://api4.thetvdb.com/v4/';
const requestsPerSecond = 30;
const tvdbTypeMapping = {
  'movie': MovieContentType.title,
  'series': MovieContentType.series,
  'people': MovieContentType.person,
  'episode': MovieContentType.episode,
};

const tvdbEndpointMapping = {
  MovieContentType.title: 'movies/',
  MovieContentType.series: 'series/',
  MovieContentType.person: 'people/',
  MovieContentType.episode: 'episodes/',
};

/// Implements [WebFetchBase] for searching The TV Database (TheTVDB).
///
/// The TVDb API is a free web service to obtain movie information.
/// Callers need to await init() before first use.
///
/// ```dart
/// QueryTVDBDetails().readList(criteria);
/// ```
abstract class QueryTVDBCommon
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryTVDBCommon(super.criteria) {
    unawaited(init());
  }

  static String? sessionKey;
  static final logedIn = Completer<bool>();
  static DateTime lastRequestTime = DateTime.now();

  late DataSourceType source;
  String midURL = 'search?query=';
  String suffixURL = '';

  /// Initialise the class for future calls;
  static Future<bool> init() {
    if (!logedIn.isCompleted) {
      logedIn.complete(login());
    }
    return logedIn.future;
  }

  /// Connect to the TVDB server and get a session key.
  static Future<bool> login() async {
    // Call 'https://api4.thetvdb.com/v4/login' to get a bearer token
    const tvdbLoginUrl = '${tvdbApiPath}login';
    const tvdbLoginAttributeName = 'apikey';
    const tvdbResult = 'status';
    const tvdbExpectedResult = 'success';
    const tvdbPayload = 'data';
    const tvdbAttribte = 'token';
    final tmdbKey = Settings().tvdbkey;

    // Send APIKey.
    final uri = Uri.parse(tvdbLoginUrl);
    final request = await HttpClient().postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('accept', 'application/json');
    final payload = jsonEncode({tvdbLoginAttributeName: tmdbKey});
    request.add(utf8.encode(payload));
    await request.flush();
    final response = await request.close();

    // Receive token.
    final responsetext = await response.transform(utf8.decoder).join();
    final jsonMap = jsonDecode(responsetext);
    if (jsonMap is Map &&
        jsonMap.containsKey(tvdbResult) &&
        jsonMap[tvdbResult] == tvdbExpectedResult) {
      final payload = jsonMap[tvdbPayload];
      if (payload is Map && payload.containsKey(tvdbAttribte)) {
        sessionKey = payload[tvdbAttribte]?.toString();
        return true;
      }
    }
    return false;
  }

  /// Must be overridden by child classes.
  /// Static snapshot of data for offline operation.
  @override
  DataSourceFn myOfflineData();

  /// Must be overridden by child classes.
  /// Convert TVDB map to MovieResultDTO records.
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

  /// API call to TVDB returning the movie details for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) =>
      Uri.parse('$tvdbApiPath$midURL$searchCriteria$suffixURL');

  // Add authorization token for compatibility with the TVDB V4 API.
  @override
  void myConstructHeaders(HttpHeaders headers) {
    // Get key from the file assets/secrets.json (not source controlled)
    headers
      ..add('Authorization', ' Bearer $sessionKey')
      ..add('accept', 'application/json');
  }

  /// Delay request so that a maximum of 10 requests are sent per second
  @override
  Future<void> myDelayRequest() {
    final nextRequestTime = lastRequestTime.add(
      // linter thinks this is zero
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
    /*if (webText.contains('data": []') || webText.contains('data": null')) {
      return [];
    }*/
    dynamic tree;
    try {
      // Assume text is json encoded.
      tree = jsonDecode(webText);
    } on FormatException {
      throw WebConvertException('Invalid json returned from web call $webText');
    }

    if (tree is Map) {
      if (tree.containsKey('data')) {
        return [tree];
      }
      if (tree.containsKey('message')) {
        throw WebConvertException(
          'TVDB call for criteria $getCriteriaText '
          'returned error:${tree['message']}',
        );
      }
    }

    throw WebConvertException(
      'TVDB results data not detected '
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
      // Cascade call to parent class.
      // ignore: invalid_use_of_visible_for_testing_member
      : super.myHttpError(address, statusCode, response);

  /// Convert TVDB map types to MovieResultDTO types.
  static MovieContentType typeToMovieContentType(String type) =>
      tvdbTypeMapping[type] ?? tvdbTypeMapping.values.first;

  /// Convert MovieResultDTO types to TVDB map types.
  static String typeToEndpoint(MovieContentType type) =>
      tvdbEndpointMapping[type] ?? tvdbEndpointMapping.values.first;
}
