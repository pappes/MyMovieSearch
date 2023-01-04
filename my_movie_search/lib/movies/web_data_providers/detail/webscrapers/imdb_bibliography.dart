import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebScraper] for retrieving person details from IMDB.
mixin ScrapeIMDBBibliographyDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape bibliography data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    return [_scrapeWebPage(document)];
  }

  /// Collect webpage text to construct a map of the movie data.
  Map _scrapeWebPage(Document document) {
    final movieData = {};

    _scrapeRelated(document, movieData);

    movieData[outerElementIdentity] = getCriteriaText;
    return movieData;
  }

  /// Extract the bibliography for the current movie.
  void _scrapeRelated(Document document, Map movieData) {
    String? roleText;
    final children = document.querySelector('#filmography')?.children;
    if (null != children) {
      for (final category in children) {
        if (category.className == 'head') {
          roleText = _getRole(category) ?? roleText;
        } else {
          final bibliography = _getBibliography(category);
          _addBibliography(movieData, roleText ?? '?', bibliography);
        }
      }
    } else {
      throw 'imdb bibliography data not detected for criteria $getCriteriaText';
    }
  }

  String? _getRole(Element credits) {
    final anchor = credits.querySelector('a')?.text;
    final firstLine = anchor?.trim().split('\n').first;
    return '$firstLine:';
  }

  void _addBibliography(Map movieData, String role, dynamic bibliography) {
    if (!movieData.containsKey(role)) {
      movieData[role] = [];
    }
    (movieData[role] as List).addAll(bibliography as List);
  }

  List<Map> _getBibliography(Element table) {
    final movies = <Map>[];
    for (final row in table.querySelectorAll('b')) {
      final title = StringBuffer();
      var linkURL = '';
      for (final link in row.querySelectorAll('a[href*="/title/tt"]')) {
        title.write(link.text.trim().split('\n').first);
        linkURL = link.attributes['href'] ?? linkURL;
      }
      if (title.isNotEmpty) {
        final movie = <String, String>{};
        movie[outerElementOfficialTitle] = title.toString();
        movie[outerElementLink] = linkURL;
        movies.add(movie);
      }
    }
    return movies;
  }
}
