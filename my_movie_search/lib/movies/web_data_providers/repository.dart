import 'dart:async';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb.dart';

import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';
import 'package:my_movie_search/movies/web_data_providers/search/omdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tmdb.dart';

class MovieRepository {
  final QueryIMDBDetails _imdbDetails;
  final QueryIMDBSuggestions _imdbSuggestions;
  final QueryIMDBSearch _imdbSearch;
  final QueryOMDBMovies _omdbSearch;
  final QueryTMDBMovies _tmdbSearch;
  final QueryGoogleMovies _googleSearch;
  StreamController<MovieResultDTO>? _movieStreamController;
  var awaitingProviders = 0;

  MovieRepository()
      : _imdbDetails = QueryIMDBDetails(),
        _imdbSuggestions = QueryIMDBSuggestions(),
        _imdbSearch = QueryIMDBSearch(),
        _omdbSearch = QueryOMDBMovies(),
        _tmdbSearch = QueryTMDBMovies(),
        _googleSearch = QueryGoogleMovies();

  Stream<MovieResultDTO> search(SearchCriteriaDTO criteria) async* {
    var feedback = MovieResultDTO();
    feedback.title = 'Searching ...';
    yield feedback;

    _movieStreamController = StreamController<MovieResultDTO>();
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
      awaitingProviders++;
      provider
          .read(criteria)
          .then((values) => _addResults(values))
          .whenComplete(_finishProvider);
    }
  }

  void _addResults(List<MovieResultDTO> values) {
    values.forEach((dto) => _movieStreamController?.add(dto));
    _getDetails(values);
  }

  Future<void> _getDetails(List<MovieResultDTO> values) async {
    var futures = [];
    values.forEach((dto) => futures = _queueDetailSearch(dto));
    futures.forEach(
        (detailSearch) => detailSearch.then((values) => _addDetails(values)));
  }

  List<Future> _queueDetailSearch(MovieResultDTO dto) {
    List<Future> futures = [];
    var criteria = SearchCriteriaDTO();

    if (dto.uniqueId.startsWith('tt')) {
      criteria.criteriaTitle = dto.uniqueId;
      futures.add(_imdbDetails.read(criteria));
    }
    return futures;
  }

  void _addDetails(List<MovieResultDTO> values) {
    values.forEach((dto) => print(dto.toString()));
    values.forEach((dto) => _movieStreamController?.add(dto));
  }

  void _finishProvider() {
    awaitingProviders = awaitingProviders - 1;
    if (awaitingProviders == 0) close();
  }
}
