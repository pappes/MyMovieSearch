import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/fishpond_barcode.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonSelector = 'script[type="application/ld+json"]';

const titleElement = 'name';
const imageElement = 'image';
const descriptionElement = 'description';
const dateElement = 'datePublished';

/// Implements [WebFetchBase] for the FishpondBarcode search html web scraper.
///
/// ```dart
/// ScrapeFishpondBarcodeSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeFishpondBarcodeSearch
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  final movieData = <Map<String, dynamic>>[];
  bool validPage = false;
  final searchLog = StringBuffer();

  /// Convert web text to a traversable tree of [List] or [Map] data.
  /// Scrape keyword data from rows in the html div named fullcredits_content.
  @override
  Future<List<Map<String, dynamic>>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    if (webText.contains('"totalResults": 0')) {
      return [];
    }
    _slowConvertWebTextToTraversableTree(webText);
    if (validPage) {
      return movieData;
    }
    throw WebConvertException(
      'FishpondBarcode results data not detected log: $searchLog '
      'for criteria $getCriteriaText in html:$webText',
    );
  }

  /// Scrape movie data from html json <script> tag.
  List<dynamic> _slowConvertWebTextToTraversableTree(String webText) {
    final document = parse(webText);
    final resultScriptElement = document.querySelector(jsonSelector);
    if (resultScriptElement?.innerHtml.isNotEmpty ?? false) {
      final jsonText = resultScriptElement!.innerHtml;
      final jsonTree = json.decode(jsonText);
      return _scrapeSearchResult(jsonText, jsonTree);
    }
    throw WebConvertException('No search results found in html:$webText');
  }

  List<dynamic> _scrapeSearchResult(String jsonText, dynamic jsonTree) {
    if (jsonTree is Map && jsonTree.containsKey(titleElement)) {
      validPage = true;
      final result = <String, dynamic>{};

      final title = jsonTree[titleElement]?.toString() ?? '';
      final rawDescription = jsonTree[descriptionElement]?.toString() ?? '';
      final rawUrl = jsonTree[imageElement]?.toString() ?? '';
      final rawYear = TreeHelper(jsonTree).deepSearch(dateElement)?.first;
      final yearText = rawYear?.toString();
      final yearParts = yearText?.split('-');
      final year = yearParts?.isNotEmpty ?? false ? yearParts?.first : '';

      result[jsonRawDescriptionKey] = '$title $year';
      result[jsonCleanDescriptionKey] = rawDescription;
      result[jsonUrlKey] = rawUrl;
      movieData.add(result);
      return movieData;
    }
    throw WebConvertException(
      'Possible FishpondBarcode site update, no search result found for search query, '
      'json contents:${jsonText.characters.take(100)}...',
    );
  }
}
