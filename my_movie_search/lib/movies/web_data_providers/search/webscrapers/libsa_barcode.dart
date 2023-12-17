import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/libsa_barcode.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultRowsSelector = '.results_cell';
const jpgPictureSelector = '.results_img';
const titleSelector = '.displayDetailLink';
const yearSelector = '.displayElementText.PUBDATE';
// '#results_bio0 > span.thumb_hidden.PUBDATE > div >
// div.displayElementText.text-p.highlightMe.PUBDATE'

/// Implements [WebFetchBase] for the LibsaBarcode search html web scraper.
///
/// ```dart
/// ScrapeLibsaBarcodeSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeLibsaBarcodeSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = <Map<String, dynamic>>[];
  bool validPage = false;
  final searchLog = StringBuffer();

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, dynamic>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('No results found in Search Results.')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw WebConvertException(
      'LibsaBarcode results data not detected for criteria '
      '$getCriteriaText in html:$webText',
    );
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    final rows = document.querySelectorAll(resultRowsSelector);
    searchLog.writeln('rowSelector found ${rows.length} rows');
    for (final row in rows) {
      validPage = true;
      _processRow(row);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final result = <String, dynamic>{};
    final rawDescription = row.querySelector(titleSelector)?.cleanText ?? '';
    final rawYear =
        row.querySelector(yearSelector)?.cleanText.replaceAll('\r', ' ') ?? '';
    final cleanYear = getYear(rawYear) ?? '';
    final cleanDescription = rawDescription
        .replaceAll('dvd', '')
        .replaceAll('DVD', '')
        .replaceAll('[]', '')
        .replaceAll(' .', '');
    result[jsonCleanDescriptionKey] = '$cleanDescription $cleanYear';
    result[jsonRawDescriptionKey] = '$rawDescription $rawYear';
    result[jsonUrlKey] =
        row.querySelector(jpgPictureSelector)?.attributes['src'];
    movieData.add(result);
  }
}
