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
  final Map _requestedDetails = {};

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

    _movieStreamController = StreamController<MovieResultDTO>(sync: true);
    _requestedDetails.clear();
    // TODO: error handling
    _initSearch(criteria);

    yield* _movieStreamController!.stream;
  }

  void close() {
    var feedback = MovieResultDTO();
    feedback.title = 'Search completed ...';
    _movieStreamController?.add(feedback);
    print('closing stream');
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
          .readList(criteria, limit: 10)
          .then((values) => _addResults(values))
          .whenComplete(_finishProvider);
    }
  }

  void _addResults(List<dynamic> results) {
    results.forEach((dto) => _movieStreamController?.add(dto));
    _getDetails(results);
  }

  void _getDetails(List<dynamic> searchResults) {
    List<Future> futures = [];
    searchResults.forEach((dto) => futures.addAll(_queueDetailSearch(dto)));
    futures.forEach((detailSearch) =>
        detailSearch.then((searchResults) => _addDetails(searchResults)));
  }

  List<Future> _queueDetailSearch(MovieResultDTO dto) {
    List<Future> futures = [];
    if (!_requestedDetails.containsKey(dto.uniqueId) && dto.uniqueId != '-1') {
      var criteria = SearchCriteriaDTO();

      if (dto.uniqueId.startsWith('tt')) {
        final imdbDetails =
            QueryIMDBDetails(); //Seperate instance per search (async)
        criteria.criteriaTitle = dto.uniqueId;
        futures.add(imdbDetails.readList(criteria));
        _requestedDetails[dto.uniqueId] = null;
      }
    }
    return futures;
  }

  void _addDetails(List<MovieResultDTO> values) {
    print('received ${values.length}');
    for (var dto in values) {
      _movieStreamController?.add(dto);
      print('${dto.toPrintableString()}');
      _requestedDetails[dto.uniqueId] = dto.title;
    }
    print(_requestedDetails.toString());
  }

  bool get _awaitingDetails {
    return _requestedDetails.values.contains(null);
  }

  void _finishDetails() {
    if (_awaitingProviders == 0 && !_awaitingDetails) close();
  }

  void _finishProvider() {
    _awaitingProviders = _awaitingProviders - 1;
    if (_awaitingProviders == 0 && !_awaitingDetails) close();
  }
}
