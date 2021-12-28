import 'dart:async';
import 'package:html_unescape/html_unescape_small.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/webscrapers/imdb_title.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';

/// Implements [WebFetchBase] for retrieving movie details from IMDB.
class QueryIMDBTitleDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBTitleDetails {
  static const _baseURL = 'https://www.imdb.com/title/';
  static const _baseURLsuffix = '/?ref_=fn_tt_tt_1';
  static final _cache = TieredCache();
  static final htmlDecode = HtmlUnescape();

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return DataSourceType.imdb.name;
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbHtmlOfflineData;
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
      ImdbMoviePageConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO().error();
    error.title = '[QueryIMDBTitleDetails] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }

  /// Check cache to see if data has already been fetched.
  @override
  bool myIsResultCached(SearchCriteriaDTO criteria) {
    final key = '${myDataSourceName()}${criteria.criteriaTitle}';
    return _cache.isCached(key);
  }

  /// Check cache to see if data in cache should be refreshed.
  @override
  bool myIsCacheStale(SearchCriteriaDTO criteria) {
    return false;
    //return _cache.isCached(criteria.criteriaTitle);
  }

  /// Insert transformed data into cache.
  @override
  void myAddResultToCache(MovieResultDTO fetchedResult) {
    final key = '${myDataSourceName()}${fetchedResult.uniqueId}';
    _cache.add(key, fetchedResult);
  }

  /// Retrieve cached result.
  @override
  Stream<MovieResultDTO> myFetchResultFromCache(
    SearchCriteriaDTO criteria,
  ) async* {
    final value =
        await _cache.get('${myDataSourceName()}${criteria.criteriaTitle}');
    if (value is MovieResultDTO) {
      yield value;
    }
  }
}
