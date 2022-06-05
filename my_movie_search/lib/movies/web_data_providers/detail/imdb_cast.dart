import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_cast.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';

/// Implements [WebFetchBase] for retrieving cast and crew information from IMDB.
///
/// ```dart
/// QueryIMDBCastDetails().readList(criteria);
/// ```
class QueryIMDBCastDetails
    extends WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://www.imdb.com/title/';
  static const _baseURLsuffix = '/fullcredits/';

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return 'imdb_cast';
  }

  @override
  WebFetchBase<MovieResultDTO, SearchCriteriaDTO> myClone() {
    return QueryIMDBCastDetails();
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbHtmlOfflineData;
  }

  /// Scrape cast data from rows in the html div named fullcredits_content.
  @override
  Stream<MovieResultDTO> myTransformTextStreamToOutputObject(
    Stream<String> str,
  ) async* {
    // Combine all HTTP chunks together for HTML parsing.
    final content = await str.reduce((value, element) => '$value$element');

    final movieData = _scrapeWebPage(content);
    yield* Stream.fromIterable(baseTransformMapToOutputHandler(movieData));
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.criteriaTitle;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria$_baseURLsuffix';
    return WebRedirect.constructURI(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      ImdbCastConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO().error();
    error.title = '[QueryIMDBCastDetails] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }

  /// Collect webpage text to construct a map of the movie data.
  Map _scrapeWebPage(String content) {
    // Extract embedded JSON.
    final document = parse(content);
    final movieData = {};

    _scrapeRelated(document, movieData);

    movieData['id'] = getCriteriaText ?? movieData['id'];
    return movieData;
  }

  /// Extract the cast for the current movie.
  void _scrapeRelated(Document document, Map movieData) {
    String? roleText;
    final children = document.querySelector('#fullcredits_content')?.children;
    if (null != children) {
      for (final credits in children) {
        roleText = _getRole(credits) ?? roleText;
        final cast = _getCast(credits);
        _addCast(movieData, roleText ?? '?', cast);
      }
    }
  }

  String? _getRole(Element credits) {
    if (credits.classes.contains('dataHeaderWithBorder')) {
      var text = credits.text;
      if (text.isEmpty) {
        text = credits.attributes['id'] ?? credits.attributes['name'] ?? '?';
      }
      final firstLine = text.trim().split('\n').first;
      return '$firstLine:';
    }
    return null;
  }

  void _addCast(Map movieData, String role, dynamic cast) {
    if (!movieData.containsKey(role)) {
      movieData[role] = [];
    }
    (movieData[role] as List).addAll(cast as List);
  }

  List<Map> _getCast(Element table) {
    final movies = <Map>[];
    for (final row in table.querySelectorAll('tr')) {
      final title = StringBuffer();
      var linkURL = '';
      for (final link in row.querySelectorAll('a[href*="/name/nm"]')) {
        title.write(link.text.trim().split('\n').first);
        linkURL = link.attributes['href'] ?? '';
      }
      if (title.isNotEmpty) {
        final person = <String, String>{};
        person[outerElementOfficialTitle] = title.toString();
        person[outerElementLink] = linkURL;
        final charactor = row.querySelector('a[href*="/title/tt"]')?.text;
        if (null != charactor) {
          // Include name of character played by actor for display in search results.
          person[outerElementAlternatetitle] = charactor;
        }
        movies.add(person);
      }
    }
    return movies;
  }
}
