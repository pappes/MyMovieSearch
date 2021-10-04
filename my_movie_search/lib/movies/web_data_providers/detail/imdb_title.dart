import 'dart:convert' show json;
import 'package:flutter/foundation.dart' show describeEnum;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb_title.dart';
import 'offline/imdb_title.dart';

const searchResultsTable = 'findList';
const columnMovieText = 'result_text';
const columnMoviePoster = 'primary_photo';

/// Implements [WebFetchBase] for retrieving movie details from IMDB.
class QueryIMDBTitleDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://www.imdb.com/title/';
  static const _baseURLsuffix = '/?ref_=fn_tt_tt_1';
  static final _cache = TieredCache();

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

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.criteriaTitle;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria$_baseURLsuffix';
    return WebRedirect.constructURI(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      ImdbMoviePageConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO().error();
    error.title = '[QueryIMDBTitleDetails] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }

  /// Check cache to see if data has already been fetched.
  @override
  bool myIsResultCached(SearchCriteriaDTO criteria) {
    return _cache.isCached(criteria.criteriaTitle);
  }

  /// Check cache to see if data in cache should be refreshed.
  @override
  bool myIsCacheStale(SearchCriteriaDTO criteria) {
    return false;
    //return _cache.isCached(criteria.criteriaTitle);
  }

  /// Insert transformed data into cache.
  @override
  void myAddResultToCache(MovieResultDTO fetchedResult) {
    _cache.add(fetchedResult.uniqueId, fetchedResult);
  }

  /// Retrieve cached result.
  @override
  Stream<MovieResultDTO> myFetchResultFromCache(
    SearchCriteriaDTO criteria,
  ) async* {
    final value = await _cache.get(criteria.criteriaTitle);
    if (value is MovieResultDTO) {
      yield value;
    }
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map _scrapeWebPage(String content) {
    // Extract embedded JSON.
    final document = parse(content);
    final movieData = json.decode(_getMovieJson(document)) as Map;

    if (movieData == {}) {
      _scrapeName(document, movieData);
      _scrapeType(document, movieData);
    }
    // Get better details from the web page where possible.
    _scrapePoster(document, movieData);
    _scrapeDescription(document, movieData);
    _scrapeLanguageDetails(document, movieData);

    _getRecomendationList(movieData, document);

    _getAttributeValue(movieData, document, innerElementRatingCount);
    _getAttributeValue(movieData, document, innerElementRatingValue);

    movieData['id'] = getCriteriaText ?? movieData['id'];
    return movieData;
  }

  /// Use CSS selector to find the JSON script on the page
  /// and extract values from the JSON.
  String _getMovieJson(Document document) {
    final scriptElement =
        document.querySelector('script[type="application/ld+json"]');
    if (scriptElement == null || scriptElement.innerHtml.isEmpty) {
      logger.e('no JSON details found for title $getCriteriaText');
      return '{}';
    }
    return scriptElement.innerHtml;
  }

  /// Extract movie type not found in JSON from HTML
  void _scrapeType(Document document, Map movieData) {
    _getAttributeValue(movieData, document, outerElementType);
    if ('' == movieData[outerElementType] &&
        null != document.querySelector('a[href*="genre=short"]')) {
      movieData[outerElementType] = "Short";
    }
  }

/*
  /// Extract type, year, Censor Rating and duration from ul<TitleBlockMetaData>
  void _scrapeTitleMetadataDetails(Document document, Map movieData) {
    var titleMetaData =
        document.querySelector('ul[data-testid="hero-title-block__metadata"]');
      titleMetaData ??= document.querySelector('ul[class*="TitleBlockMetaData"]');
    if (null != titleMetaData && titleMetaData.hasChildNodes()) {
      for (var item in titleMetaData.children) {
        // See if this lineitem is the year
        final year = item.querySelector('a[href*="releaseinfo"]')?.text;
        if (null != year) {
          movieData[outer_element_year] = year;
          continue;
        }
        // See if this lineitem is the rating
        final censorrating = item.querySelector('a[href*="parentalguide"]')?.text;
        if (null != censorrating) {
          movieData[outer_element_censor_rating] = censorrating;
          continue;
        }
        final otheritem = item.text;
        if (otheritem.isNotEmpty) {
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
  void _scrapeGenreDetails(Document document, Map movieData) {
    document.querySelectorAll('a[href*="genre"]').forEach((genre) {
      if ("" != genre.text.length > 0)
        movieData[outer_element_genre].add(genre.text);
    });
  }
*/
  /// Extract short description of movie from web page.
  void _scrapeDescription(Document document, Map movieData) {
    final description =
        document.querySelector('div[data-testid="storyline-plot-summary"]') ??
            document.querySelector('span[data-testid*="plot"]');
    if (null != description?.text) {
      movieData[outerElementDescription] = description!.text;
    }
  }

  /// Extract Official name of movie from web page.
  void _scrapeName(Document document, Map movieData) {
    final description =
        document.querySelector('h1[data-testid="hero-title-block"]') ??
            document.querySelector('h1[class*="TitleHeader"]');
    if (null != description?.text) {
      movieData[outerElementOfficialTitle] = description!.text;
    }
  }

  /// Search for movie poster.
  void _scrapePoster(Document document, Map movieData) {
    final posterBlock =
        document.querySelector('div[data-testid="hero-media__poster"]') ??
            document.querySelector('div[class="Media__PosterContainer"]');
    if (null != posterBlock && posterBlock.hasChildNodes()) {
      for (final poster in posterBlock.querySelectorAll('img')) {
        if (null != poster.attributes['src']) {
          movieData[outerElementImage] = poster.attributes['src'];
          break;
        }
      }
    }
  }

  /// Extract type, year, Censor Rating and duration from ul<TitleBlockMetaData>
  void _scrapeLanguageDetails(Document document, Map movieData) {
    movieData[outerElementLanguage] = LanguageType.none;
    final languageHtml =
        document.querySelector('li[data-testid="title-details-languages"]') ??
            document
                .querySelector('a[href*="primary_language"]')
                ?.parent // li - line item for the language.
                ?.parent; // ul - list of languages.

    if (null != languageHtml && languageHtml.hasChildNodes()) {
      final silent = languageHtml.querySelector('a[href*="language=zxx"]');
      if (null != silent) {
        movieData[outerElementLanguage] = LanguageType.silent;
        return;
      }

      movieData[outerElementLanguages] = [];
      for (final item
          in languageHtml.querySelectorAll('a[href*="language="]')) {
        movieData[outerElementLanguages].add(item.text);
      }

      for (final String languageText in movieData[outerElementLanguages]) {
        // Loop through all languages in order to see how dominant English is.
        if (languageText.toUpperCase().contains('ENGLISH')) {
          if (LanguageType.none == movieData[outerElementLanguage] ||
              LanguageType.allEnglish == movieData[outerElementLanguage]) {
            // First items found are English, assume all English until other languages found.
            movieData[outerElementLanguage] = LanguageType.allEnglish;
            continue;
          } else {
            // English is not the first langauge listed.
            movieData[outerElementLanguage] = LanguageType.someEnglish;
            return;
          }
        }
        if (LanguageType.allEnglish == movieData[outerElementLanguage]) {
          // English was the first langauge listed but found another language.
          movieData[outerElementLanguage] = LanguageType.mostlyEnglish;
          return;
        } else {
          // First item found is foreign, assume all foreign until other languages found.
          movieData[outerElementLanguage] = LanguageType.foreign;
          continue;
        }
      }
    }
  }

  /// Use CSS selector to find the text on the page
  /// and extract values from the page.
  void _getAttributeValue(Map moviedata, Document document, String attribute) {
    if (moviedata[attribute] != null) return;
    final elements = document.querySelectorAll('span[itemprop="$attribute"]');
    for (final element in elements) {
      if (element.text.length > 1) {
        final webPageText = element.text;
        moviedata[attribute] = webPageText;
      }
    }
  }

  /// Extract the movie recommendations from the current movie.
  void _getRecomendationList(Map movieData, Document document) {
    movieData[outerElementRelated] = [];
    for (final element in document.querySelectorAll('div.rec_overview')) {
      _getRecomendationOld(movieData, element);
    }
    for (final element
        in document.querySelectorAll('div.ipc-poster-card--base')) {
      _getRecomendationNew(movieData, element);
    }
  }

  void _getRecomendationNew(Map movieData, Element recommendation) {
    final attributes = {};
    // href will be in the form "/title/tt0145681/?ref_=tt_sims_tt_t_9"
    final link =
        recommendation.querySelector('a[href*="title/tt"]')?.attributes['href'];
    attributes[outerElementIdentity] = getIdFromIMDBLink(link);

    attributes[outerElementOfficialTitle] =
        recommendation.querySelector('span[data-testid="title"]')?.text;
    attributes[outerElementImage] =
        recommendation.querySelector('img')?.attributes['src'];
    attributes[innerElementRatingValue] =
        recommendation.querySelector('span.ipc-rating-star--imdb')?.text; //6.9
    movieData[outerElementRelated].add(attributes);
  }

  void _getRecomendationOld(Map movieData, Element recommendation) {
    final attributes = {};
    attributes[outerElementIdentity] = recommendation
        .querySelector('div[data-tconst]')
        ?.attributes['data-tconst']; //tt1037705
    attributes[outerElementOfficialTitle] = recommendation
        .querySelector('div.rec-title')
        ?.querySelector('b')
        ?.innerHtml; //The Book of Eli
    attributes[outerElementYear] = recommendation
        .querySelector('div.rec-title')
        ?.querySelector('span')
        ?.innerHtml; //(2010)
    attributes[outerElementImage] =
        recommendation.querySelector('img')?.attributes['src'];
    attributes[innerElementRatingValue] = recommendation
        .querySelector('span.rating-rating')
        ?.querySelector('span.value')
        ?.innerHtml; //6.9
    attributes[innerElementRatingCount] = recommendation
            .querySelector('span.rating-list')
            ?.attributes[
        'title']; //"Users rated this 6.9/10 (297,550 votes) - click stars to rate"
    attributes[outerElementDescription] = recommendation
        .querySelector('div.rec-outline')
        ?.querySelector('p')
        ?.innerHtml; //A post-apocalyptic tale... saving humankind.
    movieData[outerElementRelated].add(attributes);
  }
}
