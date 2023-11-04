//query string https://api.themoviedb.org/3/movie/{movieID]?api_key={api_key}&query=home
//json format
//movie_results
//  title = title/name
//  id = unique key
//  release_date = date the movie was released e.g. "2019-06-28",
//  vote_average = User rating
//  vote_count =  Count of users that have rated
//  poster_path = image url fragment
//  backdrop_path = alternate image url fragment
//  video = indicator of low quality movie (true/false)
//  adult = indicator of adult content (true/false)
//  genre_ids = list of numeric ids that need to be correlated with another web service call e.g. [28, 12, 878]
//  original_language = language spoken during the movie (iso_639_1) e.g. "en"
//  original_title = previous title assigned to the movie
//  overview = synopsis of the movie plot
//  popularity = raking to indcate how popular the movie is e.g. "280.151",
//person_results
//  name = name of the person
//  id = unique key
//  profile_path = image url fragment
//  known for = movie the person is famous for in movie_results format
//  adult = indicator of adult content (true/false)
//  popularity = raking to indcate how popular the person is e.g. "280.151",

import 'dart:convert';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"ttImdbId123","bestSource":"DataSourceType.tmdbFinder","title":"The Taking of Pelham 1 2 3","type":"MovieContentType.title","year":"2009","language":"LanguageType.allEnglish",
      "languages":"[\"en\"]","genres":"[]","keywords":"[]",
      "description":"Armed men hijack a New York City subway train, holding the passengers hostage in return for a ransom, and turning an ordinary day's work for dispatcher Walter Garber into a face-off with the mastermind behind the crime.",
      "userRating":"6.3","userRatingCount":"2494","sources":{"DataSourceType.tmdbFinder":"18487"},"related":{}}
''',
];

final intermediateMapList = [jsonDecode(tmdbJsonSearchFull)];

const tmdbJsonSearchInner = '''
  {"adult":false,
  "backdrop_path":"/kBWPHSszi8jKLqW5tMaQV1bISB2.jpg",
  "genre_ids":[53,80,28],
  "id":18487,
  "original_language":"en",
  "original_title":"The Taking of Pelham 1 2 3",
  "poster_path":"/baRXNiLDOpz3rH3VyjhayhgkWll.jpg",
  "vote_count":2494,
  "video":false,
  "vote_average":6.3,
  "title":"The Taking of Pelham 1 2 3",
  "overview":"Armed men hijack a New York City subway train, holding the passengers hostage in return for a ransom, and turning an ordinary day's work for dispatcher Walter Garber into a face-off with the mastermind behind the crime.",
  "release_date":"2009-06-10",
  "popularity":14.28}
''';

const tmdbJsonSearchFull =
    ' { "movie_results": [ $tmdbJsonSearchInner ],"person_results":[],"tv_results":[],"tv_episode_results":[],"tv_season_results":[]} ';
const tmdbJsonSearchEmpty =
    '{"movie_results":[],"person_results":[],"tv_results":[],"tv_episode_results":[],"tv_season_results":[]}';
const tmdbJsonSearchError =
    '{"success":false,"status_code":34,"status_message":"The resource you requested could not be found."}';

Future<Stream<String>> streamTmdbJsonOfflineData(_) {
  return Future.value(emitTmdbJsonOfflineData(_));
}

Stream<String> emitTmdbJsonOfflineData(_) async* {
  yield tmdbJsonSearchFull;
}

Stream<String> emitTmdbJsonEmpty(_) async* {
  yield tmdbJsonSearchEmpty;
}

Stream<String> emitTmdbJsonError(_) async* {
  yield tmdbJsonSearchError;
}
