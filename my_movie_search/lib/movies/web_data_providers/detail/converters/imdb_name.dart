// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

class ImdbNamePageConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    logger.i(
      json.encode(map),
    );
    return [_dtoFromMap(map)];
  }

  static MovieResultDTO _dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[outerElementIdentity]?.toString() ?? movie.uniqueId;
    movie.title = map[outerElementOfficialTitle]?.toString() ?? movie.title;
    movie.alternateTitle =
        map[outerElementAlternateTitle]?.toString() ?? movie.alternateTitle;
    movie.description = map[outerElementDescription]?.toString() ?? movie.title;
    movie.imageUrl = map[outerElementImage]?.toString() ?? movie.imageUrl;

    movie.year = getYear(map[outerElementBorn]?.toString()) ?? movie.year;
    final deathDate =
        getYear(map[outerElementDied]?.toString())?.toString() ?? '';
    movie.yearRange = '${movie.year}-$deathDate';
    movie.type = MovieContentType.person;

    final related = map[outerElementRelated];
    _getRelated(related, movie);
    return movie;
  }

  static void _getRelated(related, MovieResultDTO movie) {
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
