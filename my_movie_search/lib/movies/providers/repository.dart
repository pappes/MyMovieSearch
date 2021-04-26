import 'dart:async';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';

import 'package:my_movie_search/movies/providers/search/google.dart';
import 'package:my_movie_search/movies/providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/movies/providers/search/omdb.dart';
import 'package:my_movie_search/movies/providers/search/tmdb.dart';

class MovieRepository {
  final QueryIMDBSuggestions _imdbSearch;
  final QueryOMDBMovies _omdbSearch;
  final QueryTMDBMovies _tmdbSearch;
  final QueryGoogleMovies _googleSearch;
  final _controller = StreamController<MovieResultDTO>();

  MovieRepository()
      : _imdbSearch = QueryIMDBSuggestions(),
        _omdbSearch = QueryOMDBMovies(),
        _tmdbSearch = QueryTMDBMovies(),
        _googleSearch = QueryGoogleMovies();

  Stream<MovieResultDTO> search(SearchCriteriaDTO criteria) async* {
    var feedback = MovieResultDTO();
    feedback.title = 'Searching ...';
    yield feedback;

    // TODO: error handling
    _initSearch(criteria);

    yield* _controller.stream;
  }

  void dispose() => _controller.close();

  void _initSearch(
    SearchCriteriaDTO criteria,
  ) {
    for (var provider in [
      _imdbSearch,
      _omdbSearch,
      _tmdbSearch,
      _googleSearch,
    ]) {
      provider
          .read(criteria)
          .then((values) => values.forEach((dto) => _controller.add(dto)));
    }
  }

  static void insertSort(
    Map<String, MovieResultDTO> allResults,
    List<MovieResultDTO> sortedResults,
    MovieResultDTO newValue,
  ) {
    if (newValue.uniqueId == '-1' ||
        !allResults.containsKey(newValue.uniqueId)) {
      allResults[newValue.uniqueId] = newValue;
      sortedResults.clear();
      sortedResults.addAll(allResults.values.toList());
      // Sort by relevence with recent year first
      sortedResults.sort((a, b) => b.compareTo(a));
    }
  }
}
