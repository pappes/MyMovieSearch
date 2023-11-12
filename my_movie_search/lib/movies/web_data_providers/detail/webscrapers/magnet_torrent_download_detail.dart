import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_torrent_download_detail.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const magnetSelector = "[href^='magnet:']";
const resultTableSelector = '.torrentcontent';

/// Implements [WebFetchBase] for the TorrentDownload search html web scraper.
///
/// ```dart
/// ScrapeTorrentDownloadDetail().readList(criteria, limit: 10)
/// ```
mixin ScrapeTorrentDownloadDetail
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = <Map<String, dynamic>>[];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, dynamic>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('<b>TOP torrents last week</b>')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw 'TorrentDownload results data not detected for criteria $getCriteriaText in html:$webText';
  }

  /// extract each row from the page.
  void _scrapeWebPage(Document document) {
    final result = <String, dynamic>{};
    final links = document.querySelectorAll(magnetSelector);
    if (links.isNotEmpty) {
      validPage = true;
      result[jsonDetailLink] = links.first.attributes['href'];
      final fileTable = document.querySelectorAll(resultTableSelector);
      if (1 == fileTable.length) {
        result[jsonDescriptionKey] = fileTable.first.cleanText;
      }
      movieData.add(result);
    }
  }
}
