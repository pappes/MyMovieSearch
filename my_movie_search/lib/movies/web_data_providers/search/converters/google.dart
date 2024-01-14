// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';
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
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];
    try {
      final resultCountString = (map[outerElementSearchInformation]
          as Map)[innerElementSearchInfoCount];
      final resultCount = int.tryParse(resultCountString.toString());
      if (resultCount == 0) {
        return [];
      } else if (resultCount == null) {
        return _searchError(map);
      }
      for (final movie in map[outerElementResultsCollection] as Iterable) {
        movie as Map;
        if (!isImdbChildPage(movie)) {
          searchResults.add(_dtoFromMap(movie));
        }
      }
    } catch (e) {
      final error = MovieResultDTO().init(
        title: 'Unknown google error - potential API change! $e $map',
      );
      logger.e(error.title);

      searchResults.add(error);
    }
    return searchResults;
  }

  static List<MovieResultDTO> _searchError(Map<dynamic, dynamic> map) {
    // construct an error message
    String error = '';
    final resultsError = map[outerElementErrorFailure];
    if (resultsError != null) {
      // ignore: avoid_dynamic_calls
      error = resultsError[innerElementErrorFailureReason]?.toString() ??
          'No failure reason provided in results';
    } else {
      error = 'Google found no matching results $map';
    }
    error += ' $map';
    return [
      MovieResultDTO()
          .error('[GoogleMovieSearchConverter] $error', DataSourceType.omdb),
    ];
  }

  static MovieResultDTO _dtoFromMap(Map<dynamic, dynamic> map) {
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
      movie.type = MovieContentType.series;
    }

    // Reinitialise source after setting ID
    movie.setSource(newSource: DataSourceType.google);
    return movie;
  }

  static String getTitle(Map<dynamic, dynamic> map) {
    final title = getRawTitle(map);
    final lastOpen = title.lastIndexOf('(');
    return lastOpen > 1 ? title.substring(0, lastOpen) : title;
  }

  static String getRawTitle(Map<dynamic, dynamic> map) {
    final titles = DynamicHelper.toStringList_(
      map.deepSearch(deepElementTitle),
    );
    return (titles.isEmpty ? '' : titles.first);
  }

  static String getID(Map<dynamic, dynamic> map) =>
      map[innerElementIdentity]?.toString() ??
      map[innerElementPageconst]?.toString() ??
      movieDTOUninitialized;

  static String getYearRange(Map<dynamic, dynamic> map) {
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

  static MovieContentType getType(Map<dynamic, dynamic> map) {
    switch (map[innerElementType]) {
      case imdbResultTypeMovie:
        return MovieContentType.movie;
      case imdbResultTypeSeries:
        return MovieContentType.series;
      default:
        return MovieContentType.none;
    }
  }

  static String getImage(Map<dynamic, dynamic> map) =>
      DynamicHelper.toString_(map[innerElementImage]);

  static double getRatingValue(Map<dynamic, dynamic> map) =>
      DoubleHelper.fromText(
        map[innerElementRatingValue],
        nullValueSubstitute: 0,
      )!;

  static int getRatingCount(Map<dynamic, dynamic> map) => IntHelper.fromText(
        map[innerElementRatingCount],
        nullValueSubstitute: 0,
      )!;

  // Ignore duplicated child pages. Page sub type is: main
  // or reviews or fullcredits or trivia or locations or plotsummary or ...
  static bool isImdbChildPage(Map<dynamic, dynamic> map) {
    final subPageType = map.searchForString(key: innerElementSubtype) ??
        map.searchForString(key: innerElementPrefixedSubtype) ??
        'unknown';

    if (subPageType == imdbPageTypeParentPage) {
      return false;
    }

    return true;
  }
}
