import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/imdb_keywords.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_limiter.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonKeywordKey = 'keyword';
const jsonPageKey = 'page';

/// Implements [WebFetchBase] for the IMDB keywords html web scraper.
///
/// ```dart
/// QueryIMDBKeywords().readList(criteria, limit: 10)
/// ```
class QueryIMDBKeywords extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBKeywordsDetails {
  static const _baseURL =
      'https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=';
  static const _pageURL = '&page=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return DataSourceType.imdbKeywords.name;
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbKeywordsHtmlOfflineData;
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return ImdbKeywordsConverter.dtoFromCompleteJsonMap(map);
    }
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// Extract plain text or dto encoded keyword.
  @override
  String myFormatInputAsText(dynamic contents) {
    String keyword = _getCriteriaJsonValue(contents, jsonKeywordKey);
    if (keyword.isEmpty) {
      final criteria = contents as SearchCriteriaDTO;
      keyword = criteria.toPrintableString();
    }
    return keyword;
  }

  /// Extract page number from dto encoded data
  @override
  int myGetPageNumber(dynamic criteria) =>
      IntHelper.fromText(_getCriteriaJsonValue(criteria, jsonPageKey)) ?? 1;

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryIMDBKeywords] $message',
        DataSourceType.imdbKeywords,
      );

  /// API call to IMDB keywords returning the top matching results for [keywordsText].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    searchResultsLimit = WebFetchLimiter(55);
    final url = '$_baseURL$encodedCriteria$_pageURL$pageNumber';
    return Uri.parse(url);
  }

  static String _getCriteriaJsonValue(dynamic criteria, String key) {
    try {
      criteria as SearchCriteriaDTO;

      final jsonText = criteria.criteriaList.first.description;
      if (jsonText.isNotEmpty) {
        final map = jsonDecode(jsonText) as Map;
        return map[key] as String;
      }
    } catch (_) {}
    return '';
  }

  static String encodeJson(String keyword, String pageNumber, String url) {
    final jsonText = '{'
        ' "$jsonKeywordKey":${json.encode(keyword)},'
        ' "$jsonPageKey":${json.encode(pageNumber)},'
        ' "url":${json.encode(url)}'
        '}';
    return jsonText;
  }

  static SearchCriteriaDTO convertMovieDtoToCriteriaDto(MovieResultDTO card) {
    final criteria =
        SearchCriteriaDTO().init(SearchCriteriaSource.movieKeyword);
    criteria.criteriaList.add(card);
    criteria.criteriaTitle = _getCriteriaJsonValue(criteria, jsonKeywordKey);
    return criteria;
  }
}
