import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/fishpond_barcode.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultSelector = 'div .summary-top';
const resultHeaderSelector = 'header';
const jpgPictureSelector = 'img';
const titleSelector = 'h1';
const yearSelector = '.year';

/// Implements [WebFetchBase] for the FishpondBarcode search html web scraper.
///
/// ```dart
/// ScrapeFishpondBarcodeSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeFishpondBarcodeSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = [];
  bool validPage = false;
  final searchLog = StringBuffer();

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('did not match any items')) {
      return [];
    }
    final document = parse(webText);
    _scrapeWebPage(document);
    if (validPage) {
      return movieData;
    }
    throw 'FishpondBarcode results data not detected log: $searchLog for criteria $getCriteriaText in html:$webText';
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    final results = document.querySelectorAll(resultSelector);
    searchLog.writeln('resultSelector found ${results.length} result');
    for (final result in results) {
      validPage = true;
      _processRow(result);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final result = {};
    final rawDescription = row.querySelector(titleSelector)?.cleanText ?? '';
    final rawYear = row.querySelector(yearSelector)?.cleanText ?? '';
    result[jsonRawDescriptionKey] = '$rawDescription $rawYear';
    result[jsonUrlKey] =
        row.querySelector(jpgPictureSelector)?.attributes['src'];
    movieData.add(result);
  }
}
