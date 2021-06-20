import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:flutter/foundation.dart' show describeEnum;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb.dart';
import 'offline/imdb.dart';

const SEARCH_RESULTS_TABLE = 'findList';
const COLUMN_MOVIE_TEXT = 'result_text';
const COLUMN_MOVIE_POSTER = 'primary_photo';

/// Implements [SearchProvider] for the IMDB search html webscraper.
class QueryIMDBDetails extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://www.imdb.com/title/';
  static final baseURLsuffix = '/?ref_=fn_tt_tt_1';

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
    var url = '$baseURL$searchCriteria$baseURLsuffix';
    print("fetching imdb details $url");
    return WebRedirect.constructURI(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      ImdbMoviePageConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
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

    if (movieData == {}) {
      scrapeName(document, movieData);
      scrapeBasicDetails(document, movieData);
    }
    // Get better details form the web page where possible.
    scrapePoster(document, movieData);
    scrapeDescription(document, movieData);
    scrapeLanguageDetails(document, movieData);

    getRecomendations(movieData, document.querySelectorAll('div.rec_overview'));

    getAttributeValue(movieData, document, inner_element_rating_count);
    getAttributeValue(movieData, document, inner_element_rating_value);

    movieData['id'] = getCriteriaText ?? movieData['id'];
    return movieData;
  }

  /// Use CSS selector to find the JSON script on the page
  /// and extract values from the JSON.
  String getMovieJson(Document document) {
    var scriptElement =
        document.querySelector('script[type="application/ld+json"]');
    if (scriptElement == null || scriptElement.innerHtml.length == 0) {
      print('no JSON details found for title $getCriteriaText');
      return '{}';
    }
    return scriptElement.innerHtml;
  }

  /// Extract details that were not found in JSON from HTML
  scrapeBasicDetails(Document document, Map movieData) {
    getAttributeValue(movieData, document, outer_element_type_element);
  }

  /// Extract type, year, Censor Rating and duration from ul<TitleBlockMetaData>
  scrapeTitleMetadataDetails(Document document, Map movieData) {
    var titleMetaData =
        document.querySelector('ul[data-testid="hero-title-block__metadata"]');
    if (null == titleMetaData) {
      titleMetaData = document.querySelector('ul[class*="TitleBlockMetaData"]');
    }
    if (null != titleMetaData && titleMetaData.hasChildNodes()) {
      for (var item in titleMetaData.children) {
        // See if this lineitem is the year
        var year = item.querySelector('a[href*="releaseinfo"]')?.text;
        if (null != year) {
          movieData[outer_element_year_element] = year;
          continue;
        }
        // See if this lineitem is the rating
        var censorrating = item.querySelector('a[href*="parentalguide"]')?.text;
        if (null != censorrating) {
          movieData[outer_element_censor_rating] = censorrating;
          continue;
        }
        var otheritem = item.text;
        if (null == movieData[outer_element_type_element] &&
            null == movieData[outer_element_year_element] &&
            null == movieData[outer_element_censor_rating]) {
          // Assume first unknown Item is movie type
          movieData[outer_element_type_element] = otheritem;
        }
        // Assume last unknown Item is duration
        movieData[outer_element_duration] = otheritem;
      }
    }
  }

  /// Extract list of genres from from li<TitleBlockMetaData>
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

  /// Extract Official name of movie from web page.
  scrapeName(Document document, Map movieData) {
    var description =
        document.querySelector('h1[data-testid="hero-title-block"]');
    if (null == description) {
      description = document.querySelector('h1[class*="TitleHeader"]');
    }
    if (null != description?.text) {
      movieData[outer_element_title_element] = description?.text;
    }
  }

  /// Search for movie poster.
  scrapePoster(Document document, Map movieData) {
    var posterBlock =
        document.querySelector('div[data-testid="hero-media__poster"]');
    if (null == posterBlock) {
      posterBlock =
          document.querySelector('div[class="Media__PosterContainer"]');
    }
    if (null != posterBlock && posterBlock.hasChildNodes()) {
      for (var poster in posterBlock.querySelectorAll('img')) {
        if (null != poster.attributes['src']) {
          movieData[outer_element_image_element] = poster.attributes['src'];
          break;
        }
      }
    }
  }

  /// Extract type, year, Censor Rating and duration from ul<TitleBlockMetaData>
  scrapeLanguageDetails(Document document, Map movieData) {
    movieData[outer_element_language_element] = LanguageType.none;
    var languageMetaData =
        document.querySelector('li[data-testid="title-details-languages"]');
    if (null == languageMetaData) {
      languageMetaData = document
          .querySelector('a[href*="primary_language"]')
          ?.parent // li - line item for the language.
          ?.parent; // ul - list of langages.
    }
    if (null != languageMetaData && languageMetaData.hasChildNodes()) {
      for (var item
          in languageMetaData.querySelectorAll('a[href*="language="]')) {
        // Loop through all languages in order to see how dominant English is.
        var english = item.parent?.querySelector('a[href*="language=en"]');
        if (null != english) {
          if (LanguageType.none == movieData[outer_element_language_element]) {
            // First item found is English, assume all English until other langages found.
            movieData[outer_element_language_element] = LanguageType.allEnglish;
            continue;
          } else {
            movieData[outer_element_language_element] =
                LanguageType.someEnglish;
            return;
          }
        }
        if (LanguageType.allEnglish ==
            movieData[outer_element_language_element]) {
          movieData[outer_element_language_element] =
              LanguageType.mostlyEnglish;
          return;
        } else {
          // First item found is foreign, assume all foreign until other langages found.
          movieData[outer_element_language_element] = LanguageType.foreign;
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
  }

  /// Extract the movie recommendations from the current movie.
  void getRecomendations(movieData, List<Element> recommendations) {
    recommendations.forEach((element) => getRecomendation(movieData, element));
  }

  getRecomendation(movieData, Element recommendation) {
    Map attributes = {};
    attributes['id'] = recommendation
        .querySelector('div[data-tconst]')
        ?.attributes['data-tconst']; //tt1037705
    attributes['name'] = recommendation
        .querySelector('div.rec-title')
        ?.querySelector('b')
        ?.innerHtml; //The Book of Eli
    attributes['year'] = recommendation
        .querySelector('div.rec-title')
        ?.querySelector('span')
        ?.innerHtml; //(2010)
    attributes['poster'] =
        recommendation.querySelector('img')?.attributes['src'];
    attributes['ratingValue'] = recommendation
        .querySelector('span.rating-rating')
        ?.querySelector('span.value')
        ?.innerHtml; //6.9
    attributes['ratingCount'] = recommendation
            .querySelector('span.rating-list')
            ?.attributes[
        'title']; //"Users rated this 6.9/10 (297,550 votes) - click stars to rate"
    attributes['description'] = recommendation
        .querySelector('div.rec-outline')
        ?.querySelector('p')
        ?.innerHtml; //A post-apocalyptic tale... saving humankind.
  }
}
