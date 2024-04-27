import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/brave.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/brave.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const _BraveResultsPerPage = 10; // More than 10 results in an error!

/// Implements [WebFetchBase] for searching using brave.
///
/// The Brave API is allows 100 free requests per day as per
/// https://developers.brave.com/custom-search/v1/overview
/// The Brave JSON API is limited to 10000 requests per day as per
/// https://developers.brave.com/custom-search/docs/overview
/// and can be controlled from
/// https://programmablesearchengine.brave.com/controlpanel/all
/// This custom search filters to imdb.com/title with safesearch turned off.
///
/// ```dart
/// QueryBraveMovies().readList(criteria, limit: 10)
/// ```
class QueryBraveMovies extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryBraveMovies(super.criteria);

  static final _baseURL =
      'https://customsearch.Braveapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.brave.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamBraveMoviesJsonOfflineData;

  /// Convert brave map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return BraveMovieSearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableString();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryBraveMovies] $message',
        DataSourceType.brave,
      );

  /// API call to Brave returning the top 10 matching results
  /// for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    // Get key from the file assets/secrets.json (not source controlled)
    final BraveKey = Settings().bravekey;
    final startRecord = (pageNumber - 1) * _BraveResultsPerPage;
    final url = '$_baseURL$BraveKey'
        '&q=$searchCriteria&start=$startRecord&'
        'num=$_BraveResultsPerPage';
    return Uri.parse(url);
  }
}
