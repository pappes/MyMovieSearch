import 'package:flutter/foundation.dart';

import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:my_movie_search/utilities/dom_extentions.dart';

import 'package:my_movie_search/utilities/provider_controller.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/providers/search/converters/imdb_search.dart';
import 'package:my_movie_search/movies/providers/search/offline/imdb_search.dart';

import 'package:my_movie_search/utilities/web_redirect.dart';

const SEARCH_RESULTS_TABLE = 'findList';
const COLUMN_MOVIE_TEXT = 'result_text';
const COLUMN_MOVIE_POSTER = 'primary_photo';

/// Implements [SearchProvider] for the IMDB search html webscraper.
class QueryIMDBSearch extends ProviderController<MovieResultDTO> {
  static final baseURL = 'https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=';

  /// Describe where the data is comming from.
  @override
  String dataSourceName() {
    return describeEnum(DataSourceType.imdbSearch);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamImdbHtmlOfflineData;
  }

  /// Scrape movie data from html table(s) named findList.
  @override
  Stream<List<MovieResultDTO>> transformStream(Stream<String> str) async* {
    List<MovieResultDTO> convertedResults = [];

    // Combine all HTTP chunks together for HTML parsing
    var content = await str.reduce((value, element) => '$value\n$element');
    var document = parse(content);

    // Extract required tables from the dom (anthing named findList).
    var tables = document.getElementsByClassName(SEARCH_RESULTS_TABLE);
    extractRowsFromTables(tables).forEach(
        (rowData) => convertedResults.addAll(transformMapSafe(rowData)));

    yield convertedResults;
  }

  /// Extract movie data from rows in html table(s).
  List<Map> extractRowsFromTables(List<Element> tables) {
    List<Map> htmlMovies = [];

    for (var table in tables) {
      var rows = table.getElementsByType(ElementType.row);
      for (var row in rows) {
        htmlMovies.add(extractRowData(row));
      }
    }

    return htmlMovies;
  }

  /// Convert HTML row element into a map of individual field data.
  /// <a title>       -> Title
  /// <img>           -> Image
  /// <a href>        -> AnchorAddress
  /// <td> text </td> -> Info (year and type)
  Map<String, String?> extractRowData(Element tableRow) {
    Map<String, String?> rowData = {};
    for (var tableColumn in tableRow.children) {
      if (tableColumn.className == COLUMN_MOVIE_TEXT) {
        // <td> text </td> -> Info
        rowData[inner_element_info_element] = tableColumn.text;
        tableColumn.getElementsByType(ElementType.anchor).forEach((element) {
          // <a href> -> AnchorAddress
          rowData[inner_element_identity_element] =
              element.getAttribute(AttributeType.address);
          // <a title> -> Title
          rowData[inner_element_title_element] = element.text;
        });
      } else if (tableColumn.className == COLUMN_MOVIE_POSTER) {
        // <img> -> Image
        tableColumn.getElementsByType(ElementType.image).forEach((element) {
          rowData[inner_element_image_element] =
              element.getAttribute(AttributeType.source);
        });
      }
    }
    return rowData;
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
    error.source = DataSourceType.imdbSearch;
    return error;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    var url = '$baseURL$searchText';
    return WebRedirect.constructURI(url);
  }
}
