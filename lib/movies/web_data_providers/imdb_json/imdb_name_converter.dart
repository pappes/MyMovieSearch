
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

class ImdbNameConverter extends ImdbConverterBase {
  @override
  Iterable<MovieResultDTO> dtoFromMap(Map<dynamic, dynamic> map) {
    final movie = MovieResultDTO().init();
    final deepContent = getDeepContent(map);
    if (deepContent.containsKey(deepPersonId)) {
      // Used by QueryIMDBNameDetails.
      _deepConvertPerson(movie, deepContent);
    } else {
      return [
        movie.error('Unable to interpret IMDB contents from map $map', source),
      ];
    }
    return [movie];
  }

  /// Parse [Map] to pull IMDB data out for a single person.
  void _deepConvertPerson(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    movie.uniqueId = map.searchForString(key: deepPersonId)!;
    // ...{'nameText':...{...'text':<value>...}};
    final name = map.deepSearch(deepPersonNameHeader)?.searchForString();

    // ...{'primaryImage':...{...'url':<value>...}};
    final url =
        map.deepSearch(deepImageHeader)?.searchForString(key: deepImageField);
    // ...{'bio':...{...'plainText':<value>...}};
    final description = map
        .deepSearch(deepPersonDescriptionHeader)
        ?.searchForString(key: deepPersonDescriptionField);
    // ...{'birthDate':...{...'year':<value>...}}
    final startDate = map
        .deepSearch(deepPersonStartDateHeader)
        ?.searchForString(key: deepPersonStartDateField);
    // ...{'deathDate':...{...'year':<value>...}}
    final endDate = map
        .deepSearch(deepPersonEndDateHeader)
        ?.searchForString(key: deepPersonEndDateField);
    final yearRange = (null != endDate)
        ? '$startDate-$endDate'
        : (null != startDate)
            ? startDate
            : null;
    // ...{'meterRanking':...{...'currentRank':<value>...}}
    final popularity = map
        .deepSearch(deepPersonPopularityHeader)
        ?.searchForString(key: deepPersonPopularityField);

    // ...{'edges':...{...'node':...{...'credits':...{...'node':<value>...}}
    final List<dynamic> creditsV2 =
        map
            .deepSearch(
              deepRelatedMovieCollection, // edges
              multipleMatch: true,
            )
            ?.deepSearch(
                deepRelatedMovieContainer, multipleMatch: true) // node
            ?.deepSearch(deepPersonRelatedleaf, multipleMatch: true) // credits
            ?.deepSearch(
              deepRelatedMovieContainer, // node
              multipleMatch: true,
              stopAtTopLevel: false,
            ) ??
        [];

    final related = _getPersonRelatedMovies(creditsV2);

    movie
      ..merge(
        MovieResultDTO().init(
          uniqueId: movie.uniqueId,
          bestSource: DataSourceType.imdbSuggestions,
          title: name,
          description: description,
          year: startDate,
          yearRange: yearRange,
          userRatingCount: popularity,
          imageUrl: url,
          related: related,
        ),
      )
      // Reintialise the source after setting the ID
      ..setSource(newSource: source);
  }

  /// Search within a movie credits node for movie information for the person.
  static RelatedMovieCategories _getPersonRelatedMovies(List<dynamic> nodes) {
    final RelatedMovieCategories result = {};
    for (final related in nodes) {
      if (related is Map &&
          related.containsKey(deepRelatedMovieHeader) &&
          (related.containsKey(deepRelatedCategoryHeaderV2) ||
              related.containsKey(deepRelatedMovieParentCharacterHeader))) {
        // We have a map with the movie info, the persons roles in the movie
        // and possibly character names.
        final movie = ImdbConverterBase.getMovieFromCreditV2(
          related[deepRelatedMovieHeader],
          related,
        );
        if (movie != null) {
          // Combine the movie info with the roles.
          final MovieCollection indexedMovie = {movie.uniqueId: movie};
          final roles = ImdbConverterBase.getRolesFromCreditsV2(
            related[deepRelatedCategoryHeaderV2],
          );
          for (final role in roles) {
            ImdbConverterBase.combineMovies(
                result, role.addColonIfNeeded(), indexedMovie);
          }
        }
      }
    }
    return result;
  }
}
