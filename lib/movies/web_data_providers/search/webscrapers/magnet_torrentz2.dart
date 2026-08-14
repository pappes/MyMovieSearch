import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_helper.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrentz2.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = '.download';
const magnetSelector = "[href^='magnet:']";
const nameSelector = 'dt';
const nameLinkSelector = 'a';
const detailSelector = 'dd';

/// Implements [WebFetchBase] for the Torrentz2 search html web scraper.
///
/// ```dart
/// ScrapeTorrentz2Search().readList(criteria, limit: 10)
/// ```
mixin ScrapeTorrentz2Search on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = <Map<String, Object?>>[];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, Object?>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('<h2>0 Torrents ')) {
      return [];
    }
    final document = parse(webText);
    await _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw WebConvertException(
      'Torrentz2 results data not detected for criteria '
      '$getCriteriaText in html:$webText',
    );
  }

  /// extract each row from the table.
  Future<void> _scrapeWebPage(Document document) async {
    for (final row in document.querySelectorAll('dl')) {
      validPage = true;
      await _processRow(row);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  Future<void> _processRow(Element row) async {
    final result = <String, Object?>{};
    final nameElement = row.querySelector(nameSelector);
    result[jsonNameKey] = nameElement?.cleanText;
    result[jsonMagnetKey] = row
        .querySelector(magnetSelector)
        ?.attributes['href'];
    if (result[jsonMagnetKey] != null) {
      result[jsonMagnetKey] = MagnetHelper.addTrackers(
        row.querySelector(magnetSelector)?.attributes['href'],
      );
    } else {
      result[jsonMagnetKey] = await lookupMagnetUrl(
        nameElement?.querySelector(nameLinkSelector)?.attributes['href'],
        nameElement?.cleanText,
      );
    }
    final columns = row.querySelector(detailSelector)?.children;

    final columnsLength = columns?.length;
    if (columnsLength != null && columnsLength >= 3) {
      result[jsonDescriptionKey] = columns![columnsLength - 3].cleanText;
      result[jsonSeedersKey] = columns[columnsLength - 2].cleanText;
      result[jsonLeechersKey] = columns[columnsLength - 1].cleanText;
    }
    if (result[jsonMagnetKey] != null &&
        result[jsonNameKey] != null &&
        result[jsonSeedersKey] != null &&
        result[jsonMagnetKey]!.toString().isNotEmpty &&
        result[jsonNameKey]!.toString().isNotEmpty &&
        result[jsonSeedersKey]!.toString().isNotEmpty) {
      movieData.add(result);
    }
  }

  Future<String?> lookupMagnetUrl(String? source, String? name) async {
    if (source == null || source.isEmpty) {
      return null;
    }
    final response = await http.get(Uri.parse('$torrentz2BaseURL$source'));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      return MagnetHelper.addTrackers(
        document.querySelector(magnetSelector)?.attributes['href'],
      );
    }
    return null;
  }
}
