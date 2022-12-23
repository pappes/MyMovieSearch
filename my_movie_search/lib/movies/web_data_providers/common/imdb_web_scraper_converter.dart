// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

const _relatedMoviesLabel = 'Suggestions:';
const relatedActorsLabel = 'Cast:';
const relatedDirectorsLabel = 'Directed by:';

class ImdbWebScraperConverter {
  final DataSourceType source;
  ImdbWebScraperConverter(this.source);
  List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    final dto = dtoFromMap(map);
    return [dto];
  }

  /// Take a [Map] of IMDB data and create a [MovieResultDTO] from it.
  MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO().init(source: source);
    if (map.containsKey(outerElementIdentity)) {
      _shallowConvert(movie, map);
    } else {
      _deepConvert(movie, map);
    }
    return movie;
  }

  /// Parse [Map] to pull IMDB data out.
  void _deepConvert(MovieResultDTO movie, Map map) {
    movie.uniqueId = _deepSearch(deepPersonId, map).toString();
    final name = _getDeepString(_deepSearch(deepPersonNameHeader, map));
    final url = _getDeepString(
      _deepSearch(deepPersonImageHeader, map),
      key: deepPersonImageField,
    );
    final description = _getDeepString(
      _deepSearch(deepPersonDescriptionHeader, map),
      key: deepPersonDescriptionField,
    );
    final startDate = _getDeepString(
      _deepSearch(deepPersonStartDateHeader, map),
      key: deepPersonStartDateField,
    );
    final endDate = _getDeepString(
      _deepSearch(deepPersonEndDateHeader, map),
      key: deepPersonEndDateField,
    );
    final yearRange = (null != endDate)
        ? '$startDate-$endDate'
        : (null != startDate)
            ? startDate
            : null;
    final popularity = _getDeepString(
      _deepSearch(deepPersonPopularityHeader, map),
      key: deepPersonPopularityField,
    );
    final related = _getDeepRelated(
      _deepSearch(
        deepPersonRelatedSuffix, //'*Credits' e.g. releasedPrimaryCredits
        map,
        suffixMatch: true,
        multipleMatch: true,
      ),
    );

    movie.merge(
      MovieResultDTO().init(
        source: source,
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

  /// Recursively traverse a [Map] or [List] to pull a specific value out.
  static Object? _deepSearch(
    String tag,
    dynamic mapOrList, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) {
    if (null == mapOrList) return null;
    final matches = []; // Allow mutiple results on suffix search.
    final mapIterable = mapOrList is Map ? mapOrList.entries : null;
    final iterable = mapIterable ?? mapOrList as Iterable;
    for (final entry in iterable) {
      final key = entry is MapEntry ? entry.key : '';
      final value = entry is MapEntry ? entry.value : entry;

      if (key == tag) {
        // Simple match.
        matches.add(value);
        if (!multipleMatch) return matches.first;
      } else if (suffixMatch && key.toString().endsWith(tag)) {
        // Suffix match.
        matches.add(value);
        if (!multipleMatch) return matches.first;
      } else if (value is Map || value is Iterable) {
        // Recursively search children.
        final result = _deepSearch(
          tag,
          value,
          suffixMatch: suffixMatch,
          multipleMatch: multipleMatch,
        );
        if (result is List) {
          matches.addAll(result);
          if (!multipleMatch) return matches.first;
        }
      }
    }

    if (matches.isNotEmpty) {
      // Return mutiple results for suffix search.
      return matches;
    }
    return null;
  }

  /// Validate [map] contains a String [key].
  static String? _getDeepString(dynamic map, {String key = 'text'}) {
    final result = _deepSearch(key, map);
    if (null != result) {
      return result.toString();
    }
    return null;
  }

  /// extract actor credits information from [list].
  Map<String, Map<String, MovieResultDTO>> _getDeepRelated(
    dynamic list,
  ) {
    final result = <String, Map<String, MovieResultDTO>>{};
    if (list is List) {
      for (final related in list) {
        if (related is List) {
          for (final item in related) {
            if (item is Map) {
              final movies = _getDeepCategoryMovies(item);
              final category = _getDeepString(
                    _deepSearch(deepRelatedCategoryHeader, item),
                  ) ??
                  'Unknown';
              if (result.containsKey(category)) {
                result[category]!.addAll(movies);
              } else {
                result[category] = movies;
              }
            }
          }
        }
      }
    }
    return result;
  }

  /// extract collections of movies for a specific category.
  Map<String, MovieResultDTO> _getDeepCategoryMovies(Map category) {
    final result = <String, MovieResultDTO>{};
    final nodes = _deepSearch(
      deepPersonRelatedMovieContainer,
      category,
      multipleMatch: true,
    );
    if (nodes is List) {
      for (final node in nodes) {
        if (node is Map) {
          final title = _deepSearch(deepPersonRelatedMovieHeader, node);
          if (title is Map) {
            final movieDto = _getDeepMovie(title);
            _getMovieCharatorName(movieDto, node);
            result[movieDto.uniqueId] = movieDto;
          }
        }
      }
    }
    return result;
  }

  /// extract collections of movies for a specific category.
  static void _getMovieCharatorName(MovieResultDTO dto, Map map) {
    final charactors = _deepSearch(
      deepPersonRelatedMovieParentCharactorHeader,
      map,
    );
    if (charactors is List) {
      final names = _deepSearch(
        deepPersonRelatedMovieParentCharactorField,
        map,
        multipleMatch: true,
      );
      if (names is List && names.isNotEmpty) {
        dto.alternateTitle = ' ${names.toString()}  ${dto.alternateTitle}';
      }
    }
  }

  /// extract related movie details from [map].
  MovieResultDTO _getDeepMovie(Map map) {
    final id = _deepSearch(deepPersonRelatedMovieId, map)!.toString();
    final title = _getDeepString(
      _deepSearch(deepPersonRelatedMovieTitle, map),
    );
    final originalTitle = _getDeepString(
      _deepSearch(deepPersonRelatedMovieAlternateTitle, map),
    );
    final url = _getDeepString(
      _deepSearch(deepPersonRelatedMovieUrl, map),
      key: deepPersonImageField,
    );
    final userRating = _deepSearch(
      deepPersonRelatedMovieUserRating,
      map,
    )?.toString();
    final userRatingCount = _deepSearch(
      deepPersonRelatedMovieUserRatingCount,
      map,
    )?.toString();
    final startDate = _getDeepString(
      _deepSearch(deepPersonRelatedMovieYearHeader, map),
      key: deepPersonRelatedMovieYearStart,
    );
    final endDate = _getDeepString(
      _deepSearch(deepPersonRelatedMovieYearHeader, map),
      key: deepPersonRelatedMovieYearEnd,
    );
    final duration = _getDeepString(
      _deepSearch(deepPersonRelatedMovieDurationHeader, map),
      key: deepPersonRelatedMovieDurationField,
    );
    final movieTypeString = _getDeepString(
      _deepSearch(deepPersonRelatedMovieType, map),
    );
    final censorRating = getImdbCensorRating(
      _getDeepString(
        _deepSearch(deepPersonRelatedMovieCensorRatingHeader, map),
        key: deepPersonRelatedMovieCensorRatingField,
      ),
    );
    final movieType = getImdbMovieContentType(movieTypeString, null, id);
    final genreNode = _deepSearch(deepPersonRelatedMovieGenreHeader, map);
    String? genres;
    if (genreNode is Map) {
      final gernreList = _deepSearch(
        deepPersonRelatedMovieGenreField,
        genreNode,
        multipleMatch: true,
      );
      if (gernreList is List && gernreList.isNotEmpty) {
        genres = json.encode(gernreList);
      }
    }
    final newDTO = MovieResultDTO().init(
      source: source,
      uniqueId: id,
      title: title,
      alternateTitle: originalTitle,
      type: movieType.toString(),
      year: startDate,
      yearRange: '$startDate-$endDate',
      userRating: userRating,
      userRatingCount: userRatingCount,
      censorRating: censorRating?.toString(),
      runTime: duration,
      imageUrl: url,
      genres: genres?.toString(),
    );
    return newDTO;
  }

  void _shallowConvert(MovieResultDTO movie, Map map) {
    movie.uniqueId = map[outerElementIdentity]!.toString();

    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;
    movie.alternateTitle =
        map[outerElementAlternateTitle]?.toString() ?? movie.alternateTitle;
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

    movie.languages.combineUnique(map[outerElementLanguages]);
    movie.genres.combineUnique(map[outerElementGenre]);
    movie.keywords.combineUnique(map[outerElementKeywords]);

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
