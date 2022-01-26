import 'dart:async' show StreamSubscription;

import 'package:bloc/bloc.dart' show Bloc, Emitter;
import 'package:equatable/equatable.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

part 'bloc_parts/search_event.dart';
part 'bloc_parts/search_state.dart';

/// Moview search business logic wrapper
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
  final _allResults = <String, MovieResultDTO>{};
  List<MovieResultDTO> sortedResults = [];
  double _searchProgress = 0.0; // Value representing the search progress.

  /*@override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchCompleted) {
      yield SearchState.displayingResults(_searchProgress);
    } else if (event is SearchCancelled) {
      yield const SearchState.awaitingInput();
    } else if (event is SearchRequested) {
      yield SearchState.searching(SearchRequest(event.criteria.criteriaTitle));
      //_initiateSearch(event.criteria);
    }
  }*/

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
    _searchStatusSubscription = movieRepository
        .search(criteria)
        .listen((dto) => _receiveDTO(dto))
      ..onDone(() => isClosed ? null : add(const SearchCompleted()));
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
    _sortResults();
  }

  /// Prepare data for display by sorting by relevence and
  /// update bloc state to indicate that new data is available.
  void _sortResults() {
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
