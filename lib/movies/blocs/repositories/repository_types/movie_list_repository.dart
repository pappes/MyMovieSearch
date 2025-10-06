import 'dart:async';

import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_movie_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_person_detail.dart';

/// Search for movie data from multiple online search sources.
///
/// Suppliament content from detail providers
/// with content from additonal detail providers.
class MovieListRepository extends BaseMovieRepository {
  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  @override
  Future<int> getExtraDetails(int originalSearchUID, MovieResultDTO dto) async {
    if (!dto.isMessage()) {
      return _callDetailFetchFunction(originalSearchUID, dto);
    }
    return 0;
  }

  /// Only call TMDB find to get tmdbID if no TMDB request has completed
  bool _readyForTmdbFinder(MovieResultDTO dto) =>
      !dto.sources.containsKey(DataSourceType.tmdbFinder) &&
      !dto.sources.containsKey(DataSourceType.tmdbSearch) &&
      !dto.sources.containsKey(DataSourceType.tmdbPerson) &&
      !dto.sources.containsKey(DataSourceType.tmdbMovie);

  /// Only call TMDB details where we know the TMDB ID and
  /// TMDB details have not been returned
  bool _readyForTmdbExtraDetails(MovieResultDTO dto) =>
      dto.sources.containsKey(DataSourceType.tmdbFinder) ||
      dto.sources.containsKey(DataSourceType.tmdbSearch);

  /// Only call TMDB details where we know the TMDB ID and
  /// TMDB details have not been returned
  bool _hasFullTmdbDetails(MovieResultDTO dto) =>
      dto.sources.containsKey(DataSourceType.tmdbPerson) ||
      dto.sources.containsKey(DataSourceType.tmdbMovie);

  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  Future<int> _callDetailFetchFunction(
    int originalSearchUID,
    MovieResultDTO dto,
  ) async {
    if (_readyForTmdbFinder(dto)) {
      // Fetch tmdb id based on imdb id.
      final detailCriteria = SearchCriteriaDTO().fromString(dto.uniqueId);
      const constructor = QueryTMDBFinder.new;
      await _fetchDetails(originalSearchUID, detailCriteria, constructor);
    }
    if (_readyForTmdbExtraDetails(dto) && !_hasFullTmdbDetails(dto)) {
      await _fetchTmdbDetails(originalSearchUID, dto);
    }
    return 0;
  }

  /// Call webfetch for the criteria and manage expected web fetches.
  Future<void> _fetchDetails(
    int originalSearchUID,
    SearchCriteriaDTO criteria,
    WebFetchDTOFn searchClass,
  ) async {
    final provider = searchClass(criteria);
    initProvider(provider);
    final results = await provider.readList();
    return _addExtraDetails(
      originalSearchUID,
      results,
    ).then((_) => finishProvider(provider));
  }

  /// Add fetch full movie details from tmdb.
  static String? _getTMDBId(MovieResultDTO dto) =>
      dto.sources[DataSourceType.tmdbFinder] ??
      dto.sources[DataSourceType.tmdbSearch];

  /// Calculate criteria and fetch class for tmdb.
  Future<void> _fetchTmdbDetails(
    int originalSearchUID,
    MovieResultDTO dto,
  ) async {
    /// Fetch full movie details from tmdb based on TMDBid.
    final tmdbId = _getTMDBId(dto);
    if (null != tmdbId) {
      final detailCriteria = SearchCriteriaDTO().fromString(tmdbId);

      final constructor =
          (MovieContentType.person == dto.type)
              ? QueryTMDBPersonDetails.new
              : QueryTMDBMovieDetails.new;
      await _fetchDetails(originalSearchUID, detailCriteria, constructor);
    }
  }

  /// Add fetched tmbd movie details into the stream and search imdb.
  ///
  /// TMDBFinder returns a TMDB ID based on an IMDB ID
  /// which then requires another call to get TMDB details
  /// TMDBMovie returns an IMDB ID based on a TMDB ID
  /// which then requries another call to get IMDB details
  Future<void> _addExtraDetails(
    int originalSearchUID,
    List<MovieResultDTO> values,
  ) async {
    if (!searchInterrupted(originalSearchUID)) {
      for (final dto in values) {
        yieldResult(dto);
        unawaited(getExtraDetails(originalSearchUID, dto));
      }
    }
  }
}
