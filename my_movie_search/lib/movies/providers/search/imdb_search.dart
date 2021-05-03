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
  //@override
  Stream<List<MovieResultDTO>> transformStream(Stream<String> str) async* {
    List<MovieResultDTO> convertedResults = [];

    //var content = await str.reduce((value, element) => value + element);
    var content = imdbHtmlSampleFull;
    var document = parse(content);

    var tables = document.getElementsByClassName(SEARCH_RESULTS_TABLE);
    for (var table in tables) {
      var rows = table.getElementsByType(ElementType.row);
      for (var row in rows) {
        var rowData = extractRowData(row);
        var dtos = transformMapSafe(rowData);
        convertedResults.addAll(dtos);
      }
    }

    yield convertedResults;
  }

  /// Convert HTML row element into a map individual field data.
  Map<String, String?> extractRowData(Element tableRow) {
    Map<String, String?> rowData = {};
    for (var tableColumn in tableRow.children) {
      if (tableColumn.className == COLUMN_MOVIE_TEXT) {
        rowData['Info'] = tableColumn.text;
        tableColumn.getElementsByType(ElementType.anchor).forEach((element) {
          rowData['anchorAddress'] =
              element.getAttribute(AttributeType.address);
          rowData['Title'] = element.text;
        });
      } else if (tableColumn.className == COLUMN_MOVIE_POSTER) {
        tableColumn.getElementsByType(ElementType.image).forEach((element) {
          rowData['image'] = element.getAttribute(AttributeType.source);
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
  List<MovieResultDTO> constructError(String message) {
    var error = MovieResultDTO();
    error.title = '[${this.runtimeType}] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    error.uniqueId = '-${error.source}';
    return [error];
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    var url = '$baseURL$searchText';
    return WebRedirect.constructURI(url);
  }
}
