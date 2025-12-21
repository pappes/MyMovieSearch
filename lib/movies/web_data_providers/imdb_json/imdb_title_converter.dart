import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

class ImdbTitleConverter extends ImdbConverterBase
    with
        ReleatedPeopleForPredefinedCategory,
        ReleatedMoviesForPredefinedCategory {
  @override
  /// Get basic details for the movie or person from [data].
  dynamic getMovieOrPerson(MovieResultDTO dto, Map<dynamic, dynamic> data) {
    final deepContent = getDeepContent(data, deepTitleId2);
    if (deepContent != null) {
      // Used by QueryIMDBTitleDetails.
      return _deepConvertTitle(dto, deepContent);
    }
    throw Exception('$source Unable to interpret IMDB contents from map $data');
  }

  /// Parse [Map] to pull IMDB data out for a singl movie.
  dynamic _deepConvertTitle(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    final uniqueId = // ...{'titleId':<value>...} or ...{'tconst':<value>...}
        map.searchForString(key: deepTitleId1) ??
        map.searchForString(key: deepTitleId2)!;
    movie
      ..uniqueId = uniqueId
      ..merge(getMovieAttributes(map, movie.uniqueId));

    // Find child data containing related records.
    // ...{'mainColumnData':...}
    return map.deepSearch(deepRelatedHeader, multipleMatch: true
    );
  }
}
