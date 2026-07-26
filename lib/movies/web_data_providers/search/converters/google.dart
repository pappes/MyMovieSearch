// Helper to convert Google movie search results.
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/domain/models/movie_result_comparison.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_enums.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_transformation.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/app_logger.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

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
const deepElementTitle = 'og:title';
const innerElementYear = 'title';
const innerElementPagemap = 'pagemap';
const innerElementMetatags = 'metatags';
const innerElementRating = 'aggregaterating';
const innerElementRatingValue = 'ratingvalue';
const innerElementRatingCount = 'ratingcount';
const innerElementIdentity = 'pageid';
const innerElementPageconst = 'imdb:pageconst';
const innerElementImage = 'og:image';
const innerElementType = 'og:type';
const innerElementSubtype = 'subpagetype';
const innerElementPrefixedSubtype = 'imdb:$innerElementSubtype';
const imdbResultTypeMovie = 'video.movie';
const imdbResultTypeSeries = 'video.tv_show';
const imdbPageTypeParentPage = 'main';

class GoogleMovieSearchConverter {
  /// deserialise outer json from map then iterate inner json
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<Object?, dynamic> map,
  ) {
    // Main IMDB page results with IDs directly matching the search criteria.
    final searchResults = <String, MovieResultDTO>{};
    // Results with IDs that are child pages of the search criteria.
    final otherResults = <MovieResultDTO>[];
    try {
      final resultCountString =
          // Execption handler will handle unexpected data.
          // ignore: avoid_dynamic_calls
          map[outerElementSearchInformation]?[innerElementSearchInfoCount];
      final resultCount = int.tryParse(resultCountString.toString());
      if (resultCount == 0) {
        return [];
      } else if (resultCount == null) {
        return _searchError(map);
      }
      for (final movie in map[outerElementResultsCollection] as Iterable) {
        movie as Map;
        // Prefer main page over child pages.
        // Child pages are reviews, fullcredits, trivia,
        // locations, plotsummary, etc.
        if (isImdbChildPage(movie)) {
          otherResults.add(_dtoFromMap(movie));
        } else {
          final dto = _dtoFromMap(movie);
          searchResults[dto.uniqueId] = dto;
        }
      }
      // Supplement main page results with child page results.
      for (final dto in otherResults) {
        final existing = searchResults[dto.uniqueId];
        if (existing == null) {
          searchResults[dto.uniqueId] = dto;
        } else {
          existing.merge(dto);
        }
      }
    } catch (e) {
      final error = MovieResultDTO().init(
        title: 'Unknown google error - potential API change! $e $map',
      );
      AppLogger.instance.error(error.title);
      searchResults[movieDTOMessagePrefix] = error;
    }
    return searchResults.values.toList();
  }

  static List<MovieResultDTO> _searchError(Map<Object?, Object?> map) {
    // construct an error message
    var error = '';
    final resultsError = map[outerElementErrorFailure];
    if (resultsError != null && resultsError is Map) {
      error =
          resultsError[innerElementErrorFailureReason]?.toString() ??
          'No failure reason provided in results';
    } else {
      error = 'Google found no matching results $map';
    }
    error += ' $map';
    return [
      MovieResultDTO().error('[GoogleMovieSearchConverter] $error', .google),
    ];
  }

  static MovieResultDTO _dtoFromMap(Map<Object?, Object?> map) {
    final movie = MovieResultDTO().init(title: getTitle(map));

    final inner = map[innerElementPagemap];
    if (inner is Map) {
      final metaTags = inner[innerElementMetatags];
      if (metaTags is Iterable) {
        final metatag = metaTags.first;
        if (metatag is Map) {
          movie
            ..uniqueId = getID(metatag)
            ..imageUrl = getImage(metatag)
            ..type = getType(metatag);
        }
      }
      final innerRating = inner[innerElementPagemap];
      if (innerRating is Iterable) {
        final rating = innerRating.first;
        if (rating is Map) {
          movie
            ..userRating = getRatingValue(rating)
            ..userRatingCount = getRatingCount(rating);
        }
      }
    }

    movie
      ..yearRange = getYearRange(map)
      ..year = movie.maxYear();
    if (movie.yearRange.length > 4) {
      movie.type = .series;
    }

    // Reinitialise source after setting ID
    movie.setSource(newSource: .google);
    return movie;
  }

  static String getTitle(Map<Object?, Object?> map) {
    final title = getRawTitle(map);
    final lastOpen = title.lastIndexOf('(');
    return lastOpen > 1 ? title.substring(0, lastOpen) : title;
  }

  static String getRawTitle(Map<Object?, Object?> map) {
    final titles = DynamicHelper.toStringList_(
      map.deepSearch(deepElementTitle),
    );
    return (titles.isEmpty ? '' : titles.first);
  }

  static String getID(Map<Object?, Object?> map) =>
      map[innerElementIdentity]?.toString() ??
      map[innerElementPageconst]?.toString() ??
      movieDTOUninitialized;

  static String getYearRange(Map<Object?, Object?> map) {
    // Extract year range from 'title (TV Series 1988–1993)'
    final title = getRawTitle(map).replaceAll('–', '-');
    final lastOpen = title.lastIndexOf('(');
    if (lastOpen == -1) return '';
    var lastClose = title.lastIndexOf(')');
    if (lastClose < lastOpen) lastClose = title.length;

    final yearRange = title.substring(lastOpen + 1, lastClose).trim();
    // Anything starting and ending with numerics
    // allowing for optional dash at end of line.
    final filter = RegExp('[0-9].*[0-9]-?');
    final numerics = filter.stringMatch(yearRange);
    return DynamicHelper.toString_(numerics);
  }

  static MovieContentType getType(Map<Object?, Object?> map) {
    switch (map[innerElementType]) {
      case imdbResultTypeMovie:
        return .movie;
      case imdbResultTypeSeries:
        return .series;
      default:
        return .none;
    }
  }

  static String getImage(Map<Object?, Object?> map) =>
      DynamicHelper.toString_(map[innerElementImage]);

  static double getRatingValue(Map<Object?, Object?> map) =>
      DoubleHelper.fromText(
        map[innerElementRatingValue],
        nullValueSubstitute: 0,
      )!;

  static int getRatingCount(Map<Object?, Object?> map) =>
      IntHelper.fromText(map[innerElementRatingCount], nullValueSubstitute: 0)!;

  // Ignore duplicated child pages. Page sub type is: main
  // or reviews or fullcredits or trivia or locations or plotsummary or ...
  static bool isImdbChildPage(Map<Object?, Object?> map) {
    final subPageType =
        map.searchForString(key: innerElementSubtype) ??
        map.searchForString(key: innerElementPrefixedSubtype) ??
        'unknown';

    if (subPageType == imdbPageTypeParentPage) {
      return false;
    }

    return true;
  }
}
