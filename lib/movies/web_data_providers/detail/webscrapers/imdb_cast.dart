import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements a web scraper for retrieving person details from IMDB.
// ignore: missing_override_of_must_be_overridden
mixin ScrapeIMDBCastDetails on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape cast data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, dynamic>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    return [_scrapeWebPage(document)];
  }

  /// Collect webpage text to construct a map of the movie data.
  Map<String, dynamic> _scrapeWebPage(Document document) {
    final movieData = <String, dynamic>{};

    _scrapeRelated(document, movieData);

    movieData[outerElementIdentity] = getCriteriaText;
    return movieData;
  }

  /// Extract the cast for the current movie.
  void _scrapeRelated(Document document, Map<String, dynamic> movieData) {
    String? roleText;
    final children = document.querySelector('#fullcredits_content')?.children;
    if (null != children) {
      for (final credits in children) {
        roleText = _getRole(credits) ?? roleText;
        final cast = _getCast(credits);
        _addCast(movieData, roleText ?? '?', cast);
      }
    } else {
      throw WebConvertException(
        'imdb cast data not detected for criteria $getCriteriaText',
      );
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

  void _addCast(
    Map<String, dynamic> movieData,
    String role,
    List<Map<dynamic, dynamic>> cast,
  ) {
    if (!movieData.containsKey(role)) {
      movieData[role] = <Map<dynamic, dynamic>>[];
    }
    (movieData[role] as List).addAll(cast);
  }

  List<Map<dynamic, dynamic>> _getCast(Element table) {
    final movies = <Map<dynamic, dynamic>>[];
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
          // Include name of character played by actor
          // for display in search results.
          person[outerElementCharactorName] = charactor;
        }
        movies.add(person);
      }
    }
    return movies;
  }
}
