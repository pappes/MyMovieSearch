import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/uhtt_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/uhtt_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/uhtt_barcode.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonRawDescriptionKey = 'description';
const jsonCleanDescriptionKey = 'cleandescription';
const jsonIdKey = 'barcode';

/// Implements [WebFetchBase] for the UhttBarcode search html web scraper.
///
/// ```dart
/// QueryUhttBarcodeSearch().readList(criteria, limit: 10)
/// ```
class QueryUhttBarcodeSearch
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeUhttBarcodeSearch {
  static const _baseURL =
      'http://uhtt.ru/dispatcher/?query=SELECT%20GOODS%20BY%20CODE(';
  static const _suffixURL = ')%20FORMAT.TDDO(VIEW_GOODS)';

  QueryUhttBarcodeSearch(super.criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.uhttBarcode.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamHtmlOfflineData;

  /// Convert map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return UhttBarcodeSearchConverter.dtoFromCompleteJsonMap(map);
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
        '[QueryUhttBarcodeSearch] $message',
        DataSourceType.uhttBarcode,
      );

  /// API call to search
  /// returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$encodedCriteria$_suffixURL';
    return Uri.parse(url);
  }
}
