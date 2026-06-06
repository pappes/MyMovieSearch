import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

class ImdbMoviesForKeywordConverter extends ImdbConverterBase
    with
        ReleatedPeopleForPredefinedCategory,
        ReleatedMoviesForPredefinedCategory {
  @override
  /// Break [data] up into one Map per movie.
  Iterable<Map<Object?, Object?>> getMovieDataList(Map<Object?, Object?> data) {
    final movies = <Map<Object?, Object?>>[];
    // Used by QueryIMDBMoviesForKeyword.
    final deepContent = getDeepContent(data, outerElementSearchResults);
    // ...{'titleListItems':...}
    for (final searchResults
        in deepContent?.deepSearch(deepTitleResults) ?? []) {
      forEachMap(searchResults, movies.add);
    }
    return movies;
  }

  @override
  /// Parse [Map] to pull IMDB data out for a single movie.
  Object? getMovieOrPerson(MovieResultDTO movie, Map<Object?, Object?> map) {
    final uniqueId = // ...{'titleId':<value>...} or ...{'tconst':<value>...}
        map.searchForString(key: deepTitleId1) ??
        map.searchForString(key: deepTitleId2)!;
    movie
      ..uniqueId = uniqueId
      ..merge(getMovieAttributes(map, movie.uniqueId));
    // ...{'mainColumnData':...}
    return map.deepSearch(deepRelatedHeader, multipleMatch: true);
  }
}
