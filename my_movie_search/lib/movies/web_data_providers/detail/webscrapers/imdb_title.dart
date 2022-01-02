import 'dart:async';
import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape_small.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const searchResultsTable = 'findList';
const columnMovieText = 'result_text';
const columnMoviePoster = 'primary_photo';

/// Implements [WebScraper] for retrieving movie details from IMDB.
mixin ScrapeIMDBTitleDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final htmlDecode = HtmlUnescape();

  // Convert HTML web page to Stream of OUTPUT_TYPE.
  @override
  Stream<MovieResultDTO> baseTransformTextStreamToOutput(
    Stream<String> str,
  ) async* {
    // Combine all HTTP chunks together for HTML parsing.
    final content = await str.reduce((value, element) => '$value$element');

    final movieData = scrapeWebPage(content);
    if (movieData[outerElementDescription] == null) {
      yield myYieldError(
        'imdb webscraper data not detected '
        'for criteria $getCriteriaText',
      );
    }
    yield* Stream.fromIterable(baseTransformMapToOutputHandler(movieData));
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map scrapeWebPage(String content) {
    // Extract embedded JSON.
    final document = parse(content);
    final movieData = json.decode(_getMovieJson(document)) as Map;

    if (movieData.isNotEmpty) {
      unawaited(_fetchAdditionalPersonDetails(movieData[outerElementActors]));
      unawaited(_fetchAdditionalPersonDetails(movieData[outerElementDirector]));
      _decodeList(movieData, outerElementKeywords);
    } else {
      _scrapeName(document, movieData);
      _scrapeType(document, movieData);
    }
    // Get better details from the web page where possible.
    _scrapePoster(document, movieData);
    _scrapeDescription(document, movieData);
    _scrapeLanguageDetails(document, movieData);

    _getRecomendationList(movieData, document);
    _getCastDetailsList(movieData, document);

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

  /// Extract short description of movie from web page.
  void _scrapeDescription(Document document, Map movieData) {
    final description =
        document.querySelector('div[data-testid="storyline-plot-summary"]') ??
            document.querySelector('span[data-testid*="plot"]');
    if (null != description?.text) {
      movieData[outerElementDescription] =
          htmlDecode.convert(description!.text);
    }
  }

  /// Extract Official name of movie from web page.
  void _scrapeName(Document document, Map movieData) {
    final description =
        document.querySelector('h1[data-testid="hero-title-block"]') ??
            document.querySelector('h1[class*="TitleHeader"]');
    if (null != description?.text) {
      movieData[outerElementOfficialTitle] =
          htmlDecode.convert(description!.text);
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

  /// Extract displayed information about actors and actresses.
  void _getCastDetailsList(Map movieData, Document document) {
    for (final element
        in document.querySelectorAll('div[data-testid="title-cast-item"]')) {
      _getCastImage(movieData, element);
    }
  }

  void _getCastImage(Map movieData, Element recommendation) {
    final attributes = {};
    // href will be in the form "/name/nm0145681?ref_=tt_sims_tt_t_9"
    final link =
        recommendation.querySelector('a[data-testid="title-cast-item__actor"]');
    attributes[outerElementOfficialTitle] = link?.text;

    final href = link?.attributes['href'];
    attributes[outerElementIdentity] = getIdFromIMDBLink(href);

    final img = recommendation.querySelector('img');
    attributes[outerElementImage] = img?.attributes['src'];
    movieData[outerElementActors].add(attributes);
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
    attributes[outerElementOfficialTitle] =
        htmlDecode.convert(attributes[outerElementOfficialTitle].toString());
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
    attributes[outerElementOfficialTitle] =
        htmlDecode.convert(attributes[outerElementOfficialTitle].toString());
    attributes[outerElementDescription] =
        htmlDecode.convert(attributes[outerElementDescription].toString());
    movieData[outerElementRelated].add(attributes);
  }

  Future _fetchAdditionalPersonDetails(dynamic people) async {
    final cast = ImdbMoviePageConverter.getPeopleFromJson(people);
    for (final people in cast) {
      final detailCriteria = SearchCriteriaDTO();
      detailCriteria.criteriaTitle = people.uniqueId;

      //TODO decide if we want to prefetch cast details
      //     when pulling back the movie details
      //     before the user has drilled down to the list.
      /*ThreadRunner.namedThread('SlowThread').run(
        _getIMDBPersonDetailsFast,
        detailCriteria,
      );*/
      /*ThreadRunner.namedThread('SlowThread').run(
        _getIMDBPersonDetailsSlow,
        detailCriteria,
      );*/
    }
  }

  /// Add fetch summary person details from imdb.
  static Future<List<MovieResultDTO>> _getIMDBPersonDetailsFast(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBSuggestions().readPrioritisedCachedList(
        criteria,
        priority: ThreadRunner.verySlow,
      );

  /// Add fetch full person details from imdb.
  static Future<List<MovieResultDTO>> _getIMDBPersonDetailsSlow(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBNameDetails().readPrioritisedCachedList(
        criteria,
        priority: ThreadRunner.verySlow,
      );

  /// Remove any html encoding from a list of strings
  void _decodeList(Map movieData, String key) {
    if (movieData.containsKey(key)) {
      var tempList = <String>[];
      if (movieData[key] is List) {
        for (final keyword in movieData[key]) {
          tempList.add(htmlDecode.convert(keyword.toString()));
        }
      } else {
        tempList = movieData[key].toString().split(',');
      }
      movieData[key] = tempList;
    }
  }
}
