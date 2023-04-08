//query string https://www.imdb.com/keywords/tt0106977?ref_=tt_ov_st_sm
// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"batman character","bestSource":"DataSourceType.imdbKeywords","title":"batman character","type":"MovieContentType.keyword","sources":{"DataSourceType.imdbKeywords":"batman character"}}
''',
  r'''
{"uniqueId":"dc comics","bestSource":"DataSourceType.imdbKeywords","title":"dc comics","type":"MovieContentType.keyword","sources":{"DataSourceType.imdbKeywords":"dc comics"}}
''',
  r'''
{"uniqueId":"gotham city","bestSource":"DataSourceType.imdbKeywords","title":"gotham city","type":"MovieContentType.keyword","sources":{"DataSourceType.imdbKeywords":"gotham city"}}
''',
  r'''
{"uniqueId":"masked superhero","bestSource":"DataSourceType.imdbKeywords","title":"masked superhero","type":"MovieContentType.keyword","sources":{"DataSourceType.imdbKeywords":"masked superhero"}}
''',
  r'''
{"uniqueId":"superhero","bestSource":"DataSourceType.imdbKeywords","title":"superhero","type":"MovieContentType.keyword","sources":{"DataSourceType.imdbKeywords":"superhero"}}
''',
];

const intermediateMapList = [
  {
    'batman character': 'keyword',
    'gotham city': 'keyword',
    'dc comics': 'keyword',
    'masked superhero': 'keyword',
    'superhero': 'keyword',
  }
];

const imdbHtmlSampleInner = '''
  <a href="/search/keyword?keywords=batman-character">batman character</a>
  <a href="/search/keyword?keywords=gotham-city">gotham city</a>
  <a href="/search/keyword?keywords=dc-comics">dc comics</a>
  <a href="/search/keyword?keywords=masked-superhero">masked superhero</a>
  <a href="/search/keyword?keywords=superhero">superhero</a>
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
