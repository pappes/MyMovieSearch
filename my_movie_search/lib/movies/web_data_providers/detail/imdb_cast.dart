import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_cast.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/webscrapers/imdb_cast.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';

/// Implements [WebFetchBase] for retrieving cast and crew information from IMDB.
///
/// ```dart
/// QueryIMDBCastDetails().readList(criteria);
/// ```
class QueryIMDBCastDetails
    extends WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBCastDetails {
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
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) return ImdbCastConverter.dtoFromCompleteJsonMap(map);
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO().error();
    error.title = '[QueryIMDBCastDetails] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }
}
