import 'dart:async' show StreamController;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

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

      if (dto.uniqueId.startsWith(imdbTitlePrefix)) {
        final imdbDetails =
            QueryIMDBTitleDetails(); //Seperate instance per search (async)
        imdbDetails.readList(detailCriteria).then(
              (searchResults) =>
                  _addImdbMovieDetails(originalSearchUID, searchResults),
            );
      } else if (dto.uniqueId.startsWith(imdbPersonPrefix)) {
        final imdbDetails =
            //QueryIMDBNameDetails(); // Cant pull back details at this point because it is very slow and CPU intensive
            QueryIMDBSuggestions(); //Seperate instance per search (async)
        imdbDetails.readList(detailCriteria).then(
              (searchResults) =>
                  _addImdbMovieDetails(originalSearchUID, searchResults),
            );
      } else {
        final tmdbDetails =
            QueryTMDBDetails(); //Seperate instance per search (async)
        tmdbDetails.readList(detailCriteria).then(
              (searchResults) =>
                  _addTmdbDetails(originalSearchUID, searchResults),
            );
      }
    }
  }

  /// Add fetched tmbd movie details into the stream and search imdb.
  void _addTmdbDetails(int originalSearchUID, List<MovieResultDTO> values) {
    if (!searchInterrupted(originalSearchUID)) {
      for (final dto in values) {
        if (dto.alternateId.startsWith(imdbTitlePrefix) ||
            dto.alternateId.startsWith(imdbPersonPrefix)) {
          final imdbDetails = MovieResultDTO();
          imdbDetails.uniqueId = dto.alternateId;
          _getDetails(originalSearchUID, imdbDetails);
        }
        _finishDetails(dto);
      }
    }
  }

  /// Add fetched movie details into the stream.
  void _addImdbMovieDetails(
    int originalSearchUID,
    List<MovieResultDTO> values,
  ) {
    if (!searchInterrupted(originalSearchUID)) {
      values.forEach(_finishDetails);
    }
  }

  /// Check to see if any movie detail fetch is in progress.
  bool get _awaitingDetails {
    return _requestedDetails.values.contains(null);
  }

  /// Yield movie details to the results stream
  /// and update map to inidicate detail fetch is no longer in progress.
  /// Close the stream if all WebFetch operations have completed.
  void _finishDetails(MovieResultDTO dto) {
    yieldResult(dto);
    _requestedDetails[dto.uniqueId] = dto.title;
    if (_awaitingProviders == 0 && !_awaitingDetails) close();
  }
}
