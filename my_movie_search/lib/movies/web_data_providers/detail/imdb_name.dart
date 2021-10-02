import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb_name.dart';
import 'offline/imdb_name.dart';

/// Implements [WebFetchBase] for retrieving person details from IMDB.
class QueryIMDBNameDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://www.imdb.com/name/';

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return 'imdb_person';
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbHtmlOfflineData;
  }

  /// Scrape movie data from rows in the html table named findList.
  @override
  Stream<MovieResultDTO> baseTransformTextStreamToOutput(
      Stream<String> str) async* {
    // Combine all HTTP chunks together for HTML parsing.
    final content = await str.reduce((value, element) => '$value$element');

    var movieData = scrapeWebPage(content);
    if (movieData[outer_element_description] == null) {
      yield myYieldError('imdb webscraper data not detected '
          'for criteria $getCriteriaText');
    }
    yield* Stream.fromIterable(baseTransformMapToOutputHandler(movieData));
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    return contents!.criteriaTitle;
  }

  /// API call to IMDB person details for person id.
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    var url = '$baseURL$searchCriteria';
    print("fetching imdb person $url");
    return WebRedirect.constructURI(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      ImdbNamePageConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie Name when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    var error = MovieResultDTO().error();
    error.title = '[${this.runtimeType}] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map scrapeWebPage(String content) {
    // Extract embedded JSON.
    var document = parse(content);
    var movieData = json.decode(getMovieJson(document));
    scrapeName(document, movieData);
    scrapeRelated(document, movieData);

    movieData['id'] = getCriteriaText ?? movieData['id'];
    return movieData;
  }

  /// Use CSS selector to find the JSON script on the page
  /// and extract values from the JSON.
  String getMovieJson(Document document) {
    var scriptElement =
        document.querySelector('script[type="application/ld+json"]');
    if (scriptElement == null || scriptElement.innerHtml.length == 0) {
      print('no JSON details found for Name $getCriteriaText');
      return '{}';
    }
    return scriptElement.innerHtml;
  }

  /// Extract Official name of person from web page.
  scrapeName(Document document, Map movieData) {
    var oldName = movieData[outer_element_official_title];
    movieData[outer_element_official_title] = '';
    var section = document.querySelector('h1[data-testid="hero-Name-block"]');
    if (null == section) {
      section =
          document.querySelector('td[class*="name-overview-widget__section"]');
    }
    var spans = section?.querySelector('h1')?.querySelectorAll('span');
    if (null != spans) {
      for (var span in spans) {
        movieData[outer_element_official_title] += span.text;
      }
    }
    if ('' == movieData[outer_element_official_title]) {
      movieData[outer_element_official_title] = oldName;
    }
  }

  /// Search for movie poster.
  scrapePoster(Document document, Map movieData) {
    var posterBlock =
        document.querySelector('div[class="poster-hero-container"]');
    if (null != posterBlock && posterBlock.hasChildNodes()) {
      for (var poster in posterBlock.querySelectorAll('img')) {
        if (null != poster.attributes['src']) {
          movieData[outer_element_image] = poster.attributes['src'];
          break;
        }
      }
    }
  }

  /// Extract the movies for the current person.
  void scrapeRelated(Document document, Map movieData) {
    movieData[outer_element_related] = [];
    var filmography = document.querySelector('#filmography');
    if (null != filmography) {
      var headerText = '';
      for (var child in filmography.children) {
        if (!child.classes.contains('filmo-category-section')) {
          headerText = child.attributes['data-category'] ?? '?';
        } else {
          var movieList = getMovieList(child.children);
          movieData[outer_element_related].add({headerText: movieList});
        }
      }
    }
  }

  List<Map> getMovieList(List<Element> rows) {
    List<Map> movies = [];
    for (var child in rows) {
      var link = child.querySelector('a');
      if (null != link) {
        Map movie = {};
        movie[outer_element_official_title] = link.text;
        movie[outer_element_link] = link.attributes['href'];
        movies.add(movie);
      }
    }
    return movies;
  }
}
