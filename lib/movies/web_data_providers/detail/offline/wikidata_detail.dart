// query string https://www.wikidata.org/wiki/Special:EntityData/Q211082.json
// or https://www.wikidata.org/wiki/Special:EntityData/Q13794921.json


import 'dart:convert';

final intermediateErrorList = [jsonDecode(jsonSampleEmpty)];

const jsonSampleEmpty = '''
<!DOCTYPE html>
<html><head><title>Bad Request</title><meta name="color-scheme" content="light dark" /></head>
<body><h1>Bad Request</h1><p>Invalid ID: Q211x082.</p></body></html>
''';
const jsonSampleError =    '''
<!DOCTYPE html>
<html><head><title>Unsupported Media Type</title><meta name="color-scheme" content="light dark" /></head>
<body><h1>Unsupported Media Type</h1><p>The data format jason is not supported by this interface.</p></body></html>
''';

Future<Stream<String>> streamMovieJsonOfflineData(_) =>
    Future.value(Stream.value(jsonEncode(jsonMovie)));
Future<Stream<String>> streamPersonJsonOfflineData(_) =>
    Future.value(Stream.value(jsonEncode(jsonPerson)));

final jsonMovie = {
  'entities': {
    'Q13794921': {
      'id': 'Q13794921',
      'labels': {
        'en': {'language': 'en', 'value': 'Sharknado'},
      },
      'descriptions': {
        'en': {
          'language': 'en',
          'value': '2013 film directed by Anthony C. Ferrante',
        },
      },
      'sitelinks': {
        'enwiki': {
          'site': 'enwiki',
          'title': 'Sharknado',
          'url': 'https://en.wikipedia.org/wiki/Sharknado',
        },
      },
      'claims': {
        'rottentomatoes': 'https://www.rottentomatoes.com/',
        'P1258': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P1258',
              'hash': 'fd9028db8785541aa9e7bfcf89f4449a29fa9ebe',
              'datavalue': {'value': 'm/sharknado_2013', 'type': 'string'},
              'datatype': 'external-id',
            },
            'rank': 'deprecated',
          },
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P1258',
              'hash': '8f9b055fd81e68bcbc15f60f1ff823997cf11975',
              'datavalue': {'value': 'm/sharknado', 'type': 'string'},
              'datatype': 'external-id',
            },
            'rank': 'normal',
          },
        ],
        'imdb': 'https://www.imdb.com/title/',
        'P345': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P345',
              'hash': 'a52f415c4dca9de747826f6c3da5a8eac84f9cc9',
              'datavalue': {'value': 'tt2724064', 'type': 'string'},
              'datatype': 'external-id',
            },
            'type': 'statement',
            'id': r'q13794921$bd445b6f-474a-b0d3-de1b-999fb2f4ba38',
            'rank': 'normal',
          },
        ],
        'officalWebsite': 'various',
        'P856': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P856',
              'hash': '84d24195a8bf90b6999dd0e590916d515fe0b0a6',
              'datavalue': {
                'value': 'http://www.theasylum.cc/product.php?id=230',
                'type': 'string',
              },
              'datatype': 'url',
            },
            'type': 'statement',
            'id': r'Q13794921$E8B9D8EE-3180-45E8-A8BC-FD0D2841F3E3',
            'rank': 'normal',
          },
        ],
      },
    },
  },
};

final jsonPerson = {
  'entities': {
    'Q211082': {
      'pageid': 206800,
      'ns': 0,
      'title': 'Q211082',
      'lastrevid': 2426640300,
      'modified': '2025-11-06T17:54:26Z',
      'type': 'item',
      'id': 'Q211082',
      'labels': {
        'en': {'language': 'en', 'value': 'Tara Reid'},
      },
      'descriptions': {
        'en': {'language': 'en', 'value': 'American actress (born 1975)'},
      },
      'claims': {
        'imdb': 'https://www.imdb.com/name/',
        'P345': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P345',
              'hash': '015eff27cfbe9cb2eb1a57b00ec466747b6a9669',
              'datavalue': {'value': 'nm0005346', 'type': 'string'},
              'datatype': 'external-id',
            },
            'type': 'statement',
            'id': r'q211082$28B88210-AE86-483F-A233-EB44446D89B3',
            'rank': 'normal',
          },
        ],
        'rottentomatoes': 'https://www.rottentomatoes.com/',
        'P1258': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P1258',
              'hash': 'fbb6daccdbb1c918826d67374c862a429a50ac5b',
              'datavalue': {'value': 'celebrity/tara_reid', 'type': 'string'},
              'datatype': 'external-id',
            },
            'type': 'statement',
            'id': r'Q211082$017047f0-48d1-08ac-2f95-9bdd9ab5863f',
            'rank': 'normal',
          },
        ],
        'facebook': 'https://www.facebook.com/',
        'P2013': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P2013',
              'hash': 'e50149260c72e1ded1cf7d074a2ddec6af97aca7',
              'datavalue': {'value': 'TaraReidOfficial', 'type': 'string'},
              'datatype': 'external-id',
            },
            'type': 'statement',
            'id': r'Q211082$CC91FC80-E802-4BEC-B234-C79FE5C28E9A',
            'rank': 'normal',
          },
        ],
      },
      'sitelinks': {
        'enwiki': {
          'site': 'enwiki',
          'title': 'Tara Reid',
          'url': 'https://en.wikipedia.org/wiki/Tara_Reid',
        },
      },
    },
  },
};
