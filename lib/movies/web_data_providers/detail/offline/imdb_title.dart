import 'package:my_movie_search/movies/models/movie_result_dto.dart';

const imdbHtmlSampleStart = ' <!DOCTYPE html>     <head>';
const imdbHtmlSampleMiddle = ' </head> <body id="styleguide-v2" class="fixed">';
const imdbHtmlSampleEnd = ' </body> </html>';
const imdbHtmlSampleFull =
    '$imdbHtmlSampleStart $imdbJsonSampleInner '
    '$imdbHtmlSampleMiddle $imdbHtmlSampleInner $imdbHtmlSampleEnd';

Future<Stream<String>> streamImdbHtmlOfflineData(_) =>
    Future.value(Stream.value(imdbHtmlSampleFull));

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt6123456","bestSource":"DataSourceType.imdb","title":"Scott And Sharlene <3","alternateTitle":"Aussieland","type":"MovieContentType.series","year":"1985","yearRange":"1985-2023","runTime":"1234","language":"LanguageType.allEnglish",
      "languages":"[\"English\"]",
      "genres":"[\"Horror\",\"Romance\"]",
      "keywords":"[\"exorcism\",\"boxer\",\"chihuahua\"]",
      "description":"Then Kramer said, \"Everybody is Mescalon Smoochington\".",
      "userRating":"7.5","userRatingCount":"5123","censorRating":"CensorRatingType.family","imageUrl":"https://www.microsoft.com/images/M/MV5BYjAxMz.jpg","sources":{"DataSourceType.imdb":"tt6123456"},
  "related":{"Cast:":{"nm0012370":{"uniqueId":"nm0012370","bestSource":"DataSourceType.imdbSuggestions","title":"Bill Jole","alternateTitle":" ","characterName":" [Willy Rutter, Jimmy Banter]","type":"MovieContentType.person","creditsOrder":"100","imageUrl":"https://www.microsoft.com/images/M/MV5BM.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0012370"}},
      "nm0012372":{"uniqueId":"nm0012372","bestSource":"DataSourceType.imdbSuggestions","title":"Jenny Jole","alternateTitle":" ","characterName":" [Jilly Rutter, Jenny Banter]","type":"MovieContentType.person","creditsOrder":"99","imageUrl":"https://www.microsoft.com/images/M/MV5BY.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0012372"}}},
    "Directed by:":{"nm0214370":{"uniqueId":"nm0214370","bestSource":"DataSourceType.imdbSuggestions","title":"Andy Jole","type":"MovieContentType.person","creditsOrder":"100","imageUrl":"https://www.microsoft.com/images/M/M2V5BM.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0214370"}},
      "nm0214372":{"uniqueId":"nm0214372","bestSource":"DataSourceType.imdbSuggestions","title":"Shazza Jole","type":"MovieContentType.person","creditsOrder":"99","imageUrl":"https://www.microsoft.com/images/M/M2V5BY.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0214372"}}},
    "Suggestions:":{"tt0012370":{"uniqueId":"tt0012370","bestSource":"DataSourceType.imdbSuggestions","title":"Walk Skip Run","alternateTitle":"Run Forrest Run","type":"MovieContentType.series","year":"1973","yearRange":"1973-1974","runTime":"7140",
      "genres":"[\"Western\",\"Romance\"]",
      "userRating":"8.6","userRatingCount":"4837","censorRating":"CensorRatingType.family","imageUrl":"https://www.microsoft.com/images/M/MV5BM.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0012370"}},
      "tt0123580":{"uniqueId":"tt0123580","bestSource":"DataSourceType.imdbSuggestions","title":"Scott And Sharlene","alternateTitle":"Aussieland","type":"MovieContentType.short","year":"1985","yearRange":"1985-2023","runTime":"1234",
      "genres":"[\"Horror\",\"Romance\"]",
      "userRating":"7.5","userRatingCount":"5123","censorRating":"CensorRatingType.family","imageUrl":"https://www.microsoft.com/images/M/MV5BYjAxMz.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0123580"}}}}}
''',
];

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
