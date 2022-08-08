import 'package:html/dom.dart' show Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_search.dart';
import 'package:my_movie_search/utilities/extensions/dom_extentions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const _searchResultsTable = 'findList';
const _columnMovieText = 'result_text';
const _columnMoviePoster = 'primary_photo';

/// Implements [WebFetchBase] for the IMDB search html webscraper.
///
/// ```dart
/// QueryIMDBSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeIMDBSearchDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Scrape movie data from html table(s) named findList.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    // Extract required tables from the dom (anything named findList).
    final tables = document.getElementsByClassName(_searchResultsTable);
    final list = _extractRowsFromTables(tables);
    if (list.isNotEmpty) return list;
    throw 'no search results found in $webText';
  }

  /// Extract movie data from rows in html table(s).
  List<Map> _extractRowsFromTables(List<Element> tables) {
    final htmlMovies = <Map>[];

    for (final table in tables) {
      final rows = table.getElementsByType(ElementType.row);
      for (final row in rows) {
        htmlMovies.add(_extractRowData(row));
      }
    }

    return htmlMovies;
  }

  /// Convert HTML row element into a map of individual field data.
  /// <a title>       -> Title
  /// <img>           -> Image
  /// <a href>        -> AnchorAddress
  /// <td> text </td> -> Info (year and type)
  Map<String, String?> _extractRowData(Element tableRow) {
    final rowData = <String, String?>{};
    for (final tableColumn in tableRow.children) {
      if (tableColumn.className == _columnMovieText) {
        // <td> text </td> -> Info
        rowData[innerElementInfo] = tableColumn.text;
        tableColumn.getElementsByType(ElementType.anchor).forEach((element) {
          // <a href> -> AnchorAddress
          rowData[innerElementIdentity] =
              element.getAttribute(AttributeType.address);
          // <a title> -> Title
          rowData[innerElementTitle] = element.text;
        });
      } else if (tableColumn.className == _columnMoviePoster) {
        // <img> -> Image
        tableColumn.getElementsByType(ElementType.image).forEach((element) {
          rowData[innerElementImage] =
              element.getAttribute(AttributeType.source);
        });
      }
    }
    return rowData;
  }
}
