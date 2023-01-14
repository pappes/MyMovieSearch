//query string https://www.imdb.com/title/tt0106977/fullcredits?ref_=tt_ov_st_sm
// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

/* To update this data run
       print(actualResult.toListOfDartJsonStrings(excludeCopyrightedData:false));
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm7602562","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm7602562"},
  "related":{"Actress":{"tt1234567":{"uniqueId":"tt1234567","bestSource":"DataSourceType.imdbSuggestions","title":"Land of the fill","type":"MovieContentType.title","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"tt1234567"},"related":{}},
      "tt1234568":{"uniqueId":"tt1234568","bestSource":"DataSourceType.imdbSuggestions","title":"Fill the land","type":"MovieContentType.title","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"tt1234568"},"related":{}}},
    "Director":{"tt2234567":{"uniqueId":"tt2234567","bestSource":"DataSourceType.imdbSuggestions","title":"Land of the turtle","type":"MovieContentType.title","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"tt2234567"},"related":{}},
      "tt2234568":{"uniqueId":"tt2234568","bestSource":"DataSourceType.imdbSuggestions","title":"Turtle the land","type":"MovieContentType.title","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"tt2234568"},"related":{}}}}}
''',
];

const intermediateMapList = [
  {
    "Actress": [
      {
        "name": "Land of the fill",
        "url": "/title/tt1234567/?ref_=nm_flmg_act_1"
      },
      {"name": "Fill the land", "url": "/title/tt1234568/?ref_=nm_flmg_act_1"},
    ],
    "Director": [
      {
        "name": "Land of the turtle",
        "url": "/title/tt2234567/?ref_=nm_flmg_act_1"
      },
      {"name": "Turtle the land", "url": "/title/tt2234568/?ref_=nm_flmg_act_1"}
    ],
    "id": "nm7602562"
  }
];

const imdbHtmlSampleInner = '''
  <div id="filmography" class="header">

    <div class="head"><a name="actress">Actress</a></div>
    <div class="filmo-category-section" style="">
        <b><a href="/title/tt1234567/?ref_=nm_flmg_act_1">Land of the fill</a></b>
        <b><a href="/title/tt1234568/?ref_=nm_flmg_act_1">Fill the land</a></b>
    </div>
    <div class="head"><a name="director">Director</a></div>
    <div class="filmo-category-section" style="">
        <b><a href="/title/tt2234567/?ref_=nm_flmg_act_1">Land of the turtle</a></b>
        <b><a href="/title/tt2234568/?ref_=nm_flmg_act_1">Turtle the land</a></b>
    </div>
  </div>
''';

const imdbHtmlSampleStart = ' <!DOCTYPE html> <html     <head>'
    ' </head> <body id="styleguide-v2" class="fixed">';
const imdbHtmlSampleEnd = ' </body> </html>';
const imdbHtmlSampleFull =
    '$imdbHtmlSampleStart $imdbHtmlSampleInner $imdbHtmlSampleEnd';

Future<Stream<String>> streamImdbHtmlOfflineData(dynamic dummy) {
  return Future.value(emitImdbHtmlSample(dummy));
}

Stream<String> emitImdbHtmlSample(_) async* {
  yield imdbHtmlSampleFull;
}
