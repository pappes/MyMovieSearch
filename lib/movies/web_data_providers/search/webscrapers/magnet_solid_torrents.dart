import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_helper.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_solid_torrents.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const tableSelector = '.space-y-4 > .bg-white';
const magnetSelector = "[href^='magnet:']";
const nameSelector = 'h1, h2, h3, h4, h5, h6, h7';
const categorySelector = '.fa-file';
const sizeSelector = '.fa-download';
const seedsSelector = '.fa-arrow-up';
const leechersSelector = '.fa-arrow-down';
//const detailSelector = '.stats';

/// Implements [WebFetchBase] for the SolidTorrents search html web scraper.
///
/// ```dart
/// ScrapeSolidTorrentsSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeSolidTorrentsSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = <Map<String, Object?>>[];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, Object?>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final regex = RegExp('Found.*>0<.* results');
    if (regex.hasMatch(webText)) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw WebConvertException(
      'SolidTorrents results data not detected for criteria '
      '$getCriteriaText in html:$webText',
    );
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    final rows = document.querySelectorAll(tableSelector);
    for (final row in rows) {
      validPage = true;
      _processRow(row);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final result = <String, Object?>{};
    result[jsonDescriptionKey] = row
        .querySelector(sizeSelector)
        ?.nextElementSibling
        ?.cleanText;
    result[jsonCategoryKey] = row
        .querySelector(categorySelector)
        ?.nextElementSibling
        ?.cleanText;
    result[jsonMagnetKey] = MagnetHelper.addTrackers(
      row.querySelector(magnetSelector)?.attributes['href'],
    );
    result[jsonNameKey] = row.querySelector(nameSelector)?.cleanText;
    result[jsonSeedersKey] = row
        .querySelector(seedsSelector)
        ?.nextElementSibling
        ?.cleanText;
    result[jsonLeechersKey] = row
        .querySelector(leechersSelector)
        ?.nextElementSibling
        ?.cleanText;

    if (result[jsonMagnetKey] != null &&
        result[jsonNameKey] != null &&
        result[jsonSeedersKey] != null &&
        result[jsonMagnetKey]!.toString().isNotEmpty &&
        result[jsonNameKey]!.toString().isNotEmpty &&
        result[jsonSeedersKey]!.toString().isNotEmpty) {
      movieData.add(result);
    }
  }
}
