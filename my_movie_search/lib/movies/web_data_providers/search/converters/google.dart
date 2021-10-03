import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

//query string https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&q=wonder&safe=off&key=<key>
//json format
//title = title (Year) - Source
//pagemap.metatags.pageid = unique key
//undefined = year
//pagemap.metatags.og:type = title type
//pagemap.metatags.og:image = image url
//pagemap.aggregaterating.ratingvalue = userRating
//pagemap.aggregaterating.ratingcount = userRatingCount

const outer_element_error_failure = 'error';
const outer_element_search_information = 'searchInformation';
const outer_element_results_collection = 'items';
const inner_element_error_failure_reason = 'message';
const inner_element_search_info_count = 'totalResults';
const inner_element_title_element = 'title';
const inner_element_year_element = 'title';
const inner_element_pagemap = 'pagemap';
const inner_element_metatags = 'metatags';
const inner_element_rating = 'aggregaterating';
const inner_element_rating_value = 'ratingvalue';
const inner_element_rating_count = 'ratingcount';
const inner_element_identity_element = 'pageid';
const inner_element_pageconst_element = 'imdb:pageconst';
const inner_element_type_element = 'og:type';
const inner_element_image_element = 'og:image';
const OMDB_RESULT_TYPE_MOVIE = 'video.movie';
const OMDB_RESULT_TYPE_SERIES = 'video.tv_show';

class GoogleMovieSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    List<MovieResultDTO> searchResults = [];
    try {
      var resultCount = map[outer_element_search_information]
          [inner_element_search_info_count];
      if ((int.tryParse(resultCount.toString()) ?? 0) == 0) {
        return _searchError(map);
      }
      map[outer_element_results_collection]
          .forEach((movie) => searchResults.add(dtoFromMap(movie as Map)));
    } catch (e) {
      final error = MovieResultDTO();
      error.title =
          'Unknown google error - potential API change! $e ${map.toString()}';
      print(error.title);

      searchResults.add(error);
    }
    return searchResults;
  }

  static List<MovieResultDTO> _searchError(Map map) {
    // deserialise outer json from map then iterate inner json
    final error = MovieResultDTO();
    final resultsError = map[outer_element_error_failure];
    if (resultsError != null) {
      error.title =
          resultsError[inner_element_error_failure_reason]?.toString() ??
              'No failure reason provided in results';
    } else {
      error.title = 'Google found no matching results ${map.toString()}';
    }
    error.title += ' ${map.toString()}';
    return [error];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final movie = MovieResultDTO();
    movie.source = DataSourceType.google;

    movie.title = getTitle(map);
    movie.yearRange = getYearRange(map);
    movie.year = movie.maxYear();
    final inner = map[inner_element_pagemap];
    if (inner is Map) {
      final metaTags = inner[inner_element_metatags];
      if (metaTags is Iterable) {
        final metatag = metaTags.first;
        if (metatag is Map) {
          movie.uniqueId = getID(metatag);
          movie.imageUrl = getImage(metatag);
          movie.type = getType(metatag);
        }
      }

      final innerRating = inner[inner_element_pagemap];
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
    final String title = map[inner_element_title_element]?.toString() ?? '';
    final lastOpen = title.lastIndexOf('(');
    return lastOpen > 1 ? title.substring(0, lastOpen) : title;
  }

  static String getID(Map map) {
    return map[inner_element_identity_element]?.toString() ??
        map[inner_element_pageconst_element]?.toString() ??
        movieResultDTOUninitialised;
  }

  static String getYearRange(Map map) {
    // Extract year range from 'title (TV Series 1988–1993)'
    final String title = map[inner_element_title_element]?.toString() ?? '';
    final lastOpen = title.lastIndexOf('(');
    final lastClose = title.lastIndexOf(')');
    if (lastOpen == -1 || lastClose == -1) return '';

    final yearRange = title.substring(lastOpen + 1, lastClose);
    final filter = RegExp(r'[0-9].*[0-9]');
    final numerics = filter.stringMatch(yearRange);
    return numerics ?? '';
  }

  static MovieContentType getType(Map map) {
    switch (map[inner_element_type_element]) {
      case OMDB_RESULT_TYPE_MOVIE:
        return MovieContentType.movie;
      case OMDB_RESULT_TYPE_SERIES:
        return MovieContentType.series;
      default:
        return MovieContentType.none;
    }
  }

  static String getImage(Map map) {
    return map[inner_element_image_element]?.toString() ?? '';
  }

  static double getRatingValue(Map map) {
    return DoubleHelper.fromText(
      map[inner_element_rating_value],
      nullValueSubstitute: 0,
    )!;
  }

  static int getRatingCount(Map map) {
    return IntHelper.fromText(
      map[inner_element_rating_count],
      nullValueSubstitute: 0,
    )!;
  }
}
