import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/magnet_solid_torrents.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/magnet_solid_torrents.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/magnet_solid_torrents.dart';
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

/// Implements [WebFetchBase] for the SolidTorrents search html web scraper.
///
/// ```dart
/// QuerySolidTorrentsSearch().readList(criteria, limit: 10)
/// ```
class QuerySolidTorrentsSearch
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeSolidTorrentsSearch {
  static const _baseURL = 'https://solidtorrents.eu/search?q=';
  static const _pageURL = '&sort=seeders&page=';

  QuerySolidTorrentsSearch(super.criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.solidTorrents.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamHtmlOfflineData;

  /// Convert map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return SolidTorrentsSearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableIdOrText().toLowerCase();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QuerySolidTorrentsSearch] $message',
        DataSourceType.solidTorrents,
      );

  /// API call to search
  /// returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    searchResultsLimit = WebFetchLimiter(55);
    final convertedCriteria = encodedCriteria.replaceAll('.', '+');

    final url = '$_baseURL$convertedCriteria$_pageURL$pageNumber';
    return Uri.parse(url);
  }
}
