// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/tpb_search.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

//query string https://sg.media-imdb.com/suggests/w/wonder%20woman.json
//json format
//1 = title/name
//id = unique  key (tt=tile/nm=name/vi=video)
//s = supplimentary info (biography, actors or trailer duration
//y = year
//yr = year range for series
//q = title type
//i = image with dimensions

const outerElementResultsCollection = 'd';
const innerElementIdentity = 'id';
const innerElementTitle = 'l';
const innerElementImage = 'i';
const innerElementYear = 'y';
const innerElementType = 'q';
const innerElementYearRange = 'yr';

class TpbSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final uniqueId = map[keywordId]!.toString();

    final minutes = IntHelper.fromText(
      map[keywordDuration]?.toString().replaceAll('min', ''),
    );
    int? seconds;
    if (null != minutes) {
      seconds = Duration(minutes: minutes).inSeconds;
    }
    final yearRange = map[keywordYearRange]
        ?.toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    final movieType = MovieResultDTOHelpers.getMovieContentType(
      "${map[keywordTypeInfo]} $yearRange",
      seconds,
      uniqueId,
    )?.toString();

    final movie = MovieResultDTO().init(
      bestSource: DataSourceType.tpb,
      uniqueId: uniqueId,
      title: map[keywordName]?.toString(),
      description: map[keywordDescription]?.toString(),
      imageUrl: map[keywordImage]?.toString(),
      year: getYear(map[keywordYearRange]?.toString())?.toString(),
      yearRange: yearRange,
      type: movieType,
      userRating: map[keywordPopularityRating]?.toString(),
      userRatingCount: map[keywordPopularityRatingCount]?.toString(),
      keywords: '["${map[keywordKeywords]}"]',
    );
    return movie;
  }
}
