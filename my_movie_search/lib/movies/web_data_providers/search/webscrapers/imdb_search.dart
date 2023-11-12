import 'dart:convert';

import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const _searchResultId = 'id';
const _searchResultPersonName = 'displayNameText';
const _searchResultPersonMovie = 'knownForTitleText';
const _searchResultPersonMovieYear = 'knownForTitleYear';
const _searchResultMovieName = 'titleNameText';
const _searchResultMovieYearRange = 'titleReleaseText';
const _searchResultMovieType = 'imageType';
const _searchResultMovieActors = 'topCredits';

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
  ) async {
    try {
      final json = fastParse(webText);
      final result = _scrapeSearchResult(webText, json);
      return result;
    } catch (_) {
      return _slowConvertWebTextToTraversableTree(webText);
    }
  }

  /// Scrape movie data from html json <script> tag.
  Future<List<dynamic>> _slowConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    final resultScriptElement = document.querySelector(jsonScript);
    if (resultScriptElement?.innerHtml.isNotEmpty ?? false) {
      final jsonText = resultScriptElement!.innerHtml;
      final jsonTree = json.decode(jsonText);
      return _scrapeSearchResult(webText, jsonTree, jsonText);
    }
    throw 'No search results found in html:$webText';
  }

  /// Extract search content from json
  Future<List<dynamic>> _scrapeSearchResult(
    String webText,
    dynamic jsonTree, [
    String? jsonText,
  ]) async {
    final contents = TreeHelper(jsonTree).deepSearch(
      deepJsonResultsSuffix, // nameResults or titleResults
      multipleMatch: true,
      suffixMatch: true,
    );
    if (null != contents) {
      try {
        final list = _extractSearchResults(contents);
        return list;
      } catch (_) {}
    } else if (null != TreeHelper(jsonTree).deepSearch(deepRelatedHeader)) {
      return _scrapeMovieDetails(webText);
    }
    throw 'Possible IMDB site update, no search result found for search query, '
        'json contents:${jsonText ?? jsonTree.toString()}';
  }

  /// Delegate web scraping to IMDBMovie web scraper.
  Future<List<dynamic>> _scrapeMovieDetails(String webText) {
    final movie = QueryIMDBTitleDetails(criteria);
    return movie.myConvertWebTextToTraversableTree(webText);
  }

  // Extract search content from json
  List<Map<String, dynamic>> _extractSearchResults(List<dynamic> searchResult) {
    final results = <Map<String, dynamic>>[];
    final resultNodes = searchResult.deepSearch(
          deepJsonResults, // 'results'
          multipleMatch: true,
        ) ??
        [];
    if (resultNodes.isEmpty) {
      throw 'No results';
    }
    for (final resultNode in resultNodes) {
      if (resultNode is List) {
        for (final result in resultNode) {
          if (result is Map) {
            final uniqueid = result[outerElementIdentity]?.toString() ?? '';
            if (uniqueid.startsWith(imdbPersonPrefix)) {
              results.add(_getPerson(result));
            } else if (uniqueid.startsWith(imdbTitlePrefix)) {
              results.add(_getMovie(result));
            }
          }
        }
      }
    }
    return results;
  }

  Map<String, dynamic> _getPerson(Map<dynamic, dynamic> person) {
    final Map<String, dynamic> rowData = {};
    rowData[outerElementIdentity] = person[_searchResultId];
    rowData[outerElementOfficialTitle] = person[_searchResultPersonName];

    rowData[outerElementImage] = person.searchForString(key: deepImageField);
    String knownFor = 'known for ${person[_searchResultPersonMovie]}';
    if (null != person[_searchResultPersonMovieYear]) {
      knownFor += '(${person[_searchResultPersonMovieYear]})';
    }
    rowData[outerElementDescription] = knownFor;
    rowData[outerElementType] = MovieContentType.person;
    return rowData;
  }

  Map<String, dynamic> _getMovie(Map<dynamic, dynamic> movie) {
    final Map<String, dynamic> rowData = {};
    rowData[outerElementIdentity] = movie[_searchResultId];
    rowData[outerElementOfficialTitle] = movie[_searchResultMovieName];
    rowData[outerElementYearRange] = movie[_searchResultMovieYearRange];
    rowData[outerElementImage] = movie.searchForString(key: deepImageField);
    rowData[outerElementDescription] = 'staring '
        '${movie[_searchResultMovieActors]}';

    final movieType = MovieResultDTOHelpers.getMovieContentType(
      '${movie[_searchResultMovieType]} ${rowData[outerElementYearRange]}',
      null, // Unknown duration.
      rowData[outerElementIdentity].toString(),
    );
    rowData[outerElementType] = movieType;
    return rowData;
  }
}
