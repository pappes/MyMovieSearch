import 'dart:convert';

import 'package:html/parser.dart' show parse;
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
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
  static final detailConverter = ImdbWebScraperConverter(
    DataSourceType.imdbSearch,
  );

  /// Reduce computation effort for html extraction.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    try {
      final json = fastParse(webText);
      return _scrapeSearchResult(json, 'N/A', webText);
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
      return _scrapeSearchResult(jsonTree, jsonText, webText);
    }
    throw 'No search results found in html:$webText';
  }

  /// Extract search content from json
  Future<List> _scrapeSearchResult(
    dynamic jsonTree,
    String jsonText,
    String webText,
  ) async {
    final contents = TreeHelper(jsonTree).deepSearch(
      deepJsonResultsSuffix, // nameResults or titleResults
      multipleMatch: true,
      suffixMatch: true,
    );
    if (null != contents) {
      final list = _extractSearchResults(contents);
      return list;
    } else if (null != TreeHelper(jsonTree).deepSearch(deepRelatedHeader)) {
      return _scrapeMovieDetails(webText);
    }
    throw 'No search results found in json:$jsonText';
  }

  /// Delegate web scraping to IMDBMovie web scraper.
  Future<List> _scrapeMovieDetails(String webText) {
    final movie = QueryIMDBTitleDetails(criteria);
    return movie.myConvertWebTextToTraversableTree(webText);
  }

  // Extract search content from json
  List<Map> _extractSearchResults(List searchResult) {
    final results = <Map>[];
    final resultNodes = searchResult.deepSearch(
          deepJsonResults, // 'results'
          multipleMatch: true,
        ) ??
        [];
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
    if (results.isEmpty) {
      throw 'Possible IMDB site update, no search result found for search query, json contents:$searchResult';
    }
    return results;
  }

  Map _getPerson(Map person) {
    final Map rowData = {};
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

  Map _getMovie(Map movie) {
    final Map rowData = {};
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
