// ignore_for_file: avoid_classes_with_only_static_members

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
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    final dto = dtoFromMap(map);
    return [dto];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.uniqueId = map[outerElementIdentity]?.toString() ?? movie.uniqueId;
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
    // _getRelated(movie, map[outerElementActors], relatedActorsLabel);
    _getRelated(movie, map[outerElementRelated], _relatedMoviesLabel);

    final related = map[outerElementRelated];
    _getRelatedSections(related, movie);

    return movie;
  }

  static void _getRelated(MovieResultDTO movie, related, String label) {
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
