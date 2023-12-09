import 'dart:io';

import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/yts_detail.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonSizeKey = 'size';

const magnetSelector = "[href^='magnet:']";
const titleSelector = '#mobile-movie-info h1';
const imageSelector = '#movie-poster img';
const magnetsSelector = '.modal-torrent';
const sizeSelector = '.quality-size';
const descriptionSelector = '#movie-tech-specs .tech-spec-info';

/// Implements [WebScraper] for retrieving download details from yts.
mixin ScrapeYtsDetails on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Convert web text to a traversable tree of [List] or [Map] data.
  @override
  Future<List<Map<String, dynamic>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('404, Oops! This page could not be found')) {
      return [];
    }
    final document = parse(webText);
    return _scrapeWebPage(document);
  }

  /// Allow response parsing for http 404
  @override
  Stream<String>? myHttpError(
    Uri address,
    int statusCode,
    HttpClientResponse response,
  ) =>
      (404 == statusCode)
          ? null
          // ignore: invalid_use_of_visible_for_testing_member
          : super.myHttpError(
              address,
              statusCode,
              response,
            );

  /// Collect webpage text to construct a map of the movie data.
  List<Map<String, dynamic>> _scrapeWebPage(Document document) {
    final movieData = <Map<String, dynamic>>[];
    _scrapeMagnets(document, movieData);
    return movieData;
  }

  /// Extract the download infomation for the current movie.
  void _scrapeMagnets(Document document, List<Map<String, dynamic>> movieData) {
    final title = _getTitle(document);
    final image = _getImage(document);
    final descriptions = _getDescriptions(document);
    final links = _getLinks(document);

    for (final link in links) {
      for (final map in descriptions) {
        if (map[jsonDescriptionKey]
            .toString()
            .contains(link[jsonSizeKey].toString())) {
          movieData.add({...title, ...image, ...link, ...map});
        }
      }
    }

    if (movieData.isEmpty) {
      throw 'yts data not detected for criteria $getCriteriaText';
    }
  }
}

/// Extract the title and year for the current movie.
Map<String, dynamic> _getTitle(Document document) {
  final map = <String, dynamic>{};
  final titleElement = document.querySelector(titleSelector);
  map[jsonNameKey] = titleElement?.cleanText;
  map[jsonYearKey] = titleElement?.nextElementSibling?.cleanText;
  return map;
}

/// Extract the title and year for the current movie.
Map<String, dynamic> _getImage(Document document) {
  final map = <String, dynamic>{};
  final imageElement = document.querySelector(imageSelector);
  map[jsonImageKey] = imageElement?.attributes['src'];
  return map;
}

/// Extract the title and year for the current movie.
List<Map<String, String>> _getLinks(Document document) {
  final links = <Map<String, String>>[];
  final magnetRows = document.querySelectorAll(magnetsSelector);
  for (final row in magnetRows) {
    var size = '0 MB';
    for (final paragraph in row.querySelectorAll(sizeSelector)) {
      if (paragraph.text.endsWith('B')) {
        size = paragraph.text;
      }
    }
    final link = row.querySelector(magnetSelector);
    final url = link?.attributes['href'];

    if (url != null) {
      links.add({
        jsonSizeKey: size,
        jsonMagnetKey: url,
      });
    }
  }
  return links;
}

/// Extract the other details for the current movie.
List<Map<String, dynamic>> _getDescriptions(Document document) {
  final descriptions = <Map<String, dynamic>>[];
  final descriptionRows = document.querySelectorAll(descriptionSelector);
  for (final row in descriptionRows) {
    try {
      final text = row.children.first.cleanText;
      final stats = row.children.last.children.last.cleanText;
      var leechers = 0;
      var seeders = 0;
      if (stats.startsWith('P/S')) {
        final parts = stats.substring(4).split('/');
        if (parts.length == 2) {
          leechers = IntHelper.fromText(parts.first) ?? 0;
          seeders = IntHelper.fromText(parts.last) ?? 0;
        }
      }
      if (stats.startsWith('S')) {
        final parts = stats.split(' ');
        if (parts.length > 1) {
          seeders = IntHelper.fromText(parts.last) ?? 0;
        }
      }

      descriptions.add({
        jsonDescriptionKey: text,
        jsonLeechersKey: leechers,
        jsonSeedersKey: seeders,
      });
    } catch (_) {}
  }
  return descriptions;
}
