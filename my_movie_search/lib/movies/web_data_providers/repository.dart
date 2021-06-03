import 'dart:async' show StreamController;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'detail/imdb.dart';
import 'search/imdb_suggestions.dart';
import 'search/imdb_search.dart';
import 'search/google.dart';
import 'search/omdb.dart';
import 'search/tmdb.dart';

class MovieRepository {
  final QueryIMDBSuggestions _imdbSuggestions;
  final QueryIMDBSearch _imdbSearch;
  final QueryOMDBMovies _omdbSearch;
  final QueryTMDBMovies _tmdbSearch;
  final QueryGoogleMovies _googleSearch;
  StreamController<MovieResultDTO>? _movieStreamController;
  var _awaitingProviders = 0;
  var _awaitingDetails = 0;
  final List<String> _requestedDetails = [];

  MovieRepository()
      : _imdbSuggestions = QueryIMDBSuggestions(),
        _imdbSearch = QueryIMDBSearch(),
        _omdbSearch = QueryOMDBMovies(),
        _tmdbSearch = QueryTMDBMovies(),
        _googleSearch = QueryGoogleMovies();

  Stream<MovieResultDTO> search(SearchCriteriaDTO criteria) async* {
    var feedback = MovieResultDTO();
    feedback.title = 'Searching ...';
    yield feedback;

    _movieStreamController = StreamController<MovieResultDTO>();
    _requestedDetails.clear();
    // TODO: error handling
    _initSearch(criteria);

    yield* _movieStreamController!.stream;
  }

  void close() {
    var feedback = MovieResultDTO();
    feedback.title = 'Search completed ...';
    _movieStreamController?.add(feedback);
    _movieStreamController?.close();
    _movieStreamController = null;
  }

  void _initSearch(
    SearchCriteriaDTO criteria,
  ) {
    for (var provider in [
      _imdbSearch,
      _imdbSuggestions,
      _omdbSearch,
      _tmdbSearch,
      _googleSearch,
    ]) {
      _awaitingProviders++;
      provider
          .read(criteria, limit: 10)
          .then((values) => _addResults(values))
          .whenComplete(_finishProvider);
    }
  }

  void _addResults(List<dynamic> values) {
    values.forEach((dto) => _movieStreamController?.add(dto));
    _getDetails(values);
  }

  void _getDetails(List<dynamic> values) {
    List<Future> futures = [];
    values.forEach((dto) => futures.addAll(_queueDetailSearch(dto)));
    futures.forEach(
        (detailSearch) => detailSearch.then((values) => _addDetails(values)));
  }

  List<Future> _queueDetailSearch(MovieResultDTO dto) {
    List<Future> futures = [];
    if (!_requestedDetails.contains(dto.uniqueId)) {
      _requestedDetails.add(dto.uniqueId);
      var criteria = SearchCriteriaDTO();

      if (dto.uniqueId.startsWith('tt')) {
        final imdbDetails =
            QueryIMDBDetails(); //Seperate instance per search (async)
        criteria.criteriaTitle = dto.uniqueId;
        futures.add(imdbDetails.read(criteria));
        _awaitingDetails++;
      }
    }
    return futures;
  }

  void _addDetails(List<MovieResultDTO> values) {
    values.forEach((dto) => print(dto.toPrintableString()));
    values.forEach((dto) => _movieStreamController?.add(dto));
    _finishDetails(values.length);
  }

  void _finishDetails(int count) {
    _awaitingDetails = _awaitingDetails - count;
    if (_awaitingProviders == 0 && _awaitingDetails == 0) close();
  }

  void _finishProvider() {
    _awaitingProviders = _awaitingProviders - 1;
    if (_awaitingProviders == 0 && _awaitingDetails == 0) close();
  }
}
