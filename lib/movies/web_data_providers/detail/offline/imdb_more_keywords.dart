//query string https://www.imdb.com/keywords/tt0106977?ref_=tt_ov_st_sm

const intermediateMapList = [
  {
    'batman character': 'keyword',
    'gotham city': 'keyword',
    'dc comics': 'keyword',
    'masked superhero': 'keyword',
    'superhero': 'keyword',
  },
];

const imdbHtmlSampleInner = '''
  <a href="/search/keyword?keywords=batman-character">batman character</a>
  <a href="/search/keyword?keywords=gotham-city">gotham city</a>
  <a href="/search/keyword?keywords=dc-comics">dc comics</a>
  <a href="/search/keyword?keywords=masked-superhero">masked superhero</a>
  <a href="/search/keyword?keywords=superhero">superhero</a>
''';

const imdbHtmlSampleStart =
    ' <!DOCTYPE html> <html     <head>'
    ' </head> <body id="styleguide-v2" class="fixed">';
const imdbHtmlSampleEnd = ' </body> </html>';
const imdbHtmlSampleFull =
    '$imdbHtmlSampleStart $imdbHtmlSampleInner $imdbHtmlSampleEnd';

Future<Stream<String>> streamImdbHtmlOfflineData(_) =>
    Future.value(Stream.value(imdbHtmlSampleFull));
