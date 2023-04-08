import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape_small.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tpb_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = '#searchResult';
const magnetSelector = "[href^='magnet:']";
const nameSelector = '.detName';
const detailSelector = '.detDesc';

/// Implements [WebFetchBase] for the Tpb search html web scraper.
///
/// ```dart
/// ScrapeTpbSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeTpbSearch on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final htmlDecode = HtmlUnescape();
  final movieData = [];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw 'tpb results data not detected for criteria $getCriteriaText in html:$webText';
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    final rows = document.querySelector(resultTableSelector);
    if (null != rows) {
      validPage = true;
      for (final row in rows.querySelectorAll('tr')) {
        _processRow(row);
      }
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final columns = row.querySelectorAll('td');
    if (4 == columns.length) {
      final result = {};
      result[jsonCategoryKey] = cleanText(columns[0].text);
      result[jsonMagnetKey] =
          columns[1].querySelector(magnetSelector)?.attributes['href'] ?? "";
      result[jsonNameKey] =
          cleanText(columns[1].querySelector(nameSelector)?.text);
      result[jsonDescriptionKey] =
          cleanText(columns[1].querySelector(detailSelector)?.text);
      result[jsonSeedersKey] = cleanText(columns[2].text);
      result[jsonLeechersKey] = cleanText(columns[3].text);

      if (result[jsonMagnetKey]!.toString().isNotEmpty &&
          result[jsonNameKey]!.toString().isNotEmpty &&
          result[jsonSeedersKey]!.toString().isNotEmpty) {
        movieData.add(result);
      }
    }
  }

  String cleanText(dynamic text) {
    final str = text?.toString() ?? "";
    final cleanStr = str
        .replaceAll('\n', '')
        .replaceAll('\t', '')
        .replaceAll('\u{00a0}', '');
    return htmlDecode.convert(cleanStr.trim());
  }
}
