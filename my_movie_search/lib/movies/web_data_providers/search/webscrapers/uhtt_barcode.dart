import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/uhtt_barcode.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = 'tbody tr';

/// Implements [WebFetchBase] for the UhttBarcode search html web scraper.
///
/// ```dart
/// ScrapeUhttBarcodeSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeUhttBarcodeSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = [];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (!webText.contains('class="uhtt-view--goods-table-item"')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw 'UhttBarcode results data not detected for criteria $getCriteriaText in html:$webText';
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    final firstRow = document.querySelector(resultTableSelector);
    if (firstRow != null) {
      validPage = true;
      _processRow(firstRow);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final result = {};
    final columns = row.children;
    if (4 == columns.length) {
      result[jsonDescriptionKey] = columns[1].cleanText;
      result[jsonIdKey] = columns[3].cleanText;
      movieData.add(result);
    }
  }
}
