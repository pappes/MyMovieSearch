
const imdbHtmlSampleStart = ' <!DOCTYPE html> <html     <head>';
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
          'released': {
            'edges': [
              {
                'node': {
                  'credits': {
                    'edges': [
                      {
                        '__typename': 'CreditV2Edge',
                        'node': {
                          'creditedRoles': {
                            'edges': [
                              {
                                'node': {
                                  'category': {'text': 'Actor'},
                                  'characters': {
                                    'edges': [
                                      {
                                        'node': {'name': 'Willy Rutter'},
                                      },
                                    ],
                                  },
                                  'title': {
                                    'id': 'tt0012370',
                                    'originalTitleText': {
                                      'text': 'Run Forrest Run',
                                    },
                                    'titleText': {'text': 'Walk Skip Run'},
                                    'titleType': {'text': 'Movie'},
                                    'primaryImage': {
                                      'url':
                                          'https://www.microsoft.com/images/M/MV5BM.jpg',
                                    },
                                    'ratingsSummary': {
                                      'aggregateRating': 8.6,
                                      'voteCount': 4837,
                                    },
                                    'releaseYear': {
                                      'year': 1973,
                                      'endYear': null,
                                    },
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
                                  'characters': {
                                    'edges': [
                                      {
                                        'node': {'name': 'Nom da Plume'},
                                      },
                                      {
                                        'node': {'name': 'Other Character'},
                                      },
                                    ],
                                  },
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
                                    'releaseYear': {
                                      'year': 1985,
                                      'endYear': 2023,
                                    },
                                    'runtime': {'seconds': 1234},
                                    'genres': {
                                      'genres': [
                                        {'text': 'Horror'},
                                        {'text': 'Romance'},
                                      ],
                                    },
                                  },
                                },
                              },
                            ],
                          },
                        },
                      },
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
{
  "props": {
    "pageProps": {
      "nmconst": "nm0123456",
      "aboveTheFold": {
        "id": "nm0123456",
        "nameText": {
          "text": "Mescalon Smoochington \u003c3"
        },
        "primaryImage": {
          "url": "https://www.microsoft.com/images/M/MV5BNjdhNz.jpg"
        },
        "bio": {
          "text": {
            "plainText": "THen Kramer said, \"Everybody is Mescalon Smoochington\"."
          }
        },
        "birthDate": {
          "dateComponents": {
            "year": 1933
          }
        },
        "deathDate": {
          "dateComponents": {
            "year": 1977
          }
        },
        "meterRanking": {
          "currentRank": 184
        }
      },
      "mainColumnData": {
        "released": {
          "edges": [
            {
              "node": {
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "text": "Actor"
                                },
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Willy Rutter"
                                      }
                                    }
                                  ]
                                },
                                "title": {
                                  "id": "tt0012370",
                                  "originalTitleText": {
                                    "text": "Run Forrest Run"
                                  },
                                  "titleText": {
                                    "text": "Walk Skip Run"
                                  },
                                  "titleType": {
                                    "text": "Movie"
                                  },
                                  "primaryImage": {
                                    "url": "https://www.microsoft.com/images/M/MV5BM.jpg"
                                  },
                                  "ratingsSummary": {
                                    "aggregateRating": 8.6,
                                    "voteCount": 4837
                                  },
                                  "releaseYear": {
                                    "year": 1973,
                                    "endYear": null
                                  },
                                  "runtime": {
                                    "seconds": 7140
                                  },
                                  "genres": {
                                    "genres": [
                                      {
                                        "text": "Western"
                                      },
                                      {
                                        "text": "Romance"
                                      }
                                    ]
                                  }
                                }
                              }
                            },
                            {
                              "node": {
                                "category": {
                                  "text": "Actress"
                                },
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Nom da Plume"
                                      }
                                    },
                                    {
                                      "node": {
                                        "name": "Other Character"
                                      }
                                    }
                                  ]
                                },
                                "title": {
                                  "id": "tt0123580",
                                  "certificate": {
                                    "rating": "TV-G"
                                  },
                                  "originalTitleText": {
                                    "text": "Aussieland"
                                  },
                                  "titleText": {
                                    "text": "Scott And Sharlene"
                                  },
                                  "titleType": {
                                    "text": "TV Series"
                                  },
                                  "primaryImage": {
                                    "url": "https://www.microsoft.com/images/M/MV5BYjAxMz.jpg"
                                  },
                                  "ratingsSummary": {
                                    "aggregateRating": 7.5,
                                    "voteCount": 5123
                                  },
                                  "releaseYear": {
                                    "year": 1985,
                                    "endYear": 2023
                                  },
                                  "runtime": {
                                    "seconds": 1234
                                  },
                                  "genres": {
                                    "genres": [
                                      {
                                        "text": "Horror"
                                      },
                                      {
                                        "text": "Romance"
                                      }
                                    ]
                                  }
                                }
                              }
                            }
                          ]
                        }
                      }
                    }
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
