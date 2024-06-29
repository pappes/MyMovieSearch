import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/magnet_torrentz2.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/magnet_torrentz2.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/magnet_torrentz2.dart';
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

/// Implements [WebFetchBase] for the Torrentz2 search html web scraper.
///
/// ```dart
/// QueryTorrentz2Search().readList(criteria, limit: 10)
/// ```
class QueryTorrentz2Search
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeTorrentz2Search {
  QueryTorrentz2Search(super.criteria);

  static const _baseURL = 'https://torrentz2.nz/search?q=';
  static const _pageURL = '&page=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.torrentz2.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamHtmlOfflineData;

  /// Convert map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return Torrentz2SearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableIdOrText().toLowerCase();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryTorrentz2Search] $message',
        DataSourceType.torrentz2,
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
