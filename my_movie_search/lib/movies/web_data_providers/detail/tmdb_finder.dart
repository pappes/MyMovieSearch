import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_common.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for using IMDB IDs
/// searching The Movie Database (TMDB).
///
/// The TMDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryTMDBFinder().readList(criteria);
/// ```
class QueryTMDBFinder extends QueryTMDBCommon {
  QueryTMDBFinder(super.criteria) {
    baseURL = 'https://api.themoviedb.org/3/find/';
    midURL = '?language=en-US&external_source=imdb_id&api_key=';
    source = DataSourceType.tmdbFinder;
    imdbId = criteria.criteriaTitle;
  }
  String imdbId = '';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamTmdbJsonOfflineData;

  /// converts <INPUT_TYPE> to a string representation
  /// if criteria is an IMDB id.
  @override
  String myFormatInputAsText() {
    final text = super.myFormatInputAsText();
    if (text.startsWith(imdbPersonPrefix) || text.startsWith(imdbTitlePrefix)) {
      return text;
    }
    logger.t('surpressed $source search for non IMDB id $text');
    return ''; // do not allow searches for non-imdb IDs
  }

  /// Convert TMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is! Map) {
      throw TreeConvertException(
        'expected map got ${map.runtimeType} unable to interpret data $map',
      );
    }
    return TmdbFinderConverter.dtoFromCompleteJsonMap(map, imdbId);
  }

  /// API call to TMDB returning the movie details for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) =>
      super.myConstructURI(searchCriteria, pageNumber: pageNumber);
}
