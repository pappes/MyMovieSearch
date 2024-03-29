// ignore_for_file: unnecessary_raw_strings

import 'dart:convert';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

// query string https://yts.mx/ajax/search?query=tt6644286
// json format
// status = 'ok' or 'false'
// data = message envelope
// data/url = details page http address
// data/img = small image url
// data/title = movie title
// data/year = year of release
// message = 'a message' or 'No results found.'

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/

const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://yts.mx/movies/space-babes-from-outer-space-2017","bestSource":"DataSourceType.ytsSearch","title":"Space Babes from Outer Space","type":"MovieContentType.information","year":"2017","sources":{"DataSourceType.ytsSearch":"https://yts.mx/movies/space-babes-from-outer-space-2017"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

const ytsJsonSampleInner = '''
  {
    "url":"https://yts.mx/movies/space-babes-from-outer-space-2017",
    "img":"https://yts.mx/assets/images/movies/space_babes_from_outer_space_2017/small-cover.jpg",
    "title":"Space Babes from Outer Space",
    "year":"2017"
  }
''';
const jsonSampleFull =
    ' {"status":"ok","data":[ $ytsJsonSampleInner ],"message":"a message"}';
const jsonSampleEmpty = ' {"status":"false","message":"No results found."}';

final intermediateMapList = [json.decode(jsonSampleFull)];
final intermediateEmptyMapList = [json.decode(jsonSampleEmpty)];

Future<Stream<String>> streamJsonOfflineData(_) =>
    Future.value(Stream.value(jsonSampleFull));
