import 'dart:async' show StreamController;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_cast.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_movie_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

typedef SearchFunction = Future<List<MovieResultDTO>> Function(
  SearchCriteriaDTO criteria,
);

class SearchFunctions {
  SearchFunction? fastSearch;
  SearchFunction? supplementarySearch;
  SearchFunction? slowSearch;
}

/// Retrieve for movie data from multiple online sources.
///
/// BlockRepository to consolidate data retrieval from multiple search
/// and detail providers using the WebFetch framework.
///
/// [Search] provides a stream of incomplete and complete results.
/// [Close] can be used to cancel a search.
class BaseMovieRepository {
  StreamController<MovieResultDTO>? _movieStreamController;
  var _awaitingProviders = 0;
  final Map _requestedDetails = {};
  static int _searchUID = 1;

  BaseMovieRepository();

  /// Return a stream of data matching [criteria].
  ///
  /// Status updates are yielded with uniqueId = -1.
  /// Partial results are yielded quickly with limited information.
  /// Complete results are returned progressivly
  /// and need to be merged with the partial results.
  Stream<MovieResultDTO> search(SearchCriteriaDTO criteria) async* {
    ++_searchUID;
    final feedback = MovieResultDTO();
    feedback.title = 'Searching ...';
    yield feedback;

    _movieStreamController = StreamController<MovieResultDTO>(sync: true);
    _requestedDetails.clear();
    // TODO: error handling
    initSearch(_searchUID, criteria);

    yield* _movieStreamController!.stream;
  }

  /// Cancels or completes an in progress search.
  void close() {
    final feedback = MovieResultDTO();
    feedback.title = 'Search completed ...';
    yieldResult(feedback);
    logger.v('closing stream');
    _movieStreamController?.close();
    _movieStreamController = null;
  }

  /// Initiates a search with all known movie search providers.
  /// To be overridden by specific implementations, calling:
  ///   initProvider() before requesting data for a source.
  ///   addResults(searchUID,dto) for matching data.
  ///   finishProvider() as each source completes.
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {}

  /// Cease waiting for data provider to complete.
  /// Close the stream if all WebFetch operations have completed.
  void finishProvider() {
    _awaitingProviders = _awaitingProviders - 1;
    if (_awaitingProviders == 0 && !_awaitingDetails) close();
  }

  /// Begin waiting for another data provider to complete.
  void initProvider() {
    _awaitingProviders = _awaitingProviders + 1;
  }

  /// Yields incomplete or completed results in the stream.
  void yieldResult(MovieResultDTO result) {
    _movieStreamController?.add(result);
  }

  /// Determines if a new search has been initatatd since originalSearchUID.
  bool searchInterrupted(int originalSearchUID) {
    return originalSearchUID != _searchUID;
  }

  /// Yields incomplete or completed results in the stream
  /// and initiates retrieval of movie details.
  void addResults(int originalSearchUID, List<MovieResultDTO> results) {
    if (!searchInterrupted(originalSearchUID)) {
      // Ensure a new search has not been started.
      results.forEach(yieldResult);
      for (final dto in results) {
        _getDetails(originalSearchUID, dto);
      }
    }
  }

  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  void _getDetails(int originalSearchUID, MovieResultDTO dto) {
    if ("null" != dto.uniqueId &&
        !_requestedDetails.containsKey(dto.uniqueId) &&
        !dto.uniqueId.startsWith(movieResultDTOMessagePrefix)) {
      final detailCriteria = SearchCriteriaDTO();
      detailCriteria.criteriaTitle = dto.uniqueId;
      _requestedDetails[dto.uniqueId] = null;

      final functions = SearchFunctions();
      _getDetailSources(dto, functions);

      // Load fast results into list for display on screen
      if (null != functions.fastSearch) {
        functions.fastSearch!(detailCriteria).then(
          (searchResults) => _addDetails(originalSearchUID, searchResults),
        );
      }
      // Load supplementary results into list for display on screen
      if (null != functions.supplementarySearch) {
        functions.supplementarySearch!(detailCriteria).then(
          (searchResults) => _addDetails(originalSearchUID, searchResults),
        );
      }
      // Load slow results into cache for access on details screen in a seperate thread
      if (dotenv.env['PREFETCH'] == 'true' && null != functions.slowSearch) {
        functions.slowSearch!(detailCriteria);
      }
    }
  }

  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  void _getDetailSources(
    MovieResultDTO dto,
    SearchFunctions functions,
  ) {
    if (MovieContentType.person == dto.type) {
      if (DataSourceType.imdbSuggestions == dto.bestSource ||
          DataSourceType.imdbSearch == dto.bestSource ||
          DataSourceType.tmdbPerson == dto.bestSource) {
        functions.fastSearch = _getIMDBPersonDetailsFast;
        functions.slowSearch = _getIMDBPersonDetailsSlow;
      }
    } else {
      if (DataSourceType.imdbSuggestions == dto.bestSource ||
          DataSourceType.imdbSearch == dto.bestSource ||
          DataSourceType.tmdbSearch == dto.bestSource) {
        functions.fastSearch = _getIMDBMovieDetailsFast;
        functions.slowSearch = _getIMDBMovieDetailsSlow;
      }
      if (!dto.sources.containsKey(DataSourceType.tmdbFinder)) {
        // Restrict supplementary details
        // to prevent recursive infinite loop.  Want to avoid :
        // IMDB details -> TMDB Finder -> TMDB Details -> IMDB Details
        functions.supplementarySearch = _getTMDBExtraDetails;
      }
    }

    if (dto.sources.containsKey(DataSourceType.tmdbFinder)) {
      if (MovieContentType.person == dto.type) {
        if (!dto.sources.containsKey(DataSourceType.tmdbPerson)) {
          functions.fastSearch = _getTMDBPersonDetailsFast;
        }
      } else {
        if (!dto.sources.containsKey(DataSourceType.tmdbMovie)) {
          functions.fastSearch = _getTMDBMovieDetailsFast;
        }
      }
    }
  }

  /// Add fetch partial person details from imdb.
  static Future<List<MovieResultDTO>> _getIMDBPersonDetailsFast(
    SearchCriteriaDTO criteria,
  ) async {
    return QueryIMDBSuggestions().readList(criteria);
  }

  /// Add fetch full person details from imdb.
  static Future<List<MovieResultDTO>> _getIMDBPersonDetailsSlow(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBNameDetails().readPrioritisedCachedList(
        criteria,
        priority: ThreadRunner.verySlow,
      );

  /// Add fetch partial movie details from imdb.
  static Future<List<MovieResultDTO>> _getIMDBMovieDetailsFast(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBTitleDetails().readList(criteria);

  /// Add fetch full movie details from imdb.
  static Future<List<MovieResultDTO>> _getIMDBMovieDetailsSlow(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBCastDetails().readPrioritisedCachedList(
        criteria,
        priority: ThreadRunner.verySlow,
      );

  /// Add fetch full movie details from tmdb.
  static Future<List<MovieResultDTO>> _getTMDBMovieDetailsFast(
    SearchCriteriaDTO criteria,
  ) =>
      QueryTMDBMovieDetails().readList(criteria);

  /// Add fetch full movie details from tmdb.
  static Future<List<MovieResultDTO>> _getTMDBPersonDetailsFast(
    SearchCriteriaDTO criteria,
  ) =>
      QueryTMDBMovieDetails().readList(criteria);

  /// Add fetch full movie details from tmdb.
  static Future<List<MovieResultDTO>> _getTMDBExtraDetails(
    SearchCriteriaDTO criteria,
  ) =>
      QueryTMDBFinder().readList(criteria);

  /// Add fetched tmbd movie details into the stream and search imdb.
  ///
  /// TMDBFinder returns a TMDB ID based on an IMDB ID
  /// which then requries another call to get TMDB details
  /// TMDBMovie returns an IMDB ID based on a TMDB ID
  /// which then requries another call to get IMDB details
  void _addDetails(int originalSearchUID, List<MovieResultDTO> values) {
    for (final dto in values) {
      if (DataSourceType.tmdbFinder == dto.bestSource &&
          MovieContentType.person == dto.type) {
        //TODO: do something here?
      }
    }
    if (!searchInterrupted(originalSearchUID)) {
      for (final dto in values) {
        if (DataSourceType.tmdbMovie == dto.bestSource &&
            !dto.sources.containsKey(DataSourceType.imdb)) {
          _getDetails(originalSearchUID, dto);
        }
        _finishDetails(dto);
      }
    }
  }

  /// Check to see if any movie detail fetch is in progress.
  bool get _awaitingDetails {
    return _requestedDetails.values.contains(null);
  }

  /// Yield movie details to the results stream.
  /// Close the stream if all WebFetch operations have completed.
  void _finishDetails(MovieResultDTO dto) {
    yieldResult(dto);
    _recordResult(dto);
    //if (_awaitingProviders == 0 && !_awaitingDetails) close();
  }

  /// Update map to inidicate detail fetch is no longer in progress.
  /// If result comes from IMDB or if id is not an IMDB id.
  void _recordResult(MovieResultDTO dto) {
    if (DataSourceType.imdb == dto.bestSource ||
        (!dto.uniqueId.startsWith(imdbTitlePrefix) &&
            !dto.uniqueId.startsWith(imdbPersonPrefix))) {
      _requestedDetails[dto.uniqueId] = dto.title;
    }
  }
}
