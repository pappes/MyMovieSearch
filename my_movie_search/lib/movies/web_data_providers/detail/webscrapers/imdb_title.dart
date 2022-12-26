import 'dart:async';
import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape_small.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const searchResultsTable = 'findList';
const columnMovieText = 'result_text';
const columnMoviePoster = 'primary_photo';

/// Implements [WebScraper] for retrieving movie details from IMDB.
mixin ScrapeIMDBTitleDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final htmlDecode = HtmlUnescape();

  /// Convert web text to a traversable tree of [List] or [Map] data.
  ///
  ///
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    final movieData = _scrapeWebPage(document);
    if (movieData[outerElementDescription] == null &&
        movieData['props'] == null) {
      throw 'imdb web scraper data not detected for criteria $getCriteriaText in $webText';
    }
    return [movieData];
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map _scrapeWebPage(Document document) {
    final movieData = json.decode(_getMovieJson(document)) as Map;
    return movieData;
  }

  /// Use CSS selector to find the JSON script on the page
  /// and extract values from the JSON.
  String _getMovieJson(Document document) {
    final scriptElement =
        document.querySelector('script[type="application/json"]');
    if (scriptElement == null || scriptElement.innerHtml.isEmpty) {
      logger.e('no JSON details found for Name $getCriteriaText');
      return '{}';
    }
    return scriptElement.innerHtml;
  }
}
