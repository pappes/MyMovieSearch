import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/yts_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/webscrapers/yts_detail.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for retrieving full list of keywords for a movie from IMDB.
///
/// ```dart
/// QueryYtsDetails().readList(criteria);
/// ```
class QueryYtsDetails
    extends WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeYtsDetails {
  static const _baseURL = 'https://www.imdb.com/title/';
  static const _baseURLsuffix = '/keywords/';

  QueryYtsDetails(SearchCriteriaDTO criteria) : super(criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return 'yts_detail';
  }

  @override
  WebFetchBase<MovieResultDTO, SearchCriteriaDTO> myClone(
    SearchCriteriaDTO criteria,
  ) =>
      QueryYtsDetails(criteria);

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbHtmlOfflineData;
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() {
    final text = criteria.criteriaTitle;
    if (text.startsWith(imdbTitlePrefix)) {
      return text;
    }
    return ''; // do not allow searches for non-imdb IDs
  }

  /// API call to IMDB returning all keywords for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria$_baseURLsuffix';
    return Uri.parse(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return YtsDetailConverter.dtoFromCompleteJsonMap(map);
    }
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryYtsDetails] $message',
        DataSourceType.imdb,
      );
}
