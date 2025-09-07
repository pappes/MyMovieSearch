import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/google.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/google.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const _googleResultsPerPage = 10; // More than 10 results in an error!

/// Implements [WebFetchBase] for searching using google.
///
/// The Google API is allows 100 free requests per day as per
/// https://developers.google.com/custom-search/v1/overview
/// The Google JSON API is limited to 10000 requests per day as per
/// https://developers.google.com/custom-search/docs/overview
/// and can be controlled from
/// https://programmablesearchengine.google.com/controlpanel/all
///
/// This custom search filters to imdb.com/title with safesearch turned off.
///
/// ```dart
/// QueryGoogleMovies().readList(criteria, limit: 10)
/// ```
class QueryGoogleMovies
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryGoogleMovies(super.criteria);

  // 'https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=';
  static final _baseURL = Settings().googleurl;

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.google.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamGoogleMoviesJsonOfflineData;

  /// Convert google map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return GoogleMovieSearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableString();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
    '[QueryGoogleMovies] $message',
    DataSourceType.google,
  );

  /// API call to Google returning the top 10 matching results
  /// for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    // Get key from the file assets/secrets.json (not source controlled)
    final googleKey = Settings().googlekey;
    final startRecord = (pageNumber - 1) * _googleResultsPerPage;
    final url =
        '$_baseURL$googleKey'
        '&q=$searchCriteria&start=$startRecord&'
        'num=$_googleResultsPerPage';
    return Uri.parse(url);
  }
}
