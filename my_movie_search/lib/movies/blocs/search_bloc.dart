import 'dart:async' show StreamSubscription, unawaited;

import 'package:easy_debounce/easy_throttle.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_movie_search/firebase_app_state.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

part 'bloc_parts/search_event.dart';
part 'bloc_parts/search_state.dart';

/// Movie search business logic wrapper.
///
/// Provides a [Bloc] compliant business logic layer to
/// manage fetching movie data
/// manage search state
/// marshal data into a display ready format (sorting)
///
/// In progress search results can be accessed from
/// [SearchBloc].[sortedResults].
class SearchBloc extends HydratedBloc<SearchEvent, SearchState> {
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

  BaseMovieRepository movieRepository;
  StreamSubscription<MovieResultDTO>? _searchStatusSubscription;
  final MovieCollection _allResults = {};
  List<MovieResultDTO> sortedResults = [];
  double _searchProgress = 0; // Value representing the search progress.
  bool _searchComplete = false;
  bool _throttleActive = false; // There hase been a recent result.
  bool _throttledDataPending = false; // There has been multple recent results.
  String _throttleName = '';

  @override
  String get id => '';

  @override
  SearchState fromJson(Map<String, dynamic> json) {
    //update sorted results
    if (json.containsKey('sorted_results')) {
      final jsonList = json['sorted_results']! as String;
      sortedResults = jsonList.jsonToList();
    }
    return SearchState.displayingResults(_searchProgress);
  }

  @override
  Map<String, dynamic> toJson(SearchState state) =>
      {'sorted_results': sortedResults.toJson()};

  @override
  // Clean up all open objects.
  Future<void> close() async {
    await _searchStatusSubscription?.cancel();
    await movieRepository.close();
    return super.close();
  }

  /// Clean up the results of any previous search
  /// and submit the new search criteria.
  Future<void> _initiateSearch(
    SearchCriteriaDTO criteria,
    Emitter<SearchState> emit,
  ) async {
    if (!isClosed) {
      emit(const SearchState.awaitingInput());
    }
    await movieRepository.close();
    _allResults.clear();
    sortedResults.clear();
    _throttleName = 'SearchBloc${criteria.toPrintableString()}';
    _searchStatusSubscription = movieRepository
        .search(criteria)
        .listen(_receiveDTO)
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

  // Annotate the DTO with a read indicator
  void _addReadIndicator(MovieResultDTO dto, String? value) {
    if (null != value) {
      dto.setReadIndicator(value);
      _throttleUpdates();
    }
  }

  /// Maintain map of fetched movie snippets and details.
  /// Update bloc state to indicate that new data is available.
  void _receiveDTO(MovieResultDTO newValue) {
    final key = newValue.uniqueId;

    if (newValue.isMessage()) {
      _allResults[key] = newValue;
    } else {
      // Merge value with existing information and insert value into list

      final subsequentFetch = _allResults.containsKey(key);
      _allResults[key] = DtoCache.singleton().merge(newValue);
      if (!subsequentFetch) {
        // Check navigation history to see if this result has been viewed
        if (key.startsWith(imdbPersonPrefix) ||
            key.startsWith(imdbTitlePrefix)) {
          const collectionPrefix = 'MMSNavLog/screen/';
          final collection = key.startsWith(imdbTitlePrefix)
              ? 'moviedetails'
              : 'persondetails';
          unawaited(
            FirebaseApplicationState()
                .fetchRecord(
                  '$collectionPrefix$collection',
                  id: newValue.uniqueId,
                )
                .then(
                  (value) =>
                      _addReadIndicator(_allResults[key]!, value?.toString()),
                ),
          );
        }
      }
    }

    _findTemporaryDTO(_allResults, newValue);
    _throttleUpdates();
  }

  /// update record into the map with new key and values
  void _findTemporaryDTO(MovieCollection collection, MovieResultDTO newValue) {
    final tmdbSources = [
      DataSourceType.tmdbFinder,
      DataSourceType.tmdbMovie,
      DataSourceType.tmdbPerson,
    ];
    if (MovieContentType.error != newValue.type) {
      for (final source in tmdbSources) {
        final imdbid = newValue.uniqueId;
        final tmdbid = newValue.sources[source];
        if (null != tmdbid &&
            tmdbid != imdbid &&
            _allResults.containsKey(tmdbid)) {
          _replaceTemporaryDTO(_allResults, imdbid, tmdbid);
        }
      }
    }
  }

  /// Reinsert record into the map because we cant update the key directly.
  void _replaceTemporaryDTO(
    MovieCollection collection,
    String imdbId,
    String tmdbId,
  ) {
    // Delete TMDB record from collection
    // and merge combined TMDB data with IMDB record
    // e.g. tmdbid="11234" imdbid="nm0109036"
    final temporaryRecord = collection[tmdbId]!;
    if (MovieContentType.error != temporaryRecord.type) {
      temporaryRecord.uniqueId = imdbId;
      _allResults[imdbId] = DtoCache.singleton().merge(temporaryRecord);

      collection.remove(tmdbId);
    }
  }

  /// Batch up data for updates to subscribers.
  ///
  /// Postpone sorting and displaying of data if there has been a recent update.
  void _throttleUpdates() {
    _throttleActive = true;
    _throttledDataPending = EasyThrottle.throttle(
      _throttleName,
      const Duration(milliseconds: 500), // limit refresh to twice per second
      _sendResults, // Initial screen draw
      onAfter: _throttleCompleted, // Process throttled updates
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
    sortedResults
      ..clear()
      ..addAll(_allResults.values.toList())
      // Sort by relevence with recent year first
      ..sort((a, b) => b.compareTo(a));
    _searchProgress++;

    if (!isClosed) {
      add(SearchDataReceived(sortedResults));
    }
  }
}
