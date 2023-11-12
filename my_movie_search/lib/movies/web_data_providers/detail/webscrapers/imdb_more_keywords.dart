import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebScraper] for retrieving person details from IMDB.
mixin ScrapeIMDBMoreKeywordsDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape bibliography data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, dynamic>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains("don't have any Plot Keywords for this title yet")) {
      return [];
    }
    final document = parse(webText);
    return [_scrapeWebPage(document)];
  }

  /// Collect webpage text to construct a map of the movie data.
  Map<String, dynamic> _scrapeWebPage(Document document) {
    final movieData = <String, dynamic>{};
    _scrapeRelated(document, movieData);
    return movieData;
  }

  /// Extract the keywords for the current movie.
  void _scrapeRelated(Document document, Map<String, dynamic> movieData) {
    final links = document.querySelectorAll('[href*="search/keyword"]');
    for (final link in links) {
      movieData[link.text] = 'keyword';
    }
    if (movieData.isEmpty) {
      throw 'imdb more keywords data not detected for criteria $getCriteriaText';
    }
  }
}
