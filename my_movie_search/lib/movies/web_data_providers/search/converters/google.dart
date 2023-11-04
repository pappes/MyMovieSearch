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
const innerElementTitle = 'title';
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
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
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
          searchResults.add(dtoFromMap(movie));
        }
      }
    } catch (e) {
      final error = MovieResultDTO();
      error.title = 'Unknown google error - potential API change! $e $map';
      logger.e(error.title);

      searchResults.add(error);
    }
    return searchResults;
  }

  static List<MovieResultDTO> _searchError(Map map) {
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
      MovieResultDTO().error(
        '[GoogleMovieSearchConverter] $error',
        DataSourceType.omdb,
      )
    ];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();

    movie.title = getTitle(map);

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

    movie.yearRange = getYearRange(map);
    movie.year = movie.maxYear();
    if (movie.yearRange.length > 4) {
      movie.type = MovieContentType.series;
    }

    // Reinitialise source after setting ID
    movie.setSource(newSource: DataSourceType.google);
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
        movieDTOUninitialized;
  }

  static String getYearRange(Map map) {
    // Extract year range from 'title (TV Series 1988–1993)'
    final title = DynamicHelper.toString_(map[innerElementTitle]);
    final lastOpen = title.lastIndexOf('(');
    final lastClose = title.lastIndexOf(')');
    if (lastOpen == -1 || lastClose == -1) return '';

    final yearRange = title.substring(lastOpen + 1, lastClose);
    // Anything starting and ending with numerics allowing ofr optional dash at end of line
    final filter = RegExp('[0-9].*[0-9]-?–?');
    final numerics = filter.stringMatch(yearRange);
    return DynamicHelper.toString_(numerics);
  }

  static MovieContentType getType(Map map) {
    switch (map[innerElementType]) {
      case imdbResultTypeMovie:
        return MovieContentType.movie;
      case imdbResultTypeSeries:
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

  // Ignore duplicated child pages. Page sub type is: main
  // or reviews or fullcredits or trivia or locations or plotsummary or ...
  static bool isImdbChildPage(Map map) {
    final subPageType = map.searchForString(key: innerElementSubtype) ??
        map.searchForString(key: innerElementPrefixedSubtype) ??
        'unknown';

    if (subPageType == imdbPageTypeParentPage) {
      return false;
    }

    return true;
  }
}
