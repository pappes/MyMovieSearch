// ignore_for_file: avoid_classes_with_only_static_members

import 'package:html_unescape/html_unescape_small.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

const outerElementIdentity = 'id';

const outerElementOfficialTitle = 'name';
const outerElementCommonTitle = 'alternateName';
const outerElementDescription = 'description';
const outerElementKeywords = 'keywords';
const outerElementGenre = 'genre';
const outerElementYear = 'datePublished';
const outerElementDuration = 'duration';
const outerElementCensorRating = 'contentRating';
const outerElementRating = 'aggregateRating';
const innerElementRatingValue = 'ratingValue';
const innerElementRatingCount = 'ratingCount';
const outerElementType = '@type';
const outerElementImage = 'image';
const outerElementLanguage = 'language';
const outerElementLanguages = 'languages';
const outerElementRelated = 'related';
const outerElementActors = 'actor';
const outerElementDirector = 'director';
const outerElementLink = 'url';

const relatedMoviesLabel = 'Suggestions';
const relatedActorsLabel = 'Cast:';
const relatedDirectorsLabel = 'Directed by:';

class ImdbMoviePageConverter {
  static final htmlDecode = HtmlUnescape();

  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[outerElementIdentity]?.toString() ?? movie.uniqueId;
    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;
    movie.alternateTitle =
        map[outerElementCommonTitle]?.toString() ?? movie.alternateTitle;
    movie.description = map[outerElementDescription]?.toString() ?? movie.title;
    movie.description += '\nKeywords: ${map[outerElementKeywords]}';
    movie.imageUrl = map[outerElementImage]?.toString() ?? movie.imageUrl;
    final language = map[outerElementLanguage];
    if (language is LanguageType) {
      movie.language = language;
    }
    movie.languages.combineUnique(map[outerElementLanguages]);
    movie.genres.combineUnique(map[outerElementGenre]);
    movie.censorRating = getImdbCensorRating(
          map[outerElementCensorRating]?.toString(),
        ) ??
        movie.censorRating;

    movie.userRating = DoubleHelper.fromText(
      map[outerElementRating]?[innerElementRatingValue],
      nullValueSubstitute: movie.userRating,
    )!;
    movie.userRatingCount = IntHelper.fromText(
      map[outerElementRating]?[innerElementRatingCount],
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

    _getRelated(movie, map[outerElementRelated]);
    _getPeople(movie, map[outerElementActors], relatedActorsLabel);
    _getPeople(movie, map[outerElementDirector], relatedDirectorsLabel);

    // Remove any html escape sequences from inner text.
    movie.title = htmlDecode.convert(movie.title);
    movie.alternateTitle = htmlDecode.convert(movie.alternateTitle);
    movie.description = htmlDecode.convert(movie.description);
    return movie;
  }

  static void _getRelated(MovieResultDTO movie, dynamic suggestions) {
    if (null != suggestions && suggestions is Iterable) {
      for (final relatedMap in suggestions) {
        if (relatedMap is Map) {
          final dto = dtoFromMap(relatedMap);
          movie.addRelated(relatedMoviesLabel, dto);
        }
      }
    }
  }

  static void _getPeople(MovieResultDTO movie, dynamic people, String label) {
    if (null != people) {
      Iterable peopleList;
      if (people is Iterable) {
        peopleList = people;
      } else if (people is Map) {
        peopleList = [people];
      } else {
        return;
      }
      for (final relatedMap in peopleList) {
        if (relatedMap is Map) {
          final dto = _dtoFromPersonMap(relatedMap);
          if (null != dto) {
            movie.addRelated(label, dto);
          }
        }
      }
    }
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
