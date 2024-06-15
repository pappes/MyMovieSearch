// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

//query string https://customsearch.MsSearchapis.com/customsearch/v1?cx=821cd5ca4ed114a04&q=wonder&safe=off&key=<key>
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

class MsSearchMovieSearchConverter {
  static Stream<MovieResultDTO> dtoFromCompleteJsonMap(
    List<dynamic> list,
  ) async* {
    for (final map in list) {
      if (map is Map) {
        yield map.toMovieResultDTO();
      }
    }
  }
}
