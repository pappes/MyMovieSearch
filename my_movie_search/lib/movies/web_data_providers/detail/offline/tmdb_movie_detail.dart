//query string https://api.themoviedb.org/3/movie/{movieID]?api_key={api_key}&query=home
//json format
//title = title/name
//id = unique key
//release_date = date the movie was released e.g. "2019-06-28",
//vote_average = User rating
//vote_count =  Count of users taht have rated
//poster_path = image url fragment
//backdrop_path = alternate image url fragment
//video = indicator of low quality movie (true/false)
//adult = indicator of adult content (true/false)
//genre_ids = list of numeric ids that need to be correlated with another web service call e.g. [28, 12, 878]
//original_language = language spoken during the movie (iso_639_1) e.g. "en"
//original_title = previous title assigned to the movie
//overview = synopsis of the movie plot
//popularity = raking to indcate how popular the movie is e.g. "280.151",

import 'dart:convert';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0130827","bestSource":"DataSourceType.tmdbMovie","title":"Run Lola Run","alternateTitle":"Lola rennt","type":"MovieContentType.title","year":"1998","runTime":"4860","language":"LanguageType.someEnglish",
      "languages":"[\"German\",\"English\",\"Japanese\"]",
      "genres":"[\"Action\",\"Drama\",\"Thriller\"]","keywords":"[]",
      "description":"Lola receives a phone call from her boyfriend Manni. He lost 100,000 DM in a subway train that belongs to a very bad guy. She has 20 minutes to raise this amount and meet Manni. Otherwise, he will rob a store to get the money. Three different alternatives may happen depending on some minor event along Lola's run.",
      "userRating":"7.3","userRatingCount":"1537","imageUrl":"https://image.tmdb.org/t/p/w500/yBt6rkxRTP15nyOZOJt9pOgXDW0.jpg","sources":{"DataSourceType.tmdbMovie":"104"},"related":{}}
''',
];

final intermediateMapList = [jsonDecode(tmdbJsonSearchFull)];

const tmdbJsonSearchInner = '''
{"adult":false,
  "backdrop_path":"/lhsrT0SbPaqmBMHLd5N83j8XAFy.jpg",
  "belongs_to_collection":null,
  "budget":1530000,
  "genres":[{"id":28,"name":"Action"},{"id":18,"name":"Drama"},{"id":53,"name":"Thriller"}],
  "homepage":"",
  "id":104,
  "imdb_id":"tt0130827",
  "original_language":"de",
  "original_title":"Lola rennt",
  "overview":"Lola receives a phone call from her boyfriend Manni. He lost 100,000 DM in a subway train that belongs to a very bad guy. She has 20 minutes to raise this amount and meet Manni. Otherwise, he will rob a store to get the money. Three different alternatives may happen depending on some minor event along Lola's run.",
  "popularity":9.313,
  "poster_path":"/yBt6rkxRTP15nyOZOJt9pOgXDW0.jpg",
  "production_companies":[{"id":96,  "logo_path":"/9ps82gVzUeNdkjmLzoGDQLiLDio.png",  "name":"X Filme Creative Pool",
  "origin_country":"DE"},{"id":46,  "logo_path":"/3xFdKHLXPGHEbrAkmsepGE8974Y.png",  "name":"WDR",  "origin_country":"DE"}],
  "production_countries":[{"iso_3166_1":"DE",  "name":"Germany"}],
  "release_date":"1998-03-03",
  "revenue":7267585,
  "runtime":81,
  "spoken_languages":[{"english_name":"German",  "iso_639_1":"de",  "name":"Deutsch"},
  {"english_name":"English",  "iso_639_1":"en",  "name":"English"},
  {"english_name":"Japanese",  "iso_639_1":"ja",  "name":"日本語"}],
  "status":"Released",
  "tagline":"Every second of every day you're faced with a decision that can change your life.",
  "title":"Run Lola Run",
  "video":false,
  "vote_average":7.3,
  "vote_count":1537}
''';

const tmdbJsonSearchFull = tmdbJsonSearchInner;
const tmdbJsonSearchEmpty =
    '{"success":false,"status_code":34,"status_message":"The resource you requested could not be found."}';
const tmdbJsonSearchError =
    '{"status_code":7,"status_message":"Invalid API key: You must be granted a valid key.","success":false}';

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
