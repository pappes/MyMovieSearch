import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/magnet_magnet_dl.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/magnet_magnet_dl.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/magnet_magnet_dl.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_limiter.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonKeywordKey = 'keyword';
const jsonPageKey = 'page';
const jsonCategoryKey = 'category';
const jsonMagnetKey = 'magnet';
const jsonNameKey = 'name';
const jsonDescriptionKey = 'description';
const jsonSeedersKey = 'seeders';
const jsonLeechersKey = 'leechers';

/// Implements [WebFetchBase] for the MagnetDl search html web scraper.
///
/// ```dart
/// QueryMagnetDlSearch().readList(criteria, limit: 10)
/// ```
class QueryMagnetDlSearch
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeMagnetDlSearch {
  static const _baseURL = 'https://www.magnetdl.com/';
  static const _pageURL = '/';

  QueryMagnetDlSearch(SearchCriteriaDTO criteria) : super(criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return DataSourceType.magnetDl.name;
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamHtmlOfflineData;
  }

  /// Convert map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return MagnetDlSearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableString();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryMagnetDlSearch] $message',
        DataSourceType.magnetDl,
      );

  /// API call to search returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    searchResultsLimit = WebFetchLimiter(55);
    final prefix =
        encodedCriteria.isEmpty ? '' : encodedCriteria.substring(0, 1);

    final url = '$_baseURL$prefix/$encodedCriteria/$pageNumber$_pageURL';
    return Uri.parse(url);
  }
}
