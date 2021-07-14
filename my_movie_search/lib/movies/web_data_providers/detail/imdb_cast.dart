import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:flutter/foundation.dart' show describeEnum;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb_cast.dart';
import 'offline/imdb_title.dart';

/// Implements [SearchProvider] for the IMDB search html webscraper.
class QueryIMDBCastDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://www.imdb.com/title/';
  static final baseURLsuffix = '/fullcredits/';

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
    return contents!.criteriaTitle;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    var url = '$baseURL$searchCriteria$baseURLsuffix';
    print("fetching imdb movie cast $url");
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
    var roleText;
    for (var credits
        in document.querySelector('#fullcredits_content')?.children ?? []) {
      roleText = getRole(credits) ?? roleText;
      var cast = getCast(credits);
      addCast(movieData, roleText ?? '?', cast);
    }
  }

  String? getRole(credits) {
    if (credits.classes.contains('dataHeaderWithBorder')) {
      var text = credits.text ??
          credits.attributes['id'] ??
          credits.attributes['name'];
      return text.trim().split('\n').first + ':';
    }
  }

  addCast(Map movieData, String role, dynamic cast) {
    if (!movieData.containsKey(role)) {
      movieData[role] = [];
    }
    movieData[role].addAll(cast);
  }

  List<Map> getCast(Element table) {
    List<Map> movies = [];
    for (var row in table.querySelectorAll('tr')) {
      Map person = {outer_element_official_title: ''};
      for (var link in row.querySelectorAll('a[href*="/name/nm"]')) {
        person[outer_element_official_title] +=
            link.text.trim().split('\n').first;
        person[outer_element_link] = link.attributes['href'];
      }
      if (person[outer_element_official_title].length > 0) {
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
