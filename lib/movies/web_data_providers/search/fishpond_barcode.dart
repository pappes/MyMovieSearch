import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/fishpond_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/fishpond_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/fishpond_barcode.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonRawDescriptionKey = 'description';
const jsonCleanDescriptionKey = 'cleanDescription';
const jsonUrlKey = 'url';

/// Implements [WebFetchBase] for the FishpondBarcode search html web scraper.
///
/// ```dart
/// QueryFishpondBarcodeSearch().readList(criteria, limit: 10)
/// ```
class QueryFishpondBarcodeSearch
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeFishpondBarcodeSearch {
  QueryFishpondBarcodeSearch(super.criteria);

  static const _baseURL =
      'https://www.fishpond.com.au/advanced_search_result.php?keywords=';
  static const _suffixURL = '&cName=Movies';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.fishpondBarcode.name;

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
      return FishpondBarcodeSearchConverter.dtoFromCompleteJsonMap(
        map,
        criteria,
      );
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
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
    '[QueryFishpondBarcodeSearch] $message',
    DataSourceType.fishpondBarcode,
  );

  /// API call to search
  /// returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$encodedCriteria$_suffixURL';
    return Uri.parse(url);
  }
}
