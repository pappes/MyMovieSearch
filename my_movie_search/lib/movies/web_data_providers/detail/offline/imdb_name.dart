import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

const imdbHtmlSampleStart = ' <!DOCTYPE html> <html     <head>';
const imdbHtmlSampleMiddle = ' </head> <body id="styleguide-v2" class="fixed">';
const imdbHtmlSampleEnd = ' </body> </html>';
const imdbHtmlSampleFull =
    '$imdbHtmlSampleStart $imdbJsonSampleInner $imdbHtmlSampleMiddle $imdbHtmlSampleInner $imdbHtmlSampleEnd';

Future<Stream<String>> streamImdbHtmlOfflineData(_) =>
    Future.value(Stream.value(imdbHtmlSampleFull));

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm0123456","bestSource":"DataSourceType.imdb","title":"Mescalon Smoochington <3","type":"MovieContentType.person","year":"1933","yearRange":"1933-1977","languages":"[]","genres":"[]","keywords":"[]",
      "description":"THen Kramer said, \"Everybody is Mescalon Smoochington\".","userRatingCount":"184","imageUrl":"https://www.microsoft.com/images/M/MV5BNjdhNz.jpg","sources":{"DataSourceType.imdb":"nm0123456"},
  "related":{"Actor":{"tt0012370":{"uniqueId":"tt0012370","bestSource":"DataSourceType.imdbSuggestions","title":"Walk Skip Run","alternateTitle":" Run Forrest Run","charactorName":" [Willy Rutter]","type":"MovieContentType.title","year":"1973","yearRange":"1973","runTime":"7140","languages":"[]",
      "genres":"[\"Western\",\"Romance\"]","keywords":"[]","userRating":"8.6","userRatingCount":"4837","imageUrl":"https://www.microsoft.com/images/M/MV5BM.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0012370"},"related":{}},
      "tt0123580":{"uniqueId":"tt0123580","bestSource":"DataSourceType.imdbSuggestions","title":"Scott And Sharlene","alternateTitle":" Aussieland","charactorName":" [Nom da Plume, Other Charactor]","type":"MovieContentType.short","year":"1985","yearRange":"1985-2023","runTime":"1234","languages":"[]",
      "genres":"[\"Horror\",\"Romance\"]","keywords":"[]","userRating":"7.5","userRatingCount":"5123","censorRating":"CensorRatingType.family","imageUrl":"https://www.microsoft.com/images/M/MV5BYjAxMz.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0123580"},"related":{}}}}}
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
        'nmconst': 'nm0123456',
        'aboveTheFold': {
          'id': 'nm0123456',
          'nameText': {'text': 'Mescalon Smoochington <3'},
          'primaryImage': {
            'url': 'https://www.microsoft.com/images/M/MV5BNjdhNz.jpg',
          },
          'bio': {
            'text': {
              'plainText':
                  'THen Kramer said, "Everybody is Mescalon Smoochington".',
            },
          },
          'birthDate': {
            'dateComponents': {'year': 1933},
          },
          'deathDate': {
            'dateComponents': {'year': 1977},
          },
          'meterRanking': {'currentRank': 184},
        },
        'mainColumnData': {
          'releasedPrimaryCredits': [
            {
              'category': {'text': 'Actor'},
              'credits': {
                'edges': [
                  {
                    'node': {
                      'category': {'text': 'Actor'},
                      'characters': [
                        {'name': 'Willy Rutter'},
                      ],
                      'title': {
                        'id': 'tt0012370',
                        'originalTitleText': {'text': 'Run Forrest Run'},
                        'titleText': {'text': 'Walk Skip Run'},
                        'titleType': {'text': 'Movie'},
                        'primaryImage': {
                          'url': 'https://www.microsoft.com/images/M/MV5BM.jpg',
                        },
                        'ratingsSummary': {
                          'aggregateRating': 8.6,
                          'voteCount': 4837,
                        },
                        'releaseYear': {'year': 1973, 'endYear': null},
                        'runtime': {'seconds': 7140},
                        'genres': {
                          'genres': [
                            {'text': 'Western'},
                            {'text': 'Romance'},
                          ],
                        },
                      },
                    },
                  },
                  {
                    'node': {
                      'category': {'text': 'Actress'},
                      'characters': [
                        {'name': 'Nom da Plume'},
                        {'name': 'Other Charactor'},
                      ],
                      'title': {
                        'id': 'tt0123580',
                        'certificate': {'rating': 'TV-G'},
                        'originalTitleText': {'text': 'Aussieland'},
                        'titleText': {'text': 'Scott And Sharlene'},
                        'titleType': {'text': 'TV Series'},
                        'primaryImage': {
                          'url':
                              'https://www.microsoft.com/images/M/MV5BYjAxMz.jpg',
                        },
                        'ratingsSummary': {
                          'aggregateRating': 7.5,
                          'voteCount': 5123,
                        },
                        'releaseYear': {'year': 1985, 'endYear': 2023},
                        'runtime': {'seconds': 1234},
                        'genres': {
                          'genres': [
                            {'text': 'Horror'},
                            {'text': 'Romance'},
                          ],
                        },
                      },
                    },
                  }
                ],
              },
            }
          ],
          'unreleasedPrimaryCredits': <void>[],
          'akas': {
            'edges': [
              {
                'node': {
                  'displayableProperty': {
                    'value': {'plainText': 'Spongebob'},
                  },
                },
              },
              {
                'node': {
                  'displayableProperty': {
                    'value': {'plainText': 'Squarepants'},
                  },
                },
              },
            ],
          },
        },
      },
    },
  }
];

const _embeddedJson = r'''
{"props":{"pageProps":{
      "nmconst": "nm0123456",
      "aboveTheFold": {
        "id": "nm0123456",
        "nameText": {"text": "Mescalon Smoochington \u003c3"},
        "primaryImage": {
          "url": "https://www.microsoft.com/images/M/MV5BNjdhNz.jpg"
        },
        "bio": {
          "text": {
            "plainText":
                "THen Kramer said, \"Everybody is Mescalon Smoochington\"."
          }
        },
        "birthDate": {
          "dateComponents": {"year": 1933}
        },
        "deathDate": {
          "dateComponents": {"year": 1977}
        },
        "meterRanking": {"currentRank": 184}
      },
      "mainColumnData": {
        "releasedPrimaryCredits": [
          {
            "category": {"text": "Actor"},
            "credits": {
              "edges": [
                {
                  "node": {
                    "category": {"text": "Actor"},
                    "characters": [
                      {"name": "Willy Rutter"}
                    ],
                    "title": {
                      "id": "tt0012370",
                      "originalTitleText": {"text": "Run Forrest Run"},
                      "titleText": {"text": "Walk Skip Run"},
                      "titleType": {"text": "Movie"},
                      "primaryImage": {
                        "url": "https://www.microsoft.com/images/M/MV5BM.jpg"
                      },
                      "ratingsSummary": {
                        "aggregateRating": 8.6,
                        "voteCount": 4837
                      },
                      "releaseYear": {"year": 1973, "endYear": null},
                      "runtime": {"seconds": 7140},
                      "genres": {
                        "genres": [
                          {"text": "Western"},
                          {"text": "Romance"}
                        ]
                      }
                    }
                  }
                },
                {
                  "node": {
                    "category": {"text": "Actress"},
                    "characters": [
                      {"name": "Nom da Plume"},
                      {"name": "Other Charactor"}
                    ],
                    "title": {
                      "id": "tt0123580",
                      "certificate": {"rating": "TV-G"},
                      "originalTitleText": {"text": "Aussieland"},
                      "titleText": {"text": "Scott And Sharlene"},
                      "titleType": {"text": "TV Series"},
                      "primaryImage": {
                        "url":
                            "https://www.microsoft.com/images/M/MV5BYjAxMz.jpg"
                      },
                      "ratingsSummary": {
                        "aggregateRating": 7.5,
                        "voteCount": 5123
                      },
                      "releaseYear": {"year": 1985, "endYear": 2023},
                      "runtime": {"seconds": 1234},
                      "genres": {
                        "genres": [
                          {"text": "Horror"},
                          {"text": "Romance"}
                        ]
                      }
                    }
                  }
                }
              ]
            }
          }
        ],
        "unreleasedPrimaryCredits": [],
        "akas": {
          "edges": [
            {
              "node": {
                "displayableProperty": {
                  "value": {"plainText": "Spongebob"}
                }
              }
            },
            {
              "node": {
                "displayableProperty": {
                  "value": {"plainText": "Squarepants"}
                }
              }
            }
          ]
        }
      }
    }
  }
}''';
