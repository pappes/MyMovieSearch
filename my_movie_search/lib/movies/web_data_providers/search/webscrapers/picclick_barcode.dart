import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/picclick_barcode.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const resultTableSelector = 'div ul.items li';
const jpgPictureSelector = 'picture source[type="image/jpeg"]';
const jpgDescriptionSelector = 'h3';

/// Implements [WebFetchBase] for the PicclickBarcode search html web scraper.
///
/// ```dart
/// ScrapePicclickBarcodeSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapePicclickBarcodeSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = [];
  bool validPage = false;

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
    throw 'PicclickBarcode results data not detected for criteria $getCriteriaText in html:$webText';
  }

  /// extract each row from the table.
  void _scrapeWebPage(Document document) {
    final table = document.querySelectorAll(resultTableSelector);
    for (final row in table) {
      validPage = true;
      _processRow(row);
    }
  }

  /// Collect webpage text to construct a map of the movie data.
  void _processRow(Element row) {
    final result = {};
    result[jsonDescriptionKey] =
        row.querySelector(jpgDescriptionSelector)?.cleanText;
    result[jsonIdKey] = row.attributes['id'];
    result[jsonUrlKey] =
        row.querySelector(jpgPictureSelector)?.attributes['srcset'];
    movieData.add(result);
  }
}
