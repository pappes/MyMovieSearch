import 'dart:convert';

import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for the IMDB search html web scraper.
///
/// ```dart
/// QueryIMDBSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeIMDBSearchDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Reduce computation effort for html extraction.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
    // Use async to defer expensive processing until needed.
    // ignore: unnecessary_async
  ) async {
    try {
      final json = fastParse(webText);
      final result = _scrapeSearchResult(webText, json);
      return result;
    } on FastParseException {
      return _slowConvertWebTextToTraversableTree(webText);
    }
  }

  /// Scrape movie data from html json <script> tag.
  Future<List<dynamic>> _slowConvertWebTextToTraversableTree(String webText) {
    final document = parse(webText);
    final resultScriptElement = document.querySelector(jsonScript);
    if (resultScriptElement?.innerHtml.isNotEmpty ?? false) {
      final jsonText = resultScriptElement!.innerHtml;
      final jsonTree = json.decode(jsonText);
      return _scrapeSearchResult(webText, jsonTree, jsonText);
    }
    throw WebConvertException('No search results found in html:$webText');
  }

  /// Extract search content from json
  Future<List<dynamic>> _scrapeSearchResult(
    String webText,
    dynamic jsonTree, [
    String? jsonText,
  ]) {
    final contents = TreeHelper(jsonTree).deepSearch(
      deepJsonResultsSuffix, // nameResults or titleResults
      multipleMatch: true,
      suffixMatch: true,
    );
    if (null != contents) {
      try {
        final list = _extractSearchResults(contents);
        return Future.value(list);
      } catch (_) {}
    } else if (null != TreeHelper(jsonTree).deepSearch(deepRelatedHeader)) {
      return _scrapeMovieDetails(webText);
    }
    throw WebConvertException(
      'Possible IMDB site update, no search result found for search query, '
      'json contents:${jsonText ?? jsonTree.toString()}',
    );
  }

  /// Delegate web scraping to IMDBMovie web scraper.
  Future<List<dynamic>> _scrapeMovieDetails(String webText) {
    final movie = QueryIMDBTitleDetails(criteria);
    return movie.myConvertWebTextToTraversableTree(webText);
  }

  // Extract search content from json
  List<Map<String, dynamic>> _extractSearchResults(List<dynamic> searchResult) {
    final results = <Map<String, dynamic>>[];
    final resultNodes =
        searchResult.deepSearch(
          deepJsonResults, // 'results'
          multipleMatch: true,
        ) ??
        [];
    if (resultNodes.isEmpty) {
      throw WebConvertException(
        'No IMDB nameResults or titleResults detected in json for criteria '
        '$getCriteriaText',
      );
    }
    for (final resultNode in resultNodes) {
      if (resultNode is List) {
        for (final result in resultNode) {
          if (result is Map) {
            final uniqueid = result[outerSearchResultsId]?.toString() ?? '';
            final map = result[outerSearchResultsContents];
            if (map is Map) {
              if (uniqueid.startsWith(imdbPersonPrefix)) {
                results.add(_getPerson(map));
              } else if (uniqueid.startsWith(imdbTitlePrefix)) {
                results.add(_getMovie(map));
              }
            }
          }
        }
      }
    }
    return results;
  }

  Map<String, dynamic> _getPerson(Map<dynamic, dynamic> person) {
    final rowData = <String, dynamic>{};
    rowData[outerElementIdentity] = person[outerSearchPersonId];
    rowData[outerElementOfficialTitle] = person[deepPersonNameHeader];

    rowData[outerElementImage] = person.searchForString(key: deepImageField);
    var knownFor = person[deepPersonDescriptionHeader].toString();
    if (null != person[outerSearchResultsKnownForYear]) {
      ///???
      knownFor += '(${person[outerSearchResultsKnownForYear]})';
    }
    rowData[outerElementDescription] = knownFor;
    rowData[outerElementType] = MovieContentType.person;
    return rowData;
  }

  Map<String, dynamic> _getMovie(Map<dynamic, dynamic> movie) {
    final rowData = <String, dynamic>{};
    rowData[outerElementIdentity] = movie[deepTitleId1];
    rowData[outerElementOfficialTitle] = movie[outerSearchResultsMovieTitle];
    final startYear = movie[outerSearchResultsMovieStartYear];
    final endYear = movie[outerSearchResultsMovieEndYear];
    final yearRange = endYear == null ? startYear : '$startYear-$endYear';
    rowData[outerElementYearRange] = yearRange;
    rowData[outerElementDuration] = movie[deepRelatedMovieDurationHeader];
    rowData[outerElementImage] = movie.searchForString(key: deepImageField);
    rowData[outerElementDescription] =
        movie[outerSearchResultsMovieDescription];

    final typeContainer = movie[outerSearchResultsMovieType];
    if (typeContainer is Map) {
      final typeText = typeContainer[outerSearchResultsMovieTypeText];
      final movieType = MovieResultDTOHelpers.getMovieContentType(
        '$typeText $yearRange',
        int.tryParse(rowData[outerElementDuration].toString()),
        rowData[outerElementIdentity].toString(),
      );
      rowData[outerElementType] = movieType;
    }
    return rowData;
  }
}
