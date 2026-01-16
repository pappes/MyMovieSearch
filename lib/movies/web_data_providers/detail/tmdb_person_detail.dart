import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_person_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_person_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_common.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for fetching people data
/// in The Movie Database (TMDB).
///
/// The TMDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryTMDBPersonDetails().readList(criteria);
/// ```
// ignore: missing_override_of_must_be_overridden
class QueryTMDBPersonDetails extends QueryTMDBCommon {
  QueryTMDBPersonDetails(super.criteria) {
    baseURL = 'https://api.themoviedb.org/3/person/';
    midURL = '?append_to_response=external_ids&api_key=';
    source = DataSourceType.tmdbPerson;
  }

  @override
  String myDataSourceName() => 'QueryTMDBPersonDetails';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamTmdbJsonOfflineData;

  /// Convert TMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return TmdbPersonDetailConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }
}
