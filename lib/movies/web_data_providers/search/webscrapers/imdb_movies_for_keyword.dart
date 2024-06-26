import 'dart:convert';

import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for the IMDB Keywords html web scraper.
///
/// ```dart
/// ScrapeIMDBMoviesForKeyword().readList(criteria, limit: 10)
/// ```
// ignore: missing_override_of_must_be_overridden
mixin ScrapeIMDBMoviesForKeyword
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Reduce computation effort for html extraction.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    try {
      return fastParse(webText);
    } on FastParseException {
      return slowConvertWebTextToTraversableTree(webText);
    }
  }

  /// Convert web text to a traversable tree of [List] or [Map] data.
  ///
  ///
  Future<List<dynamic>> slowConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    final movieData = _scrapeWebPage(document);
    if (movieData[outerElementDescription] == null &&
        movieData['props'] == null) {
      throw WebConvertException(
          'imdb web scraper data not detected for criteria '
          '$getCriteriaText in $webText');
    }
    return [movieData];
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map<dynamic, dynamic> _scrapeWebPage(Document document) {
    final movieData = json.decode(_getMovieJson(document)) as Map;
    return movieData;
  }

  /// Use CSS selector to find the JSON script on the page
  /// and extract values from the JSON.
  String _getMovieJson(Document document) {
    final scriptElement = document.querySelector(jsonScript);
    if (scriptElement == null || scriptElement.innerHtml.isEmpty) {
      logger.e('no JSON details found for Name $getCriteriaText');
      return '{}';
    }
    return scriptElement.innerHtml;
  }
}














/*






  static final htmlDecode = HtmlUnescape();
  static const splitter = LineSplitter();

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, dynamic>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    return _scrapeWebPage(document);
  }

  /// Collect webpage text to construct a map of the movie data.
  List<Map<String, dynamic>> _scrapeWebPage(Document document) {
    final movieData = <Map<String, dynamic>>[];

    final children = document.querySelector('.lister-list')?.children;
    if (null != children) {
      for (final row in children) {
        final movie = _getMovie(row);
        final id = movie[keywordId];

        if (null != id && id.toString().startsWith(imdbTitlePrefix)) {
          movieData.add(movie);
        }
      }
    } else {
      throw WebConvertException(
        'imdb keyword data not detected for criteria $getCriteriaText',
      );
    }
    return movieData;
  }

  Map<String, dynamic> _getMovie(Element row) {
    final sections = _getSections(row);
    final map = <String, dynamic>{};
    map[keywordId] = _getId(sections['header']);

    map[keywordName] = _getTitle(sections['header']);
    map[keywordDescription] = _getDescription(sections['description']);
    map[keywordImage] = _getImage(sections['image']);
    map[keywordYearRange] = _getYearRange(sections['header']);
    map[keywordTypeInfo] = _getTypeInfo(sections['header']);
    map[keywordCensorRating] = _getCensorRating(sections['subheading']);
    map[keywordPopularityRating] = _getPopularityRating(sections['ratings']);
    map[keywordPopularityRatingCount] = _getRatingCount(sections['votes']);
    map[keywordDuration] = _getDuration(sections['subheading']);
    map[keywordDirectors] = _getDirectors(sections['related']);
    map[keywordActors] = _getActors(sections['related']);
    map[keywordKeywords] = _getKeywords(row);

    return map;
  }

  String? _getId(Element? section) {
    if (null != section) {
      final anchor = section.querySelector('a')?.attributes['href'];
      final id = getIdFromIMDBLink(anchor);
      if (id.startsWith(imdbTitlePrefix)) return id;
    }
    return null;
  }

  String? _getTitle(Element? section) {
    if (null != section) {
      final anchor = section.querySelector('a');
      return htmlDecode.convert(anchor?.text.reduceWhitespace() ?? '');
    }
    return null;
  }

  String? _getDescription(Element? section) =>
      htmlDecode.convert(section?.text.reduceWhitespace() ?? '');

  String? _getImage(Element? section) {
    final imageAttributes = section?.querySelector('img')?.attributes;
    if (null != imageAttributes) {
      final loadlate = imageAttributes['loadlate']?.length ?? 0;
      if (loadlate > 10) {
        return imageAttributes['loadlate'];
      }
      if (imageAttributes['src'] ==
          'https://m.media-amazon.com/images/S/sash/4FyxwxECzL-U1J8.pn') {
        return null;
      }
      return imageAttributes['src'];
    }
    return null;
  }

  String? _getRatingCount(Element? section) =>
      section?.querySelector("span[name='nv']")?.text.reduceWhitespace();

  String? _getDuration(Element? section) =>
      section?.querySelector('.runtime')?.text.reduceWhitespace();

  String? _getPopularityRating(Element? section) {
    final ratingText = splitter.convert(section?.text.reduceWhitespace() ?? '');
    if (ratingText.isNotEmpty) {
      return ratingText.first.reduceWhitespace();
    }
    return '';
  }

  String? _getCensorRating(Element? section) =>
      section?.querySelector('.certificate')?.text.reduceWhitespace();

  String? _getTypeInfo(Element? section) =>
      section?.querySelector('.lister-item-year')?.text.reduceWhitespace();

  String? _getYearRange(Element? section) =>
      section?.querySelector('.lister-item-year')?.text.reduceWhitespace();

  String? _getKeywords(Element? section) => criteria.criteriaTitle;

  String? _getActors(Element? section) {
    final cast = <String, dynamic>{};
    var skipDirectors = section?.innerHtml.contains('Director') ?? false;
    if (section?.innerHtml.contains('Stars') ?? false) {
      for (final element in section!.children) {
        if (!skipDirectors) {
          if (null != element.attributes['href']) {
            cast[element.text] = element.attributes['href'];
          }
        } else if (element.text == '|') {
          skipDirectors = false;
        }
      }
    }
    return json.encode(cast);
  }

  String? _getDirectors(Element? section) {
    final directors = <String, dynamic>{};
    if (section?.innerHtml.contains('Director') ?? false) {
      for (final element in section!.children) {
        if (element.text == '|') {
          break;
        }
        if (null != element.attributes['href']) {
          directors[element.text] = element.attributes['href'];
        }
      }
    }
    return json.encode(directors);
  }

  Map<String, Element> _getSections(Element row) {
    final sections = <String, Element>{};
    for (final section in row.children) {
      if (section.className.contains('lister-item-image')) {
        sections['image'] = section;
      }
      if (section.className.contains('lister-item-content')) {
        for (final subsection in section.children) {
          if (subsection.className.contains('lister-item-header')) {
            sections['header'] = subsection;
          } else if (subsection.className.contains('text-muted') &&
              !sections.containsKey('subheading')) {
            sections['subheading'] = subsection;
          } else if (subsection.className.contains('ratings-bar')) {
            sections['ratings'] = subsection;
          } else if (subsection.className.contains('text-muted') &&
              subsection.text.contains('Votes')) {
            sections['votes'] = subsection;
          } else if (subsection.className.contains('text-muted') &&
              (subsection.text.contains('Director') ||
                  subsection.text.contains('Stars'))) {
            sections['related'] = subsection;
          } else if (!sections.containsKey('description')) {
            sections['description'] = subsection;
          }
        }
      }
    }

    return sections;
  }
/*IMDB has moved away from url encoding for pagination



      final next = document.querySelector('.lister-page-next');
      if (null != next) {
        movieData.add(_addNextPage(next));
      }

      
  Map<String, dynamic> _addNextPage(Element next) {
    final keyword = criteria.criteriaTitle;
    final baseURL = myConstructURI(keyword);
    final String extraURL = next.attributes['href'] ?? '';
    final fullUrl = baseURL.resolve(extraURL);
    final pageNumber = fullUrl.queryParameters['page'] ?? '1';
    return {
      keywordId: fullUrl.toString(),
      keywordName: next.text,
      keywordKeywords: keyword,
      keywordDescription: QueryIMDBMoviesForKeyword.encodeJson(
        keyword,
        pageNumber,
        fullUrl.toString(),
      ),
    };
  }*/
}
*/
