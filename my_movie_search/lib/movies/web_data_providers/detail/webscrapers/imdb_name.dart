import 'dart:convert' show json;

import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebScraper] for retrieving person details from IMDB.
mixin ScrapeIMDBNameDetails on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Convert web text to a traversable tree of [List] or [Map] data.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    final movieData = _scrapeWebPage(document);
    if (movieData[outerElementDescription] == null &&
        movieData['props'] == null) {
      throw 'imdb web scraper data not detected for criteria $getCriteriaText';
    }
    return [movieData];
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map _scrapeWebPage(Document document) {
    // Extract embedded JSON.
    final movieData = json.decode(_getMovieJson(document)) as Map;
    if (movieData.isNotEmpty) {
      movieData[outerElementYear] =
          getYear(movieData[outerElementBorn]?.toString()) ?? '';
      final deathDate =
          getYear(movieData[outerElementDied]?.toString())?.toString() ?? '';
      movieData[outerElementYearRange] =
          '${movieData[outerElementYear]}-$deathDate';
    }
    movieData[dataSource] = DataSourceType.imdb;
    movieData[outerElementIdentity] = getCriteriaText;

    _scrapeName(document, movieData);
    _scrapePoster(document, movieData);
    _scrapeRelated(document, movieData);

    movieData[outerElementType] = MovieContentType.person;

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

  /// Extract Official name of person from web page.
  void _scrapeName(Document document, Map movieData) {
    final newName = StringBuffer();
    var section = document.querySelector('h1[data-testid="hero-Name-block"]');
    section ??=
        document.querySelector('td[class*="name-overview-widget__section"]');
    final spans = section?.querySelector('h1')?.querySelectorAll('span');
    if (null != spans) {
      for (final span in spans) {
        newName.write(span.text);
      }
    }
    if (newName.isNotEmpty) {
      movieData[outerElementOfficialTitle] = newName.toString();
    }
  }

  /// Search for movie poster.
  void _scrapePoster(Document document, Map movieData) {
    final posterBlock =
        document.querySelector('div[class="poster-hero-container"]');
    if (null != posterBlock && posterBlock.hasChildNodes()) {
      for (final poster in posterBlock.querySelectorAll('img')) {
        final img = poster.getAttribute(AttributeType.source);
        if (null != img) {
          movieData[outerElementImage] = img;
          return;
        }
      }
    }
  }

  /// Extract the movies for the current person.
  void _scrapeRelated(Document document, Map movieData) {
    final Map related = {};
    final filmography = document.querySelector('#filmography');
    if (null != filmography) {
      var headerText = '';
      for (final child in filmography.children) {
        if (!child.classes.contains('filmo-category-section')) {
          headerText = child.attributes['data-category'] ?? '?';
        } else {
          final movieList = _getMovieList(child.children);
          related[headerText] = movieList;
        }
      }
    }
    movieData[outerElementRelated] = related;
  }

  List<Map> _getMovieList(List<Element> rows) {
    final movies = <Map>[];
    for (final child in rows) {
      final link = child.querySelector('a');
      if (null != link) {
        final movie = {};
        movie[outerElementOfficialTitle] = link.text;
        movie[outerElementLink] = link.getAttribute(AttributeType.address);
        movies.add(movie);
      }
    }
    return movies;
  }
}
