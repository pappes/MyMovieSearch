import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_magnet_dl.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = '.download';
const magnetSelector = "[href^='magnet:']";
const nameSelector = '.n';
const detailSelector = '.t2';
const seedSelector = '.s';
const leechSelector = '.l';

/// Implements [WebFetchBase] for the MagnetDl search html web scraper.
///
/// ```dart
/// ScrapeMagnetDlSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeMagnetDlSearch on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = [];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('Your search has returned <strong>0</strong>')) {
      return [];
    }
    if (webText.contains(
        'The download may have been removed or search query blocked due to copyright complaint. We apologize for the inconvenience')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw 'magnetDl results data not detected for criteria $getCriteriaText in html:$webText';
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
    final result = {};
    result[jsonCategoryKey] = row.querySelector(detailSelector)?.cleanText;
    result[jsonMagnetKey] =
        row.querySelector(magnetSelector)?.attributes['href'] ?? "";
    result[jsonNameKey] = row.querySelector(nameSelector)?.cleanText;
    result[jsonDescriptionKey] =
        row.querySelector(seedSelector)?.previousElementSibling?.cleanText;
    result[jsonSeedersKey] = row.querySelector(seedSelector)?.cleanText;
    result[jsonLeechersKey] = row.querySelector(leechSelector)?.cleanText;

    if (result[jsonMagnetKey]!.toString().isNotEmpty &&
        result[jsonNameKey]!.toString().isNotEmpty &&
        result[jsonSeedersKey]!.toString().isNotEmpty) {
      movieData.add(result);
    }
  }
}
