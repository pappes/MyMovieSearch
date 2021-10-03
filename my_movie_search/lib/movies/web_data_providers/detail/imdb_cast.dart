import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:flutter/foundation.dart' show describeEnum;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb_cast.dart';
import 'offline/imdb_title.dart';

/// Implements [WebFetchBase] for retrieving cast and crew information from IMDB.
class QueryIMDBCastDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://www.imdb.com/title/';
  static final baseURLsuffix = '/fullcredits/';
  static var cache = TieredCache();

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return describeEnum(DataSourceType.imdb);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbHtmlOfflineData;
  }

  /// Scrape cast data from rows in the html div named fullcredits_content.
  @override
  Stream<MovieResultDTO> baseTransformTextStreamToOutput(
      Stream<String> str) async* {
    // Combine all HTTP chunks together for HTML parsing.
    final content = await str.reduce((value, element) => '$value$element');

    var movieData = scrapeWebPage(content);
    yield* Stream.fromIterable(baseTransformMapToOutputHandler(movieData));
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.criteriaTitle;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    var url = '$baseURL$searchCriteria$baseURLsuffix';
    return WebRedirect.constructURI(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      ImdbCastConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    var error = MovieResultDTO().error();
    error.title = '[${this.runtimeType}] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }

  /// Check cache to see if data has already been fetched.
  @override
  bool myIsResultCached(SearchCriteriaDTO criteria) {
    return cache.isCached(criteria.criteriaTitle);
  }

  /// Check cache to see if data in cache should be refreshed.
  @override
  bool myIsCacheStale(SearchCriteriaDTO criteria) {
    return false;
    return cache.isCached(criteria.criteriaTitle);
  }

  /// Insert transformed data into cache.
  @override
  void myAddResultToCache(MovieResultDTO fetchedResult) {
    cache.add(fetchedResult.uniqueId, fetchedResult);
  }

  /// Retrieve cached result.
  @override
  Stream<MovieResultDTO> myFetchResultFromCache(
      SearchCriteriaDTO criteria) async* {
    var value = await cache.get(criteria.criteriaTitle);
    if (value is MovieResultDTO) {
      yield value;
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  Map scrapeWebPage(String content) {
    // Extract embedded JSON.
    var document = parse(content);
    Map movieData = {};

    scrapeRelated(document, movieData);

    movieData['id'] = getCriteriaText ?? movieData['id'];
    return movieData;
  }

  /// Extract the cast for the current movie.
  void scrapeRelated(Document document, Map movieData) {
    String? roleText;
    final children = document.querySelector('#fullcredits_content')?.children;
    if (null != children) {
      for (var credits in children) {
        roleText = _getRole(credits) ?? roleText;
        var cast = _getCast(credits);
        _addCast(movieData, roleText ?? '?', cast);
      }
    }
  }

  String? _getRole(Element credits) {
    if (credits.classes.contains('dataHeaderWithBorder')) {
      var text = credits.text;
      if (text.isEmpty) {
        text = credits.attributes['id'] ?? credits.attributes['name'] ?? '?';
      }
      return text.trim().split('\n').first + ':';
    }
  }

  _addCast(Map movieData, String role, dynamic cast) {
    if (!movieData.containsKey(role)) {
      movieData[role] = [];
    }
    movieData[role].addAll(cast);
  }

  List<Map> _getCast(Element table) {
    List<Map> movies = [];
    for (var row in table.querySelectorAll('tr')) {
      var title = '';
      var linkURL = '';
      for (var link in row.querySelectorAll('a[href*="/name/nm"]')) {
        title += link.text.trim().split('\n').first;
        linkURL = link.attributes['href'] ?? '';
      }
      if (title.isNotEmpty) {
        Map<String, String> person = {outer_element_official_title: title};
        person[outer_element_link] = linkURL;
        var charactor = row.querySelector('a[href*="/title/tt"]')?.text;
        if (null != charactor) {
          person[outer_element_alternate_title] = charactor;
        }
        movies.add(person);
      }
    }
    return movies;
  }
}
