import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/cache/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/webscrapers/imdb_name.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for retrieving person details from IMDB.
///
/// ```dart
/// QueryIMDBNameDetails().readList(criteria);
/// ```
class QueryIMDBNameDetails
    extends WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBNameDetails, ThreadedCacheIMDBNameDetails {
  static const _baseURL = 'https://www.imdb.com/name/';
  static const defaultSearchResultsLimit = 100;

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return 'imdb_person';
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
    final text = criteria.toPrintableString();
    if (text.startsWith(imdbPersonPrefix)) {
      return text;
    }
    return ''; // do not allow searches for non-imdb IDs
  }

  /// API call to IMDB person details for person id.
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria';
    return Uri.parse(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return ImdbWebScraperConverter(DataSourceType.imdb)
          .dtoFromCompleteJsonMap(map);
    }
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// Include entire map in the movie Name when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO().error();
    error.title = '[QueryIMDBNameDetails] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }
}
