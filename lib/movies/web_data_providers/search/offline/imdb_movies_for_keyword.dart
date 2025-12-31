// Raw data in code is generated from an external source.
// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

const imdbHtmlSampleStart = ' <!DOCTYPE html>    <head>';
const imdbHtmlSampleMiddle = ' </head> <body id="styleguide-v2" class="fixed">';
const imdbHtmlSampleEnd = ' </body> </html>';
const imdbHtmlSampleFull =
    '$imdbHtmlSampleStart $imdbJsonSampleInner '
    '$imdbHtmlSampleMiddle $imdbHtmlSampleEnd';
const imdbJsonSampleInner = '''
<script type="application/json">$_embeddedJson</script>
''';

const imdbHtmlSampleEmpty =
    '$imdbHtmlSampleStart $imdbJsonEmptySampleInner '
    '$imdbHtmlSampleMiddle $imdbHtmlSampleEnd';
const imdbJsonEmptySampleInner = '''
<script type="application/json">$_embeddedEmptyJson</script>
''';

Future<Stream<String>> streamImdbKeywordsHtmlOfflineData(_) =>
    Future.value(Stream.value(imdbHtmlSampleFull));

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0012336","title":"Pwin Tweaks","bestSource":"DataSourceType.imdbKeywords","alternateTitle":"Pwin Tweakers","type":"MovieContentType.series","year":"1990","yearRange":"1990-1991","runTime":"5000",
      "genres":"[\"Crime\",\"Drama\",\"Mystery\"]",
      "description":"A person does a thing.",
      "userRating":"4.8","userRatingCount":"21186","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTEx...TczOTIx._V1_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0012336"}}
''',
  r'''
{"uniqueId":"tt1123256","title":"Darlingly","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2022","yearRange":"2022","runTime":"6780",
      "genres":"[\"Drama\",\"Mystery\",\"Thriller\"]",
      "description":"While leaves in a question.",
      "userRating":"5.3","userRatingCount":"15339","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzFkMWUzM2ItZ...yNTAzNzgwNTg@._V1_.jpg","sources":{"DataSourceType.imdbKeywords":"tt1123256"}}
''',
];

const intermediateEmptyMapList = [
  {
    'props': {
      'pageProps': {
        'searchResults': {
          'titleResults': {'titleListItems': <dynamic>[], 'total': 0},
        },
      },
    },
  },
];

const intermediateMapList = [
  {
    'props': {
      'pageProps': {
        'searchResults': {
          'titleResults': {
            'titleListItems': [
              {
                'certificate': 'TV-MA',
                'creators': <dynamic>[],
                'directors': <dynamic>[],
                'endYear': 1991,
                'genres': ['Crime', 'Drama', 'Mystery'],
                'originalTitleText': 'Pwin Tweakers',
                'plot': 'A person does a thing.',
                'primaryImage': {
                  'url':
                      'https://m.media-amazon.com/images/M/MV5BMTEx...TczOTIx._V1_.jpg',
                },
                'ratingSummary': {'aggregateRating': 4.8, 'voteCount': 21186},
                'releaseYear': 1990,
                'runtime': 5000,
                'titleId': 'tt0012336',
                'titleText': 'Pwin Tweaks',
                'titleType': {'id': 'tvSeries', 'text': 'TV Series'},
              },
              {
                'certificate': 'R',
                'endYear': null,
                'genres': ['Drama', 'Mystery', 'Thriller'],
                'originalTitleText': 'Darlingly',
                'plot': 'While leaves in a question.',
                'primaryImage': {
                  'url':
                      'https://m.media-amazon.com/images/M/MV5BMzFkMWUzM2ItZ...yNTAzNzgwNTg@._V1_.jpg',
                },
                'ratingSummary': {'aggregateRating': 5.3, 'voteCount': 15339},
                'releaseYear': 2022,
                'runtime': 6780,
                'titleId': 'tt1123256',
                'titleText': 'Darlingly',
                'titleType': {'id': 'movie', 'text': ''},
              },
            ],
            'total': 2,
          },
        },
      },
    },
  },
];

const _embeddedEmptyJson = r'''
{
  "props": {"pageProps": {"searchResults": {
        "titleResults": {
          "titleListItems": [
          ],
          "total": 0
        }
      }
    }
  }
}''';

const _embeddedJson = r'''
{"props":{"pageProps":{"searchResults": {
        "titleResults": {
          "titleListItems": [
            {
              "certificate": "TV-MA",
              "creators": [],
              "directors": [],
              "endYear": 1991,
              "genres": [
                "Crime",
                "Drama",
                "Mystery"
              ],
              "originalTitleText": "Pwin Tweakers",
              "plot": "A person does a thing.",
              "primaryImage": {
                "url": "https://m.media-amazon.com/images/M/MV5BMTEx...TczOTIx._V1_.jpg"
              },
              "ratingSummary": {
                "aggregateRating": 4.8,
                "voteCount": 21186
              },
              "releaseYear": 1990,
              "runtime": 5000,
              "titleId": "tt0012336",
              "titleText": "Pwin Tweaks",
              "titleType": {
                "id": "tvSeries",
                "text": "TV Series"
              }
            },
            {
              "certificate": "R",
              "endYear": null,
              "genres": [
                "Drama",
                "Mystery",
                "Thriller"
              ],
              "originalTitleText": "Darlingly",
              "plot": "While leaves in a question.",
              "primaryImage": {
                "url": "https://m.media-amazon.com/images/M/MV5BMzFkMWUzM2ItZ...yNTAzNzgwNTg@._V1_.jpg"
              },
              "ratingSummary": {
                "aggregateRating": 5.3,
                "voteCount": 15339
              },
              "releaseYear": 2022,
              "runtime": 6780,
              "titleId": "tt1123256",
              "titleText": "Darlingly",
              "titleType": {
                "id": "movie",
                "text": ""
              }
            }
          ],
          "total": 2
        }
      }
    }
  }
}''';
