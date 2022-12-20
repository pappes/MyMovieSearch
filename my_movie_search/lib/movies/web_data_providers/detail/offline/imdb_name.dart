//query string https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=wonder%20woman

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

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

/* To update this data run
       print(actualResult.toListOfDartJsonStrings(excludeCopyrightedData:false));
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm0123456","source":"DataSourceType.imdbSearch","title":"Mescalon Smoochington","type":"MovieContentType.person","year":"1933","yearRange":"1933-1977","languages":"[]","genres":"[]","keywords":"[]",
      "description":"THen Kramer said, \"Everybody is Mescalon Smoochington\".","userRatingCount":"184","imageUrl":"https://www.microsoft.com/images/M/MV5BNjdhNz.jpg",
  "related":{"Actor":{"tt0012370":{"uniqueId":"tt0012370","source":"DataSourceType.imdbSearch","title":"Walk Skip Run","alternateTitle":" [Willy Rutter]  Run Forrest Run","type":"MovieContentType.movie","year":"1973","yearRange":"1973-null","runTime":"7140","languages":"[]",
      "genres":"[\"Western\"]","keywords":"[]","userRating":"8.6","userRatingCount":"4837","imageUrl":"https://www.microsoft.com/images/M/MV5BM.jpg","related":{}}}}}
''',
];

const imdbJsonSampleInner = '''
<script type="application/json">$_embeddedJson</script>
''';
const imdbHtmlSampleInner = '';

const _imdbJsonSampleInner = '''
<script type="application/ld+json">{
  "@context": "http://schema.org",
  "@type": "Person",
  "url": "/name/nm0004376/",
  "name": "Franka Potente",
  "image": "https://m.media-amazon.com/images/M/MV5BNTY3ODYyNjU0NV5BMl5BanBnXkFtZTcwNDMxNDE3OA@@._V1_.jpg",
  "jobTitle": [
    "Actress",
    "Soundtrack",
    "Director"
  ],
  "description": "Franka Potente was born on 22 July 1974 in the German city of Münster, to Hildegard, a medical assistant, and Dieter Potente, a teacher, and raised in the nearby town of Dülmen. After her graduation in 1994, she went to the Otto-Falckenberg-Schule, a drama school in Munich, but soon broke off to study at the Lee Strasberg Theatre Institute in New ...",
  "birthDate": "1974-07-22"
}</script>
''';
const _imdbHtmlSampleInner = r'''
        <table cellspacing="0" cellpadding="0" border="0" id="name-overview-widget-layout">
            <tbody>
                <tr>
                    <td class="name-overview-widget__section">
                      <h1 class="header"> <span class="itemprop">Franka Potente</span>
                      </h1>
                          <hr/>
                    </td>
                </tr>
                <tr>
                    <td id="img_primary">
                        <div class="poster-hero-container">
                                <div class="image">
                                    <a href="/name/nm0004376/mediaviewer/rm1767485184?ref_=nm_ov_ph"
                                      > <img id="name-poster"
                                      height="317"
                                      width="214"
                                      alt="Franka Potente Picture"
                                      title="Franka Potente Picture"
                                      src="https://m.media-amazon.com/images/M/MV5BNTY3ODYyNjU0NV5BMl5BanBnXkFtZTcwNDMxNDE3OA@@._V1_UY317_CR5,0,214,317_AL_.jpg" />
                                    </a>
                                </div> 

                                <div class="heroWidget">
                                    <figure class="slate">
                                      <a href="/video/imdb/vi413448985?playlistId=nm0004376&ref_=nm_ov_vi"
                                        class="slate_button prevent-ad-overlay video-modal" data-type='recommends' data-nconst='nm0004376' data-video='vi413448985' data-context='imdb' data-refsuffix='nm_ov_vi' data-pixels=''> <img alt="Trailer"
                                        title="Trailer"
                                        src="https://m.media-amazon.com/images/M/MV5BMDE1Yzc2NGQtZGIyNS00NDIzLWJlMjQtNTc5MDRhYjQ4MzgyXkEyXkFqcGdeQXRodW1ibmFpbC1pbml0aWFsaXplcg@@._V1_UX477_CR0,0,477,268_AL_.jpg" />
                                      </a>            <figcaption class="caption">
                                      <div>2:01 <span class="ghost">|</span> Trailer</div>
                                          <div >        <a href="/name/nm0004376/videogallery?ref_=nm_ov_vi_sm"
                                            >17 VIDEOS</a>
                                                <span class="ghost">|</span>        <a href="/name/nm0004376/mediaindex?ref_=nm_ov_mi_sm"
                                            >126 IMAGES</a>
                                          </div>
                                        </figcaption>
                                    </figure>
                                </div>
                        </div>
                    </td>
                </tr>
        </table>

    <div id="filmography">
      <div id="filmo-head-actress" class="head" data-category="actress" onclick="toggleFilmoCategory(this);">
        <span id="hide-actress" class="hide-link"
        >Hide&nbsp;<img src="https://m.media-amazon.com/images/S/sash/5o6LtZOQM$gRIYv.png" class="absmiddle" alt="Hide" width="18" height="16"></span>
        <span id="show-actress" class="show-link"
        >Show&nbsp;<img src="https://m.media-amazon.com/images/S/sash/OPcpIfkmvSt2$q1.png" class="absmiddle" alt="Show" width="18" height="16"></span>
        <a name="actress">Actress</a> (57 credits)
      </div>
      <div class="filmo-category-section"
        >
        <div class="filmo-row odd" id="actress-tt3520738">
          <span class="year_column">
            &nbsp;
          </span>
          <b><a href="/title/tt3520738/?ref_=nm_flmg_act_1">
    Blanco
            </a></b>
    (TV Movie)
          <br/>
    Leslee
        </div>
        <div class="filmo-row even" id="actress-tt10933008">
          <span class="year_column">
            &nbsp;2019
          </span>
          <b><a href="/title/tt10933008/?ref_=nm_flmg_act_2">
    The Haunted Swordsman</a></b>
    (Short)
          <br/>
    The Onibaba Witch
        </div>
      </div>
    </div>

''';

const intermediateMapList = [
  {
    'props': {
      'pageProps': {
        'nmconst': 'nm0123456',
        'aboveTheFold': {
          'id': 'nm0123456',
          'nameText': {'text': 'Mescalon Smoochington'},
          'primaryImage': {
            'url': 'https://www.microsoft.com/images/M/MV5BNjdhNz.jpg'
          },
          'bio': {
            'text': {
              'plainText':
                  'THen Kramer said, "Everybody is Mescalon Smoochington".'
            }
          },
          'birthDate': {
            'dateComponents': {'year': 1933}
          },
          'deathDate': {
            'dateComponents': {'year': 1977}
          },
          'meterRanking': {'currentRank': 184}
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
                        {'name': 'Willy Rutter'}
                      ],
                      'title': {
                        'id': 'tt0012370',
                        'originalTitleText': {'text': 'Run Forrest Run'},
                        'titleText': {'text': 'Walk Skip Run'},
                        'titleType': {'text': 'Movie'},
                        'primaryImage': {
                          'url': 'https://www.microsoft.com/images/M/MV5BM.jpg'
                        },
                        'ratingsSummary': {
                          'aggregateRating': 8.6,
                          'voteCount': 4837
                        },
                        'releaseYear': {'year': 1973, 'endYear': null},
                        'runtime': {'seconds': 7140},
                        'genres': {
                          'genres': [
                            {'text': 'Western'},
                            {'text': 'Romance'}
                          ]
                        }
                      }
                    }
                  },
                  {
                    'node': {
                      'category': {'text': 'Actress'},
                      'characters': [
                        {'name': 'Nom da Plume'},
                        {'name': 'Other Charactor'}
                      ],
                      'title': {
                        'id': 'tt0123580',
                        'certificate': {'rating': 'TV-G'},
                        'originalTitleText': {'text': 'Aussieland'},
                        'titleText': {'text': 'Scott And Sharlene'},
                        'titleType': {'text': 'TV Series'},
                        'primaryImage': {
                          'url':
                              'https://www.microsoft.com/images/M/MV5BYjAxMz.jpg'
                        },
                        'ratingsSummary': {
                          'aggregateRating': 7.5,
                          'voteCount': 5123
                        },
                        'releaseYear': {'year': 1985, 'endYear': 2023},
                        'runtime': {'seconds': 1234},
                        'genres': {
                          'genres': [
                            {'text': 'Horror'},
                            {'text': 'Romance'}
                          ]
                        }
                      }
                    }
                  }
                ]
              }
            }
          ],
          'unreleasedPrimaryCredits': [],
          'akas': {
            'edges': [
              {
                'node': {
                  'displayableProperty': {
                    'value': {'plainText': 'Spongebob'}
                  }
                }
              },
              {
                'node': {
                  'displayableProperty': {
                    'value': {'plainText': 'Squarepants'}
                  }
                }
              }
            ]
          }
        }
      }
    },
    'datePublished': '',
    'yearRange': '-',
    'source': DataSourceType.imdb,
    'id': 'nm0123456',
    'related': {},
    '@type': MovieContentType.person
  }
];

const _embeddedJson = r'''
{
  "props": {
    "pageProps": {
      "nmconst": "nm0123456",
      "aboveTheFold": {
        "id": "nm0123456",
        "nameText": {"text": "Mescalon Smoochington"},
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
}
''';
