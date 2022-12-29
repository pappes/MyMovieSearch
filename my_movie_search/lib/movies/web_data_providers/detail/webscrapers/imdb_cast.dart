import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebScraper] for retrieving person details from IMDB.
mixin ScrapeIMDBCastDetails on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape cast data from rows in the html div named fullcredits_content.
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

    movieData[outerElementIdentity] =
        getCriteriaText ?? movieData[outerElementIdentity];
    return movieData;
  }

  /// Extract the cast for the current movie.
  void _scrapeRelated(Document document, Map movieData) {
    String? roleText;
    final children = document.querySelector('#fullcredits_content')?.children;
    if (null != children) {
      for (final credits in children) {
        roleText = _getRole(credits) ?? roleText;
        final cast = _getCast(credits);
        _addCast(movieData, roleText ?? '?', cast);
      }
    } else {
      throw 'imdb cast data not detected for criteria $getCriteriaText';
    }
  }

  String? _getRole(Element credits) {
    if (credits.classes.contains('dataHeaderWithBorder')) {
      var text = credits.text;
      if (text.isEmpty) {
        text = credits.attributes['id'] ?? credits.attributes['name'] ?? '?';
      }
      final firstLine = text.trim().split('\n').first;
      return '$firstLine:';
    }
    return null;
  }

  void _addCast(Map movieData, String role, dynamic cast) {
    if (!movieData.containsKey(role)) {
      movieData[role] = [];
    }
    (movieData[role] as List).addAll(cast as List);
  }

  List<Map> _getCast(Element table) {
    final movies = <Map>[];
    for (final row in table.querySelectorAll('tr')) {
      final title = StringBuffer();
      var linkURL = '';
      for (final link in row.querySelectorAll('a[href*="/name/nm"]')) {
        title.write(link.text.trim().split('\n').first);
        linkURL = link.attributes['href'] ?? '';
      }
      if (title.isNotEmpty) {
        final person = <String, String>{};
        person[outerElementOfficialTitle] = title.toString();
        person[outerElementLink] = linkURL;
        final charactor = row.querySelector('a[href*="/title/tt"]')?.text;
        if (null != charactor) {
          // Include name of character played by actor for display in search results.
          person[outerElementAlternateTitle2] = charactor;
        }
        movies.add(person);
      }
    }
    return movies;
  }
}
