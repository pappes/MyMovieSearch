import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:flutter/foundation.dart' show describeEnum;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb_title.dart';
import 'offline/imdb_title.dart';

const SEARCH_RESULTS_TABLE = 'findList';
const COLUMN_MOVIE_TEXT = 'result_text';
const COLUMN_MOVIE_POSTER = 'primary_photo';

/// Implements [WebFetchBase] for retrieving movie details from IMDB.
class QueryIMDBTitleDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://www.imdb.com/title/';
  static final baseURLsuffix = '/?ref_=fn_tt_tt_1';
  static var cache = TieredCache();

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

  /// Check cache to see if data has already been fetched.
  @override
  bool myIsResultCached(SearchCriteriaDTO criteria) {
    return cache.isCached(criteria.criteriaTitle);
  }

  /// Check cache to see if data in cache should be refreshed.
  @override
  bool myIsCacheStale(SearchCriteriaDTO criteria) {
    return false;
    return cache.isCached(criteria.criteriaTitle);
  }

  /// Insert transformed data into cache.
  @override
  void myAddResultToCache(MovieResultDTO fetchedResult) {
    cache.add(fetchedResult.uniqueId, fetchedResult);
  }

  /// Retrieve cached result.
  @override
  Stream<MovieResultDTO> myFetchResultFromCache(
      SearchCriteriaDTO criteria) async* {
    var value = await cache.get(criteria.criteriaTitle);
    if (value is MovieResultDTO) {
      yield value;
    }
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map scrapeWebPage(String content) {
    // Extract embedded JSON.
    var document = parse(content);
    var movieData = json.decode(getMovieJson(document));

    if (movieData == {}) {
      scrapeName(document, movieData);
      scrapeType(document, movieData);
    }
    // Get better details form the web page where possible.
    scrapePoster(document, movieData);
    scrapeDescription(document, movieData);
    scrapeLanguageDetails(document, movieData);

    getRecomendationList(movieData, document);

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

  /// Extract movie type not found in JSON from HTML
  scrapeType(Document document, Map movieData) {
    getAttributeValue(movieData, document, outer_element_type);
    if ("" == movieData[outer_element_type] &&
        null != document.querySelector('a[href*="genre=short"]')) {
      movieData[outer_element_type] = "Short";
    }
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
      movieData[outer_element_description] = description!.text;
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
      movieData[outer_element_official_title] = description!.text;
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
          movieData[outer_element_image] = poster.attributes['src'];
          break;
        }
      }
    }
  }

  /// Extract type, year, Censor Rating and duration from ul<TitleBlockMetaData>
  scrapeLanguageDetails(Document document, Map movieData) {
    movieData[outer_element_language] = LanguageType.none;
    var languageHtml =
        document.querySelector('li[data-testid="title-details-languages"]');
    if (null == languageHtml) {
      languageHtml = document
          .querySelector('a[href*="primary_language"]')
          ?.parent // li - line item for the language.
          ?.parent; // ul - list of languages.
    }
    if (null != languageHtml && languageHtml.hasChildNodes()) {
      var silent = languageHtml.querySelector('a[href*="language=zxx"]');
      if (null != silent) {
        movieData[outer_element_language] = LanguageType.silent;
        return;
      }
      movieData[outer_element_languages] = [];
      for (var item in languageHtml.querySelectorAll('a[href*="language="]')) {
        movieData[outer_element_languages].add(item.text);
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
  }

  /// Extract the movie recommendations from the current movie.
  void getRecomendationList(Map movieData, Document document) {
    movieData[outer_element_related] = [];
    List<Element> recommendations =
        document.querySelectorAll('div.rec_overview');
    if (0 != recommendations.length) {
      recommendations
          .forEach((element) => getRecomendationOld(movieData, element));
    }
    recommendations = document.querySelectorAll('div.ipc-poster-card--base');
    if (0 != recommendations.length) {
      recommendations
          .forEach((element) => getRecomendationNew(movieData, element));
    }
  }

  void getRecomendationNew(Map movieData, Element recommendation) {
    Map attributes = {};
    //"/title/tt0145681/?ref_=tt_sims_tt_t_9"
    var link =
        recommendation.querySelector('a[href*="title/tt"]')?.attributes['href'];
    attributes[outer_element_identity_element] = getIdFromIMDBLink(link);
    attributes[outer_element_official_title] = recommendation
        .querySelector('span[data-testid="title"]')
        ?.text; //The Book of Eli
    attributes[outer_element_image] =
        recommendation.querySelector('img')?.attributes['src'];
    attributes[inner_element_rating_value] =
        recommendation.querySelector('span.ipc-rating-star--imdb')?.text; //6.9
    movieData[outer_element_related].add(attributes);
  }

  getRecomendationOld(Map movieData, Element recommendation) {
    Map attributes = {};
    attributes[outer_element_identity_element] = recommendation
        .querySelector('div[data-tconst]')
        ?.attributes['data-tconst']; //tt1037705
    attributes[outer_element_official_title] = recommendation
        .querySelector('div.rec-title')
        ?.querySelector('b')
        ?.innerHtml; //The Book of Eli
    attributes[outer_element_year] = recommendation
        .querySelector('div.rec-title')
        ?.querySelector('span')
        ?.innerHtml; //(2010)
    attributes[outer_element_image] =
        recommendation.querySelector('img')?.attributes['src'];
    attributes[inner_element_rating_value] = recommendation
        .querySelector('span.rating-rating')
        ?.querySelector('span.value')
        ?.innerHtml; //6.9
    attributes[inner_element_rating_count] = recommendation
            .querySelector('span.rating-list')
            ?.attributes[
        'title']; //"Users rated this 6.9/10 (297,550 votes) - click stars to rate"
    attributes[outer_element_description] = recommendation
        .querySelector('div.rec-outline')
        ?.querySelector('p')
        ?.innerHtml; //A post-apocalyptic tale... saving humankind.
    movieData[outer_element_related].add(attributes);
  }
}
