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

final intermediateMapList = [jsonDecode(jsonSampleFull)];

const tmdbTree = {
  'adult': false,
  'also_known_as': <void>[],
  'biography': 'I came, I saw, I went',
  'birthday': '1963-12-18',
  'deathday': null,
  'gender': 0,
  'homepage': null,
  'id': 11234,
  'imdb_id': 'nm0109036',
  'known_for_department': 'Editing',
  'name': 'Fred Abraham',
  'place_of_birth': null,
  'popularity': 0.6,
  'profile_path': '/kU3B75TyRiCfivoq.jpg',
  'external_ids': {
    'id': 104,
    'imdb_id': 'tt0137523',
    'wikidata_id': 'Q105553568',
    'facebook_id': 'FightClub',
    'instagram_id': 'wednesdaynetflix',
    'twitter_id': 'wednesdayaddams',
  },
};

final jsonSampleInner = jsonEncode(tmdbTree);

final jsonSampleFull = jsonSampleInner;
const jsonSampleEmpty = '{"success":false,"status_code":34,'
    '"status_message":"The resource you requested could not be found."}';
const jsonSampleError = '{"status_code":7,'
    '"status_message":"Invalid API key: You must be granted a valid key.", '
    '"success":false}';

Future<Stream<String>> streamTmdbJsonOfflineData(_) =>
    Future.value(Stream.value(jsonSampleFull));
