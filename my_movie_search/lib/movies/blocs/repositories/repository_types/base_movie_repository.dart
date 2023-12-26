import 'dart:async' show StreamController, unawaited;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

typedef ExtraDetailFn = Future<List<MovieResultDTO>> Function(MovieResultDTO);

/// Retrieve movie data from multiple online sources.
///
/// BlockRepository to consolidate data retrieval from multiple search
/// and detail providers using the WebFetch framework.
///
/// [search] provides a stream of incomplete and complete results.
/// [close] can be used to cancel a search.
class BaseMovieRepository {
  BaseMovieRepository();

  late SearchCriteriaDTO criteria;
  StreamController<MovieResultDTO>? _movieStreamController;
  final _awaitingProviders = <dynamic>[];
  static int _searchUID = 1;

  /// Return a stream of data matching [criteria].
  ///
  /// Status updates are yielded with uniqueId = -1.
  /// Partial results are yielded quickly with limited information.
  /// Complete results are returned progressivly
  /// and need to be merged with the partial results.
  Stream<MovieResultDTO> search(SearchCriteriaDTO newCriteria) async* {
    criteria = newCriteria;
    ++_searchUID;
    yield MovieResultDTO()
      ..title = 'Searching ...'
      ..type = MovieContentType.information;

    _movieStreamController = StreamController<MovieResultDTO>(sync: true);
    // TODO(pappes): error handling
    initSearch(_searchUID, criteria);
    // TODO(pappes): make fetch duration configurable.
    unawaited(
      Future<void>.delayed(const Duration(seconds: 30)).then((_) => close()),
    );

    yield* _movieStreamController!.stream;
  }

  /// Cancels or completes an in progress search.
  Future<void> close() async {
    yieldResult(
      MovieResultDTO()
        ..title = 'Search completed ...'
        ..type = MovieContentType.information,
    );

    if (_movieStreamController != null) {
      logger.t('closing stream');
      final tempController = _movieStreamController!;
      _movieStreamController = null;
      return tempController.close();
    }
  }

  /// Initialise the class for a new search
  /// with all known movie search providers.
  ///
  /// To be overridden by specific implementations, calling:
  ///   initProvider() before requesting data for a source.
  ///   await addResults(searchUID,dto) for matching data.
  ///   await finishProvider() as each source completes.
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {}

  /// Initiates a secondary data fetch.
  ///
  /// To be overridden by specific implementations, calling:
  ///   initProvider() before requesting data for a source.
  ///   yieldResult() for any returned data.
  ///   await finishProvider() as each source completes.
  /// Returns number of extra fetches requested.
  Future<int> getExtraDetails(
    int originalSearchUID,
    MovieResultDTO dto,
  ) async =>
      0;

  /// Begin waiting for another data provider to complete.
  ///
  /// [provider] uniquely identifies the search source and search criteria.
  void initProvider(dynamic provider) {
    _awaitingProviders.add(provider);
  }

  /// Cease waiting for data provider to complete.
  /// Close the stream if all WebFetch operations have completed.
  ///
  /// [provider] is the same passed through to initProvider.
  Future<void> finishProvider(dynamic provider) async {
    _awaitingProviders.remove(provider);
    if (_awaitingProviders.isEmpty) {
      DtoCache.dumpCache();
      return close();
    }
  }

  /// Yields incomplete or completed results in the stream.
  void yieldResult(MovieResultDTO result) =>
      _movieStreamController?.add(result);

  /// Determines if a new search has been initatatd since originalSearchUID.
  bool searchInterrupted(int originalSearchUID) =>
      originalSearchUID != _searchUID;

  /// Yields incomplete or completed results in the stream
  /// and initiates retrieval of movie details.
  Future<void> addResults(
    int originalSearchUID,
    List<MovieResultDTO> results,
  ) async {
    if (!searchInterrupted(originalSearchUID)) {
      // Ensure a new search has not been started.
      results.forEach(yieldResult);
      for (final dto in results) {
        unawaited(getExtraDetails(originalSearchUID, dto));
      }
    }
  }
}
