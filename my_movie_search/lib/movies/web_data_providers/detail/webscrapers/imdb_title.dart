import 'dart:async';
import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape_small.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_title.dart';
import 'package:my_movie_search/utilities/extensions/dom_extentions.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const searchResultsTable = 'findList';
const columnMovieText = 'result_text';
const columnMoviePoster = 'primary_photo';

/// Implements [WebScraper] for retrieving movie details from IMDB.
mixin ScrapeIMDBTitleDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final htmlDecode = HtmlUnescape();

  /// Convert web text to a traversable tree of [List] or [Map] data.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    final movieData = _scrapeWebPage(document);
    if (movieData[outerElementOfficialTitle] == null) {
      var sample = webText;
      if (sample.length > 100) {
        sample = webText.replaceRange(100, webText.length, '...');
      }
      throw 'imdb web scraper data not detected for criteria $getCriteriaText in $sample';
    }
    return [movieData];
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map _scrapeWebPage(Document document) {
    // Extract embedded JSON.
    final movieData = json.decode(_getMovieJson(document)) as Map;

    if (movieData.isNotEmpty) {
      unawaited(_fetchAdditionalPersonDetails(movieData[outerElementActors]));
      unawaited(_fetchAdditionalPersonDetails(movieData[outerElementDirector]));
      _decodeList(movieData, outerElementKeywords);
    }
    // Get better details from the web page where possible.
    _scrapePoster(document, movieData);
    _scrapeBetterDescription(document, movieData);
    _scrapeLanguageDetails(document, movieData);

    _getRecommendationList(movieData, document);
    _getCastDetailsList(movieData, document);

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

  /// Extract short description of movie from web page.
  void _scrapeBetterDescription(Document document, Map movieData) {
    final descriptionElement =
        document.querySelector('div[data-testid="storyline-plot-summary"]') ??
            document.querySelector('span[data-testid*="plot"]');
    final newDescription = descriptionElement?.text ?? '';
    final oldDescription = (movieData[outerElementDescription] ?? '') as String;
    if (newDescription.length > oldDescription.length) {
      movieData[outerElementDescription] = newDescription;
    }
  }

  /// Search for movie poster.
  void _scrapePoster(Document document, Map movieData) {
    final posterBlock =
        document.querySelector('div[data-testid="hero-media__poster"]') ??
            document.querySelector('div[class="Media__PosterContainer"]');
    if (null != posterBlock && posterBlock.hasChildNodes()) {
      for (final poster in posterBlock.querySelectorAll('img')) {
        final url = poster.getAttribute(AttributeType.source);
        if (null != url) {
          movieData[outerElementImage] = url;
          break;
        }
      }
    }
  }

  /// Loop through all languages to see how predominant English is.
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

      final languages = <String>[];
      for (final item
          in languageHtml.querySelectorAll('a[href*="language="]')) {
        languages.add(item.text);
      }
      movieData[outerElementLanguages] = languages;
      movieData[outerElementLanguage] = _distillLanguages(languages);
    }
  }

  /// Loop through all languages in order to see how dominant English is.
  LanguageType _distillLanguages(List<String> languages) {
    var mainLanguage = LanguageType.none;
    for (final String languageText in languages) {
      if (languageText.toUpperCase().contains('ENGLISH')) {
        if (LanguageType.none == mainLanguage ||
            LanguageType.allEnglish == mainLanguage) {
          // First item(s) found are English, assume all English until other languages found.
          mainLanguage = LanguageType.allEnglish;
          continue;
        } else {
          // English is not the first language listed.
          return LanguageType.someEnglish;
        }
      }
      if (LanguageType.allEnglish == mainLanguage) {
        // English was the first language listed but found another language.
        return LanguageType.mostlyEnglish;
      } else {
        // First item found is foreign, assume all foreign until other languages found.
        mainLanguage = LanguageType.foreign;
        continue;
      }
    }
    return mainLanguage;
  }

  /// Extract displayed information about actors and actresses.
  void _getCastDetailsList(Map movieData, Document document) {
    for (final element
        in document.querySelectorAll('div[data-testid="title-cast-item"]')) {
      _getCastImage(movieData, element);
    }
  }

  void _getCastImage(Map movieData, Element recommendation) {
    final castMember = {};
    // href will be in the form "/name/nm0145681?ref_=tt_sims_tt_t_9"
    final link =
        recommendation.querySelector('a[data-testid="title-cast-item__actor"]');
    if (null != link) {
      castMember[outerElementOfficialTitle] = link.text;
      castMember[outerElementIdentity] = getIdFromIMDBLink(
        link.getAttribute(
          AttributeType.address,
        ),
      );
      castMember[outerElementImage] = recommendation
          .querySelector('img')
          ?.getAttribute(AttributeType.source);

      if (movieData[outerElementActors] == null) {
        movieData[outerElementActors] = [castMember];
      } else {
        (movieData[outerElementActors] as List).add(castMember);
      }
    }
  }

  /// Extract the movie recommendations from the current movie.
  void _getRecommendationList(Map movieData, Document document) {
    movieData[outerElementRelated] = [];
    for (final element
        in document.querySelectorAll('div.ipc-poster-card--base')) {
      _getRecommendation(movieData, element);
    }
  }

  void _getRecommendation(Map movieData, Element recommendation) {
    final attributes = {};
    // href will be in the form "/title/tt0145681/?ref_=tt_sims_tt_t_9"
    final link =
        recommendation.querySelector('a[href*="title/tt"]')?.attributes['href'];
    attributes[outerElementIdentity] = getIdFromIMDBLink(link);

    attributes[outerElementOfficialTitle] =
        recommendation.querySelector('span[data-testid="title"]')?.text;
    attributes[outerElementImage] =
        recommendation.querySelector('img')?.getAttribute(AttributeType.source);
    attributes[innerElementRatingValue] =
        recommendation.querySelector('span.ipc-rating-star--imdb')?.text; //6.9
    attributes[outerElementOfficialTitle] =
        attributes[outerElementOfficialTitle].toString();
    (movieData[outerElementRelated] as List).add(attributes);
  }

  Future _fetchAdditionalPersonDetails(dynamic people) async {
    final cast = ImdbTitleConverter.getPeopleFromJson(people);
    for (final people in cast) {
      final detailCriteria = SearchCriteriaDTO();
      detailCriteria.criteriaTitle = people.uniqueId;
      //TODO: once rate limiting is implemented, queue a low priority fetch
    }
  }

  /// Remove any html encoding from a list of strings or comma delimited string
  void _decodeList(Map movieData, String key) {
    if (movieData.containsKey(key)) {
      if (movieData[key] is List) {
        final tempList = <String>[];
        for (final keyword in movieData[key]) {
          tempList.add(htmlDecode.convert(keyword.toString()));
        }
        movieData[key] = tempList;
      } else {
        final tempList = movieData[key].toString().split(',');
        movieData[key] = tempList;
        _decodeList(movieData, key);
      }
    }
  }
}
