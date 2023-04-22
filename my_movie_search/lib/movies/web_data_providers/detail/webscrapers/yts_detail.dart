import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebScraper] for retrieving download details from yts.
mixin ScrapeYtsDetails on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Convert web text to a traversable tree of [List] or [Map] data.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains("The page you're looking for does not exist")) {
      return [];
    }
    final document = parse(webText);
    return [_scrapeWebPage(document)];
  }

  /// Collect webpage text to construct a map of the movie data.
  Map _scrapeWebPage(Document document) {
    final movieData = {};
    _scrapeRelated(document, movieData);
    return movieData;
  }

  /// Extract the keywords for the current movie.
  void _scrapeRelated(Document document, Map movieData) {
    final links = document.querySelectorAll('[href*="search/keyword"]');
    for (final link in links) {
      movieData[link.text] = 'keyword';
    }
    if (movieData.isEmpty) {
      throw 'yts data not detected for criteria $getCriteriaText';
    }
  }
}
