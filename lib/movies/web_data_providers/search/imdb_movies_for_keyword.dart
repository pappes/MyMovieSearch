import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_movies_for_keyword.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/imdb_movies_for_keyword.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_limiter.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonKeywordKey = 'keyword';
const jsonPageKey = 'page';

/// Implements [WebFetchBase] for the IMDB keywords html web scraper.
///
/// ```dart
/// QueryIMDBMoviesForKeyword().readList(criteria, limit: 10)
/// ```
class QueryIMDBMoviesForKeyword
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBMoviesForKeyword {
  QueryIMDBMoviesForKeyword(super.criteria);

  static const _baseUrl = 'https://www.imdb.com/search/title/?keywords=';
  static const _urlSuffix = '&explore=keywords';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.imdbKeywords.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbKeywordsHtmlOfflineData;

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return ImdbWebScraperConverter()
          .dtoFromCompleteJsonMap(map, DataSourceType.imdbKeywords);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableString();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryIMDBMoviesForKeyword] $message',
        DataSourceType.imdbKeywords,
      );

  /// API call to IMDB keywords returning the top matching results
  /// for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    searchResultsLimit = WebFetchLimiter(55);
    final url = '$_baseUrl$encodedCriteria$_urlSuffix';
    return Uri.parse(url);
  }

/*IMDB has moved away from url encoding for pagination
  /// Extract plain text or dto encoded keyword.
  @override
  String myFormatInputAsText() {
    String keyword = _getCriteriaJsonValue(criteria, jsonKeywordKey);
    if (keyword.isEmpty) {
      keyword = criteria.toPrintableString();
    }
    return keyword;
  }


  /// Extract page number from dto encoded data
  @override
  int myGetPageNumber() =>
      IntHelper.fromText(_getCriteriaJsonValue(criteria, jsonPageKey)) ?? 1;

  static String _getCriteriaJsonValue(SearchCriteriaDTO criteria, String key) {
    try {
      final jsonText = criteria.criteriaContext?.description ?? '';
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
    final newCriteria = SearchCriteriaDTO()
      ..init(SearchCriteriaType.moviesForKeyword)
      ..criteriaContext = card;
    newCriteria.criteriaTitle =
        _getCriteriaJsonValue(newCriteria, jsonKeywordKey);
    return newCriteria;
  }*/
}
