import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrent_download.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = '.table2';
const detailLinkSelector = "a";
const nameSelector = '.tdleft';
const seedSelector = '.tdseed';
const leechSelector = '.tdleech';
const descriptionSelector = '.tdnormal';

/// Implements [WebFetchBase] for the TorrentDownload search html web scraper.
///
/// ```dart
/// ScrapeTorrentDownloadSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeTorrentDownloadSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = [];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('<h2>No Results Found</h2>')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw 'TorrentDownload results data not detected for criteria $getCriteriaText in html:$webText';
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    final tables = document.querySelectorAll(resultTableSelector);
    for (final table in tables) {
      for (final row in table.querySelectorAll('tr')) {
        if (row.children.length > 4) {
          validPage = true;
          _processRow(row);
        }
      }
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final result = {};
    result[jsonNameKey] = row.querySelector(nameSelector)?.cleanText;
    result[jsonSeedersKey] = row.querySelector(seedSelector)?.cleanText;
    result[jsonLeechersKey] = row.querySelector(leechSelector)?.cleanText;

    final path = row.querySelector(detailLinkSelector)?.attributes['href'];
    if (null != path) {
      result[jsonDetailLink] =
          myConstructURI('sample').resolve(path).toString();
    }

    result[jsonDescriptionKey] =
        row.querySelectorAll(descriptionSelector).last.cleanText;
    if (result[jsonDetailLink]!.toString().isNotEmpty &&
        result[jsonNameKey]!.toString().isNotEmpty &&
        result[jsonSeedersKey]!.toString().isNotEmpty) {
      movieData.add(result);
    }
  }
}
