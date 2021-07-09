import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:flutter/foundation.dart' show describeEnum;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb_name.dart';
import 'offline/imdb_name.dart';

const SEARCH_RESULTS_TABLE = 'findList';
const COLUMN_MOVIE_TEXT = 'result_text';
const COLUMN_MOVIE_POSTER = 'primary_photo';

/// Implements [SearchProvider] for the IMDB search html webscraper.
class QueryIMDBNameDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://www.imdb.com/name/';

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return describeEnum(DataSourceType.imdb);
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

  /// API call to IMDB search returning the top matching results for [searchText].
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
/*
    // Get better details form the web page where possible.
    scrapePoster(document, movieData);
    scrapeDescription(document, movieData);
    scrapeLanguageDetails(document, movieData);

    getRecomendations(movieData, document);

    getAttributeValue(movieData, document, inner_element_rating_count);
    getAttributeValue(movieData, document, inner_element_rating_value);
*/
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

/*
  /// Extract type, year, Censor Rating and duration from ul<NameBlockMetaData>
  scrapeNameMetadataDetails(Document document, Map movieData) {
    var NameMetaData =
        document.querySelector('ul[data-testid="hero-Name-block__metadata"]');
    if (null == NameMetaData) {
      NameMetaData = document.querySelector('ul[class*="NameBlockMetaData"]');
    }
    if (null != NameMetaData && NameMetaData.hasChildNodes()) {
      for (var item in NameMetaData.children) {
        // See if this lineitem is the year
        var year = item.querySelector('a[href*="releaseinfo"]')?.text;
        if (null != year) {
          movieData[outer_element_year] = year;
          continue;
        }
        // See if this lineitem is the rating
        var censorrating = item.querySelector('a[href*="parentalguide"]')?.text;
        if (null != censorrating) {
          movieData[outer_element_censor_rating] = censorrating;
          continue;
        }
        String otheritem = item.text;
        if ("" != otheritem) {
          if (null == movieData[outer_element_type] &&
              null == movieData[outer_element_year] &&
              null == movieData[outer_element_censor_rating]) {
            // Assume first unknown Item is movie type
            movieData[outer_element_type] = otheritem;
          }
          // Assume last unknown Item is duration
          movieData[outer_element_duration] = otheritem;
        }
      }
    }
  }

  /// Extract list of genres from from li<NameBlockMetaData>
  scrapeGenreDetails(Document document, Map movieData) {
    var genreData =
        document.querySelector('li[data-testid="storyline-genres"]');
    if (null != genreData) {
      genreData = genreData.querySelector('div'); // Discard the "Genres" label.
    }
    if (null == genreData) {
      genreData = document
          .querySelector('a[href*="genre"]')
          ?.parent // li - line item containing the anchor
          ?.parent; // ul - list containing the line items
    }
    if (null != genreData && "" != genreData.text) {
      movieData[outer_element_genre] = genreData.text;
    }
  }

  /// Extract short description of movie from web page.
  scrapeDescription(Document document, Map movieData) {
    var description =
        document.querySelector('div[data-testid="storyline-plot-summary"]');
    if (null == description) {
      description = document.querySelector('span[data-testid*="plot"]');
    }
    if (null != description?.text) {
      movieData[outer_element_description] = description?.text;
    }
  }


  /// Extract type, year, Censor Rating and duration from ul<NameBlockMetaData>
  scrapeLanguageDetails(Document document, Map movieData) {
    movieData[outer_element_language] = LanguageType.none;
    var languageHtml =
        document.querySelector('li[data-testid="Name-details-languages"]');
    if (null == languageHtml) {
      languageHtml = document
          .querySelector('a[href*="primary_language"]')
          ?.parent // li - line item for the language.
          ?.parent; // ul - list of languages.
    }
    if (null != languageHtml && languageHtml.hasChildNodes()) {
      movieData[outer_element_languages] =
          languageHtml.querySelector('div')?.text;
      var silent = languageHtml.querySelector('a[href*="language=zxx"]');
      if (null != silent) {
        movieData[outer_element_language] = LanguageType.silent;
        return;
      }
      for (var item in languageHtml.querySelectorAll('a[href*="language="]')) {
        // Loop through all languages in order to see how dominant English is.
        String link = item.attributes['href']!;
        if (link.contains('language=en')) {
          if (LanguageType.none == movieData[outer_element_language] ||
              LanguageType.allEnglish == movieData[outer_element_language]) {
            // First items found are English, assume all English until other languages found.
            movieData[outer_element_language] = LanguageType.allEnglish;
            continue;
          } else {
            movieData[outer_element_language] = LanguageType.someEnglish;
            return;
          }
        }
        if (LanguageType.allEnglish == movieData[outer_element_language]) {
          movieData[outer_element_language] = LanguageType.mostlyEnglish;
          return;
        } else {
          // First item found is foreign, assume all foreign until other languages found.
          movieData[outer_element_language] = LanguageType.foreign;
          continue;
        }
      }
    }
  }

  /// Use CSS selector to find the text on the page
  /// and extract values from the page.
  void getAttributeValue(Map moviedata, Document document, String attribute) {
    if (moviedata[attribute] != null) return;
    var elements = document.querySelectorAll('span[itemprop="$attribute"]');
    for (var element in elements) {
      if (element.text.length > 1) {
        var webPageText = element.text;
        moviedata[attribute] = webPageText;
      }
    }
  }*/

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
