import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_more_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/webscrapers/imdb_more_keywords.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for retrieving full list of keywords
/// for a movie from IMDB.
///
/// ```dart
/// QueryIMDBMoreKeywordsDetails().readList(criteria);
/// ```
class QueryIMDBMoreKeywordsDetails
    extends WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBMoreKeywordsDetails {
  QueryIMDBMoreKeywordsDetails(super.criteria);

  static const _baseURL = 'https://www.imdb.com/title/';
  static const _baseURLsuffix = '/keywords/';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => 'imdb_more_keywords';

  @override
  @factory
  WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> myClone(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBMoreKeywordsDetails(criteria);

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflineData;

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() {
    final text = criteria.criteriaTitle;
    if (text.startsWith(imdbTitlePrefix)) {
      return text;
    }
    return ''; // do not allow searches for non-imdb IDs
  }

  /// API call to IMDB returning all keywords for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria$_baseURLsuffix';
    return Uri.parse(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return ImdbMoreKeywordsConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryIMDBMoreKeywordsDetails] $message',
        DataSourceType.imdb,
      );
}
