import 'package:my_movie_search/movies/models/movie_result_dto.dart';

const imdbHtmlSampleStart = ' <!DOCTYPE html> <html     <head>';
const imdbHtmlSampleMiddle = ' </head> <body id="styleguide-v2" class="fixed">';
const imdbHtmlSampleEnd = ' </body> </html>';
const imdbHtmlSampleFull =
    '$imdbHtmlSampleStart $imdbJsonSampleInner $imdbHtmlSampleMiddle $imdbHtmlSampleInner $imdbHtmlSampleEnd';

Future<Stream<String>> streamImdbHtmlOfflineData(dynamic dummy) {
  return Future.value(emitImdbHtmlSample(dummy));
}

Stream<String> emitImdbHtmlSample(_) async* {
  yield imdbHtmlSampleFull;
}

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
/* To update this data run
       print(actualResult.toListOfDartJsonStrings(excludeCopyrightedData:false));
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt6123456","source":"DataSourceType.imdb","title":"Scott And Sharlene","alternateTitle":"Aussieland","type":"MovieContentType.series","year":"1985","yearRange":"1985-2023","runTime":"1234","languages":"[]",
      "genres":"[\"Horror\",\"Romance\"]",
      "keywords":"[\"exorcism\",\"boxer\",\"chihuahua\"]",
      "languages":"[\"English\"]",
      "description":"Then Kramer said, \"Everybody is Mescalon Smoochington\".","userRating":"7.5","userRatingCount":"5123","censorRating":"CensorRatingType.family","imageUrl":"https://www.microsoft.com/images/M/MV5BYjAxMz.jpg",
  "related":{"Cast:":{"nm0012370":{"uniqueId":"nm0012370","source":"DataSourceType.imdb","title":"Bill Jole","alternateTitle":" ","charactorName":" [Willy Rutter, Jimmy Banter]","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://www.microsoft.com/images/M/MV5BM.jpg","related":{}},
      "nm0012372":{"uniqueId":"nm0012372","source":"DataSourceType.imdb","title":"Jenny Jole","alternateTitle":" ","charactorName":" [Jilly Rutter, Jenny Banter]","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://www.microsoft.com/images/M/MV5BY.jpg","related":{}}},
    "Directed by:":{"nm0214370":{"uniqueId":"nm0214370","source":"DataSourceType.imdb","title":"Andy Jole","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://www.microsoft.com/images/M/M2V5BM.jpg","related":{}},
      "nm0214372":{"uniqueId":"nm0214372","source":"DataSourceType.imdb","title":"Shazza Jole","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://www.microsoft.com/images/M/M2V5BY.jpg","related":{}}},
    "Suggestions:":{"tt0012370":{"uniqueId":"tt0012370","source":"DataSourceType.imdb","title":"Walk Skip Run","alternateTitle":"Run Forrest Run","type":"MovieContentType.movie","year":"1973","yearRange":"1973","runTime":"7140","languages":"[]",
      "genres":"[\"Western\",\"Romance\"]","keywords":"[]","userRating":"8.6","userRatingCount":"4837","censorRating":"CensorRatingType.family","imageUrl":"https://www.microsoft.com/images/M/MV5BM.jpg","related":{}},
      "tt0123580":{"uniqueId":"tt0123580","source":"DataSourceType.imdb","title":"Scott And Sharlene","alternateTitle":"Aussieland","type":"MovieContentType.series","year":"1985","yearRange":"1985-2023","runTime":"1234","languages":"[]",
      "genres":"[\"Horror\",\"Romance\"]","keywords":"[]","userRating":"7.5","userRatingCount":"5123","censorRating":"CensorRatingType.family","imageUrl":"https://www.microsoft.com/images/M/MV5BYjAxMz.jpg","related":{}}}}}
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
          'titleText': {'text': 'Scott And Sharlene'},
          'titleType': {'text': 'TV Series'},
          'primaryImage': {
            'url': 'https://www.microsoft.com/images/M/MV5BYjAxMz.jpg'
          },
          'ratingsSummary': {'aggregateRating': 7.5, 'voteCount': 5123},
          'releaseYear': {'year': 1985, 'endYear': 2023},
          'runtime': {'seconds': 1234},
          'genres': {
            'genres': [
              {'text': 'Horror'},
              {'text': 'Romance'}
            ]
          },
          'keywords': {
            'edges': [
              {
                'node': {'text': 'exorcism'}
              },
              {
                'node': {'text': 'boxer'}
              },
              {
                'node': {'text': 'chihuahua'}
              }
            ]
          },
          'plot': {
            'plotText': {
              'plainText':
                  'Then Kramer said, "Everybody is Mescalon Smoochington".'
            }
          }
        },
        'mainColumnData': {
          'spokenLanguages': {
            'spokenLanguages': [
              {'text': 'English'}
            ]
          },
          'cast': {
            'edges': [
              {
                'node': {
                  'characters': [
                    {'name': 'Willy Rutter'},
                    {'name': 'Jimmy Banter'}
                  ],
                  'name': {
                    'id': 'nm0012370',
                    'nameText': {'text': 'Bill Jole'},
                    'primaryImage': {
                      'url': 'https://www.microsoft.com/images/M/MV5BM.jpg'
                    }
                  }
                }
              },
              {
                'node': {
                  'characters': [
                    {'name': 'Jilly Rutter'},
                    {'name': 'Jenny Banter'}
                  ],
                  'name': {
                    'id': 'nm0012372',
                    'nameText': {'text': 'Jenny Jole'},
                    'primaryImage': {
                      'url': 'https://www.microsoft.com/images/M/MV5BY.jpg'
                    }
                  }
                }
              }
            ]
          },
          'directors': [
            {
              'credits': [
                {
                  'name': {
                    'id': 'nm0214370',
                    'nameText': {'text': 'Andy Jole'},
                    'primaryImage': {
                      'url': 'https://www.microsoft.com/images/M/M2V5BM.jpg'
                    }
                  }
                },
                {
                  'name': {
                    'id': 'nm0214372',
                    'nameText': {'text': 'Shazza Jole'},
                    'primaryImage': {
                      'url': 'https://www.microsoft.com/images/M/M2V5BY.jpg'
                    }
                  }
                }
              ]
            }
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
                    'url': 'https://www.microsoft.com/images/M/MV5BM.jpg'
                  },
                  'ratingsSummary': {'aggregateRating': 8.6, 'voteCount': 4837},
                  'releaseYear': {'year': 1973, 'endYear': null},
                  'runtime': {'seconds': 7140},
                  'titleCardGenres': {
                    'genres': [
                      {'text': 'Western'},
                      {'text': 'Romance'}
                    ]
                  }
                }
              },
              {
                'node': {
                  'id': 'tt0123580',
                  'certificate': {'rating': 'TV-G'},
                  'originalTitleText': {'text': 'Aussieland'},
                  'titleText': {'text': 'Scott And Sharlene'},
                  'titleType': {'text': 'TV Series'},
                  'primaryImage': {
                    'url': 'https://www.microsoft.com/images/M/MV5BYjAxMz.jpg'
                  },
                  'ratingsSummary': {'aggregateRating': 7.5, 'voteCount': 5123},
                  'releaseYear': {'year': 1985, 'endYear': 2023},
                  'runtime': {'seconds': 1234},
                  'titleCardGenres': {
                    'genres': [
                      {'text': 'Horror'},
                      {'text': 'Romance'}
                    ]
                  }
                }
              }
            ]
          }
        }
      }
    }
  }
];

const _embeddedJson = r'''
    {
  "props": {
    "pageProps": {
      "tconst": "tt6123456",
      "aboveTheFold": {
        "id": "tt6123456",
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
                "releaseYear": {"year": 1973, "endYear": null},
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
}
''';
