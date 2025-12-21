import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

class ImdbNameConverter extends ImdbConverterBase
    with RelatedMoviesForDynamicCategory, ReleatedPeopleForDynamicCategory {
  @override
  /// Get basic details for the movie or person from [data].
  dynamic getMovieOrPerson(MovieResultDTO dto, Map<dynamic, dynamic> data) {
    final deepContent = getDeepContent(data, deepPersonId);
    if (deepContent != null) {
      // Used by QueryIMDBNameDetails.
      return _deepConvertPerson(dto, deepContent);
    }
    throw Exception('$source Unable to interpret IMDB contents from map $data');
  }

  /// Parse [Map] to pull IMDB data out for a single person.
  dynamic _deepConvertPerson(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    movie.uniqueId = map.searchForString(key: deepPersonId)!;
    // ...{'nameText':...{...'text':<value>...}};
    final name = map.deepSearch(deepPersonNameHeader)?.searchForString();

    // ...{'primaryImage':...{...'url':<value>...}};
    final url = map
        .deepSearch(deepImageHeader)
        ?.searchForString(key: deepImageField);
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
    final yearRange =
        (null != endDate)
            ? '$startDate-$endDate'
            : (null != startDate)
            ? startDate
            : null;
    // ...{'meterRanking':...{...'currentRank':<value>...}}
    final popularity = map
        .deepSearch(deepPersonPopularityHeader)
        ?.searchForString(key: deepPersonPopularityField);
    movie
      ..bestSource = DataSourceType.imdbSuggestions
      ..title = name ?? movie.title
      ..description = description ?? movie.description
      ..imageUrl = url ?? movie.imageUrl
      ..year = IntHelper.fromText(startDate) ?? movie.year
      ..yearRange = yearRange ?? movie.yearRange
      ..userRatingCount =
          IntHelper.fromText(popularity) ?? movie.userRatingCount;

    // Find child nodes to be converted to related movies.
    // ...{'edges':...{...'node':...{...'credits':...{...'node':<value>...}}
    return map
        .deepSearch(
          deepRelatedMovieCollection, // edges
          multipleMatch: true,
        )
        ?.deepSearch(deepRelatedMovieContainer, multipleMatch: true) // node
        ?.deepSearch(deepPersonRelatedleaf, multipleMatch: true) // credits
        ?.deepSearch(
          deepRelatedMovieContainer, // node
          multipleMatch: true,
          stopAtTopLevel: false,
        );
  }
}
