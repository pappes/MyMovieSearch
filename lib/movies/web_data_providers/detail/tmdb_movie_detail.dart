import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_movie_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_movie_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_common.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for movie data from The Movie Database (TMDB).
///
/// The TMDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryTMDBMovieDetails().readList(criteria);
/// ```
// ignore: missing_override_of_must_be_overridden
class QueryTMDBMovieDetails extends QueryTMDBCommon {
  QueryTMDBMovieDetails(super.criteria) {
    baseURL = 'https://api.themoviedb.org/3/movie/';
    source = DataSourceType.tmdbMovie;
  }

  @override
  String myDataSourceName() => 'QueryTMDBMovieDetails';

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
      final dto = TmdbMovieDetailConverter.dtoFromCompleteJsonMap(map);
      return dto;
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }
}
