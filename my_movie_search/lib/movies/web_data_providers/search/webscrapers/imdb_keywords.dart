import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape_small.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const keywordId = 'id';
const keywordName = 'titleNameText';
const keywordDescription = 'titleDescription';
const keywordImage = 'titleImage';
const keywordYearRange = 'titleReleaseText';
const keywordTypeInfo = 'titleInfo';
const keywordCensorRating = 'titleCensorRating';
const keywordPopularityRating = 'titlePopulartyRating';
const keywordPopularityRatingCount = 'titlePopulartyRatingCount';
const keywordDuration = 'titleDuration';
const keywordDirectors = 'directors';
const keywordActors = 'topCredits';
const keywordKeywords = 'keywords';

/// Implements [WebFetchBase] for the IMDB Keywords html web scraper.
///
/// ```dart
/// QueryIMDBKeywords().readList(criteria, limit: 10)
/// ```
mixin ScrapeIMDBKeywordsDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final detailConverter = ImdbWebScraperConverter(
    DataSourceType.imdbKeywords,
  );
  static final htmlDecode = HtmlUnescape();

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    return _scrapeWebPage(document);
  }

  /// Collect webpage text to construct a map of the movie data.
  List _scrapeWebPage(Document document) {
    final movieData = [];

    final children = document.querySelector('.lister-list')?.children;
    if (null != children) {
      for (final row in children) {
        final movie = _getMovie(row);
        final id = movie[keywordId];

        if (null != id && id.toString().startsWith(imdbTitlePrefix)) {
          movieData.add(movie);
        }
      }
      final next = document.querySelector('.lister-page-next');
      if (null != next) {
        movieData.add(_addNextPage(next));
      }
    } else {
      throw 'imdb keyword data not detected for criteria $getCriteriaText';
    }
    return movieData;
  }

  Map _getMovie(Element row) {
    final sections = _getSections(row);
    final map = {};
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
    map[keywordDirectors] = _getDirectors(row);
    map[keywordActors] = _getActors(row);
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
      return htmlDecode.convert(anchor?.text.trim() ?? '');
    }
    return null;
  }

  String? _getDescription(Element? section) =>
      htmlDecode.convert(section?.text.trim() ?? '');

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
      section?.querySelector("span[name='nv']")?.text.trim();

  String? _getDuration(Element? section) =>
      section?.querySelector('.runtime')?.text.trim();

  String? _getPopularityRating(Element? section) => section?.text.trim();

  String? _getCensorRating(Element? section) =>
      section?.querySelector(".certificate")?.text.trim();

  String? _getTypeInfo(Element? section) =>
      section?.querySelector('.lister-item-year')?.text.trim();

  String? _getYearRange(Element? section) =>
      section?.querySelector('.lister-item-year')?.text.trim();

  String? _getKeywords(Element? section) {
    return null; // TODO:
  }

  String? _getActors(Element? section) {
    return null; // TODO:
  }

  String? _getDirectors(Element? section) {
    return null; // TODO:
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
              !sections.containsKey('ratings')) {
            //before ratings
            sections['subheading'] = subsection;
          } else if (subsection.className.contains('ratings-bar')) {
            sections['ratings'] = subsection;
          } else if (subsection.className.contains('text-muted') &&
              sections.containsKey('ratings')) {
            //after ratings
            sections['related'] = subsection;
          } else if (subsection.className.contains('num_votes')) {
            sections['votes'] = subsection;
          } else {
            sections['description'] = subsection;
          }
        }
      }
    }

    return sections;
  }

  Map _addNextPage(Element next) {
    final keyword = criteria?.criteriaTitle ?? '';
    final baseURL = myConstructURI(keyword);
    final String extraURL = next.attributes['href'] ?? '';
    final fullUrl = Uri.parse('$baseURL${extraURL.replaceAll('?', '&')}');
    final pageNumber = fullUrl.queryParameters['page'];
    return {
      keywordId: fullUrl.toString(),
      keywordName: next.text,
      keywordKeywords: keyword,
      keywordDescription:
          '{"keyword":$keyword, "page":$pageNumber, "url":$fullUrl}',
    };
  }
}
