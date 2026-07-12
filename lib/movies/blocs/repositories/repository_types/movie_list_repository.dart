import 'dart:async';

import 'package:my_movie_search/data/persistence/dto_cache.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/data/movie_result_mappers.dart';
import 'package:my_movie_search/movies/data/search_criteria_mappers.dart';
import 'package:my_movie_search/movies/domain/models/move_result_comparison.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_movie_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_person_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tvdb_details.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/wikidata_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';

/// Search for movie data from multiple online search sources.
///
/// Supplement content from detail providers
/// with content from additional detail providers.
class MovieListRepository extends BaseMovieRepository {
  bool _googleSearchStarted = false;

  /// Initialize the search for movie data from multiple online sources.
  ///
  @override
  Future<void> initSearch(int searchUID, SearchCriteriaDTO criteria) async {
    await super.initSearch(searchUID, criteria);
    if (criteria.criteriaList.isNotEmpty) {
      // Wikidata and google can search multiple IDs at once
      await _populateFromWikidata(searchUID);
    }
  }

  /// Cease waiting for data provider to complete.
  /// Close the stream if all WebFetch operations have completed.
  ///
  /// [provider] is the same passed through to initProvider.
  @override
  void finishProvider(Object provider) {
    if (waitingForProviders() == 1 && criteria.criteriaList.isNotEmpty) {
      // Search google last to avoid duplicate data from other sources.
      _populateFromGoogle(QueryGoogleMovies(criteria), currentSearchUID());
    }
    return super.finishProvider(provider);
  }

  /// Populate the stream with data from wikidata.
  ///
  /// [searchUID] is the unique identifier for the current search.
  Future<void> _populateFromWikidata(int searchUID) async {
    final provider = QueryWikidataDetails(criteria);
    initProvider(provider);
    await provider
        .readList()
        .then((values) => addResults(searchUID, values))
        .whenComplete(() => finishProvider(provider));
  }

  /// Start populating the stream with extra data from google.
  ///
  /// [provider]  is the google WebFetch that has been initialized
  ///             with the search criteria.
  /// [searchUID] is the unique identifier for the current search.
  void _populateFromGoogle(QueryGoogleMovies provider, int searchUID) {
    if (!_googleSearchStarted) {
      _googleSearchStarted = true;
      initProvider(provider);
      unawaited(_fetchGooleData(provider, searchUID));
    }
  }

  /// Populate the stream with data from google.
  ///
  /// [googleProvider]  is the google WebFetch that has been initialized
  ///             with the search criteria.
  /// [searchUID] is the unique identifier for the current search.
  Future<void> _fetchGooleData(
    QueryGoogleMovies googleProvider,
    int searchUID,
  ) async {
    // Restrict google search to data that cannot be found in other sources.
    await _removePopulatedData(criteria.criteriaList);
    await addResults(searchUID, await googleProvider.readMultipleList());
    finishProvider(googleProvider);
  }

  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  @override
  Future<int> getExtraDetails(int originalSearchUID, MovieResultDTO dto) async {
    if (!dto.isMessage()) {
      return _callDetailFetchFunction(originalSearchUID, dto);
    }
    return 0;
  }

  static final priorTvdbCalls = <String>[];

  /// To be overridden by specific implementations, calling:
  ///   initProvider() before requesting data for a source.
  ///   yieldResult() for any returned data.
  ///   await finishProvider() as each source completes.
  /// Returns number of extra fetches requested.
  ///
  Future<int> _getExtraTvdbDetails(
    int originalSearchUID,
    MovieResultDTO dto,
  ) async {
    final searchKey = '$originalSearchUID${dto.uniqueId}';
    if (priorTvdbCalls.contains(searchKey)) {
      return 0;
    }
    priorTvdbCalls.add(searchKey);

    final detailCriteria = SearchCriteriaDTO().fromString(dto.uniqueId);
    final provider = QueryTVDBDetails(detailCriteria);
    initProvider(provider);
    final results = await provider.readList();

    results.forEach(yieldResult);
    finishProvider(provider);
    return results.length;
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
    await _getExtraTvdbDetails(originalSearchUID, dto);
    if (_readyForTmdbFinder(dto)) {
      // Fetch tmdb id based on imdb id.
      const constructor = QueryTMDBFinder.new;
      final detailCriteria = SearchCriteriaDTO().fromString(dto.uniqueId);
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

      final constructor = (dto.type == .person)
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
        await getExtraDetails(originalSearchUID, dto);
      }
    }
  }

  /// Filter out any movies that already have details from other sources.
  /// This is to avoid making unnecessary calls to Google
  /// for data that is already available.
  Future<void> _removePopulatedData(List<MovieResultDTO> criteriaList) async {
    final newList = criteriaList.shallowCopy();
    for (final dto in newList) {
      final cached = await DtoCache.singleton().fetch(dto);
      if (cached.type != .title ||
          cached.userRating > 0 ||
          cached.userRatingCount > 0) {
        // Remove from original list without impacting the for loop.
        criteriaList.remove(dto);
      }
    }
  }
}
