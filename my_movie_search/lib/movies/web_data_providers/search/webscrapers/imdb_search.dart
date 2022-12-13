import 'dart:convert';

import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const _searchResultsTable = 'findList';
const _columnMovieText = 'result_text';
const _columnMoviePoster = 'primary_photo';
const _searchResultId = 'id';
const _searchResultPersonName = 'displayNameText';
const _searchResultPersonImage = 'avatarImageModel';
const _searchResultPersonJob = 'knownForJobCategory';
const _searchResultPersonMovie = 'knownForTitleText';
const _searchResultMovieName = 'titleNameText';
const _searchResultMovieYearRange = 'titleReleaseText';
const _searchResultMovieType = 'imageType';
const _searchResultMovieImage = 'titlePosterImageModel';
const _searchResultMovieActors = 'topCredits';

/// Implements [WebFetchBase] for the IMDB search html web scraper.
///
/// ```dart
/// QueryIMDBSearch().readList(criteria, limit: 10)
/// ```
mixin ScrapeIMDBSearchDetails
    on WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  /// Scrape movie data from html table(s) named findList.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final document = parse(webText);
    return _scrapeSearchResult(document, webText);
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Future<List> _scrapeSearchResult(Document document, String webText) async {
    // Check to see if search retruned a single result page
    final detailScriptElement =
        document.querySelector('script[type="application/ld+json"]');
    if (detailScriptElement?.innerHtml.isNotEmpty ?? false) {
      final movieData = json.decode(detailScriptElement!.innerHtml) as Map;
      if (movieData["@type"] == "Person") {
        return _scrapePersonResult(webText);
      }
      if (movieData["@type"] != null) {
        return _scrapeMovieResult(webText);
      }
    }
    // Extract search content from json
    final resultScriptElement =
        document.querySelector('script[type="application/json"]');
    if (detailScriptElement?.innerHtml.isNotEmpty ?? false) {
      final searchResult = json.decode(detailScriptElement!.innerHtml) as Map;
      final list = _extractRowsFromMap(searchResult);
      if (list.isNotEmpty) return list;
    }
    // Extract required tables from the dom (anything named findList).
    final tables = document.getElementsByClassName(_searchResultsTable);
    final list = _extractRowsFromTables(tables);
    if (list.isNotEmpty) return list;
    throw 'no search results found in $webText';
  }

  /// Delegate web scraping to IMDBPerson web scraper.
  Future<List> _scrapePersonResult(String webText) {
    final person = QueryIMDBNameDetails();
    person.criteria = criteria;
    return person.myConvertWebTextToTraversableTree(webText);
  }

  /// Delegate web scraping to IMDBMovie web scraper.
  Future<List> _scrapeMovieResult(String webText) {
    final movie = QueryIMDBTitleDetails();
    movie.criteria = criteria;
    return movie.myConvertWebTextToTraversableTree(webText);
  }

  // Extract search content from json
  List<Map> _extractRowsFromMap(Map searchResult) {
    List<Map> results = [];
    try {
      final content = searchResult['props']?['pageProps'] as Map;
      final people = content?['nameResults']?['results'] as List;
      for (final person in people) {
        results.add(_getPerson(person as Map));
      }
      final movies = content?['titleResults']?['results'];
      for (final movie in movies) {
        results.add(_getMovie(movie as Map));
      }
    } catch (_) {
      //TODO: return error explaining IMDB change of format for search result
    }
    return results;
  }

  Map _getPerson(Map person) {
    final Map rowData = {};
    rowData[outerElementIdentity] = person[_searchResultId];
    rowData[outerElementOfficialTitle] = person[_searchResultPersonName];
    //rowData[outerElementYearRange] = getYearRange(info);
    //rowData[outerElementType] = movieType;
    rowData[outerElementImage] = person[_searchResultPersonImage];
    return rowData;
  }

  Map _getMovie(Map movie) {
    final Map rowData = {};
    rowData[outerElementIdentity] = rowData[_searchResultId];
    rowData[outerElementOfficialTitle] = rowData[_searchResultMovieName];
    rowData[outerElementYearRange] = rowData[_searchResultMovieYearRange];
    rowData[outerElementType] = rowData[_searchResultMovieType];
    rowData[outerElementImage] = rowData[_searchResultMovieImage];
    return rowData;
  }

  /// Extract movie data from rows in html table(s).
  List<Map> _extractRowsFromTables(List<Element> tables) {
    final htmlMovies = <Map>[];

    for (final table in tables) {
      final rows = table.getElementsByType(ElementType.row);
      for (final row in rows) {
        htmlMovies.add(_extractRowData(row));
      }
    }

    return htmlMovies;
  }

  /// Convert HTML row element into a map of individual field data.
  /// <a title>       -> Title
  /// <img>           -> Image
  /// <a href>        -> AnchorAddress
  /// <td> text </td> -> Info (year and type)
  Map _extractRowData(Element tableRow) {
    final rowData = {};
    for (final tableColumn in tableRow.children) {
      if (tableColumn.className == _columnMovieText) {
        rowData[dataSource] = DataSourceType.imdbSearch;
        String title =
            DynamicHelper.toString_(rowData[outerElementOfficialTitle]);
        String uniqueId =
            DynamicHelper.toString_(rowData[outerElementIdentity]);

        // <td> text </td> -> Title (year) (Type)
        final info = tableColumn.text;
        tableColumn.getElementsByType(ElementType.anchor).forEach((element) {
          // <a href> -> AnchorAddress
          uniqueId =
              getID(element.getAttribute(AttributeType.address)) ?? uniqueId;
          // <a title> -> Title
          title = element.text;
        });

        rowData[outerElementIdentity] = uniqueId;
        rowData[outerElementOfficialTitle] = title;
        rowData[outerElementYearRange] = getYearRange(info);

        final movieType = findImdbMovieContentTypeFromTitle(
          info,
          title,
          null, // Unknown duration.
          uniqueId,
        );
        rowData[outerElementType] = movieType;
      } else if (tableColumn.className == _columnMoviePoster) {
        // <img> -> Image
        tableColumn.getElementsByType(ElementType.image).forEach((element) {
          rowData[outerElementImage] =
              element.getAttribute(AttributeType.source);
        });
      }
    }
    return rowData;
  }

  // Determine unique ID from '/title/tt13722802/?ref_=fn_tt_tt_6'
  static String? getID(Object? identifier) {
    if (identifier == null) return null;
    final id = identifier.toString();
    final lastSlash = id.lastIndexOf('/');
    if (lastSlash == -1) return null;
    final secondLastSlash = id.lastIndexOf('/', lastSlash - 1);
    if (secondLastSlash == -1) return null;
    return id.substring(secondLastSlash + 1, lastSlash);
  }

  // Extract year range from 'title 123 (1988–1993) (TV Series) aka title 123'
  static String? getYearRange(Object? info) {
    if (info == null) return null;
    final String title = info.toString();
    final lastClose = title.lastIndexOf(')');
    if (lastClose == -1) return null;
    final dates = title.lastIndexOf(RegExp('[0-9]'), lastClose);
    if (dates == -1) return null;
    final yearOpen = title.lastIndexOf('(', dates);
    final yearClose = title.indexOf(')', dates);
    if (yearOpen == -1 || yearClose == -1) return null;

    final yearRange = title.substring(yearOpen + 1, yearClose);
    final filter = RegExp('[0-9].*[0-9]');
    final numerics = filter.stringMatch(yearRange);
    return numerics;
  }
}
