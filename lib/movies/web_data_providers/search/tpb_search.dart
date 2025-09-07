import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/tpb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/tpb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/tpb_search.dart';
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

/// Implements [WebFetchBase] for the tpb search html web scraper.
///
/// ```dart
/// QueryTpbSearch().readList(criteria, limit: 10)
/// ```
class QueryTpbSearch extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeTpbSearch {
  QueryTpbSearch(super.criteria);

  static const _baseURL = 'https://tpb.party/search/';
  static const _pageURL = '/99/0';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.tpb.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamTpbHtmlOfflineData;

  /// Convert TPB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return TpbSearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableIdOrText().toLowerCase();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) =>
      MovieResultDTO().error('[QueryTpbSearch] $message', DataSourceType.tpb);

  /// API call to tpb search
  /// returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    searchResultsLimit = WebFetchLimiter(55);
    final url = '$_baseURL$encodedCriteria/$pageNumber$_pageURL';
    return Uri.parse(url);
  }
}
