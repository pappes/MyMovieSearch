import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_common.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for using IMDB IDs searching The Movie Database (TMDB).
///
/// The TMDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryTMDBFinder().readList(criteria);
/// ```
class QueryTMDBFinder extends QueryTMDBCommon {
  QueryTMDBFinder() {
    baseURL = 'https://api.themoviedb.org/3/find/';
    midURL = '?language=en-US&external_source=imdb_id&api_key=';
    source = DataSourceType.tmdbFinder;
  }
  String imdbId = '';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamTmdbJsonOfflineData;

  /// converts <INPUT_TYPE> to a string representation if criteria is an IMDB id.
  @override
  String myFormatInputAsText(dynamic contents) {
    final text = super.myFormatInputAsText(contents);
    if (text.startsWith(imdbPersonPrefix) || text.startsWith(imdbTitlePrefix)) {
      return text;
    }
    return ''; // do not allow searches for non-imdb IDs
  }

  /// Convert TMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is! Map) {
      throw 'expected map got ${map.runtimeType} unable to interpret data $map';
    }
    final results = <MovieResultDTO>[];
    for (final movie
        in TmdbFinderConverter(imdbId).dtoFromCompleteJsonMap(map)) {
      results.add(movie);
    }
    return results;
  }

  /// API call to TMDB returning the movie details for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    imdbId = searchCriteria;
    return super.myConstructURI(searchCriteria, pageNumber: pageNumber);
  }
}
