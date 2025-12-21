import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

const titleRelatedMoviesLabel = 'Suggestions:';
const titleRelatedCastLabel = 'Cast:';
const titleRelatedDirectorsLabel = 'Directed by:';
const titleRelatedActressLabel = 'Actress:';
const titleRelatedActorLabel = 'Actor:';

const personRelatedActressLabel = 'Actress:';
const personRelatedActorLabel = 'Actor:';
const personRelatedDirectorLabel = 'Director:';
const personRelatedProducerLabel = 'Producer:';
const personRelatedWriterLabel = 'Writer:';

/// Used to convert search results, movie details and person details Map
/// to a dto list.
///
/// Using IMDB to search for a string returns a list.
/// Using IMDB search on an IMDBID redirects to the details page for that ID.
abstract class ImdbConverterBase extends ConverterHelper {
  late final DataSourceType source;
  Iterable<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
    DataSourceType source,
  ) {
    this.source = source;
    final List<MovieResultDTO> result = [];
    getMovieList(result, map);
    return result;
  }

  /// Get full content of movies and people with related information.
  void getMovieList(List<MovieResultDTO> result, Map<dynamic, dynamic> data) {
    final movies = getMovieDataList(data);
    for (final movie in movies) {
      final dto = MovieResultDTO().init();
      final childData = getMovieOrPerson(dto, movie);
      getRelatedMovies(dto.related, childData);
      getRelatedPeople(dto.related, childData);

      dto.setSource(newSource: source);
      result.add(dto);
    }
  }

  /// Break [data] up into one Map per movie.
  /// Default behaviour is to assume there is only one movie.
  Iterable<Map<dynamic, dynamic>> getMovieDataList(
    Map<dynamic, dynamic> data,
  ) => [data];

  /// Get basic details for the movie or person from [data].
  dynamic getMovieOrPerson(MovieResultDTO dto, Map<dynamic, dynamic> data) {}

  /// Get movies the person has worked on or recommended simliar movies.
  void getRelatedMovies(RelatedMovieCategories related, dynamic data) {}

  /// Get people involved in making the movie.
  void getRelatedPeople(RelatedMovieCategories related, dynamic data) {}

  /// Take a [Map] of IMDB data and create a [MovieResultDTO] from it.
  //Iterable<MovieResultDTO> dtoFromMap(Map<dynamic, dynamic> map);

  /// Common function to find the contents of map["props"]["pageProps"]
  /// returns null if child key is not present.
  Map<dynamic, dynamic>? getDeepContent(
    Map<dynamic, dynamic> map,
    String childKey,
  ) {
    final props = map[rootAttribute];
    if (null != props && props is Map) {
      final pageProps = props[rootAttributeChild];
      if (null != pageProps &&
          pageProps is Map &&
          pageProps.containsKey(childKey)) {
        return pageProps;
      }
    }
    return null;
  }

  /// extract basic movie details from [map].
  MovieResultDTO getMovieAttributes(Map<dynamic, dynamic> map, String id) {
    // ...{'titleText':...{...'text':<value>...}} or
    // ...{'titleText':<value>...}
    final title =
        map.deepSearch(deepRelatedMovieTitle)?.searchForString() ??
        map.searchForString(key: deepRelatedMovieTitle);
    // ...{'originalTitleText':...{...'text':<value>...}}or
    // ...{'originalTitleText':<value>...}
    String? originalTitle =
        map.deepSearch(deepRelatedMovieOriginalTitle)?.searchForString() ??
        map.searchForString(key: deepRelatedMovieOriginalTitle);
    if (title == originalTitle) {
      originalTitle =
          map.deepSearch(deepRelatedMovieAlternateTitle)?.searchForString();
    }

    // ...{'plotText':...{...'plainText':<value>...}} or
    // ...{'plot':<value>...}
    final description =
        map
            .deepSearch(deepRelatedMoviePlotHeader)
            ?.searchForString(key: deepRelatedMoviePlotField) ??
        map.searchForString(key: deepRelatedMoviePlot);
    // ...{'primaryImage':...{...'url':<value>...}}
    final url = map
        .deepSearch(deepImageHeader)
        ?.searchForString(key: deepImageField);
    // ...{...'aggregateRating':<value>...}
    final userRating = map.searchForString(key: deepRelatedMovieUserRating);
    // ...{...'voteCount':<value>...}
    final userRatingCount = map.searchForString(
      key: deepRelatedMovieUserRatingCount,
    );
    // ...{'runtime':...{...'seconds':<value>...}} or
    // ...{'runtime':<value>...}
    final duration =
        map
            .deepSearch(deepRelatedMovieDurationHeader)
            ?.searchForString(key: deepRelatedMovieDurationField) ??
        map
            .deepSearch(deepRelatedMovieDURATIONHeader)
            ?.searchForString(key: deepRelatedMovieDurationField) ??
        map.searchForString(key: deepRelatedMovieDurationHeader);

    final yearHeader = map.deepSearch(deepRelatedMovieYearHeader);
    // ...{'releaseYear':...{...'year':<value>...}} or
    // ...{'releaseYear':<value>...}
    final startDate =
        yearHeader?.searchForString(key: deepRelatedMovieYearStart) ??
        (yearHeader?.length == 1 && yearHeader!.first is int
            ? yearHeader.first.toString()
            : null);
    // ...{'releaseYear':...{...'endYear':<value>...}} or
    // ...{'endYear':<value>...}
    final endDate =
        yearHeader?.searchForString(key: deepRelatedMovieYearEnd) ??
        map.searchForString(key: deepRelatedMovieYearEnd);
    final yearRange =
        (null != endDate)
            ? '$startDate-$endDate'
            : (null != startDate)
            ? startDate
            : null;

    // ...{'certificate':...{...'rating':<value>...}} or
    // ...{'certificate':<value>...}
    final censorRatingText =
        map
            .deepSearch(deepRelatedMovieCensorRatingHeader)
            ?.searchForString(key: deepRelatedMovieCensorRatingField) ??
        map.searchForString(key: deepRelatedMovieCensorRatingHeader);
    final censorRating = getImdbCensorRating(censorRatingText);

    // ...{'genres':...[...{...'text':<value>...}...]} or
    // ...{'genres':[<value>,<value>,<value>,...]}
    final genreNode = map.deepSearch(deepRelatedMovieGenreHeader);
    String? genres;
    if (null != genreNode) {
      final genreList = genreNode.deepSearch(
        deepRelatedMovieGenreField,
        multipleMatch: true,
      );
      if (genreList is List && genreList.isNotEmpty) {
        genres = json.encode(genreList);
      } else if (genreNode.isNotEmpty) {
        final innerGenres = genreNode.first;
        if (innerGenres is List &&
            innerGenres.isNotEmpty &&
            innerGenres.first is String) {
          genres = json.encode(innerGenres);
        }
      }
    }

    // ...{'titleType':...{...'text':<value>...}}
    final movieTypeString =
        map.deepSearch(deepRelatedMovieType)?.searchForString();
    final movieType = MovieResultDTOHelpers.getMovieContentType(
      '$movieTypeString $genres $yearRange',
      IntHelper.fromText(duration),
      id,
    );

    // ...{'SpokenLanguages':...[...{...'text':<value>...}...]}
    final languageNode = map.deepSearch(deepRelatedMovieLanguageHeader);
    String? languages;
    if (null != languageNode) {
      final languageList = languageNode.deepSearch(
        deepRelatedMovieLanguageField,
        multipleMatch: true,
      );
      if (languageList is List && languageList.isNotEmpty) {
        languages = json.encode(languageList);
      }
    }

    // ...{'keywords':...[...{...'text':<value>...}...]} or
    // ...{'keywords':[<value>,<value>,<value>,...]}
    final keywordNode = map.deepSearch(deepRelatedMovieKeywordHeader);
    String? keywords;
    if (null != keywordNode) {
      final keywordList = keywordNode.deepSearch(
        deepRelatedMovieKeywordField,
        multipleMatch: true,
      );
      if (keywordList is List && keywordList.isNotEmpty) {
        keywords = json.encode(keywordList);
      } else if (keywordNode.isNotEmpty && keywordNode.first is String) {
        keywords = json.encode(keywordNode);
      }
    }
    return MovieResultDTO().init(
      uniqueId: id,
      bestSource: DataSourceType.imdbSuggestions,
      title: title,
      alternateTitle: originalTitle,
      description: description,
      type: movieType?.toString(),
      year: startDate,
      yearRange: yearRange,
      userRating: userRating,
      userRatingCount: userRatingCount,
      censorRating: censorRating?.toString(),
      runTime: duration,
      imageUrl: url,
      genres: genres?.toString(),
      keywords: keywords?.toString(),
      languages: languages?.toString(),
    );
  }

  /// extract collections of movies for a specific category for the title
  /// from a map or a list.
  MovieCollection getRelatedMoviesForCategory(dynamic nodes) {
    final MovieCollection result = {};

    void addMovie(Map<dynamic, dynamic> node) {
      final movieDto = getMovieDetails(node);
      getMovieCharacterName(movieDto, node);
      result[movieDto.uniqueId] = movieDto;
    }

    ConverterHelper().forEachMap(nodes, addMovie);
    return result;
  }

  /// extract related movie details from [map].
  MovieResultDTO getMovieDetails(Map<dynamic, dynamic> map) {
    final id = // ...{'id':<value>...}
        map.searchForString(key: deepRelatedMovieId)!;
    final dto = getMovieAttributes(map, id);
    return dto;
  }

  /// Maintain credits order when extracting people involved in a movie.
  static void getRelatedPersonWithCreditsOrder(
    MovieCollection collection,
    Map<dynamic, dynamic> node, [
    int? creditsOrder,
  ]) {
    final movieDto = getRelatedPersonDetails(node);
    getMovieCharacterName(movieDto, node);
    if (creditsOrder != null) {
      movieDto.creditsOrder = creditsOrder;
    }
    collection[movieDto.uniqueId] = movieDto;
  }

  /// Extract collections of movies for a specific category.
  static void getMovieCharacterName(
    MovieResultDTO dto,
    Map<dynamic, dynamic> map,
  ) {
    final characters = // ...{'characters':...} or
        map.deepSearch(deepRelatedMovieParentCharacterHeader)?.first;

    if (characters is List || characters is Map) {
      // ...{'characters':...{...'name':<value>...}}
      final names = TreeHelper(
        characters,
      ).deepSearch(deepRelatedMovieParentCharacterField, multipleMatch: true);
      if (names is List && names.isNotEmpty) {
        dto
          ..alternateTitle = ' ${dto.alternateTitle}'
          ..characterName = ' $names';
      }
    }
  }

  /// extract related movie details from [map].
  static MovieResultDTO getRelatedPersonDetails(Map<dynamic, dynamic> map) {
    final id = // ...{'id':<value>...}
        map.searchForString(key: deepRelatedPersonId)!;
    final title = // ...{'nameText':...{...'text':<value>...}}
        map.deepSearch(deepPersonNameHeader)?.searchForString();
    final url = // ...{'primaryImage':...{...'url':<value>...}}
        map.deepSearch(deepImageHeader)?.searchForString(key: deepImageField);

    final newDTO = MovieResultDTO().init(
      bestSource: DataSourceType.imdbSuggestions,
      uniqueId: id,
      title: title,
      imageUrl: url,
    );
    return newDTO;
  }

  /// Find the roles a person has in a movie.
  static List<String> getRolesFromCreditsV2(dynamic creditedRoles) {
    const defaultLabel = 'Unknown';
    final Set<String> categories = {defaultLabel};

    // ...{'category':...{id:<value>, text:<value>...}}
    final categoryHeader = TreeHelper(
      creditedRoles,
    ).deepSearch(deepRelatedCategoryHeader, multipleMatch: true);
    // Allow a person to have multiple roles in a movie.
    if (categoryHeader is List && categoryHeader.isNotEmpty) {
      final labels = categoryHeader.deepSearch('text', multipleMatch: true);
      labels?.forEach(
        (label) => categories.add(label.toString().addColonIfNeeded()),
      );
    }
    categories.remove(':');
    if (categories.length > 1) {
      categories.remove(defaultLabel);
    }
    return categories.toList();
  }

  /// get movie title in from a movie creditsV2 node.
  ///
  MovieResultDTO? getRelatedMovieCharacter(
    dynamic title,
    Map<dynamic, dynamic> parent,
  ) {
    if (title is Map) {
      final movieDto = getMovieDetails(title);
      ImdbConverterBase.getMovieCharacterName(movieDto, parent);
      return movieDto;
    }
    return null;
  }
}

// Sample ReleatedMoviesForPredefinedCategory Json from imdb_json
// { data->name->
//   'unreleasedCredits': [
//     {
//       'category': {'id': 'actor', 'text': 'Actor'},
//       'credits': {
//         'edges': [
//           { 'node':
//             {'category':...,'characters':...,'title':
//               {'id':...,'titleText':...}],
//         ]
//       }
//     },
//   ],
//   'releasedCredits': [
//     {
//       'category': {'id': 'actor', 'text': 'Actor'},
//       'credits': twoEdges,
//     },
//   ],
// }
//             OR
// Sample ReleatedMoviesForDynamicCategory Json from imdb_title
// { 'props'->pageProps->tconst->mainColumnData->edges->node->
//       'cast': {...},
//       'directors': {...},...
//       'moreLikeThisTitles': {
//         'edges': [
//           { 'node':
//             {'id':...,'titleText':...}],
//         ]
//       },...
// }
mixin ReleatedMoviesForPredefinedCategory on ImdbConverterBase {
  @override
  void getRelatedMovies(RelatedMovieCategories related, dynamic data) {
    // imdb_title uses ...{'moreLikeThisTitles':...}
    final relatedTree = TreeHelper(data)
        .deepSearch(deepTitleRelatedTitlesHeader)
        ?.deepSearch(deepRelatedMovieContainer, multipleMatch: true);
    final movies = getRelatedMoviesForCategory(relatedTree);
    ConverterHelper().combineMovies(related, titleRelatedMoviesLabel, movies);
  }
}

// TODO  related logic for cast and json
//       still need to be brought into the mixin classes
// Sample ReleatedMoviesForPredefinedCategory Json from imdb_cast ???? imdb_json_converter.dart
// { 'props'->pageProps->contentData-data->title
//   'creditCategories': [
//     {
//       'category': {'id': 'actor', 'text': 'Actor'},
//       'credits': {
//         'edges': [
//           { 'node':
//             {'category:...,'name':
//               {'id':...,'nameText':...}],
//         ]
//       }
//     },
//   ]
// }
//             OR
// Sample ReleatedMoviesForDynamicCategory Json from imdb_title (AND ImdbMoviesForKeywordConverter)
// { 'props'->pageProps->tconst->mainColumnData->edges->node->
//       'cast': {
//         'edges': [
//           { 'node':
//             {'charactors:...,'name':
//               {'id':...,'nameText':...}],
//         ]
//       },
//       'directors': {
//         'credits': [
//             {'name':
//               {'id':...,'nameText':...}],
//         ]
//       },...
//       'moreLikeThisTitles': {...},...
// }
//  , imdb_movies_for_keyword_converter.dart  ????
mixin ReleatedPeopleForPredefinedCategory on ImdbConverterBase {
  @override
  void getRelatedPeople(RelatedMovieCategories related, dynamic data) {
    final list = TreeHelper(data);

    // imdb_title uses ...{'cast':...}
    final castTree = list
        .deepSearch(deepTitleRelatedCastHeader)
        ?.deepSearch(deepTitleRelatedCastContainer, multipleMatch: true);
    final cast = ReleatedPeopleForPredefinedCategory.getPeopleForCategory(
      castTree,
    );
    ConverterHelper().combineMovies(related, titleRelatedCastLabel, cast);

    // imdb_title uses ...{'directors':...}
    final directorsTree = list
        .deepSearch(deepTitleRelatedDirectorHeader)
        ?.deepSearch(deepTitleRelatedDirectorContainer, multipleMatch: true);
    final directors = ReleatedPeopleForPredefinedCategory.getPeopleForCategory(
      directorsTree,
    );
    ConverterHelper().combineMovies(
      related,
      titleRelatedDirectorsLabel,
      directors,
    );

    if (data is List) {
      // ...{'category':...{id:<value>, text:<value>...}}
      final categoryHeader = data.deepSearch(
        deepRelatedCategoryHeader,
        multipleMatch: true,
      );
      // Allow a person to have multiple roles in a movie.
      if (categoryHeader is List && categoryHeader.isNotEmpty) {
      } else {
        getRelatedPeopleFromMainColumnData(related, data);
      }
    }
  }

  /// extract collections of people for a specific category for the title
  /// from a map or a list.
  ///
  /// used from ImdbTitleConverter
  static MovieCollection getPeopleForCategory(dynamic nodes) {
    final MovieCollection result = {};
    int creditsOrder = 100;

    void addToCollection(Map<dynamic, dynamic> node) {
      ImdbConverterBase.getRelatedPersonWithCreditsOrder(
        result,
        node,
        creditsOrder,
      );
      if (creditsOrder > 0) {
        creditsOrder--;
      }
    }

    ConverterHelper().forEachMap(nodes, addToCollection);
    return result;
  }

  /// extract actor credits information from [list].
  ///
  /// used from ImdbMoviesForKeywordConverter
  void getRelatedPeopleFromMainColumnData(
    RelatedMovieCategories related,
    List<dynamic>? list,
  ) {
    // ...{'cast':...}
    final castTree = list
        ?.deepSearch(deepTitleRelatedCastHeader)
        ?.deepSearch(deepTitleRelatedCastContainer, multipleMatch: true);
    final cast = ReleatedPeopleForPredefinedCategory.getPeopleForCategory(
      castTree,
    );
    ConverterHelper().combineMovies(related, titleRelatedCastLabel, cast);

    // ...{'directors':...}
    final directorsTree = list
        ?.deepSearch(deepTitleRelatedDirectorHeader)
        ?.deepSearch(deepTitleRelatedDirectorContainer, multipleMatch: true);
    final directors = ReleatedPeopleForPredefinedCategory.getPeopleForCategory(
      directorsTree,
    );
    ConverterHelper().combineMovies(
      related,
      titleRelatedDirectorsLabel,
      directors,
    );
  }
}

// Sample ReleatedMoviesForDynamicCategory Json from imdb_name
// { 'released'->edges->node->credits->edges->node->
//       'creditedRoles': {
//         'edges': [
//           { 'node':
//             {'category:...,'charactors:...,'title':
//               {'id':...,'titleText':...}],
//         ]
//       }
// }
mixin RelatedMoviesForDynamicCategory on ImdbConverterBase {
  /// Search within a movie credits node for movie information for the person.
  @override
  void getRelatedMovies(RelatedMovieCategories related, dynamic data) {
    if (data is List) {
      for (final credits in data) {
        if (credits is Map &&
            credits.containsKey(deepRelatedMovieHeader) &&
            (credits.containsKey(deepRelatedCategoryHeaderV2) ||
                credits.containsKey(deepRelatedMovieParentCharacterHeader))) {
          // We have a map with the movie info, the persons roles in the movie
          // and possibly character names.
          final movie = getRelatedMovieCharacter(
            credits[deepRelatedMovieHeader],
            credits,
          );
          if (movie != null) {
            // Combine the movie info with the roles.
            final MovieCollection indexedMovie = {movie.uniqueId: movie};
            // Search for role types from {...creditedRoles...}
            // or current top level credits node.
            final roles = ImdbConverterBase.getRolesFromCreditsV2(
              credits[deepRelatedCategoryHeaderV2] ?? credits,
            );
            for (final role in roles) {
              ConverterHelper().combineMovies(
                related,
                role.addColonIfNeeded(),
                indexedMovie,
              );
            }
          }
        }
      }
    }
  }
}

mixin ReleatedPeopleForDynamicCategory on ImdbConverterBase {
  /// Search within a movie credits node for movie information for the person.
  @override
  void getRelatedPeople(RelatedMovieCategories related, dynamic data) {}
}

class ConverterHelper {
  /// Add movies to a new category or an exisiting category
  void combineMovies(
    RelatedMovieCategories existing,
    String category,
    MovieCollection movies,
  ) {
    if (movies.isNotEmpty) {
      if (existing.containsKey(category)) {
        existing[category]!.addAll(movies);
      } else {
        existing[category] = movies;
      }
    }
  }

  /// Perform [action] on each Map contained in [input].
  ///
  /// A fallback option is available
  /// to still call [action] if the data passed in
  /// is not iterable. If fallback is true and [input] is not iterable,
  /// calls [action] directly on the entire [input].
  ///
  ///
  void forEachMap(
    dynamic collection,
    void Function(Map<dynamic, dynamic>) action, {
    bool fallback = false,
  }) {
    forEachType<Map<dynamic, dynamic>>(collection, action, fallback: fallback);
  }
}
