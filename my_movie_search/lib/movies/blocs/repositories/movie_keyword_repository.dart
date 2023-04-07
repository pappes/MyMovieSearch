import 'package:my_movie_search/movies/blocs/repositories/movie_list_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_keywords.dart';

typedef SearchFunction = Future<List<MovieResultDTO>> Function(
  MovieResultDTO criteria,
);

class SearchFunctions {
  List<SearchFunction> fastSearch = [];
  List<SearchFunction> supplementarySearch = [];
  List<SearchFunction> slowSearch = [];
}

/// Search for movie data from multiple online search sources.
///
/// BlockRepository to consolidate data retrieval from multiple search
/// and detail providers using the WebFetch framework.
///
/// [Search] provides a stream of incomplete and complete results.
/// [Close] can be used to cancel a search.
class MovieKeywordRepository extends MovieListRepository {
  late QueryIMDBKeywords _imdbKeywords;

  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {
    _imdbKeywords = QueryIMDBKeywords(criteria);
    for (final provider in [_imdbKeywords]) {
      initProvider();
      provider
          .readList(limit: 10)
          .then((values) => addResults(searchUID, values))
          .whenComplete(finishProvider);
    }
  }
}
