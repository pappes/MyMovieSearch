// query string https://www.wikidata.org/wiki/Special:EntityData/Q211082.json
// or           https://www.wikidata.org/wiki/Special:EntityData/Q13794921.json


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
        'run time': '128',
        'P2047': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P2047',
              'hash': '87b93e5da7b23eb564255937bd5c7d90a23ea400',
              'datavalue': {
                'value': {
                  'amount': '+28',
                  'unit': 'http://www.wikidata.org/entity/Q7727',
                },
                'type': 'quantity',
              },
              'datatype': 'external-id',
            },
            'rank': 'normal',
          },
        ],
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

final jsonSeries = {
  'entities': {
    'Q253205': {
      'id': 'Q253205',
      'labels': {
        'en': {'language': 'en', 'value': 'Entourage'},
      },
      'descriptions': {
        'en': {
          'language': 'en',
          'value': 'American comedy-drama television series',
        },
      },
      'claims': {
        'movie type': 'tv series',
        'P31': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P31',
              'hash': '40a93c25a36e6a07478de6eca4ba68f5b9aaa85f',
              'datavalue': {
                'value': {
                  'entity-type': 'item',
                  'numeric-id': 5398426,
                  'id': 'Q5398426',
                },
                'type': 'wikibase-entityid',
              },
              'datatype': 'wikibase-item',
            },
            'type': 'statement',
            'rank': 'normal',
          },
        ],
        'start date': '18/7/2004',
        'P580': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P580',
              'hash': '87b93e5da7b23eb564255937bd5c7d90a23ea400',
              'datavalue': {
                'value': {'time': '+2004-07-18T00:00:00Z'},
                'type': 'time',
              },
              'datatype': 'time',
            },
            'rank': 'normal',
          },
        ],
        'end date': '11/9/2011',
        'P582': [
          {
            'mainsnak': {
              'snaktype': 'value',
              'property': 'P582',
              'hash': '5d1ae0a9be90a4cf4b7775d140fdaeb4e928cfb7',
              'datavalue': {
                'value': {'time': '+2011-09-11T00:00:00Z'},
                'type': 'time',
              },
              'datatype': 'time',
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
              'hash': 'c31a47d7d4300f80ec921ad2dee9ffff85517f6b',
              'datavalue': {'value': 'tt0387199', 'type': 'string'},
              'datatype': 'external-id',
            },
            'type': 'statement',
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


final jsonMultipleMovie = {
  'head': {
    'vars': [
      'movieIMDB',
      'movieName',
      'contentTypes',
      'typeQIDs',
      'descriptions',
      'rating',
      'firstReleaseDate',
      'maxRuntime',
      'tmdbLink',
      'theTVDBLink',
      'originalNetwork',
      'knowYourMemeLink',
      'filmAffinityLink',
      'metacriticLink',
      'netflixLink',
      'rottenTomatoesLink',
      'tvTropesLink',
      'twitterLink',
      'youtubeLink',
      'facebookLink',
      'letterboxdLink',
      'lezWatchLink',
      'plexLink',
      'ratingGraphLink',
      'tvMazeLink',
    ],
  },
  'results': {
    'bindings': [
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0068646'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'The Godfather',
        },
        'contentTypes': {'type': 'literal', 'value': 'film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': '1972 US film by Francis Ford Coppola',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1972-03-15T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '175',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film809297.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value': 'https://www.metacritic.com/movie/movie/the-godfather',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value': 'https://www.rottentomatoes.com/m/m/the_godfather',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value':
              'https://tvtropes.org/pmwiki/pmwiki.php/Main/Film/TheGodfather',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d7768248a7581001f12bc72',
        },
        'youtubeLink': {
          'type': 'literal',
          'value': 'https://www.youtube.com/watch?v=mJLWydHPkMw',
        },
        'netflixLink': {
          'type': 'literal',
          'value': 'https://www.netflix.com/title/60011152',
        },
        'facebookLink': {
          'type': 'literal',
          'value': 'https://www.facebook.com/thegodfathermovie',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0080684'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'Star Wars: Episode V – The Empire Strikes Back',
        },
        'contentTypes': {'type': 'literal', 'value': 'film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value':
              '1980 American epic space opera film directed by Irvin Kershner',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1980-01-01T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '122',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film605090.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value':
              'https://www.metacritic.com/movie/movie/star-wars-episode-v---the-empire-strikes-back',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value':
              'https://www.rottentomatoes.com/m/m/star_wars_episode_v_the_empire_strikes_back',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value':
              'https://tvtropes.org/pmwiki/pmwiki.php/Main/Film/TheEmpireStrikesBack',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d77682a880197001ec91562',
        },
        'netflixLink': {
          'type': 'literal',
          'value': 'https://www.netflix.com/title/60011114',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0108052'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': "Schindler's List",
        },
        'contentTypes': {'type': 'literal', 'value': 'film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': '1993 film by Steven Spielberg',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1993-01-01T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '195',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film656153.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value': 'https://www.metacritic.com/movie/movie/schindlers-list',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value': 'https://www.rottentomatoes.com/m/m/schindlers_list',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value':
              'https://tvtropes.org/pmwiki/pmwiki.php/Main/Film/SchindlersList',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d7768255af944001f1f65a1',
        },
        'youtubeLink': {
          'type': 'literal',
          'value': 'https://www.youtube.com/watch?v=KUlZ-iZjDsc',
        },
        'netflixLink': {
          'type': 'literal',
          'value': 'https://www.netflix.com/title/60036359',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0110912'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'Pulp Fiction',
        },
        'contentTypes': {'type': 'literal', 'value': 'film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': '1994 film by Quentin Tarantino',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1994-05-21T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '154',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film160882.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value': 'https://www.metacritic.com/movie/movie/pulp-fiction',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value': 'https://www.rottentomatoes.com/m/m/pulp_fiction',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value':
              'https://tvtropes.org/pmwiki/pmwiki.php/Main/Film/PulpFiction',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d776827103a2d001f564488',
        },
        'letterboxdLink': {
          'type': 'literal',
          'value': 'https://letterboxd.com/film/film/pulp-fiction',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0111161'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'The Shawshank Redemption',
        },
        'contentTypes': {'type': 'literal', 'value': 'film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': '1994 American drama film directed by Frank Darabont',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1994-01-01T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '142',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film161026.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value':
              'https://www.metacritic.com/movie/movie/the-shawshank-redemption',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value': 'https://www.rottentomatoes.com/m/m/shawshank_redemption',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value':
              'https://tvtropes.org/pmwiki/pmwiki.php/Main/Film/TheShawshankRedemption',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d7768248a7581001f12bc77',
        },
        'youtubeLink': {
          'type': 'literal',
          'value': 'https://www.youtube.com/watch?v=ZWXKyDK8eZE',
        },
        'netflixLink': {
          'type': 'literal',
          'value': 'https://www.netflix.com/title/70005379',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0114709'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'Toy Story',
        },
        'contentTypes': {'type': 'literal', 'value': 'animated film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': '1995 American animated film',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1995-01-01T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '81',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film459936.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value': 'https://www.metacritic.com/movie/movie/toy-story',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value': 'https://www.rottentomatoes.com/m/m/toy_story',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value':
              'https://tvtropes.org/pmwiki/pmwiki.php/Main/WesternAnimation/ToyStory1',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d776828880197001ec90d44',
        },
        'youtubeLink': {
          'type': 'literal',
          'value': 'https://www.youtube.com/watch?v=vGe1JFJ8Ylc',
        },
        'netflixLink': {
          'type': 'literal',
          'value': 'https://www.netflix.com/title/60036637',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0133093'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'The Matrix',
        },
        'contentTypes': {'type': 'literal', 'value': 'film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': '1999 American science fiction action thriller film',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1999-03-31T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '136',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film932476.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value': 'https://www.metacritic.com/movie/movie/the-matrix',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value': 'https://www.rottentomatoes.com/m/m/matrix',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value': 'https://tvtropes.org/pmwiki/pmwiki.php/Main/Film/TheMatrix',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d776827880197001ec90904',
        },
        'youtubeLink': {
          'type': 'literal',
          'value': 'https://www.youtube.com/watch?v=_XrKhqC5rQQ',
        },
        'netflixLink': {
          'type': 'literal',
          'value': 'https://www.netflix.com/title/20557937',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0137523'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'Fight Club',
        },
        'contentTypes': {'type': 'literal', 'value': 'film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': '1999 film directed by David Fincher',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1999-01-01T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '139',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film536945.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value': 'https://www.metacritic.com/movie/movie/fight-club',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value': 'https://www.rottentomatoes.com/m/m/fight_club',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value': 'https://tvtropes.org/pmwiki/pmwiki.php/Main/Film/FightClub',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d7768265af944001f1f6976',
        },
        'youtubeLink': {
          'type': 'literal',
          'value': 'https://www.youtube.com/watch?v=oHlZeNj0Edw',
        },
        'netflixLink': {
          'type': 'literal',
          'value': 'https://www.netflix.com/title/26004747',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0167260'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'The Lord of the Rings: The Return of the King',
        },
        'contentTypes': {'type': 'literal', 'value': 'film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': '2003 film by Peter Jackson',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '2003-12-01T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '200',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film226427.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value':
              'https://www.metacritic.com/movie/movie/the-lord-of-the-rings-the-return-of-the-king',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value':
              'https://www.rottentomatoes.com/m/m/the_lord_of_the_rings_the_return_of_the_king',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value':
              'https://tvtropes.org/pmwiki/pmwiki.php/Main/Film/TheLordOfTheRingsTheReturnOfTheKing',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d7768248a7581001f12bc73',
        },
        'youtubeLink': {
          'type': 'literal',
          'value': 'https://www.youtube.com/watch?v=_PO7ohKKgWE',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt0468569'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'The Dark Knight',
        },
        'contentTypes': {'type': 'literal', 'value': 'film'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': '2008 film directed by Christopher Nolan',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '2008-07-18T00:00:00Z',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '153',
        },
        'tmdbLink': {'type': 'literal', 'value': ''},
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film867354.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value': 'https://www.metacritic.com/movie/movie/the-dark-knight',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value': 'https://www.rottentomatoes.com/m/m/the_dark_knight',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value':
              'https://tvtropes.org/pmwiki/pmwiki.php/Main/Film/TheDarkKnight',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/5d7768247e9a3c0020c6a8f3',
        },
        'youtubeLink': {
          'type': 'literal',
          'value': 'https://www.youtube.com/watch?v=kmJLuwP3MbY',
        },
        'netflixLink': {
          'type': 'literal',
          'value': 'https://www.netflix.com/title/70079583',
        },
      },
      {
        'movieIMDB': {'type': 'literal', 'value': 'tt13443470'},
        'movieName': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'Wednesday',
        },
        'contentTypes': {'type': 'literal', 'value': 'television series'},
        'typeQIDs': {'type': 'literal', 'value': ''},
        'descriptions': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'American horror comedy television series',
        },
        'maxRuntime': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#decimal',
          'type': 'literal',
          'value': '360',
        },
        'firstReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1972-03-15T00:00:00Z',
        },
        'lastReleaseDate': {
          'datatype': 'http://www.w3.org/2001/XMLSchema#dateTime',
          'type': 'literal',
          'value': '1974-03-15T00:00:00Z',
        },
        'tmdbLink': {
          'type': 'literal',
          'value': 'https://www.themoviedb.org/movie/119051',
        },
        'filmAffinityLink': {
          'type': 'literal',
          'value': 'https://www.filmaffinity.com/en/film995233.html',
        },
        'metacriticLink': {
          'type': 'literal',
          'value': 'https://www.metacritic.com/movie/tv/wednesday',
        },
        'rottenTomatoesLink': {
          'type': 'literal',
          'value': 'https://www.rottentomatoes.com/m/tv/wednesday',
        },
        'tvTropesLink': {
          'type': 'literal',
          'value':
              'https://tvtropes.org/pmwiki/pmwiki.php/Main/Series/Wednesday',
        },
        'plexLink': {
          'type': 'literal',
          'value':
              'https://app.plex.tv/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/60300ded22d896002c2d4897',
        },
        'youtubeLink': {
          'type': 'literal',
          'value': 'https://www.youtube.com/watch?v=Di310WS8zLk',
        },
        'netflixLink': {
          'type': 'literal',
          'value': 'https://www.netflix.com/title/81231974',
        },
        'facebookLink': {
          'type': 'literal',
          'value': 'https://www.facebook.com/wednesdaynetflix',
        },
        'letterboxdLink': {
          'type': 'literal',
          'value': 'https://letterboxd.com/film/tv-and-radio/wednesday',
        },
        'theTVDBLink': {
          'type': 'literal',
          'value': 'https://thetvdb.com/series/397060',
        },
        'originalNetwork': {
          'xml:lang': 'en',
          'type': 'literal',
          'value': 'Netflix',
        },
        'knowYourMemeLink': {
          'type': 'literal',
          'value': 'https://knowyourmeme.com/memes/wednesday-2022-series',
        },
        'twitterLink': {
          'type': 'literal',
          'value': 'https://twitter.com/wednesdayaddams',
        },
        'lezWatchLink': {
          'type': 'literal',
          'value': 'https://lezwatchtv.com/show/wednesday',
        },
        'ratingGraphLink': {
          'type': 'literal',
          'value':
              'https://www.ratingraph.com/tv-shows/wednesday-ratings-101930',
        },
        'tvMazeLink': {
          'type': 'literal',
          'value': 'https://tvmaze.com/shows/53647',
        },
      },
    ],
  },
};
