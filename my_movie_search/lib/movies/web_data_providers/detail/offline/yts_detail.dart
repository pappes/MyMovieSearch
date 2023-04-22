// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"batman character","bestSource":"DataSourceType.ytsDetails","title":"batman character","type":"MovieContentType.download","sources":{"DataSourceType.ytsDetails":"batman character"}}
''',
  r'''
{"uniqueId":"dc comics","bestSource":"DataSourceType.ytsDetails","title":"dc comics","type":"MovieContentType.download","sources":{"DataSourceType.ytsDetails":"dc comics"}}
''',
  r'''
{"uniqueId":"gotham city","bestSource":"DataSourceType.ytsDetails","title":"gotham city","type":"MovieContentType.download","sources":{"DataSourceType.ytsDetails":"gotham city"}}
''',
  r'''
{"uniqueId":"masked superhero","bestSource":"DataSourceType.ytsDetails","title":"masked superhero","type":"MovieContentType.download","sources":{"DataSourceType.ytsDetails":"masked superhero"}}
''',
  r'''
{"uniqueId":"superhero","bestSource":"DataSourceType.ytsDetails","title":"superhero","type":"MovieContentType.download","sources":{"DataSourceType.ytsDetails":"superhero"}}
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

const htmlSampleInner = '''
  <a href="/search/keyword?keywords=batman-character">batman character</a>
  <a href="/search/keyword?keywords=gotham-city">gotham city</a>
  <a href="/search/keyword?keywords=dc-comics">dc comics</a>
  <a href="/search/keyword?keywords=masked-superhero">masked superhero</a>
  <a href="/search/keyword?keywords=superhero">superhero</a>
''';

const htmlSampleStart = ' <!DOCTYPE html> <html     <head>'
    ' </head> <body id="styleguide-v2" class="fixed">';
const htmlSampleEnd = ' </body> </html>';
const htmlSampleFull = '$htmlSampleStart $htmlSampleInner $htmlSampleEnd';

Future<Stream<String>> streamhtmlOfflineData(dynamic dummy) {
  return Future.value(emitHtmlSample(dummy));
}

Stream<String> emitHtmlSample(_) async* {
  yield htmlSampleFull;
}
