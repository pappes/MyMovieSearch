import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_name.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for retrieving person details from IMDB.
mixin ScrapeIMDBNameDetails on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Scrape movie data from rows in the html table named findList.
  @override
  Stream<MovieResultDTO> myTransformTextStreamToOutputObject(
    Stream<String> str,
  ) async* {
    // Combine all HTTP chunks together for HTML parsing.
    final content = await str.reduce((value, element) => '$value$element');

    final movieData = _scrapeWebPage(content);
    if (movieData[outerElementDescription] == null) {
      yield myYieldError(
        'imdb webscraper data not detected '
        'for criteria $getCriteriaText',
      );
    }
    yield* Stream.fromIterable(baseTransformMapToOutputHandler(movieData));
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map _scrapeWebPage(String content) {
    // Extract embedded JSON.
    final document = parse(content);
    final movieData = json.decode(_getMovieJson(document)) as Map;
    _scrapeName(document, movieData);
    _scrapePoster(document, movieData);
    _scrapeRelated(document, movieData);

    movieData['id'] = getCriteriaText ?? movieData['id'];
    return movieData;
  }

  /// Use CSS selector to find the JSON script on the page
  /// and extract values from the JSON.
  String _getMovieJson(Document document) {
    final scriptElement =
        document.querySelector('script[type="application/ld+json"]');
    if (scriptElement == null || scriptElement.innerHtml.isEmpty) {
      logger.e('no JSON details found for Name $getCriteriaText');
      return '{}';
    }
    return scriptElement.innerHtml;
  }

  /// Extract Official name of person from web page.
  void _scrapeName(Document document, Map movieData) {
    final oldName = movieData[outerElementOfficialTitle];
    movieData[outerElementOfficialTitle] = '';
    var section = document.querySelector('h1[data-testid="hero-Name-block"]');
    section ??=
        document.querySelector('td[class*="name-overview-widget__section"]');
    final spans = section?.querySelector('h1')?.querySelectorAll('span');
    if (null != spans) {
      for (final span in spans) {
        movieData[outerElementOfficialTitle] += span.text;
      }
    }
    if ('' == movieData[outerElementOfficialTitle]) {
      movieData[outerElementOfficialTitle] = oldName;
    }
    movieData[outerElementOfficialTitle] =
        movieData[outerElementOfficialTitle].toString();
  }

  /// Search for movie poster.
  void _scrapePoster(Document document, Map movieData) {
    final posterBlock =
        document.querySelector('div[class="poster-hero-container"]');
    if (null != posterBlock && posterBlock.hasChildNodes()) {
      for (final poster in posterBlock.querySelectorAll('img')) {
        if (null != poster.attributes['src']) {
          movieData[outerElementImage] = poster.attributes['src'];
          break;
        }
      }
    }
  }

  /// Extract the movies for the current person.
  void _scrapeRelated(Document document, Map movieData) {
    movieData[outerElementRelated] = [];
    final filmography = document.querySelector('#filmography');
    if (null != filmography) {
      var headerText = '';
      for (final child in filmography.children) {
        if (!child.classes.contains('filmo-category-section')) {
          headerText = child.attributes['data-category'] ?? '?';
        } else {
          final movieList = _getMovieList(child.children);
          movieData[outerElementRelated].add({headerText: movieList});
        }
      }
    }
  }

  List<Map> _getMovieList(List<Element> rows) {
    final movies = <Map>[];
    for (final child in rows) {
      final link = child.querySelector('a');
      if (null != link) {
        final movie = {};
        movie[outerElementOfficialTitle] = link.text;
        movie[outerElementLink] = link.attributes['href'];
        movie[outerElementOfficialTitle] =
            movie[outerElementOfficialTitle].toString();
        movies.add(movie);
      }
    }
    return movies;
  }
}
