// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

//query string https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&q=wonder&safe=off&key=<key>
//json format
//title = title (Year) - Source
//pagemap.metatags.pageid = unique key
//undefined = year
//pagemap.metatags.og:type = title type
//pagemap.metatags.og:image = image url
//pagemap.aggregaterating.ratingvalue = userRating
//pagemap.aggregaterating.ratingcount = userRatingCount

const outerElementErrorFailure = 'error';
const outerElementSearchInformation = 'searchInformation';
const outerElementResultsCollection = 'items';
const innerElementErrorFailureReason = 'message';
const innerElementSearchInfoCount = 'totalResults';
const innerElementTitle = 'title';
const innerElementYear = 'title';
const innerElementPagemap = 'pagemap';
const innerElementMetatags = 'metatags';
const innerElementRating = 'aggregaterating';
const innerElementRatingValue = 'ratingvalue';
const innerElementRatingCount = 'ratingcount';
const innerElementIdentity = 'pageid';
const innerElementPageconst = 'imdb:pageconst';
const innerElementType = 'og:type';
const innerElementImage = 'og:image';
const omdbResultTypeMovie = 'video.movie';
const omdbResultTypeSeries = 'video.tv_show';

class GoogleMovieSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];
    try {
      final resultCount = (map[outerElementSearchInformation]
          as Map)[innerElementSearchInfoCount];
      if ((int.tryParse(resultCount.toString()) ?? 0) == 0) {
        return _searchError(map);
      }
      for (final Map movie in map[outerElementResultsCollection]) {
        searchResults.add(dtoFromMap(movie));
      }
    } catch (e) {
      final error = MovieResultDTO();
      error.title =
          'Unknown google error - potential API change! $e ${map.toString()}';
      logger.e(error.title);

      searchResults.add(error);
    }
    return searchResults;
  }

  static List<MovieResultDTO> _searchError(Map map) {
    // deserialise outer json from map then iterate inner json
    final error = MovieResultDTO();
    final resultsError = map[outerElementErrorFailure];
    if (resultsError != null) {
      // ignore: avoid_dynamic_calls
      error.title = resultsError[innerElementErrorFailureReason]?.toString() ??
          'No failure reason provided in results';
    } else {
      error.title = 'Google found no matching results ${map.toString()}';
    }
    error.title += ' ${map.toString()}';
    return [error];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.bestSource = DataSourceType.google;

    movie.title = getTitle(map);
    movie.yearRange = getYearRange(map);
    movie.year = movie.maxYear();
    final inner = map[innerElementPagemap];
    if (inner is Map) {
      final metaTags = inner[innerElementMetatags];
      if (metaTags is Iterable) {
        final metatag = metaTags.first;
        if (metatag is Map) {
          movie.uniqueId = getID(metatag);
          movie.imageUrl = getImage(metatag);
          movie.type = getType(metatag);
        }
      }

      final innerRating = inner[innerElementPagemap];
      if (innerRating is Iterable) {
        final rating = innerRating.first;
        if (rating is Map) {
          movie.userRating = getRatingValue(rating);
          movie.userRatingCount = getRatingCount(rating);
        }
      }
    }
    return movie;
  }

  static String getTitle(Map map) {
    final title = DynamicHelper.toString_(map[innerElementTitle]);
    final lastOpen = title.lastIndexOf('(');
    return lastOpen > 1 ? title.substring(0, lastOpen) : title;
  }

  static String getID(Map map) {
    return map[innerElementIdentity]?.toString() ??
        map[innerElementPageconst]?.toString() ??
        movieResultDTOUninitialized;
  }

  static String getYearRange(Map map) {
    // Extract year range from 'title (TV Series 1988–1993)'
    final title = DynamicHelper.toString_(map[innerElementTitle]);
    final lastOpen = title.lastIndexOf('(');
    final lastClose = title.lastIndexOf(')');
    if (lastOpen == -1 || lastClose == -1) return '';

    final yearRange = title.substring(lastOpen + 1, lastClose);
    final filter = RegExp('[0-9].*[0-9]');
    final numerics = filter.stringMatch(yearRange);
    return DynamicHelper.toString_(numerics);
  }

  static MovieContentType getType(Map map) {
    switch (map[innerElementType]) {
      case omdbResultTypeMovie:
        return MovieContentType.movie;
      case omdbResultTypeSeries:
        return MovieContentType.series;
      default:
        return MovieContentType.none;
    }
  }

  static String getImage(Map map) {
    return DynamicHelper.toString_(map[innerElementImage]);
  }

  static double getRatingValue(Map map) {
    return DoubleHelper.fromText(
      map[innerElementRatingValue],
      nullValueSubstitute: 0,
    )!;
  }

  static int getRatingCount(Map map) {
    return IntHelper.fromText(
      map[innerElementRatingCount],
      nullValueSubstitute: 0,
    )!;
  }
}
