import 'dart:async' show StreamSubscription;

import 'package:bloc/bloc.dart' show Bloc, Emitter;
import 'package:easy_debounce/easy_throttle.dart';
import 'package:equatable/equatable.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';

part 'bloc_parts/search_event.dart';
part 'bloc_parts/search_state.dart';

/// Moview search business logic wrapper.
///
/// Provides a [Bloc] compliant business logic layer to
/// manage fetching movie data
/// manage search state
/// marshal data into a display ready format (sorting)
///
/// In progress search results can be accessed from [SearchBloc].[sortedResults].
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.movieRepository})
      : super(const SearchState.awaitingInput()) {
    on<SearchCompleted>(
      (event, emit) => isClosed
          ? null
          : emit(SearchState.displayingResults(_searchProgress)),
    );
    on<SearchDataReceived>(
      (event, emit) => isClosed
          ? null
          : emit(SearchState.displayingResults(_searchProgress)),
    );
    on<SearchCancelled>(
      (event, emit) =>
          isClosed ? null : emit(const SearchState.awaitingInput()),
    );
    on<SearchRequested>((event, emit) {
      _initiateSearch(event.criteria, emit);
    });
  }

  final MovieSearchRepository movieRepository;
  StreamSubscription<MovieResultDTO>? _searchStatusSubscription;
  final RelatedMovies _allResults = {};
  List<MovieResultDTO> sortedResults = [];
  double _searchProgress = 0.0; // Value representing the search progress.
  bool _searchComplete = false;
  bool _throttleActive = false; // There hase been a recent result.
  bool _throttledDataPending = false; // There has been multple recent results.
  String _throttleName = '';

  @override
  // Clean up all open objects.
  Future<void> close() {
    _searchStatusSubscription?.cancel();
    movieRepository.close();
    return super.close();
  }

  /// Clean up the results of any previous search and submit the new search criteria.
  void _initiateSearch(SearchCriteriaDTO criteria, Emitter<SearchState> emit) {
    if (!isClosed) {
      emit(const SearchState.awaitingInput());
    }
    movieRepository.close();
    _allResults.clear();
    sortedResults.clear();
    _throttleName = 'SearchBloc${criteria.toPrintableString()}';
    _searchStatusSubscription = movieRepository
        .search(criteria)
        .listen((dto) => _receiveDTO(dto))
      ..onDone(_completeSearch);
  }

  /// Notify subscribers the stream of data is complete.
  void _completeSearch() {
    _searchComplete = true;

    if (!isClosed && !_throttleActive) {
      // Ensure subscriber has not cancelled to subscription
      add(const SearchCompleted());
    }
  }

  /// Maintain map of fetched movie snippets and details.
  /// Update bloc state to indicate that new data is available.
  void _receiveDTO(MovieResultDTO newValue) {
    if (newValue.uniqueId.startsWith(movieResultDTOMessagePrefix) ||
        !_allResults.containsKey(newValue.uniqueId)) {
      _allResults[newValue.uniqueId] = newValue;
    } else {
      newValue.mergeDtoList(_allResults, {newValue.uniqueId: newValue});
      _allResults[newValue.uniqueId]!.merge(newValue);
    }
    if ('' != newValue.alternateId) {
      // Delete TMDB record from collection
      // and merge combined TMDB data with IMDB record
      final old = _allResults[newValue.uniqueId]!;
      _allResults.remove(newValue.uniqueId);

      old.uniqueId = old.alternateId;
      old.alternateId = '';
      newValue.mergeDtoList(_allResults, {old.uniqueId: old});
    }
    _throttleUpdates();
  }

  /// Batch up data for updates to subscribers.
  ///
  /// Postpone sorting and displaying of data if there has been a recent update.
  void _throttleUpdates() {
    _throttleActive = true;
    _throttledDataPending = EasyThrottle.throttle(
      _throttleName,
      const Duration(milliseconds: 2000), // limit refresh to every 2 seconds
      () => _sendResults(), // Initial screen draw
      onAfter: () => _throttleCompleted(), // Process throttled updates
    );
  }

  /// Process any pending operations that were held waiting for more data.
  void _throttleCompleted() {
    _throttleActive = false;
    if (_throttledDataPending) {
      _sendResults();
      _throttledDataPending = false;
    }

    if (!isClosed && _searchComplete) {
      _completeSearch();
    }
  }

  /// Prepare data for display by sorting by relevence and
  /// update bloc state to indicate that new data is available.
  void _sendResults() {
    sortedResults.clear();
    sortedResults.addAll(_allResults.values.toList());
    // Sort by relevence with recent year first
    sortedResults.sort((a, b) => b.compareTo(a));
    _updateProgress();

    if (!isClosed) {
      add(SearchDataReceived(sortedResults));
    }
  }

  /// Calculate a value representing the search progress.
  /// Currently uses count of rows + sum of user rating values
  /// to account for progressive population of movie details.
  void _updateProgress() {
    _searchProgress = sortedResults.length.toDouble();
    for (final element in sortedResults) {
      _searchProgress += element.userRating;
    }
  }
}
