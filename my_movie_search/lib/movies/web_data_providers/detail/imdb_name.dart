import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape_small.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb_name.dart';
import 'offline/imdb_name.dart';

/// Implements [WebFetchBase] for retrieving person details from IMDB.
class QueryIMDBNameDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://www.imdb.com/name/';
  static final _cache = TieredCache();
  static const _defaultSearchResultsLimit = 100;
  static final List<SearchCriteriaDTO> _normalQueue = [];
  static final List<SearchCriteriaDTO> _verySlowQueue = [];
  static final htmlDecode = HtmlUnescape();

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return 'imdb_person';
  }

  /// Return a list with data matching [criteria].
  ///
  /// Optionally override the [priority] to push slow operations to another thread.
  /// Optionally inject [source] as an alternate datasource for mocking/testing.
  /// Optionally [limit] the quantity of results returned from the query.
  Future<List<MovieResultDTO>> readPrioritisedCachedList(
    SearchCriteriaDTO criteria, {
    String priority = ThreadRunner.slow,
    DataSourceFn? source,
    int? limit = _defaultSearchResultsLimit,
  }) async {
    var retval = <MovieResultDTO>[];

    // if cached and not stale yield from cache
    if (_isResultCached(criteria) && !_isCacheStale(criteria)) {
      print(
        '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
        'value was precached ${myFormatInputAsText(criteria)}',
      );
      return _fetchResultFromCache(criteria).toList();
    }

    final newPriority = _enqueRequest(criteria, priority);
    if (null == newPriority) {
      print(
        '${ThreadRunner.currentThreadName}($priority) '
        'discarded ${myFormatInputAsText(criteria)}',
      );
      return [];
    }
    print(
      '${ThreadRunner.currentThreadName}($priority) ${myDataSourceName()} '
      'requesting ${myFormatInputAsText(criteria)}',
    );

    retval = await ThreadRunner.namedThread(newPriority).run(
      runReadList,
      {
        'criteria': criteria,
        'source': source,
        'limit': limit,
      },
    ) as List<MovieResultDTO>;
    retval.forEach(_addResultToCache);

    _normalQueue.remove(criteria);
    _verySlowQueue.remove(criteria);
    return retval;
  }

  /// static wrapper to readList() for compatability with ThreadRunner.
  static Future<List<MovieResultDTO>> runReadList(Map input) {
    return QueryIMDBNameDetails().readList(
      input['criteria'] as SearchCriteriaDTO,
      source: input['source'] as DataSourceFn?,
      limit: input['limit'] as int?,
    );
  }

  /// Check cache to see if data has already been fetched.
  bool _isResultCached(SearchCriteriaDTO criteria) {
    final key = '${myDataSourceName()}${criteria.criteriaTitle}';
    return _cache.isCached(key);
  }

  /// Check cache to see if data in cache should be refreshed.
  bool _isCacheStale(SearchCriteriaDTO criteria) {
    return false;
    //return _cache.isCached(criteria.criteriaTitle);
  }

  /// Insert transformed data into cache.
  void _addResultToCache(MovieResultDTO fetchedResult) {
    final key = '${myDataSourceName()}${fetchedResult.uniqueId}';
    print(
      '${ThreadRunner.currentThreadName} cache add '
      '${fetchedResult.uniqueId} size:${_cache.cachedSize()}',
    );

    if (fetchedResult.uniqueId == 'nm0000243') {
      print(
        '${ThreadRunner.currentThreadName} breakpoint cache add '
        '${fetchedResult.uniqueId} size:${_cache.cachedSize()}',
      );
    }
    _cache.add(key, fetchedResult);
  }

  /// Retrieve cached result.
  Stream<MovieResultDTO> _fetchResultFromCache(
    SearchCriteriaDTO criteria,
  ) async* {
    final value =
        await _cache.get('${myDataSourceName()}${criteria.criteriaTitle}');
    if (value is MovieResultDTO) {
      yield value;
    }
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbHtmlOfflineData;
  }

  /// Scrape movie data from rows in the html table named findList.
  @override
  Stream<MovieResultDTO> baseTransformTextStreamToOutput(
    Stream<String> str,
  ) async* {
    // Combine all HTTP chunks together for HTML parsing.
    final content = await str.reduce((value, element) => '$value$element');

    final movieData = _scrapeWebPage(content);
    if (movieData[outerElementDescription] == null) {
      yield myYieldError(
        'imdb webscraper data not detected '
        'for criteria $getCriteriaText',
      );
    }
    yield* Stream.fromIterable(baseTransformMapToOutputHandler(movieData));
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.criteriaTitle;
  }

  /// API call to IMDB person details for person id.
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria';
    return WebRedirect.constructURI(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      ImdbNamePageConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie Name when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO().error();
    error.title = '[QueryIMDBNameDetails] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map _scrapeWebPage(String content) {
    // Extract embedded JSON.
    final document = parse(content);
    final movieData = json.decode(_getMovieJson(document)) as Map;
    _scrapeName(document, movieData);
    _scrapePoster(document, movieData);
    _scrapeRelated(document, movieData);

    movieData['id'] = getCriteriaText ?? movieData['id'];
    return movieData;
  }

  /// Use CSS selector to find the JSON script on the page
  /// and extract values from the JSON.
  String _getMovieJson(Document document) {
    final scriptElement =
        document.querySelector('script[type="application/ld+json"]');
    if (scriptElement == null || scriptElement.innerHtml.isEmpty) {
      logger.e('no JSON details found for Name $getCriteriaText');
      return '{}';
    }
    return scriptElement.innerHtml;
  }

  /// Extract Official name of person from web page.
  void _scrapeName(Document document, Map movieData) {
    final oldName = movieData[outerElementOfficialTitle];
    movieData[outerElementOfficialTitle] = '';
    var section = document.querySelector('h1[data-testid="hero-Name-block"]');
    section ??=
        document.querySelector('td[class*="name-overview-widget__section"]');
    final spans = section?.querySelector('h1')?.querySelectorAll('span');
    if (null != spans) {
      for (final span in spans) {
        movieData[outerElementOfficialTitle] += span.text;
      }
    }
    if ('' == movieData[outerElementOfficialTitle]) {
      movieData[outerElementOfficialTitle] = oldName;
    }
    movieData[outerElementOfficialTitle] =
        htmlDecode.convert(movieData[outerElementOfficialTitle].toString());
  }

  /// Search for movie poster.
  void _scrapePoster(Document document, Map movieData) {
    final posterBlock =
        document.querySelector('div[class="poster-hero-container"]');
    if (null != posterBlock && posterBlock.hasChildNodes()) {
      for (final poster in posterBlock.querySelectorAll('img')) {
        if (null != poster.attributes['src']) {
          movieData[outerElementImage] = poster.attributes['src'];
          break;
        }
      }
    }
  }

  /// Extract the movies for the current person.
  void _scrapeRelated(Document document, Map movieData) {
    movieData[outerElementRelated] = [];
    final filmography = document.querySelector('#filmography');
    if (null != filmography) {
      var headerText = '';
      for (final child in filmography.children) {
        if (!child.classes.contains('filmo-category-section')) {
          headerText = child.attributes['data-category'] ?? '?';
        } else {
          final movieList = _getMovieList(child.children);
          movieData[outerElementRelated].add({headerText: movieList});
        }
      }
    }
  }

  List<Map> _getMovieList(List<Element> rows) {
    final movies = <Map>[];
    for (final child in rows) {
      final link = child.querySelector('a');
      if (null != link) {
        final movie = {};
        movie[outerElementOfficialTitle] = link.text;
        movie[outerElementLink] = link.attributes['href'];
        movie[outerElementOfficialTitle] =
            htmlDecode.convert(movie[outerElementOfficialTitle].toString());
        movies.add(movie);
      }
    }
    return movies;
  }

  String? _enqueRequest(SearchCriteriaDTO criteria, String priority) {
    // Track and throttle low priority requests
    if (ThreadRunner.slow == priority || ThreadRunner.verySlow == priority) {
      if (_normalQueue.contains(criteria) ||
          _verySlowQueue.contains(criteria)) {
        return null;
      }
      if (criteria.criteriaTitle == 'nm0000243') {
        print(
          '${ThreadRunner.currentThreadName}cache miss '
          '${criteria.criteriaTitle}',
        );
      }

      if (_normalQueue.length < 10 && ThreadRunner.verySlow != priority) {
        _normalQueue.add(criteria);
      } else {
        _verySlowQueue.add(criteria);
        return ThreadRunner.verySlow;
      }
    }
    return priority;
  }
}
