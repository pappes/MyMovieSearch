import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_glo_torrents.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = '.ttable_headinner';
const magnetSelector = "[href^='magnet:']";

/// Implements [WebFetchBase] for the gloTorrents search html web scraper.
///
/// ```dart
/// ScrapeGloTorrentsSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeGloTorrentsSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = [];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText
        .contains('No torrents were found based on your search criteria.')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw 'gloTorrents results data not detected for criteria $getCriteriaText in html:$webText';
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
    if (9 == columns.length) {
      final result = {};

      //result[jsonCategoryKey] = columns[0].cleanText;
      result[jsonMagnetKey] =
          row.querySelector(magnetSelector)?.attributes['href'] ?? "";
      result[jsonNameKey] = columns[1].children.last.attributes['title'];
      result[jsonDescriptionKey] = columns[4].cleanText;
      result[jsonSeedersKey] = columns[5].cleanText;
      result[jsonLeechersKey] = columns[6].cleanText;

      if (result[jsonMagnetKey]!.toString().isNotEmpty &&
          result[jsonNameKey]!.toString().isNotEmpty &&
          result[jsonSeedersKey]!.toString().isNotEmpty) {
        movieData.add(result);
      }
    }
  }
}
