import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/picclick_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/picclick_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/picclick_barcode.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_limiter.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonRawDescriptionKey = 'description';
const jsonCleanDescriptionKey = 'cleanDescription';
const jsonIdKey = 'barcode';
const jsonUrlKey = 'url';

/// Implements [WebFetchBase] for the PicclickBarcode search html web scraper.
///
/// ```dart
/// QueryPicclickBarcodeSearch().readList(criteria, limit: 10)
/// ```
class QueryPicclickBarcodeSearch
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapePicclickBarcodeSearch {
  static const _baseURL = 'https://picclick.com.au/?q=';
  static const _suffixURL = '+';

  QueryPicclickBarcodeSearch(SearchCriteriaDTO criteria) : super(criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return DataSourceType.picclickBarcode.name;
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
      return PicclickBarcodeSearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toSearchId().toLowerCase();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryPicclickBarcodeSearch] $message',
        DataSourceType.picclickBarcode,
      );

  /// API call to search returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$encodedCriteria$_suffixURL';
    return Uri.parse(url);
  }
}
