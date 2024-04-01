import 'dart:async' show StreamController, unawaited;

import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

typedef ExtraDetailFn = Future<List<MovieResultDTO>> Function(MovieResultDTO);

/// Retrieve movie data from multiple online sources.
///
/// BlockRepository to consolidate data retrieval from multiple search
/// and detail providers using the WebFetch framework.
///
/// [search] provides a stream of incomplete and complete results.
/// [close] can be used to cancel a search.
///
/// Child calsses shoud override
/// - initSearch if a
/// - getProviders if using one or more WebFetchBase are use to fetch the data.
/// - getExtraDetails if additional dat is require for each record returned.
class BaseMovieRepository {
  BaseMovieRepository();

  late SearchCriteriaDTO criteria;
  StreamController<MovieResultDTO>? _movieStreamController;
  final _awaitingProviders = <dynamic>[];
  final providers = <WebFetchBase<MovieResultDTO, SearchCriteriaDTO>>[];
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
    unawaited(initSearch(_searchUID, criteria));
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

  /// Initiates the primary data fetch.
  ///
  /// May be overridden by specific implementations, calling:
  ///   initProvider() before requesting data for a source.
  ///   await addResults(searchUID,dto) to yeild each matching record.
  ///   await finishProvider() as each source completes.
  @protected
  Future<void> initSearch(int searchUID, SearchCriteriaDTO criteria) async {
    if (criteria.criteriaList.isEmpty) {
      await _searchText(searchUID);
    }
    if (criteria.criteriaType == SearchCriteriaType.barcode) {
      await _searchText(searchUID);
    } else {
      await _searchList(searchUID);
    }
  }

  /// Initiates a secondary data fetch.
  ///
  /// To be overridden by specific implementations
  /// Returning a list containing a map of:
  ///   WebFetchBase class : result quantity limit.
  /// e.g. Return [{QueryIMDBSearch(criteria):10}]
  @protected
  Map<WebFetchBase<MovieResultDTO, SearchCriteriaDTO>, int> getProviders() =>
      {};

  /// Initiates a secondary data fetch.
  ///
  /// To be overridden by specific implementations, calling:
  ///   initProvider() before requesting data for a source.
  ///   yieldResult() for any returned data.
  ///   await finishProvider() as each source completes.
  /// Returns number of extra fetches requested.
  @protected
  Future<void> getExtraDetails(
    int originalSearchUID,
    MovieResultDTO dto,
  ) async {}

  /// Begin waiting for another data provider to complete.
  ///
  /// [provider] uniquely identifies the search source and search criteria.
  @protected
  void initProvider(dynamic provider) {
    _awaitingProviders.add(provider);
  }

  /// Cease waiting for data provider to complete.
  /// Close the stream if all WebFetch operations have completed.
  ///
  /// [provider] is the same passed through to initProvider.
  @protected
  Future<void> finishProvider(dynamic provider) async {
    _awaitingProviders.remove(provider);
    if (_awaitingProviders.isEmpty) {
      DtoCache.dumpCache();
      return close();
    }
  }

  /// Yields incomplete or completed results in the stream.
  @protected
  void yieldResult(MovieResultDTO result) =>
      _movieStreamController?.add(result);

  /// Determines if a new search has been initatatd since originalSearchUID.
  @protected
  bool searchInterrupted(int originalSearchUID) =>
      originalSearchUID != _searchUID;

  /// Yields incomplete or completed results in the stream
  /// and initiates retrieval of movie details.
  @protected
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

  /// Initiates a search with multiple WebFetch providers.
  /// Requests details retrieval for all returned search results.
  Future<void> _searchText(int searchUID) async {
    final futures = <Future<dynamic>>{};

    for (final entry in getProviders().entries) {
      final provider = entry.key;
      final limit = entry.value;
      initProvider(provider);
      futures.add(
        provider
            .readList(limit: limit)
            .then((values) => addResults(searchUID, values))
            .whenComplete(() => finishProvider(provider)),
      );
    }
    for (final future in futures) {
      await future;
    }
  }

  /// Initiates a details retrival for a specified list of movies.
  Future<void> _searchList(int searchUID) async {
    initProvider(this);
    return addResults(searchUID, criteria.criteriaList)
        .then((_) => finishProvider(this));
  }
}
