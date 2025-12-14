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
    return dtoFromMap(map);
  }

  /// Take a [Map] of IMDB data and create a [MovieResultDTO] from it.
  Iterable<MovieResultDTO> dtoFromMap(Map<dynamic, dynamic> map);

  // find the contents of map[props][pageProps]
  Map<dynamic, dynamic> getDeepContent(Map<dynamic, dynamic> map) {
    final props = map[rootAttribute];
    if (null != props && props is Map) {
      final pageProps = props[rootAttributeChild];
      if (null != pageProps && pageProps is Map) {
        return pageProps;
      }
    }
    return {};
  }

  /// extract related movie details from [map].
  static MovieResultDTO getDeepTitleCommon(
    Map<dynamic, dynamic> map,
    String id,
  ) {
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


  /// get movie title in from a movie credits node.
  static MovieResultDTO? getMovieFromCreditV2(
    dynamic title,
    Map<dynamic, dynamic> parent,
  ) {
    if (title is Map) {
      final movieDto = getDeepTitle(title);
      getMovieCharacterName(movieDto, parent);
      return movieDto;
    }
    return null;
  }

  /// Find the roles a person has in a movie.
  static List<String> getRolesFromCreditsV2(dynamic creditedRoles) {
    const defaultLabel = 'Unknown';
    final categories = [defaultLabel];

    // ...{'category':...{id:<value>, text:<value>...}}
    final categoryHeader = TreeHelper(
      creditedRoles,
    ).deepSearch(deepRelatedCategoryHeader, multipleMatch: true);
    // Allow a person to have multiple roles in a movie.
    if (categoryHeader is List && categoryHeader.isNotEmpty) {
      final labels = categoryHeader.deepSearch('text', multipleMatch: true);
      if (labels is List && labels.isNotEmpty) {
        for (final label in labels) {
          if (label is String) {
            final categoryText = label.addColonIfNeeded();
            if (!categories.contains(categoryText)) {
              categories.add(categoryText);
            }
          }
        }
        if (categories.length > 1) {
          categories.remove(defaultLabel);
        }
      }
    }
    return categories;
  }

  /// extract collections of movies for a specific category for the title
  /// from a map or a list.
  static MovieCollection getDeepTitleRelatedMoviesForCategory(dynamic nodes) {
    final MovieCollection result = {};

    void addMovie(Map<dynamic, dynamic> node) {
      final movieDto = getDeepTitle(node);
      getMovieCharacterName(movieDto, node);
      result[movieDto.uniqueId] = movieDto;
    }

    forEachType<Map<dynamic, dynamic>>(nodes, addMovie);
    return result;
  }

  /// extract collections of people for a specific category for the title
  /// from a map or a list.
  static MovieCollection getDeepTitleRelatedPeopleForCategory(dynamic nodes) {
    final MovieCollection result = {};
    int creditsOrder = 100;

    void addToCollection(Map<dynamic, dynamic> node) {
      getDeepRelatedPersonCredits(result, node, creditsOrder);
      if (creditsOrder > 0) {
        creditsOrder--;
      }
    }

    forEachType(nodes, addToCollection);
    return result;
  }

  /// Maintain credits order when extracting people involved in a movie.
  static void getDeepRelatedPersonCredits(
    MovieCollection collection,
    Map<dynamic, dynamic> node, [
    int? creditsOrder,
  ]) {
    final movieDto = getDeepRelatedPerson(node);
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
  static MovieResultDTO getDeepRelatedPerson(Map<dynamic, dynamic> map) {
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

  /// extract related movie details from [map].
  static MovieResultDTO getDeepTitle(Map<dynamic, dynamic> map) {
    final id = // ...{'id':<value>...}
        map.searchForString(key: deepRelatedMovieId)!;
    final dto = getDeepTitleCommon(map, id);
    return dto;
  }
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
}
