import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

class ImdbTitleConverter extends ImdbConverterBase {
  @override
  Iterable<MovieResultDTO> dtoFromMap(Map<dynamic, dynamic> map) {
    final movie = MovieResultDTO().init();
    final deepContent = getDeepContent(map);
    if (deepContent.containsKey(deepTitleId2)) {
      // Used by QueryIMDBNameDetails.
      _deepConvertTitle(movie, deepContent);
    } else {
      return [
        movie.error('Unable to interpret IMDB contents from map $map', source),
      ];
    }
    return [movie];
  }

  /// Parse [Map] to pull IMDB data out for a singl movie.
  void _deepConvertTitle(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    final uniqueId = // ...{'titleId':<value>...} or ...{'tconst':<value>...}
        map.searchForString(key: deepTitleId1) ??
        map.searchForString(key: deepTitleId2)!;
    movie
      ..uniqueId = uniqueId
      ..merge(ImdbConverterBase.getDeepTitleCommon(map, movie.uniqueId));
    // ...{'mainColumnData':...}
    final relatedMap = map.deepSearch(
      deepRelatedHeader, // mainColumnData
      multipleMatch: true,
    );
    if (null != relatedMap) {
      movie.related = _getDeepTitleRelated(relatedMap);
    }

    // Reintialise the source after setting the ID
    movie.setSource(newSource: source);
  }

  /// extract actor credits information from [list].
  RelatedMovieCategories _getDeepTitleRelated(List<dynamic>? list) {
    final RelatedMovieCategories result = {};

    // ...{'cast':...}
    final castTree = list
        ?.deepSearch(deepTitleRelatedCastHeader)
        ?.deepSearch(deepTitleRelatedCastContainer, multipleMatch: true);
    final cast = ImdbConverterBase.getDeepTitleRelatedPeopleForCategory(
      castTree,
    );
    ImdbConverterBase.combineMovies(result, titleRelatedCastLabel, cast);

    // ...{'directors':...}
    final directorsTree = list
        ?.deepSearch(deepTitleRelatedDirectorHeader)
        ?.deepSearch(deepTitleRelatedDirectorContainer, multipleMatch: true);
    final directors = ImdbConverterBase.getDeepTitleRelatedPeopleForCategory(
      directorsTree,
    );
    ImdbConverterBase.combineMovies(
      result,
      titleRelatedDirectorsLabel,
      directors,
    );

    // ...{'moreLikeThisTitles':...}
    final relatedTree = list
        ?.deepSearch(deepTitleRelatedTitlesHeader)
        ?.deepSearch(deepRelatedMovieContainer, multipleMatch: true);
    final related = ImdbConverterBase.getDeepTitleRelatedMoviesForCategory(
      relatedTree,
    );
    ImdbConverterBase.combineMovies(result, titleRelatedMoviesLabel, related);

    return result;
  }
}
