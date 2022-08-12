//query string https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=home
//json format
//title = title/name
//id = unique key
//release_date = date the movie was released e.g. "2019-06-28",
//vote_average = User rating
//vote_count =  Count of users that have rated
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
const expectedDtoJsonStringList = [
  '{"source": "tmdbMovie", "uniqueId": "429617", "title": "Spider-Man: Far from Home", "year": "2019", "languages": [], "genres": [], "keywords": [], "related": {}}',
  '{"source": "tmdbMovie", "uniqueId": "228161", "title": "Home", "year": "2015", "languages": [], "genres": [], "keywords": [], "related": {}}',
  '{"source": "tmdbMovie", "uniqueId": "521029", "title": "Annabelle Comes Home", "year": "2019", "languages": [], "genres": [], "keywords": [], "related": {}}',
  '{"source": "tmdbMovie", "uniqueId": "380565", "title": "Home Invasion", "year": "2016", "languages": [], "genres": [], "keywords": [], "related": {}}',
];

final intermediateMapList = [jsonDecode(tmdbJsonSearchFull)];

const tmdbJsonSearchInner = '''
  {"adult":false,"backdrop_path":"/8XiTPUQJf.jpg","genre_ids":[28,12,878],"id":429617,"original_language":"en",
   "original_title":"Spider-Man: Far from Home","overview":"Peter Parker and his friends go on... continent.",
   "popularity":36.5,"poster_path":"/4q2NyXl.jpg","release_date":"2019-06-28",
   "title":"Spider-Man: Far from Home","video":false,"vote_average":7.5,"vote_count":9483},
  {"adult":false,"backdrop_path":"/gnkBzJlne.jpg","genre_ids":[14,35,16,878,10751],"id":228161,"original_language":"en",
   "original_title":"Home","overview":"When Earth is taken over by the ov...a lifetime.",
   "popularity":4.5,"poster_path":"/usFeWMGR.jpg","release_date":"2015-03-18",
   "title":"Home","video":false,"vote_average":6.8,"vote_count":3032},
  {"adult":false,"backdrop_path":"/dBt0Do23M.jpg","genre_ids":[27,53,9648],"id":521029,"original_language":"en",
   "original_title":"Annabelle Comes Home","overview":"Determined to keep Annabelle from ...er friends.",
   "popularity":9.7,"poster_path":"/qWsHRVRs.jpg","release_date":"2019-06-26",
   "title":"Annabelle Comes Home","video":false,"vote_average":6.4,"vote_count":2240},
  {"adult":false,"backdrop_path":"/xfF8brc0o.jpg","genre_ids":[53,10770],"id":380565,"original_language":"en",
   "original_title":"Home Invasion","overview":"Terror arrives at the one place we... to safety?",
   "popularity":2.5,"poster_path":"/9Wbtkxnw.jpg","release_date":"2016-02-02",
   "title":"Home Invasion","video":false,"vote_average":5.2,"vote_count":105}
''';

const tmdbJsonSearchFull =
    ' { "page": 1, "results": [ $tmdbJsonSearchInner ], "total_pages": 12, "total_results": 340 } ';
const tmdbJsonSearchEmpty =
    '{ "status_message": "The resource you requested could not be found.", "status_code": 34 }';
const tmdbJsonSearchError =
    '{ "status_message": "Invalid API key: You must be granted a valid key.", "success": false, "status_code": 7 }';

Future<Stream<String>> streamTmdbJsonOfflineData(dynamic dummy) {
  return Future.value(emitTmdbJsonOfflineData(dummy));
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
