import 'dart:async' show StreamController;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb.dart';

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
    var feedback = MovieResultDTO();
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
    var feedback = MovieResultDTO();
    feedback.title = 'Search completed ...';
    _movieStreamController?.add(feedback);
    print('closing stream');
    _movieStreamController?.close();
    _movieStreamController = null;
  }

  /// Initiates a search with all known movie search providers.
  /// To be overridden by specific implementations, calling:
  ///   initProvider() before requesting data for a source.
  ///   addResults() for matching data.
  ///   finishProvider() as each source completes.
  void initSearch(int originalSearchUID, SearchCriteriaDTO criteria) {}

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

  /// Yields incomplete results in the stream
  /// and initiates retrieval of movie details.
  void addResults(int originalSearchUID, List<dynamic> results) {
    if (originalSearchUID == _searchUID) {
      // Ensure a new search has not been started.
      results.forEach((dto) => _movieStreamController?.add(dto));
      results.forEach((dto) => _getDetails(originalSearchUID, dto));
    }
  }

  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  void _getDetails(int originalSearchUID, MovieResultDTO dto) {
    if (!_requestedDetails.containsKey(dto.uniqueId) && dto.uniqueId != '-1') {
      // Ensure a new search has not been started.
      var detailCriteria = SearchCriteriaDTO();

      if (dto.uniqueId.startsWith('tt')) {
        final imdbDetails =
            QueryIMDBDetails(); //Seperate instance per search (async)
        detailCriteria.criteriaTitle = dto.uniqueId;
        _requestedDetails[dto.uniqueId] = null;
        imdbDetails.readList(detailCriteria).then(
            (searchResults) => _addDetails(originalSearchUID, searchResults));
      } else {
        // TODO: fetch details from alternate source
      }
    }
  }

  /// Add fetched movie details into the stream.
  void _addDetails(int originalSearchUID, List<MovieResultDTO> values) {
    if (originalSearchUID == _searchUID) {
      // Ensure a new search has not been started.
      print('received list length ${values.length}');
      for (var dto in values) {
        _finishDetails(dto);
        print('${dto.toPrintableString()}');
      }
      print(_requestedDetails.toString());
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
    _movieStreamController?.add(dto);
    _requestedDetails[dto.uniqueId] = dto.title;
    if (_awaitingProviders == 0 && !_awaitingDetails) close();
  }
}
