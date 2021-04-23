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

  MovieRepository()
      : _imdbSearch = QueryIMDBSuggestions(),
        _omdbSearch = QueryOMDBMovies(),
        _tmdbSearch = QueryTMDBMovies(),
        _googleSearch = QueryGoogleMovies();

  Future<List<MovieResultDTO>> search(SearchCriteriaDTO criteria) async {
    // TODO: error handling and concurrency
    final imdbData = _imdbSearch.read(criteria);
    final omdbData = _omdbSearch.read(criteria);
    final tmdbData = _tmdbSearch.read(criteria);
    final googleData = _googleSearch.read(criteria);
    final Map<String, MovieResultDTO> allResults = {};
    final List<MovieResultDTO> sortedResults = [];
    addDto(allResults, sortedResults, imdbData);
    addDto(allResults, sortedResults, omdbData);
    addDto(allResults, sortedResults, tmdbData);
    addDto(allResults, sortedResults, googleData);

    Future.wait([imdbData, omdbData, tmdbData, googleData]);
    return sortedResults;
  }
}

void addDto(
  Map<String, MovieResultDTO> allResults,
  List<MovieResultDTO> uniqueResults,
  Future<List<MovieResultDTO>> newResults,
) async {
  (await newResults).forEach((newValue) {
    if (newValue.uniqueId == '-1' ||
        !allResults.containsKey(newValue.uniqueId)) {
      allResults[newValue.uniqueId] = newValue;
      uniqueResults = allResults.values.toList();
      // Sort by relevence with recent year first
      uniqueResults.sort((a, b) => b.compareTo(a));
    }
  });
}
