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

class ImdbTitleConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    final dto = dtoFromMap(map);
    return [dto];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[outerElementIdentity]?.toString() ?? movie.uniqueId;
    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;
    movie.alternateTitle =
        map[outerElementAlternateTitle]?.toString() ?? movie.alternateTitle;
    movie.description = map[outerElementDescription]?.toString() ?? movie.title;
    movie.imageUrl = map[outerElementImage]?.toString() ?? movie.imageUrl;
    final language = map[outerElementLanguage];
    if (language is LanguageType) {
      movie.language = language;
    }
    movie.languages.combineUnique(map[outerElementLanguages]);
    movie.genres.combineUnique(map[outerElementGenre]);
    movie.keywords.combineUnique(map[outerElementKeywords]);
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

    final year = getYear(map[outerElementYear]?.toString());
    if (null != year) {
      movie.year = year;
    } else {
      movie.yearRange = map[outerElementYear]?.toString() ?? movie.yearRange;
    }
    try {
      movie.runTime = Duration.zero.fromIso8601(map[outerElementDuration]);
    } catch (e) {
      movie.runTime = Duration.zero;
    }
    movie.type = getImdbMovieContentType(
          map[outerElementType],
          movie.runTime.inMinutes,
          movie.uniqueId,
        ) ??
        movie.type;

    for (final person in getPeopleFromJson(map[outerElementDirector])) {
      movie.addRelated(relatedDirectorsLabel, person);
    }
    for (final person in getPeopleFromJson(map[outerElementActors])) {
      movie.addRelated(relatedActorsLabel, person);
    }
    _getRelated(movie, map[outerElementActors], relatedActorsLabel);
    _getRelated(movie, map[outerElementRelated], _relatedMoviesLabel);

    // Remove any html escape sequences from inner text.
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
}
