import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_movie_detail.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for using IMDB IDs searching The Movie Database (TMDB).
///
/// The TMDb API is a free web service to obtain movie information.
class QueryTMDBFinder extends QueryTMDBMovieDetails {
  static const _baseURL = 'https://api.themoviedb.org/3/find/';
  static const _midURL = '?language=en-US&external_source=imdb_id&api_key=';
  String _originalID = "";

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamTmdbJsonOfflineData;

  /// Convert TMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) {
    final results = <MovieResultDTO>[];
    for (final movie in TmdbFinderConverter.dtoFromCompleteJsonMap(map)) {
      movie.alternateId = _originalID;
      results.add(movie);
    }
    return results;
  }

  /// API call to TMDB returning the movie details for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    _originalID = searchCriteria;
    final omdbKey = dotenv
        .env['TMDB_KEY']; // From the file assets/.env (not source controlled)
    return Uri.parse('$_baseURL$searchCriteria$_midURL$omdbKey');
  }
}
