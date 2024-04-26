import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrentz2.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = '.download';
const magnetSelector = "[href^='magnet:']";
const nameSelector = 'dt';
const detailSelector = 'dd';

/// Implements [WebFetchBase] for the Torrentz2 search html web scraper.
///
/// ```dart
/// ScrapeTorrentz2Search().readList(criteria, limit: 10)
/// ```
// ignore: missing_override_of_must_be_overridden
mixin ScrapeTorrentz2Search on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = <Map<String, dynamic>>[];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, dynamic>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('<h2>0+ Torrents ')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw WebConvertException(
        'Torrentz2 results data not detected for criteria '
        '$getCriteriaText in html:$webText');
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    for (final row in document.querySelectorAll('dl')) {
      validPage = true;
      _processRow(row);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final result = <String, dynamic>{};
    result[jsonNameKey] = row.querySelector(nameSelector)?.cleanText;
    result[jsonMagnetKey] =
        row.querySelector(magnetSelector)?.attributes['href'] ?? '';
    final columns = row.querySelector(detailSelector)?.children;

    if (5 == columns?.length) {
      result[jsonDescriptionKey] = columns![2].cleanText;
      result[jsonSeedersKey] = columns[3].cleanText;
      result[jsonLeechersKey] = columns[4].cleanText;
    }
    if (result[jsonMagnetKey]!.toString().isNotEmpty &&
        result[jsonNameKey]!.toString().isNotEmpty &&
        result[jsonSeedersKey]!.toString().isNotEmpty) {
      movieData.add(result);
    }
  }
}
