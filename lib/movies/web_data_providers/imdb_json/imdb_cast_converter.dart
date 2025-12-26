import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

class ImdbCastConverter extends ImdbConverterBase {
  @override
  /// Parse [Map] to pull IMDB data out for a single movie.
  dynamic getMovieOrPerson(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    final deepContent = getDeepContent(map, deepEntityHeader);
    if (deepContent != null) {
      // Used by QueryIMDBCastDetails.
      return _deepConvertMetadata(movie, deepContent);
    }
    throw Exception('$source Unable to interpret IMDB contents from map $map');
  }

  /// No related movies for a movie.
  @override
  void getRelatedMovies(RelatedMovieCategories related, dynamic data) {}

  /// TODO extract people conversion logic out of _deepConvertMetadata.
  @override
  void getRelatedPeople(RelatedMovieCategories related, dynamic data) {}

  // Parse [Map] to pull IMDB data out for a singl movie.
  void _deepConvertMetadata(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    final contentData = map[deepEntityHeader] as Map<dynamic, dynamic>;
    final metadata = // ...{'entityMetadata':...}
        contentData.deepSearch(deepEntityMetadata);
    final uniqueId = // ...{'entityMetadata':...{'id':<value>...}}
        metadata!.searchForString(key: deepEntityMetadataId)!;
    movie
      ..uniqueId = uniqueId
      ..merge(getMovieAttributes(contentData, movie.uniqueId))
      // Reintialise the source after setting the ID
      ..setSource(newSource: source);

    // ...{'creditCategories':...}
    final mainCredits = TreeHelper(
      contentData.deepSearch(deepEntityRelatedCastContainer)?.first,
    ).deepSearch(deepEntityCastInstance, multipleMatch: true);
    if (null != mainCredits && mainCredits.isNotEmpty) {
      _getDeepCreditsMain(movie.related, mainCredits);
    }

    // ...{'categories':...}
    final otherCredits = contentData[deepEntityExtraCastContainer];
    if (null != otherCredits &&
        otherCredits is List &&
        otherCredits.isNotEmpty) {
      _getDeepCreditsExtra(movie.related, otherCredits);
    }
  }

  /// extract actor, actress, director, writer, etc
  /// credits information from cast json from [relatedList]
  /// contentData -> data -> creditCategories.
  void _getDeepCreditsMain(
    RelatedMovieCategories cast,
    List<dynamic> relatedList,
  ) {
    for (final person in relatedList) {
      if (person is Map) {
        // ...{'category':...{'id':<value>...}}
        final categoryName = _getDeepCategoryName(
          person.deepSearch(deepRelatedCategoryHeader)!.searchForString() ??
              person
                  .deepSearch(deepRelatedCategoryHeader)!
                  .searchForString(key: deepEntityCastCategoryNameBackup),
        );
        final credit = _getDeepNodeRelatedPerson(person);

        ConverterHelper().combineMovies(
          cast,
          categoryName.addColonIfNeeded(),
          credit,
        );
      }
    }
  }

  /// extract Cast, Director, Writer, etc
  /// credits information from cast json from [relatedList].
  /// contentData -> categories.
  void _getDeepCreditsExtra(
    RelatedMovieCategories cast,
    List<dynamic> relatedList,
  ) {
    for (final category in relatedList) {
      if (category is Map) {
        final categoryName = _getDeepCategoryName(
          category[deepEntityExtraCastCategoryName],
        );
        final section = category[deepEntityExtraCastSection];
        if (null != section && section is Map) {
          final people = section[deepEntityExtraCastSectionItems];
          if (null != people && people is List) {
            for (final person in people) {
              if (person is Map) {
                final credit = _getDeepCreditsExtraPerson(person);
                ConverterHelper().combineMovies(
                  cast,
                  categoryName.addColonIfNeeded(),
                  credit,
                );
              }
            }
          }
        }
      }
    }
  }

  /// Get the category name based on the key.
  String _getDeepCategoryName(dynamic key) {
    if (key != null && key is String && key.isNotEmpty) {
      switch (key.toUpperCase()) {
        case deepEntityExtraCastNameActors:
          return titleRelatedActorLabel;
        case deepEntityExtraCastNameActresses:
          return titleRelatedActressLabel;
        case deepEntityExtraCastNameDirectors:
          return titleRelatedDirectorsLabel;
        case deepEntityExtraCastNameCast:
          return titleRelatedCastLabel;
      }
      return '$key:';
    }

    return 'Unknown';
  }

  /// Extract movie extra data to a DTO
  MovieCollection _getDeepCreditsExtraPerson(Map<dynamic, dynamic> person) {
    final MovieCollection collection = {};

    final imageProps = TreeHelper(person[deepEntityExtraCastImageProps]);

    final movieDto = MovieResultDTO().init(
      bestSource: DataSourceType.imdbSuggestions,
      // get id, rowTitle and image url
      uniqueId: person.searchForString(key: deepEntityExtraCastId),
      title: person.searchForString(key: deepEntityExtraCastPersonName),
      imageUrl: imageProps.searchForString(key: deepImageField),
    );
    collection[movieDto.uniqueId] = movieDto;

    return collection;
  }

  /// extract collections of people for a specific category for the title
  /// from a map or a list.
  MovieCollection _getDeepNodeRelatedPerson(dynamic node) {
    final MovieCollection result = {};
    if (node is Map) {
      // ...{'data':...{'node':...{'name':...}}}
      final personMap = node.deepSearch(deepEntityPersonName)?.first;
      if (null != personMap && personMap is Map<dynamic, dynamic>) {
        ImdbConverterBase.getRelatedPersonWithCreditsOrder(result, personMap);
      }
    }
    return result;
  }
}
