import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/libsa_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/libsa_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/libsa_barcode.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonCleanDescriptionKey = 'cleanDescription';
const jsonRawDescriptionKey = 'rawDescription';
const jsonUrlKey = 'url';

/// Implements [WebFetchBase] for the LibsaBarcode search html web scraper.
///
/// ```dart
/// QueryLibsaBarcodeSearch().readList(criteria, limit: 10)
/// ```
class QueryLibsaBarcodeSearch
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeLibsaBarcodeSearch {
  static const _baseURL =
      'https://libraries.sa.gov.au/client/en_AU/sapubliclibraries/search/results?qu=';

  QueryLibsaBarcodeSearch(super.criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.libsaBarcode.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamHtmlOfflineData;

  /// Convert map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return LibsaBarcodeSearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toSearchId().toLowerCase();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryLibsaBarcodeSearch] $message',
        DataSourceType.libsaBarcode,
      );

  /// API call to search returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$encodedCriteria';
    return Uri.parse(url);
  }
}
