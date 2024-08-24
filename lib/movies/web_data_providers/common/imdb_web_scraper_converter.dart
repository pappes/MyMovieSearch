// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

const titleRelatedMoviesLabel = 'Suggestions:';
const titleRelatedActorsLabel = 'Cast:';
const titleRelatedDirectorsLabel = 'Directed by:';

const personRelatedActressLabel = 'Actress';
const personRelatedActorLabel = 'Actor';
const personRelatedDirectorLabel = 'Director';
const personRelatedProducerLabel = 'Producer';
const personRelatedWriterLabel = 'Writer';

/// Used to convert search results, movie details and person details Map
/// to a dto list.
///
/// Using IMDB to search for a string returns a list.
/// Using IMDB search on an IMDBID redirects to the details page for that ID.
class ImdbWebScraperConverter {
  late final DataSourceType source;
  Iterable<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
    DataSourceType source,
  ) {
    this.source = source;
    return dtoFromMap(map, '');
  }

  /// Take a [Map] of IMDB data and create a [MovieResultDTO] from it.
  Iterable<MovieResultDTO> dtoFromMap(Map<dynamic, dynamic> map, String a) {
    final movie = MovieResultDTO().init();
    if (null != map.deepSearch(outerElementSearchResults)) {
      return _deepConvertSearchResults(map);
    } else if (map.containsKey(outerElementIdentity)) {
      _shallowConvert(movie, map);
    } else if (null != map.deepSearch(deepPersonId)) {
      _deepConvertPerson(movie, map);
    } else if (null != map.deepSearch(deepTitleId2)) {
      _deepConvertTitle(movie, map);
    } else {
      return [
        movie.error(
          'Unable to interpret IMDB contents from map $map',
          source,
        ),
      ];
    }
    return [movie];
  }

  /// Parse [Map] to pull IMDB data out for a single person.
  void _deepConvertPerson(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    movie.uniqueId = map.deepSearch(deepPersonId)!.first!.toString();
    // ...{'nameText':...{...'text':<value>...}};
    final name = map.deepSearch(deepPersonNameHeader)?.searchForString();

    // ...{'primaryImage':...{...'url':<value>...}};
    final url = map.deepSearch(deepImageHeader)?.searchForString(
          key: deepImageField,
        );
    // ...{'bio':...{...'plainText':<value>...}};
    final description =
        map.deepSearch(deepPersonDescriptionHeader)?.searchForString(
              key: deepPersonDescriptionField,
            );
    // ...{'birthDate':...{...'year':<value>...}}
    final startDate =
        map.deepSearch(deepPersonStartDateHeader)?.searchForString(
              key: deepPersonStartDateField,
            );
    // ...{'deathDate':...{...'year':<value>...}}
    final endDate = map.deepSearch(deepPersonEndDateHeader)?.searchForString(
          key: deepPersonEndDateField,
        );
    final yearRange = (null != endDate)
        ? '$startDate-$endDate'
        : (null != startDate)
            ? startDate
            : null;
    // ...{'meterRanking':...{...'currentRank':<value>...}}
    final popularity =
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

  /// Parse [Map] to pull IMDB data out for a singl movie.
  void _deepConvertTitle(
    MovieResultDTO movie,
    Map<dynamic, dynamic> map,
  ) {
    final uniqueIds =
        map.deepSearch(deepTitleId1) ?? map.deepSearch(deepTitleId2);
    movie
      ..uniqueId = uniqueIds!.first!.toString()
      ..merge(_getDeepTitleCommon(map, movie.uniqueId));
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

  /// Parse [Map] to pull IMDB data out.
  Iterable<MovieResultDTO> _deepConvertSearchResults(
    Map<dynamic, dynamic> map,
  ) {
    final movies = <MovieResultDTO>[];
    for (final searchResults in map.deepSearch(deepTitleResults) ?? []) {
      if (searchResults is Iterable) {
        for (final movieMap in searchResults) {
          if (movieMap is Map) {
            final movieDto = MovieResultDTO().init();
            _deepConvertTitle(movieDto, movieMap);
            movies.add(movieDto);
          }
        }
      }
    }
    return movies;
  }

  /// extract related movie details from [map].
  static MovieResultDTO _getDeepTitleCommon(
    Map<dynamic, dynamic> map,
    String id,
  ) {
    // ...{'titleText':...{...'text':<value>...}} or
    // ...{'titleText':<value>...}
    final title = map.deepSearch(deepRelatedMovieTitle)?.searchForString() ??
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
        map.deepSearch(deepRelatedMoviePlotHeader)?.searchForString(
                  key: deepRelatedMoviePlotField,
                ) ??
            map.deepSearch(deepRelatedMoviePlot)?.first?.toString();
    // ...{'primaryImage':...{...'url':<value>...}}
    final url = map.deepSearch(deepImageHeader)?.searchForString(
          key: deepImageField,
        );
    // ...{...'aggregateRating':<value>...}
    final userRating = map.searchForString(key: deepRelatedMovieUserRating);
    // ...{...'voteCount':<value>...}
    final userRatingCount =
        map.searchForString(key: deepRelatedMovieUserRatingCount);
    // ...{'runtime':...{...'seconds':<value>...}} or
    // ...{'runtime':<value>...}
    final duration =
        map.deepSearch(deepRelatedMovieDurationHeader)?.searchForString(
                  key: deepRelatedMovieDurationField,
                ) ??
            map.deepSearch(deepRelatedMovieDURATIONHeader)?.searchForString(
                  key: deepRelatedMovieDurationField,
                ) ??
            map.deepSearch(deepRelatedMovieDurationHeader)?.first?.toString();

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
    final endDate = yearHeader?.searchForString(key: deepRelatedMovieYearEnd) ??
        map.searchForString(key: deepRelatedMovieYearEnd);
    final yearRange = (null != endDate)
        ? '$startDate-$endDate'
        : (null != startDate)
            ? startDate
            : null;

    // ...{'certificate':...{...'rating':<value>...}} or
    // ...{'certificate':<value>...}
    final censorRatingText = map
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

  /// extract actor credits information from [list].
  RelatedMovieCategories _getDeepTitleRelated(List<dynamic>? list) {
    final RelatedMovieCategories result = {};

    final castTree = list
        ?.deepSearch(deepTitleRelatedCastHeader)
        ?.deepSearch(deepTitleRelatedCastContainer, multipleMatch: true);
    final cast = _getDeepTitleRelatedPeopleForCategory(castTree);
    combineMovies(result, titleRelatedActorsLabel, cast);

    final directorsTree = list
        ?.deepSearch(deepTitleRelatedDirectorHeader)
        ?.deepSearch(deepTitleRelatedDirectorContainer, multipleMatch: true);
    final directors = _getDeepTitleRelatedPeopleForCategory(directorsTree);
    combineMovies(result, titleRelatedDirectorsLabel, directors);

    final relatedTree = list
        ?.deepSearch(deepTitleRelatedTitlesHeader)
        ?.deepSearch(deepRelatedMovieContainer, multipleMatch: true);
    final related = _getDeepTitleRelatedMoviesForCategory(relatedTree);
    combineMovies(result, titleRelatedMoviesLabel, related);

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
              // Pull description out of top level
              // and movie details out of lower level.
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

  /// extract collections of movies for a specific category for the person
  /// from a map or a list.
  static MovieCollection _getDeepPersonRelatedMoviesForCategory(
    dynamic category,
  ) {
    final MovieCollection result = {};
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

  /// extract collections of movies for a specific category for the title
  /// from a map or a list.
  MovieCollection _getDeepTitleRelatedMoviesForCategory(dynamic nodes) {
    final MovieCollection result = {};
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

  /// extract collections of people for a specific category for the title
  /// from a map or a list.
  MovieCollection _getDeepTitleRelatedPeopleForCategory(dynamic nodes) {
    final MovieCollection result = {};
    var creditsOrder = 100;
    if (nodes is List) {
      for (final node in nodes) {
        if (node is Map) {
          final movieDto = _getDeepTitleRelatedPerson(node);
          _getMovieCharactorName(movieDto, node);
          if (0 < creditsOrder) {
            movieDto.creditsOrder = creditsOrder--;
          }
          result[movieDto.uniqueId] = movieDto;
        }
      }
    }
    return result;
  }

  /// extract collections of movies for a specific category.
  static void _getMovieCharactorName(
    MovieResultDTO dto,
    Map<dynamic, dynamic> map,
  ) {
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
        dto
          ..alternateTitle = ' ${dto.alternateTitle}'
          ..charactorName = ' $names';
      }
    }
  }

  /// extract related movie details from [map].
  MovieResultDTO _getDeepTitleRelatedPerson(Map<dynamic, dynamic> map) {
    final id = map.deepSearch(deepRelatedPersonId)!.first!.toString();
    final title = // ...{'nameText':...{...'text':<value>...}}
        map.deepSearch(deepPersonNameHeader)?.searchForString();
    final url = // ...{'primaryImage':...{...'url':<value>...}}
        map.deepSearch(deepImageHeader)?.searchForString(
              key: deepImageField,
            );

    final newDTO = MovieResultDTO().init(
      bestSource: DataSourceType.imdbSuggestions,
      uniqueId: id,
      title: title,
      imageUrl: url,
    );
    return newDTO;
  }

  /// extract related movie details from [map].
  static MovieResultDTO _getDeepTitle(Map<dynamic, dynamic> map) {
    final id = map.deepSearch(deepRelatedMovieId)!.first!.toString();
    final dto = _getDeepTitleCommon(map, id);
    return dto;
  }

  void _shallowConvert(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    movie.setSource(
      newSource: map[dataSource],
      newUniqueId: map[outerElementIdentity]!.toString(),
    );
    if (movie.uniqueId.startsWith(imdbPersonPrefix)) {
      _shallowConvertPerson(movie, map);
    } else if (movie.uniqueId.startsWith(imdbTitlePrefix)) {
      _shallowConvertTitle(movie, map);
    }
  }

  void _shallowConvertPerson(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    final name = map[deepPersonNameHeader];
    if (name != null && name is Map) {
      movie.title = name.searchForString() ?? movie.imageUrl;
    } else {
      movie.title = name?.toString() ?? movie.imageUrl;
    }
    final url = map[deepImageHeader];
    if (url != null && url is Map) {
      movie.imageUrl =
          url.searchForString(key: outerElementLink) ?? movie.imageUrl;
    } else {
      movie.imageUrl = url?.toString() ?? movie.imageUrl;
    }

    combineMovies(
      movie.related,
      personRelatedActorLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonActorHeader]),
    );
    combineMovies(
      movie.related,
      personRelatedActressLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonActressHeader]),
    );
    combineMovies(
      movie.related,
      personRelatedDirectorLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonDirectorHeader]),
    );
    combineMovies(
      movie.related,
      personRelatedProducerLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonProducerHeader]),
    );
    combineMovies(
      movie.related,
      personRelatedWriterLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonWriterHeader]),
    );

    // Reintialise the source after setting the ID
    movie.setSource(newSource: source);
  }

  void _shallowConvertTitle(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    movie
      ..title = map[outerElementOfficialTitle]?.toString() ?? movie.title
      ..alternateTitle =
          map[outerElementAlternateTitle]?.toString() ?? movie.alternateTitle;
    if (movie.title == movie.alternateTitle) {
      movie.alternateTitle = '';
    }
    movie
      ..description =
          map[outerElementDescription]?.toString() ?? movie.description
      ..imageUrl = map[outerElementImage]?.toString() ?? movie.imageUrl
      ..year = getYear(map[outerElementYear]?.toString()) ?? movie.year
      ..yearRange = map[outerElementYearRange]?.toString() ?? movie.yearRange
      ..year = movie.maxYear()
      ..censorRating = getImdbCensorRating(
            map[outerElementCensorRating]?.toString(),
          ) ??
          movie.censorRating
      ..userRating = DoubleHelper.fromText(
        (map[outerElementRating] as Map?)?[innerElementRatingValue],
        nullValueSubstitute: movie.userRating,
      )!
      ..userRatingCount = IntHelper.fromText(
        (map[outerElementRating] as Map?)?[innerElementRatingCount],
        nullValueSubstitute: movie.userRatingCount,
      )!;

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
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {}

    movie
      ..genres.combineUnique(map[outerElementGenre])
      ..keywords.combineUnique(map[outerElementKeywords])
      ..languages.combineUnique(map[outerElementLanguages])
      ..getLanguageType();

    for (final person in getPeopleFromJson(map[outerElementDirector])) {
      movie.addRelated(titleRelatedDirectorsLabel, person);
    }
    for (final person in getPeopleFromJson(map[outerElementActors])) {
      movie.addRelated(titleRelatedActorsLabel, person);
    }
    //_getRelated(movie, map[outerElementActors], relatedActorsLabel);
    _getRelated(movie, map[outerElementRelated], titleRelatedMoviesLabel);

    final related = map[outerElementRelated];
    _getRelatedSections(related, movie);

    // Reintialise the source after setting the ID
    movie.setSource(newSource: source);
  }

  void _getRelated(MovieResultDTO movie, dynamic related, String label) {
    // Do nothing if related is null
    if (related is Map) {
      for (final dto in dtoFromMap(related, '')) {
        movie.addRelated(label, dto);
      }
    } else if (related is Iterable) {
      for (final relatedMap in related) {
        if (relatedMap is Map) {
          for (final dto in dtoFromMap(relatedMap, '')) {
            movie.addRelated(label, dto);
          }
        }
      }
    }
  }

  static List<MovieResultDTO> getPeopleFromJson(dynamic people) {
    final result = <MovieResultDTO>[];
    if (null != people) {
      Iterable<dynamic> peopleList;
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

  static MovieResultDTO? _dtoFromPersonMap(Map<dynamic, dynamic> map) {
    final id = getIdFromIMDBLink(map[outerElementLink]?.toString());
    if (map[outerElementType] != 'Person' || id == '') {
      return null;
    }
    return MovieResultDTO().init(
      bestSource: DataSourceType.imdbSuggestions,
      uniqueId: id,
      title: map[outerElementOfficialTitle]?.toString(),
    );
  }

  static void _getRelatedSections(dynamic related, MovieResultDTO movie) {
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

  static void _getMovieCategories(
    Map<dynamic, dynamic> related,
    MovieResultDTO movie,
  ) {
    for (final category in related.entries) {
      _getMovies(
        movie,
        category.value,
        category.key.toString(),
      );
    }
  }

  static void _getMovies(MovieResultDTO movie, dynamic movies, String label) {
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

  static void _getMovie(
    Map<dynamic, dynamic> movies,
    MovieResultDTO movie,
    String label,
  ) {
    final dto = _dtoFromRelatedMap(movies);
    if (null != dto) {
      movie.addRelated(label, dto);
    } else {}
  }

  static MovieResultDTO? _dtoFromRelatedMap(Map<dynamic, dynamic> map) {
    final id = getIdFromIMDBLink(map[outerElementLink]?.toString());
    if (id == '') {
      return null;
    }
    return MovieResultDTO().init(
      bestSource: DataSourceType.imdbSuggestions,
      uniqueId: id,
      title: map[outerElementOfficialTitle]?.toString(),
    );
  }
}
