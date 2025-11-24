import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/yts_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/yts_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/webscrapers/yts_detail.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonKeywordKey = 'keyword';
const jsonPageKey = 'page';
const jsonCategoryKey = 'category';
const jsonMagnetKey = 'magnet';
const jsonNameKey = 'name';
const jsonImageKey = 'image';
const jsonYearKey = 'year';
const jsonDescriptionKey = 'description';
const jsonSeedersKey = 'seeders';
const jsonLeechersKey = 'leechers';

/// Implements [WebFetchBase] for retrieving full list of keywords
/// for a movie from IMDB.
///
/// ```dart
/// QueryYtsDetails().readList(criteria);
/// ```
class QueryYtsDetails extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeYtsDetails {
  QueryYtsDetails(super.criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => 'yts_detail';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflineData;

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() {
    final text = criteria.criteriaTitle;
    if (!text.startsWith(imdbTitlePrefix)) {
      return text;
    }
    return ''; // do not allow searches for imdb IDs
  }

  /// API call to IMDB returning all keywords for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final decodedCriteria = Uri.decodeComponent(searchCriteria);
    final baseUrl = ytsHelper().ytsBaseUrl;

    final detailUrl = '$baseUrl/movies/';
    if (decodedCriteria.startsWith(detailUrl)) {
      return Uri.parse(decodedCriteria);
    }
    final url = '$detailUrl$searchCriteria';
    return Uri.parse(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return YtsDetailConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) =>
      MovieResultDTO().error('[QueryYtsDetails] $message', DataSourceType.imdb);
}
