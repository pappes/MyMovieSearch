import 'package:my_movie_search/movies/blocs/repositories/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_movie_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_person_detail.dart';
import 'package:my_movie_search/utilities/settings.dart';

typedef SearchFunction = Future<List<MovieResultDTO>> Function(
  MovieResultDTO criteria,
);

class SearchFunctions {
  List<SearchFunction> fastSearch = [];
  List<SearchFunction> supplementarySearch = [];
  List<SearchFunction> slowSearch = [];
}

/// Search for movie data from multiple online search sources.
///
/// BlockRepository to consolidate data retrieval from multiple search
/// and detail providers using the WebFetch framework.
///
/// [Search] provides a stream of incomplete and complete results.
/// [Close] can be used to cancel a search.
class MovieListRepository extends BaseMovieRepository {
  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  @override
  void getExtraDetails(int originalSearchUID, MovieResultDTO dto) {
    if ("null" !=
            dto.uniqueId && /*
        !_requestedDetails.containsKey(dto.uniqueId) &&*/
        !dto.uniqueId.startsWith(movieDTOMessagePrefix)) {
      final functions = SearchFunctions();
      _getDetailSources(dto, functions);

      // Load fast results into list for display on screen
      for (final function in functions.fastSearch) {
        function(dto).then(
          (searchResults) => _addExtraDetails(originalSearchUID, searchResults),
        );
      }
      // Load supplementary results into list for display on screen
      for (final function in functions.supplementarySearch) {
        function(dto).then(
          (searchResults) => _addExtraDetails(originalSearchUID, searchResults),
        );
      }
      // Load slow results into cache for access on details screen in a seperate thread
      for (final function in functions.slowSearch) {
        if (Settings.singleton().get('PREFETCH') == 'true') {
          function(dto);
        }
      }
    }
  }

  /// Only call TMDB find to get tmdbID is no TMDB request has completed
  bool _readyForTmdbFinder(MovieResultDTO dto) {
    if (!dto.sources.containsKey(DataSourceType.tmdbFinder) &&
        !dto.sources.containsKey(DataSourceType.tmdbSearch) &&
        !dto.sources.containsKey(DataSourceType.tmdbPerson) &&
        !dto.sources.containsKey(DataSourceType.tmdbMovie)) {
      return true;
    }
    return false;
  }

  /// Only call TMDB details where we know the TMDB ID and
  /// TMDB details have not been returned
  bool _readyForTmdbExtraDetails(MovieResultDTO dto) {
    if (dto.sources.containsKey(DataSourceType.tmdbFinder) ||
        dto.sources.containsKey(DataSourceType.tmdbSearch)) {
      if (!dto.sources.containsKey(DataSourceType.tmdbPerson) &&
          !dto.sources.containsKey(DataSourceType.tmdbMovie)) {
        return true;
      }
    }
    return false;
  }

  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  void _getDetailSources(
    MovieResultDTO dto,
    SearchFunctions functions,
  ) {
    if (_readyForTmdbFinder(dto)) {
      // If we have an imdbId and we dont have a tmdbId, go fetch the tmdbId
      functions.supplementarySearch.add(_getTMDBFinderId);
    }

    if (_readyForTmdbExtraDetails(dto)) {
      // tmdbFinder and tmdbSearch both return a tmdbId
      // which can be used for more details.
      if (MovieContentType.person == dto.type) {
        if (!dto.sources.containsKey(DataSourceType.tmdbPerson)) {
          functions.fastSearch.add(_getTMDBPersonDetailsFast);
        }
      } else {
        if (!dto.sources.containsKey(DataSourceType.tmdbMovie)) {
          functions.fastSearch.add(_getTMDBMovieDetailsFast);
        }
      }
    }
  }

  /// Add fetch full movie details from tmdb.
  static String? _getTMDBId(MovieResultDTO dto) =>
      dto.sources[DataSourceType.tmdbFinder] ??
      dto.sources[DataSourceType.tmdbSearch];

  /// Add fetch full movie details from tmdb.
  static Future<List<MovieResultDTO>> _getTMDBMovieDetailsFast(
    MovieResultDTO dto,
  ) {
    final tmdbId = _getTMDBId(dto);
    if (null != tmdbId) {
      final detailCriteria = SearchCriteriaDTO().fromString(tmdbId);
      return QueryTMDBMovieDetails(detailCriteria).readList();
    }
    return Future.value(<MovieResultDTO>[]);
  }

  /// Add fetch full person details from tmdb.
  static Future<List<MovieResultDTO>> _getTMDBPersonDetailsFast(
    MovieResultDTO dto,
  ) {
    final tmdbId = _getTMDBId(dto);
    if (null != tmdbId) {
      final detailCriteria = SearchCriteriaDTO().fromString(tmdbId);
      return QueryTMDBPersonDetails(detailCriteria).readList();
    }
    return Future.value(<MovieResultDTO>[]);
  }

  /// Fetch tmdb id based on imdb id.
  static Future<List<MovieResultDTO>> _getTMDBFinderId(
    MovieResultDTO dto,
  ) {
    final detailCriteria = SearchCriteriaDTO().fromString(dto.uniqueId);
    return QueryTMDBFinder(detailCriteria).readList();
  }

  /// Add fetched tmbd movie details into the stream and search imdb.
  ///
  /// TMDBFinder returns a TMDB ID based on an IMDB ID
  /// which then requires another call to get TMDB details
  /// TMDBMovie returns an IMDB ID based on a TMDB ID
  /// which then requries another call to get IMDB details
  void _addExtraDetails(int originalSearchUID, List<MovieResultDTO> values) {
    if (!searchInterrupted(originalSearchUID)) {
      for (final dto in values) {
        yieldResult(dto);
        getExtraDetails(originalSearchUID, dto);
      }
    }
  }
}
