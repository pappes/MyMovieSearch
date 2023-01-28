//query string https://api.themoviedb.org/3/person/{personID]?api_key={api_key}&query=home
//json format

// "adult" = indicator of adult content (true/false)
// "also_known_as" = list of aliases
// "biography" = description of actors carrer
// "birthday" = date of birth
// "deathday" = date of death
// "gender" = 0, 1, 2 or 3
// "homepage" = personal profile page
// "id" = unique key
// "imdb_id" = imdb refernce number
// "known_for_department" = Acting, Editing, Directing, etc
// "name" = common name
// "place_of_birth" = city where person was born
// "popularity" = decmial value summarising recent activity level
// "profile_path" = name of profile image

import 'dart:convert';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
// ignore_for_file: unnecessary_raw_strings

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

/* To update this data run
       print(actualResult.toListOfDartJsonStrings(excludeCopyrightedData:false));
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm0109036","bestSource":"DataSourceType.tmdbPerson","title":"Fred Abraham","type":"MovieContentType.person","year":"1963","languages":"[]","genres":"[]","keywords":"[]",
      "description":"I came, I saw, I went",
      "userRating":"0.6","userRatingCount":"1","imageUrl":"https://image.tmdb.org/t/p/w500/kU3B75TyRiCfivoq.jpg","sources":{"DataSourceType.tmdbPerson":"11234"},"related":{}}
''',
];

final intermediateMapList = [jsonDecode(tmdbJsonSearchFull)];

const tmdbTree = {
  "adult": false,
  "also_known_as": [],
  "biography": "I came, I saw, I went",
  "birthday": "1963-12-18",
  "deathday": null,
  "gender": 0,
  "homepage": null,
  "id": 11234,
  "imdb_id": "nm0109036",
  "known_for_department": "Editing",
  "name": "Fred Abraham",
  "place_of_birth": null,
  "popularity": 0.6,
  "profile_path": "/kU3B75TyRiCfivoq.jpg"
};

final tmdbJsonSearchInner = jsonEncode(tmdbTree);

final tmdbJsonSearchFull = tmdbJsonSearchInner;
const tmdbJsonSearchEmpty =
    '{"success":false,"status_code":34,"status_message":"The resource you requested could not be found."}';
const tmdbJsonSearchError =
    '{"status_code":7,"status_message":"Invalid API key: You must be granted a valid key.","success":false}';

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
