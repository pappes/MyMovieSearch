import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_helper.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_eztv.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = 'tr.forum_header_border';
const magnetSelector = "[href^='magnet:']";
const nameSelector = 'a';
const seedSelector = '.forum_thread_post_end';
const descriptionAttribute = 'title';

/// Implements [WebFetchBase] for the MagnetEztv search html web scraper.
///
/// ```dart
/// ScrapeMagnetEztvSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeMagnetEztvSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = <Map<String, dynamic>>[];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, dynamic>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('No torrents found!')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw WebConvertException(
      'magnetEztv results data not detected for criteria '
      '$getCriteriaText in html:$webText',
    );
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    final rows = document.querySelectorAll(resultTableSelector);
    if (rows.isNotEmpty) {
      validPage = true;
      rows.forEach(_processRow);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final result = <String, dynamic>{};
    result[jsonMagnetKey] = MagnetHelper.addTrackers(
      row.querySelector(magnetSelector)?.attributes['href'],
    );
    result[jsonNameKey] = getName(row);
    result[jsonSeedersKey] = row.querySelector(seedSelector)?.cleanText;

    if (result[jsonMagnetKey] != null &&
        result[jsonNameKey] != null &&
        result[jsonSeedersKey] != null &&
        result[jsonSeedersKey] != '-' &&
        result[jsonMagnetKey]!.toString().isNotEmpty &&
        result[jsonNameKey]!.toString().isNotEmpty &&
        result[jsonSeedersKey]!.toString().isNotEmpty) {
      movieData.add(result);
    }
  }

  String? getName(Element row) {
    final elements = row.querySelectorAll(nameSelector);
    if (elements.length > 1) {
      final description = elements[1].attributes[descriptionAttribute]
          ?.toString();
      if (description != null) {
        return description;
      }
    }
    return null;
  }
}
