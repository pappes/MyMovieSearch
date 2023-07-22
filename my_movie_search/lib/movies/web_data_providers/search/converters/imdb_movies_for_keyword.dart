// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_web_scraper_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/imdb_movies_for_keyword.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

//query string https://sg.media-imdb.com/suggestion/x/wonder%20woman.json
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

class ImdbMoviesForKeywordConverter {
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
    var movieType = MovieResultDTOHelpers.getMovieContentType(
      "${map[keywordTypeInfo]} $yearRange",
      seconds,
      uniqueId,
    )?.toString();
    if (uniqueId.startsWith('http')) {
      movieType = MovieContentType.navigation.name;
    }

    final RelatedMovieCategories related = {};
    final directors = _getRelatedPeople(map[keywordDirectors]?.toString());
    final cast = _getRelatedPeople(map[keywordActors]?.toString());
    if (directors.isNotEmpty) {
      related[relatedDirectorsLabel] = directors;
    }
    if (cast.isNotEmpty) {
      related[relatedActorsLabel] = cast;
    }

    final movie = MovieResultDTO().init(
      bestSource: DataSourceType.imdbKeywords,
      uniqueId: uniqueId,
      title: map[keywordName]?.toString(),
      description: map[keywordDescription]?.toString(),
      imageUrl: map[keywordImage]?.toString(),
      year: getYear(map[keywordYearRange]?.toString())?.toString(),
      yearRange: yearRange,
      type: movieType,
      censorRating:
          getImdbCensorRating(map[keywordCensorRating]?.toString()).toString(),
      userRating: map[keywordPopularityRating]?.toString(),
      userRatingCount: map[keywordPopularityRatingCount]?.toString(),
      keywords: '["${map[keywordKeywords]}"]',
      related: related,
    );
    return movie;
  }

  static MovieCollection _getRelatedPeople(String? jsonText) {
    final MovieCollection relatedPeople = {};
    if (null != jsonText) {
      final map = json.decode(jsonText) as Map;
      for (final entry in map.entries) {
        relatedPeople.addAll(_decodePerson(entry));
      }
    }
    return relatedPeople;
  }

  static MovieCollection _decodePerson(MapEntry entry) {
    final name = entry.key?.toString();
    final url = entry.value?.toString();
    if (null != url) {
      final id = getIdFromIMDBLink(url);
      if (null != name && '' != id) {
        return {id: MovieResultDTO().init(uniqueId: id, title: name)};
      }
    }
    return {};
  }
}
