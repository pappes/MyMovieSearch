import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/imdb_keywords.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_limiter.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for the IMDB keywords html web scraper.
///
/// ```dart
/// QueryIMDBKeywords().readList(criteria, limit: 10)
/// ```
class QueryIMDBKeywords extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBKeywordsDetails {
  static const _baseURL =
      'https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=';

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

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.toPrintableString();
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryIMDBKeywords] $message',
        DataSourceType.imdbKeywords,
      );

  /// API call to IMDB keywords returning the top matching results for [keywordsText].
  @override
  Uri myConstructURI(String keywordsCriteria, {int pageNumber = 1}) {
    searchResultsLimit = WebFetchLimiter(100);
    final url = '$_baseURL$keywordsCriteria';
    return Uri.parse(url);
  }
}
