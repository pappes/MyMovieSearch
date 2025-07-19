import 'dart:async';
import 'dart:convert' show json;
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements a web scraper for retrieving movie details from IMDB.
// ignore: missing_override_of_must_be_overridden
mixin ScrapeIMDBJsonDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Reduce computation effort for html extraction.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    try {
      return fastParse(webText);
    } on FastParseException {
      return slowConvertWebTextToTraversableTree(webText);
    }
  }

  /// Convert web text to a traversable tree of [List] or [Map] data.
  ///
  ///
  Future<List<dynamic>> slowConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    final movieData = _scrapeWebPage(document);
    if (movieData[outerElementDescription] == null &&
        movieData['props'] == null) {
      throw WebConvertException(
          'imdb web scraper data not detected for criteria '
          '$getCriteriaText in $webText');
    }
    return [movieData];
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map<dynamic, dynamic> _scrapeWebPage(Document document) {
    final movieData = json.decode(_getImdbJson(document)) as Map;
    return movieData;
  }

  /// Use CSS selector to find the JSON script on the page
  /// and extract values from the JSON.
  String _getImdbJson(Document document) {
    final scriptElement = document.querySelector(jsonScript);
    if (scriptElement == null || scriptElement.innerHtml.isEmpty) {
      logger.e('no JSON details found for $getCriteriaText');
      return '{}';
    }
    return scriptElement.innerHtml;
  }
}
