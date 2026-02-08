const imdbHtmlSampleStart = ' <!DOCTYPE html>     <head>';
const imdbHtmlSampleMiddle = ' </head> <body id="styleguide-v2" class="fixed">';
const imdbHtmlSampleEnd = ' </body> </html>';
const imdbHtmlSampleFull =
    '$imdbHtmlSampleStart $imdbJsonSampleInner '
    '$imdbHtmlSampleMiddle $imdbHtmlSampleInner $imdbHtmlSampleEnd';

Future<Stream<String>> streamImdbHtmlOfflineData(_) =>
    Future.value(Stream.value(imdbHtmlSampleFull));

const imdbJsonSampleInner = '''
<script type="application/json">$_embeddedJson</script>
''';
const imdbHtmlSampleInner = '';

const intermediateMapList = [
  {
    'props': {
      'pageProps': {
        'tconst': 'tt6123456',
        'aboveTheFold': {
          'id': 'tt6123456',
          'certificate': {'rating': 'TV-G'},
          'originalTitleText': {'text': 'Aussieland'},
          'titleText': {'text': 'Scott And Sharlene <3'},
          'titleType': {'text': 'TV Series'},
          'primaryImage': {
            'url': 'https://www.microsoft.com/images/M/MV5BYjAxMz.jpg',
          },
          'ratingsSummary': {'aggregateRating': 7.5, 'voteCount': 5123},
          'releaseYear': {'year': 1985, 'endYear': 2023},
          'runtime': {'seconds': 1234},
          'genres': {
            'genres': [
              {'text': 'Horror'},
              {'text': 'Romance'},
            ],
          },
          'keywords': {
            'edges': [
              {
                'node': {'text': 'exorcism'},
              },
              {
                'node': {'text': 'boxer'},
              },
              {
                'node': {'text': 'chihuahua'},
              },
            ],
          },
          'plot': {
            'plotText': {
              'plainText':
                  'Then Kramer said, "Everybody is Mescalon Smoochington".',
            },
          },
        },
        'mainColumnData': {
          'spokenLanguages': {
            'spokenLanguages': [
              {'text': 'English'},
            ],
          },
          'cast': {
            'edges': [
              {
                'node': {
                  'characters': [
                    {'name': 'Willy Rutter'},
                    {'name': 'Jimmy Banter'},
                  ],
                  'name': {
                    'id': 'nm0012370',
                    'nameText': {'text': 'Bill Jole'},
                    'primaryImage': {
                      'url': 'https://www.microsoft.com/images/M/MV5BM.jpg',
                    },
                  },
                },
              },
              {
                'node': {
                  'characters': [
                    {'name': 'Jilly Rutter'},
                    {'name': 'Jenny Banter'},
                  ],
                  'name': {
                    'id': 'nm0012372',
                    'nameText': {'text': 'Jenny Jole'},
                    'primaryImage': {
                      'url': 'https://www.microsoft.com/images/M/MV5BY.jpg',
                    },
                  },
                },
              },
            ],
          },
          'directors': [
            {
              'credits': [
                {
                  'name': {
                    'id': 'nm0214370',
                    'nameText': {'text': 'Andy Jole'},
                    'primaryImage': {
                      'url': 'https://www.microsoft.com/images/M/M2V5BM.jpg',
                    },
                  },
                },
                {
                  'name': {
                    'id': 'nm0214372',
                    'nameText': {'text': 'Shazza Jole'},
                    'primaryImage': {
                      'url': 'https://www.microsoft.com/images/M/M2V5BY.jpg',
                    },
                  },
                },
              ],
            },
          ],
          'moreLikeThisTitles': {
            'edges': [
              {
                'node': {
                  'id': 'tt0012370',
                  'certificate': {'rating': 'PG-13'},
                  'originalTitleText': {'text': 'Run Forrest Run'},
                  'titleText': {'text': 'Walk Skip Run'},
                  'titleType': {'text': 'Movie'},
                  'primaryImage': {
                    'url': 'https://www.microsoft.com/images/M/MV5BM.jpg',
                  },
                  'ratingsSummary': {'aggregateRating': 8.6, 'voteCount': 4837},
                  'releaseYear': {'year': 1973, 'endYear': 1974},
                  'runtime': {'seconds': 7140},
                  'titleCardGenres': {
                    'genres': [
                      {'text': 'Western'},
                      {'text': 'Romance'},
                    ],
                  },
                },
              },
              {
                'node': {
                  'id': 'tt0123580',
                  'certificate': {'rating': 'TV-G'},
                  'originalTitleText': {'text': 'Aussieland'},
                  'titleText': {'text': 'Scott And Sharlene'},
                  'titleType': {'text': 'TV Series'},
                  'primaryImage': {
                    'url': 'https://www.microsoft.com/images/M/MV5BYjAxMz.jpg',
                  },
                  'ratingsSummary': {'aggregateRating': 7.5, 'voteCount': 5123},
                  'releaseYear': {'year': 1985, 'endYear': 2023},
                  'runtime': {'seconds': 1234},
                  'titleCardGenres': {
                    'genres': [
                      {'text': 'Horror'},
                      {'text': 'Romance'},
                    ],
                  },
                },
              },
            ],
          },
        },
      },
    },
  },
];

const _embeddedJson = r'''
{"props":{"pageProps":{"tconst":"tt6123456",
      "aboveTheFold": {
        "id": "tt6123456",
        "certificate": {"rating": "TV-G"},
        "originalTitleText": {"text": "Aussieland"},
        "titleText": {"text": "Scott And Sharlene \u003c3"},
        "titleType": {"text": "TV Series"},
        "primaryImage": {
          "url": "https://www.microsoft.com/images/M/MV5BYjAxMz.jpg"
        },
        "ratingsSummary": {"aggregateRating": 7.5, "voteCount": 5123},
        "releaseYear": {"year": 1985, "endYear": 2023},
        "runtime": {"seconds": 1234},
        "genres": {
          "genres": [
            {"text": "Horror"},
            {"text": "Romance"}
          ]
        },
        "keywords": {
          "edges": [
            {
              "node": {"text": "exorcism"}
            },
            {
              "node": {"text": "boxer"}
            },
            {
              "node": {"text": "chihuahua"}
            }
          ]
        },
        "plot": {
          "plotText": {
            "plainText":
                "Then Kramer said, \"Everybody is Mescalon Smoochington\"."
          }
        }
      },
      "mainColumnData": {
        "spokenLanguages": {
          "spokenLanguages": [
            {"text": "English"}
          ]
        },
        "cast": {
          "edges": [
            {
              "node": {
                "characters": [
                  {"name": "Willy Rutter"},
                  {"name": "Jimmy Banter"}
                ],
                "name": {
                  "id": "nm0012370",
                  "nameText": {"text": "Bill Jole"},
                  "primaryImage": {
                    "url": "https://www.microsoft.com/images/M/MV5BM.jpg"
                  }
                }
              }
            },
            {
              "node": {
                "characters": [
                  {"name": "Jilly Rutter"},
                  {"name": "Jenny Banter"}
                ],
                "name": {
                  "id": "nm0012372",
                  "nameText": {"text": "Jenny Jole"},
                  "primaryImage": {
                    "url": "https://www.microsoft.com/images/M/MV5BY.jpg"
                  }
                }
              }
            }
          ]
        },
        "directors": [
          {
            "credits": [
              {
                "name": {
                  "id": "nm0214370",
                  "nameText": {"text": "Andy Jole"},
                  "primaryImage": {
                    "url": "https://www.microsoft.com/images/M/M2V5BM.jpg"
                  }
                }
              },
              {
                "name": {
                  "id": "nm0214372",
                  "nameText": {"text": "Shazza Jole"},
                  "primaryImage": {
                    "url": "https://www.microsoft.com/images/M/M2V5BY.jpg"
                  }
                }
              }
            ]
          }
        ],
        "moreLikeThisTitles": {
          "edges": [
            {
              "node": {
                "id": "tt0012370",
                "certificate": {"rating": "PG-13"},
                "originalTitleText": {"text": "Run Forrest Run"},
                "titleText": {"text": "Walk Skip Run"},
                "titleType": {"text": "Movie"},
                "primaryImage": {
                  "url": "https://www.microsoft.com/images/M/MV5BM.jpg"
                },
                "ratingsSummary": {"aggregateRating": 8.6, "voteCount": 4837},
                "releaseYear": {"year": 1973, "endYear": 1974},
                "runtime": {"seconds": 7140},
                "titleCardGenres": {
                  "genres": [
                    {"text": "Western"},
                    {"text": "Romance"}
                  ]
                }
              }
            },
            {
              "node": {
                "id": "tt0123580",
                "certificate": {"rating": "TV-G"},
                "originalTitleText": {"text": "Aussieland"},
                "titleText": {"text": "Scott And Sharlene"},
                "titleType": {"text": "TV Series"},
                "primaryImage": {
                  "url": "https://www.microsoft.com/images/M/MV5BYjAxMz.jpg"
                },
                "ratingsSummary": {"aggregateRating": 7.5, "voteCount": 5123},
                "releaseYear": {"year": 1985, "endYear": 2023},
                "runtime": {"seconds": 1234},
                "titleCardGenres": {
                  "genres": [
                    {"text": "Horror"},
                    {"text": "Romance"}
                  ]
                }
              }
            }
          ]
        }
      }
    }
  }
}''';
