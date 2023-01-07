// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

const _relatedMoviesLabel = 'Suggestions:';
const relatedActorsLabel = 'Cast:';
const relatedDirectorsLabel = 'Directed by:';

/// Used to convert search results, movie details and person details Map
/// to a dto list.
///
/// Using IMDB to search for a string returns a list.
/// Using IMDB search on an IMDBID redirects to the details page for that ID.
class ImdbWebScraperConverter {
  final DataSourceType source;
  ImdbWebScraperConverter(this.source);
  List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    final dto = dtoFromMap(map);
    return [dto];
  }

  /// Take a [Map] of IMDB data and create a [MovieResultDTO] from it.
  MovieResultDTO dtoFromMap(Map map) {
    var movie = MovieResultDTO().init();
    if (map.containsKey(outerElementIdentity)) {
      _shallowConvert(movie, map);
    } else if (null != map.deepSearch(deepPersonId)) {
      _deepConvertPerson(movie, map);
    } else if (null != map.deepSearch(deepTitleId)) {
      _deepConvertTitle(movie, map);
    } else {
      movie = movie.error('Unable to interpret IMDB contents from map $map');
    }
    movie.source = source;
    return movie;
  }

  /// Parse [Map] to pull IMDB data out.
  void _deepConvertPerson(MovieResultDTO movie, Map map) {
    movie.uniqueId = map.deepSearch(deepPersonId)!.first!.toString();
    final name = // ...{'nameText':...{...'text':<value>...}};
        map.deepSearch(deepPersonNameHeader)?.searchForString();

    final url = // ...{'primaryImage':...{...'url':<value>...}};
        map.deepSearch(deepImageHeader)?.searchForString(
              key: deepImageField,
            );
    final description = // ...{'bio':...{...'plainText':<value>...}};
        map.deepSearch(deepPersonDescriptionHeader)?.searchForString(
              key: deepPersonDescriptionField,
            );
    final startDate = // ...{'birthDate':...{...'year':<value>...}}
        map.deepSearch(deepPersonStartDateHeader)?.searchForString(
              key: deepPersonStartDateField,
            );
    final endDate = // ...{'deathDate':...{...'year':<value>...}}
        map.deepSearch(deepPersonEndDateHeader)?.searchForString(
              key: deepPersonEndDateField,
            );
    final yearRange = (null != endDate)
        ? '$startDate-$endDate'
        : (null != startDate)
            ? startDate
            : null;
    final popularity = // ...{'meterRanking':...{...'currentRank':<value>...}}
        map.deepSearch(deepPersonPopularityHeader)?.searchForString(
              key: deepPersonPopularityField,
            );
    final related = _getDeepPersonRelatedCategories(
      map.deepSearch(
        deepPersonRelatedSuffix, //'*Credits' e.g. releasedPrimaryCredits
        suffixMatch: true,
        multipleMatch: true,
      ),
    );

    movie.merge(
      MovieResultDTO().init(
        source: DataSourceType.imdbSuggestions,
        title: name,
        description: description,
        type: getImdbMovieContentType('', null, movie.uniqueId).toString(),
        year: startDate,
        yearRange: yearRange,
        userRatingCount: popularity,
        imageUrl: url,
        related: related,
      ),
    );
  }

  /// Parse [Map] to pull IMDB data out.
  void _deepConvertTitle(MovieResultDTO movie, Map map) {
    movie.uniqueId = map.deepSearch(deepTitleId)!.first!.toString();
    movie.merge(_getDeepTitleCommon(map, movie.uniqueId));
    final relatedMap = map.deepSearch(
      deepRelatedHeader, // mainColumnData
      multipleMatch: true,
    );
    if (null != relatedMap) {
      movie.related = _getDeepTitleRelated(relatedMap);
    }
  }

  /// extract related movie details from [map].
  MovieResultDTO _getDeepTitleCommon(Map map, String id) {
    final title = // ...{'titleText':...{...'text':<value>...}}
        map.deepSearch(deepRelatedMovieTitle)?.searchForString();
    String?
        originalTitle = // ...{'originalTitleText':...{...'text':<value>...}}
        map.deepSearch(deepRelatedMovieAlternateTitle)?.searchForString();
    if (title == originalTitle) {
      originalTitle = null;
    }

    final description = // ...{'plotText':...{...'plainText':<value>...}}
        map.deepSearch(deepRelatedMoviePlotHeader)?.searchForString(
              key: deepRelatedMoviePlotField,
            );
    final url = // ...{'primaryImage':...{...'url':<value>...}}
        map.deepSearch(deepImageHeader)?.searchForString(
              key: deepImageField,
            );
    final userRating = // ...{...'aggregateRating':<value>...}
        map.searchForString(key: deepRelatedMovieUserRating);
    final userRatingCount = // ...{...'voteCount':<value>...}
        map.searchForString(key: deepRelatedMovieUserRatingCount);
    final duration = // ...{'runtime':...{...'seconds':<value>...}}
        map.deepSearch(deepRelatedMovieDurationHeader)?.searchForString(
              key: deepRelatedMovieDurationField,
            );

    final yearHeader = map.deepSearch(deepRelatedMovieYearHeader);
    final startDate = // ...{'releaseYear':...{...'year':<value>...}}
        yearHeader?.searchForString(key: deepRelatedMovieYearStart);
    final endDate = // ...{'releaseYear':...{...'endYear':<value>...}}
        yearHeader?.searchForString(key: deepRelatedMovieYearEnd);
    final yearRange = (null != endDate)
        ? '$startDate-$endDate'
        : (null != startDate)
            ? startDate
            : null;

    final censorRatingText = // ...{'certificate':...{...'rating':<value>...}}
        map
            .deepSearch(deepRelatedMovieCensorRatingHeader)
            ?.searchForString(key: deepRelatedMovieCensorRatingField);
    final censorRating = getImdbCensorRating(censorRatingText);

    final movieTypeString = // ...{'titleType':...{...'text':<value>...}}
        map.deepSearch(deepRelatedMovieType)?.searchForString();
    final movieType = getImdbMovieContentType(movieTypeString, null, id);

    final genreNode = // ...{'genres':...[...{...'text':<value>...}...]}
        map.deepSearch(deepRelatedMovieGenreHeader);
    String? genres;
    if (null != genreNode) {
      final genreList = genreNode.deepSearch(
        deepRelatedMovieGenreField,
        multipleMatch: true,
      );
      if (genreList is List && genreList.isNotEmpty) {
        genres = json.encode(genreList);
      }
    }

    final languageNode = // ...{'SpokenLanguages':...[...{...'text':<value>...}...]}
        map.deepSearch(deepRelatedMovieLanguageHeader);
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

    final keywordNode = // ...{'keywords':...[...{...'text':<value>...}...]}
        map.deepSearch(deepRelatedMovieKeywordHeader);
    String? keywords;
    if (null != keywordNode) {
      final keywordList = keywordNode.deepSearch(
        deepRelatedMovieKeywordField,
        multipleMatch: true,
      );
      if (keywordList is List && keywordList.isNotEmpty) {
        keywords = json.encode(keywordList);
      }
    }
    return MovieResultDTO().init(
      uniqueId: id,
      source: DataSourceType.imdbSuggestions,
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

  /// extract actor credits information from [list].
  RelatedMovieCategories _getDeepTitleRelated(List? list) {
    final RelatedMovieCategories result = {};

    final castTree = list
        ?.deepSearch(deepTitleRelatedCastHeader)
        ?.deepSearch(deepTitleRelatedCastContainer, multipleMatch: true);
    final cast = _getDeepTitleRelatedPeopleForCategory(castTree);
    combineMovies(result, relatedActorsLabel, cast);

    final directorsTree = list
        ?.deepSearch(deepTitleRelatedDirectorHeader)
        ?.deepSearch(deepTitleRelatedDirectorContainer, multipleMatch: true);
    final directors = _getDeepTitleRelatedPeopleForCategory(directorsTree);
    combineMovies(result, relatedDirectorsLabel, directors);

    final relatedTree = list
        ?.deepSearch(deepTitleRelatedTitlesHeader)
        ?.deepSearch(deepRelatedMovieContainer, multipleMatch: true);
    final related = _getDeepTitleRelatedMoviesForCategory(relatedTree);
    combineMovies(result, _relatedMoviesLabel, related);

    return result;
  }

  /// extract actor credits information from [list].
  RelatedMovieCategories _getDeepPersonRelatedCategories(
    dynamic list,
  ) {
    final RelatedMovieCategories result = {};
    if (list is List) {
      for (final related in list) {
        if (related is List) {
          for (final item in related) {
            if (item is Map) {
              //Pull description out of top level and movie details out of lower level
              final categoryHeader = item.deepSearch(deepRelatedCategoryHeader);
              final categoryText =
                  categoryHeader?.searchForString() ?? 'Unknown';

              final movies = _getDeepPersonRelatedMoviesForCategory(item);
              combineMovies(result, categoryText, movies);
            }
          }
        }
      }
    }
    return result;
  }

  /// Add movies to a new category or an exisiting category
  void combineMovies(
    RelatedMovieCategories existing,
    String category,
    RelatedMovies movies,
  ) {
    if (movies.isNotEmpty) {
      if (existing.containsKey(category)) {
        existing[category]!.addAll(movies);
      } else {
        existing[category] = movies;
      }
    }
  }

  /// extract collections of movies for a specific category from a map or a list.
  RelatedMovies _getDeepPersonRelatedMoviesForCategory(dynamic category) {
    final RelatedMovies result = {};
    final nodes = TreeHelper(category).deepSearch(
      deepRelatedMovieContainer,
      multipleMatch: true,
    );
    if (nodes is List) {
      for (final node in nodes) {
        if (node is Map) {
          final title = node.deepSearch(deepRelatedMovieHeader)?.first;
          if (title is Map) {
            final movieDto = _getDeepTitle(title);
            _getMovieCharactorName(movieDto, node);
            result[movieDto.uniqueId] = movieDto;
          }
        }
      }
    }
    return result;
  }

  /// extract collections of movies for a specific category from a map or a list.
  RelatedMovies _getDeepTitleRelatedMoviesForCategory(dynamic nodes) {
    final RelatedMovies result = {};
    if (nodes is List) {
      for (final node in nodes) {
        if (node is Map) {
          final movieDto = _getDeepTitle(node);
          _getMovieCharactorName(movieDto, node);
          result[movieDto.uniqueId] = movieDto;
        }
      }
    }
    return result;
  }

  /// extract collections of movies for a specific category from a map or a list.
  RelatedMovies _getDeepTitleRelatedPeopleForCategory(dynamic nodes) {
    final RelatedMovies result = {};
    if (nodes is List) {
      for (final node in nodes) {
        if (node is Map) {
          final movieDto = _getDeepTitleRelatedPerson(node);
          _getMovieCharactorName(movieDto, node);
          result[movieDto.uniqueId] = movieDto;
        }
      }
    }
    return result;
  }

  /// extract collections of movies for a specific category.
  static void _getMovieCharactorName(MovieResultDTO dto, Map map) {
    final charactors = map
        .deepSearch(
          deepRelatedMovieParentCharactorHeader,
        )
        ?.first;
    if (charactors is List) {
      final names = charactors.deepSearch(
        deepRelatedMovieParentCharactorField,
        multipleMatch: true,
      );
      if (names is List && names.isNotEmpty) {
        dto.alternateTitle = ' ${dto.alternateTitle}';
        dto.charactorName = ' ${names.toString()}';
      }
    }
  }

  /// extract related movie details from [map].
  MovieResultDTO _getDeepTitleRelatedPerson(Map map) {
    final id = map.deepSearch(deepRelatedPersonId)!.first!.toString();
    final title = // ...{'nameText':...{...'text':<value>...}}
        map.deepSearch(deepPersonNameHeader)?.searchForString();
    final url = // ...{'primaryImage':...{...'url':<value>...}}
        map.deepSearch(deepImageHeader)?.searchForString(
              key: deepImageField,
            );

    final newDTO = MovieResultDTO().init(
      source: DataSourceType.imdbSuggestions,
      uniqueId: id,
      title: title,
      imageUrl: url,
    );
    return newDTO;
  }

  /// extract related movie details from [map].
  MovieResultDTO _getDeepTitle(Map map) {
    final id = map.deepSearch(deepRelatedMovieId)!.first!.toString();
    final dto = _getDeepTitleCommon(map, id);
    return dto;
  }

  void _shallowConvert(MovieResultDTO movie, Map map) {
    movie.uniqueId = map[outerElementIdentity]!.toString();

    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;
    movie.alternateTitle =
        map[outerElementAlternateTitle]?.toString() ?? movie.alternateTitle;
    if (movie.title == movie.alternateTitle) {
      movie.alternateTitle = '';
    }
    movie.description =
        map[outerElementDescription]?.toString() ?? movie.description;
    movie.imageUrl = map[outerElementImage]?.toString() ?? movie.imageUrl;
    movie.year = getYear(map[outerElementYear]?.toString()) ?? movie.year;
    movie.yearRange = map[outerElementYearRange]?.toString() ?? movie.yearRange;
    movie.year = movie.maxYear();

    movie.censorRating = getImdbCensorRating(
          map[outerElementCensorRating]?.toString(),
        ) ??
        movie.censorRating;
    movie.userRating = DoubleHelper.fromText(
      (map[outerElementRating] as Map?)?[innerElementRatingValue],
      nullValueSubstitute: movie.userRating,
    )!;
    movie.userRatingCount = IntHelper.fromText(
      (map[outerElementRating] as Map?)?[innerElementRatingCount],
      nullValueSubstitute: movie.userRatingCount,
    )!;

    final source = map[dataSource];
    if (source is DataSourceType) {
      movie.source = source;
    }
    final language = map[outerElementLanguage];
    if (language is LanguageType) {
      movie.language = language;
    }
    final movieType = map[outerElementType];
    if (movieType is MovieContentType) {
      movie.type = movieType;
    }

    try {
      movie.runTime = Duration.zero.fromIso8601(map[outerElementDuration]);
    } catch (_) {}

    movie.genres.combineUnique(map[outerElementGenre]);
    movie.keywords.combineUnique(map[outerElementKeywords]);
    movie.languages.combineUnique(map[outerElementLanguages]);
    movie.getLanguageType();

    for (final person in getPeopleFromJson(map[outerElementDirector])) {
      movie.addRelated(relatedDirectorsLabel, person);
    }
    for (final person in getPeopleFromJson(map[outerElementActors])) {
      movie.addRelated(relatedActorsLabel, person);
    }
    //_getRelated(movie, map[outerElementActors], relatedActorsLabel);
    _getRelated(movie, map[outerElementRelated], _relatedMoviesLabel);

    final related = map[outerElementRelated];
    _getRelatedSections(related, movie);
  }

  void _getRelated(MovieResultDTO movie, related, String label) {
    // Do nothing if related is null
    if (related is Map) {
      final dto = dtoFromMap(related);
      movie.addRelated(label, dto);
    } else if (related is Iterable) {
      for (final relatedMap in related) {
        if (relatedMap is Map) {
          final dto = dtoFromMap(relatedMap);
          movie.addRelated(label, dto);
        }
      }
    }
  }

  static List<MovieResultDTO> getPeopleFromJson(dynamic people) {
    final result = <MovieResultDTO>[];
    if (null != people) {
      Iterable peopleList;
      // Massage the data to ensure the results are a list of people
      // (or a single person in a list)
      if (people is Iterable) {
        peopleList = people;
      } else if (people is Map) {
        peopleList = [people];
      } else {
        return result;
      }
      for (final relatedMap in peopleList) {
        if (relatedMap is Map) {
          final dto = _dtoFromPersonMap(relatedMap);
          if (null != dto) {
            result.add(dto);
          }
        }
      }
    }
    return result;
  }

  static MovieResultDTO? _dtoFromPersonMap(Map map) {
    final id = getIdFromIMDBLink(map[outerElementLink]?.toString());
    if (map[outerElementType] != 'Person' || id == '') {
      return null;
    }
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdbSuggestions;
    movie.uniqueId = id;
    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;

    return movie;
  }

  static void _getRelatedSections(related, MovieResultDTO movie) {
    // Do nothing if related is null
    if (related is Map) {
      _getMovieCategories(related, movie);
    } else if (related is Iterable) {
      for (final categories in related) {
        if (categories is Map) {
          _getMovieCategories(categories, movie);
        }
      }
    }
  }

  static void _getMovieCategories(Map related, MovieResultDTO movie) {
    for (final category in related.entries) {
      _getMovies(
        movie,
        category.value,
        category.key.toString(),
      );
    }
  }

  static void _getMovies(MovieResultDTO movie, movies, String label) {
    if (movies is Map) {
      _getMovie(movies, movie, label);
    } else if (movies is Iterable) {
      for (final relatedMap in movies) {
        if (relatedMap is Map) {
          _getMovie(relatedMap, movie, label);
        }
      }
    }
  }

  static void _getMovie(Map movies, MovieResultDTO movie, String label) {
    final dto = _dtoFromRelatedMap(movies);
    if (null != dto) {
      movie.addRelated(label, dto);
    } else {}
  }

  static MovieResultDTO? _dtoFromRelatedMap(Map map) {
    final id = getIdFromIMDBLink(map[outerElementLink]?.toString());
    if (id == '') {
      return null;
    }
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdbSuggestions;
    movie.uniqueId = id;
    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;

    return movie;
  }
}
