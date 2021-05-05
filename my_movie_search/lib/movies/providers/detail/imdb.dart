import 'package:flutter/foundation.dart';

import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:my_movie_search/utilities/dom_extentions.dart';

import 'package:my_movie_search/utilities/provider_controller.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/providers/detail/converters/imdb.dart';
import 'package:my_movie_search/movies/providers/detail/offline/imdb.dart';

import 'package:my_movie_search/utilities/web_redirect.dart';

const SEARCH_RESULTS_TABLE = 'findList';
const COLUMN_MOVIE_TEXT = 'result_text';
const COLUMN_MOVIE_POSTER = 'primary_photo';

/// Implements [SearchProvider] for the IMDB search html webscraper.
class QueryIMDBSearch extends ProviderController<MovieResultDTO> {
  static final baseURL = 'https://www.imdb.com/title/';
  static final baseURLsuffix = '/?ref_=fn_tt_tt_1';

  /// Describe where the data is comming from.
  @override
  String dataSourceName() {
    return describeEnum(DataSourceType.imdb);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamImdbHtmlOfflineData;
  }

  /// Scrape movie data from rows in the html table named findList.
  @override
  Stream<List<MovieResultDTO>> transformStream(Stream<String> str) async* {
    // Combine all HTTP chunks together for HTML parsing
    var content = await str.reduce((value, element) => '$value\n$element');
    var document = parse(content);

    Map moviedata = {'id': str};

    getAttributeValue(moviedata, document, inner_element_rating_count);
    getAttributeValue(moviedata, document, inner_element_rating_value);

    yield transformMapSafe(moviedata);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> transformMap(Map map) =>
      ImdbSearchConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO constructError(String message) {
    var error = MovieResultDTO();
    error.title = '[${this.runtimeType}] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    var url = '$baseURL$searchText$baseURLsuffix';
    return WebRedirect.constructURI(url);
  }

  void getAttributeValue(Map moviedata, Document document, String attribute) {
    var elements = document.getElementsByTagName('E[itemprop="$attribute"]');
    for (var element in elements) {
      if (element.text.length > 1) moviedata[attribute] = element.text;
    }
  }
}
