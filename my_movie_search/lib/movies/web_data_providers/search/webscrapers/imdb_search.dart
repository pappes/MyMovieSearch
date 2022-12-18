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
const _searchResultPersonMovieYear = 'knownForTitleYear';
const _searchResultMovieName = 'titleNameText';
const _searchResultMovieYearRange = 'titleReleaseText';
const _searchResultMovieType = 'imageType';
const _searchResultMovieImage = 'titlePosterImageModel';
const _searchResultImageUrl = 'url';
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
    // Check to see if search returned a single result page
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
    if (resultScriptElement?.innerHtml.isNotEmpty ?? false) {
      final searchResult = json.decode(resultScriptElement!.innerHtml) as Map;
      final list = _extractRowsFromMap(searchResult);
      return list;
    }
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
    rowData[outerElementImage] =
        person[_searchResultPersonImage][_searchResultImageUrl];
    String knownFor = 'known for ${person[_searchResultPersonMovie]}';
    if (null != person[_searchResultPersonMovieYear]) {
      knownFor += '(${person[_searchResultPersonMovieYear]})';
    }
    rowData[outerElementDescription] = knownFor;
    return rowData;
  }

  Map _getMovie(Map movie) {
    final Map rowData = {};
    rowData[outerElementIdentity] = movie[_searchResultId];
    rowData[outerElementOfficialTitle] = movie[_searchResultMovieName];
    rowData[outerElementYearRange] = movie[_searchResultMovieYearRange];
    rowData[outerElementImage] =
        movie[_searchResultMovieImage][_searchResultImageUrl];
    rowData[outerElementDescription] = 'staring '
        '${movie[_searchResultMovieActors]}';

    final movieType = getImdbMovieContentType(
      movie[_searchResultMovieType],
      null, // Unknown duration.
      rowData[outerElementIdentity].toString(),
    );
    rowData[outerElementType] = movieType;
    return rowData;
  }
}
