import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_solid_torrents.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const magnetSelector = "[href^='magnet:']";
const nameSelector = '.title';
const categorySelector = '.category';
const detailSelector = '.stats';

/// Implements [WebFetchBase] for the SolidTorrents search html web scraper.
///
/// ```dart
/// ScrapeSolidTorrentsSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeSolidTorrentsSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = <Map>[];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('Found <b>0</b> results')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw 'SolidTorrents results data not detected for criteria $getCriteriaText in html:$webText';
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    final rows = document.querySelectorAll('li');
    for (final row in rows) {
      validPage = true;
      _processRow(row);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final result = <String, dynamic>{};
    final details = row.querySelectorAll(detailSelector);
    if (details.isNotEmpty) {
      final stats = details.first;
      if (5 == stats.children.length) {
        result[jsonDescriptionKey] = stats.cleanText;
        result[jsonCategoryKey] =
            row.querySelector(categorySelector)?.cleanText;
        result[jsonMagnetKey] =
            row.querySelector(magnetSelector)?.attributes['href'] ?? "";
        result[jsonNameKey] = row.querySelector(nameSelector)?.cleanText;
        result[jsonSeedersKey] = stats.children[2].cleanText;
        result[jsonLeechersKey] = stats.children[3].cleanText;

        if (result[jsonMagnetKey]!.toString().isNotEmpty &&
            result[jsonNameKey]!.toString().isNotEmpty &&
            result[jsonSeedersKey]!.toString().isNotEmpty) {
          movieData.add(result);
        }
      }
    }
  }
}
