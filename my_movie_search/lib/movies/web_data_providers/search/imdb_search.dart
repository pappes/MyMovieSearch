import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/imdb_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for the IMDB search html web scraper.
///
/// ```dart
/// QueryIMDBSearch().readList(criteria, limit: 10)
/// ```
class QueryIMDBSearch extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBSearchDetails {
  static const _baseURL = 'https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return DataSourceType.imdbSearch.name;
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbSearchHtmlOfflineData;
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return ImdbWebScraperConverter(DataSourceType.imdbSearch)
          .dtoFromCompleteJsonMap(map);
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
        '[QueryIMDBSearch] $message',
        DataSourceType.imdbSearch,
      );

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria';
    return Uri.parse(url);
  }
}
