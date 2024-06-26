import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/cache/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/webscrapers/imdb_title.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for retrieving movie details from IMDB.
///
/// ```dart
/// QueryIMDBTitleDetails().readList(criteria);
/// ```
class QueryIMDBTitleDetails
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBTitleDetails, ThreadedCacheIMDBTitleDetails {
  QueryIMDBTitleDetails(super.criteria);

  static const _baseURL = 'https://www.imdb.com/title/';
  static const _baseURLsuffix = '/?ref_=fn_tt_tt_1';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.imdb.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflineData;

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() {
    final text = criteria.toPrintableString();
    if (text.startsWith(imdbTitlePrefix)) {
      return text;
    }
    return ''; // do not allow searches for non-imdb IDs
  }

  /// API call to IMDB search returning the top matching results
  /// for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria$_baseURLsuffix';
    return Uri.parse(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return ImdbWebScraperConverter()
          .dtoFromCompleteJsonMap(map, DataSourceType.imdb);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryIMDBTitleDetails] $message',
        DataSourceType.imdb,
      );
}
