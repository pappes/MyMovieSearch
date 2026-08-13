import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_helper.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_magnet_dl.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = '.download';
const magnetSelector = "[href^='magnet:']";
const magnetHashSelector = 'dl.col2 > dd';
const magnetUrlSelector = 'a';
const nameSelector = 'td:not([class]), td[class=""]';
const detailSelector = 'td:nth-child(5)'; // 5th column
const seedSelector = '.s';
const leechSelector = '.l';

/// Implements [WebFetchBase] for the MagnetDl search html web scraper.
///
/// ```dart
/// ScrapeMagnetDlSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeMagnetDlSearch on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = <Map<String, Object?>>[];
  bool validPage = false;

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, Object?>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.isEmpty) {
      return [];
    }
    const start = ' <html> <body> <table class="download"> <tbody> ';
    const end = ' </tbody> </table> </body> </html> ';
    final document = parse('$start $webText $end');
    await _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw WebConvertException(
      'magnetDl results data not detected for criteria '
      '$getCriteriaText in html:$webText',
    );
  }

  /// extract each row from the table.
  Future<void> _scrapeWebPage(Document document) async {
    final rows = document.querySelectorAll('tr');
    if (rows.isNotEmpty) {
      validPage = true;
      final futures = <Future<void>>[];
      for (final row in rows) {
        futures.add(_processRow(row));
      }
      await Future.wait(futures);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  Future<void> _processRow(Element row) async {
    final result = <String, Object?>{};
    final nameCell = row.querySelector(nameSelector);
    result[jsonNameKey] = nameCell?.cleanText;
    result[jsonMagnetKey] = row
        .querySelector(magnetSelector)
        ?.attributes['href'];
    if (result[jsonMagnetKey] != null) {
      result[jsonMagnetKey] = MagnetHelper.addTrackers(
        result[jsonMagnetKey].toString(),
      );
    } else {
      result[jsonMagnetKey] = await lookupMagnetUrl(
        nameCell?.querySelector(magnetUrlSelector)?.attributes['href'],
        nameCell?.cleanText,
      );
    }
    final seedElement = row.querySelector(seedSelector);
    final descriptionElement = seedElement?.previousElementSibling;
    final categoryElement = descriptionElement?.previousElementSibling;
    result[jsonCategoryKey] = categoryElement?.cleanText;
    result[jsonDescriptionKey] = descriptionElement?.cleanText;
    result[jsonSeedersKey] = seedElement?.cleanText;
    result[jsonLeechersKey] = row.querySelector(leechSelector)?.cleanText;

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
    final response = await http.get(Uri.parse(source));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final hash = document.querySelectorAll(magnetHashSelector).last.cleanText;
      if (hash.isNotEmpty) {
        return MagnetHelper.createMagnet(hash, name);
      }
    }
    return null;
  }
}
