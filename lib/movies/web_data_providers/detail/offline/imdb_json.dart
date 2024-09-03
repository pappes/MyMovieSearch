//query string https://www.imdb.com/title/tt0106977/fullcredits?ref_=tt_ov_st_sm
// ignore_for_file: unnecessary_raw_strings

import 'dart:convert';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm1913125","title":"Raman Rodger","bestSource":"DataSourceType.imdbJson","imageUrl":"https://m.media-amazon.com/images/M/MV5BNWMyMGQxZVyNTAyNTY1NA@@._V1_CR243,0,986,1479_.jpg","sources":{"DataSourceType.imdbJson":"nm1913125"},
  "related":{"Actor":{"tt11123818":{"uniqueId":"tt11123818","title":"Our Tupple","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2002","yearRange":"2002",
      "genres":"[\"Drama\"]",
      "userRating":"6.7","userRatingCount":"8","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTE0NWNhZGdeQXVyMTY1ODE1NTk@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt11123818"}},
      "tt11812323":{"uniqueId":"tt11812323","title":"lilly","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","charactorName":" [Jacob]","type":"MovieContentType.movie","year":"2002","yearRange":"2002","runTime":"5123",
      "genres":"[\"Horror\"]",
      "userRating":"7.5","userRatingCount":"2123","imageUrl":"https://m.media-amazon.com/images/M/MV5BNWFhNcGdeQXVyMTcyODY0OTE@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt11812323"}},
      "tt17512392":{"uniqueId":"tt17512392","title":"Willman Tryer","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","charactorName":" [Willman Tryer]","type":"MovieContentType.episode","year":"2003","yearRange":"2003","runTime":"2123",
      "genres":"[\"Crime\",\"Drama\"]",
      "userRating":"3.3","userRatingCount":"11235","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjZhZWMwNTMmVmXkEyXkFqcGdeQXVyMTY0Njc2MTUx._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt17512392"}}}}}
''',
];

Future<Stream<String>> streamImdbHtmlOfflineFilteredData(_) =>
    Future.value(Stream.value(jsonEncode(imdbJsonSample)));

Future<Stream<String>> streamImdbHtmlOfflinePaginatedData(_) =>
    Future.value(Stream.value(jsonEncode(imdbJsonSample)));

const imdbJsonSample = {
  'data': {
    'name': imdbJsonInnerSample,
  },
};
const imdbJsonInnerSample = {
  'id': 'nm1913125',
  'nameText': {'text': 'Raman Rodger'},
  'primaryImage': {
    'caption': {'plainText': 'Raman Rodger'},
    'height': 1479,
    'width': 986,
    'url':
        'https://m.media-amazon.com/images/M/MV5BNWMyMGQxZVyNTAyNTY1NA@@._V1_CR243,0,986,1479_.jpg',
  },
  'actor_credits': {
    'total': 3,
    'edges': [
      {
        'node': {
          'attributes': null,
          'category': {'id': 'actor', 'text': 'Actor'},
          'characters': [
            {'name': 'Willman Tryer'},
          ],
          'episodeCredits': {
            'total': 23,
            'yearRange': {'year': 2023, 'endYear': 2024},
            'displayableYears': {
              'total': 2,
              'edges': [
                {
                  'node': {
                    'year': '2003',
                    'displayableProperty': {
                      'value': {'plainText': '2003'},
                    },
                  },
                },
              ],
            },
          },
          'title': {
            'id': 'tt17512392',
            'canRate': {'isRatable': true},
            'certificate': {'rating': 'TV-14'},
            'originalTitleText': {'text': 'Willman Tryer'},
            'titleText': {'text': 'Willman Tryer'},
            'titleType': {
              'canHaveEpisodes': true,
              'displayableProperty': {
                'value': {'plainText': 'TV Series'},
              },
              'text': 'TV Series',
              'id': 'tvSeries',
            },
            'primaryImage': {
              'url':
                  'https://m.media-amazon.com/images/M/MV5BNjZhZWMwNTMmVmXkEyXkFqcGdeQXVyMTY0Njc2MTUx._V1_.jpg',
              'height': 1351,
              'width': 1080,
              'caption': {
                'plainText': 'Raman Rodger in Willman Tryer (2003)',
              },
            },
            'ratingsSummary': {'aggregateRating': 3.3, 'voteCount': 11235},
            'releaseYear': {'year': 2003, 'endYear': null},
            'runTime': {'seconds': 2123},
            'series': null,
            'titleGenres': {
              'genres': [
                {
                  'genre': {'text': 'Crime'},
                },
                {
                  'genre': {'text': 'Drama'},
                }
              ],
            },
          },
        },
      },
      {
        'node': {
          'attributes': [
            {'text': 'as Raman Rodger'},
          ],
          'category': {'id': 'actor', 'text': 'Actor'},
          'characters': [
            {'name': 'Jacob'},
          ],
          'title': {
            'id': 'tt11812323',
            'canRate': {'isRatable': true},
            'certificate': null,
            'originalTitleText': {'text': 'lilly'},
            'titleText': {'text': 'lilly'},
            'titleType': {
              'canHaveEpisodes': false,
              'displayableProperty': {
                'value': {'plainText': ''},
              },
              'text': 'Movie',
              'id': 'movie',
            },
            'primaryImage': {
              'url':
                  'https://m.media-amazon.com/images/M/MV5BNWFhNcGdeQXVyMTcyODY0OTE@._V1_.jpg',
              'height': 2560,
              'width': 1728,
              'caption': {'plainText': 'lilly (2002)'},
            },
            'ratingsSummary': {'aggregateRating': 7.5, 'voteCount': 2123},
            'releaseYear': {'year': 2002, 'endYear': null},
            'runTime': {'seconds': 5123},
            'series': null,
            'titleGenres': {
              'genres': [
                {
                  'genre': {'text': 'Horror'},
                }
              ],
            },
          },
        },
      },
      {
        'node': {
          'attributes': [
            {'text': 'as Raman Rodger'},
          ],
          'category': {'id': 'actor', 'text': 'Actor'},
          'characters': null,
          'title': {
            'id': 'tt11123818',
            'certificate': null,
            'originalTitleText': {'text': 'Our Tupple'},
            'titleText': {'text': 'Our Tupple'},
            'titleType': {
              'canHaveEpisodes': false,
              'displayableProperty': {
                'value': {'plainText': 'TV Movie'},
              },
              'text': 'TV Movie',
              'id': 'tvMovie',
            },
            'primaryImage': {
              'url':
                  'https://m.media-amazon.com/images/M/MV5BNTE0NWNhZGdeQXVyMTY1ODE1NTk@._V1_.jpg',
              'height': 2304,
              'width': 1728,
              'caption': {'plainText': 'Our Tupple (2002)'},
            },
            'ratingsSummary': {'aggregateRating': 6.7, 'voteCount': 8},
            'releaseYear': {'year': 2002, 'endYear': null},
            'runTime': null,
            'series': null,
            'titleGenres': {
              'genres': [
                {
                  'genre': {'text': 'Drama'},
                }
              ],
            },
          },
        },
      }
    ],
  },
};
