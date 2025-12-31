import 'dart:convert';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
// Raw data in code is generated from an external source.
// ignore_for_file: unnecessary_raw_strings
// ignore_for_file: prefer_single_quotes

//query string https://www.imdb.com/title/tt0106977/fullcredits?ref_=tt_ov_st_sm

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

const _imdbHtmlSampleStart = ' <!DOCTYPE html> <html     <head>';
const _imdbHtmlSampleMiddle =
    ' </head> <body id="styleguide-v2" class="fixed">';
const _imdbHtmlSampleEnd = ' </body> </html>';
final imdbHtmlSampleFull =
    '$_imdbHtmlSampleStart $_imdbJsonSampleInner '
    '$_imdbHtmlSampleMiddle $_imdbHtmlSampleInner $_imdbHtmlSampleEnd';
final _imdbJsonSampleInner = '''
<script type="application/json">$_embeddedJson</script>
''';
const _imdbHtmlSampleInner = '';

final _embeddedJson = jsonEncode(intermediateMapList.first);

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0106977","bestSource":"DataSourceType.imdbCast","type":"MovieContentType.movie","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjI3OGJmNGEtNzA1Yi00ZGQ1LWIzNDYtZGY3ZWUzY2VhMzA2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbCast":"tt0106977"},
  "related":{"Actor:":{"nm0000148":{"uniqueId":"nm0000148","title":"Harrison Ford","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY4Mjg0NjIxOV5BMl5BanBnXkFtZTcwMTM2NTI3MQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0000148"}}},
    "Actress:":{"nm0000688":{"uniqueId":"nm0000688","title":"Sela Ward","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0000688"}}},
    "Cast:":{"nm0398703":{"uniqueId":"nm0398703","title":"Rudolf Hrusínský","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY4Mjg0NjIxOV5BMl5BanBnXkFtZTcwMTM2NTI3MQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0398703"}}},
    "Directed by:":{"nm0001112":{"uniqueId":"nm0001112","title":"Andrew Davis","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjI3OGJmNGEtNzA1Yi00ZGQ1LWIzNDYtZGY3ZWUzY2VhMzA2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0001112"}}},
    "Writer:":{"nm0835732":{"uniqueId":"nm0835732","title":"Jeb Stuart","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTE4MDEzMmItZTAxMi00ZmFlLTliZmYtZGY5ODFkODA0ZDg2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0835732"}}},
    "writer:":{"nm0400403":{"uniqueId":"nm0400403","title":"Roy Huggins","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0400403"}},
      "nm0878638":{"uniqueId":"nm0878638","title":"David Twohy","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0878638"}}}}}
''',
];

const intermediateMapList = [
  {
    "props": {
      "pageProps": {
        "contentData": {
          "entityMetadata": {"id": "tt0106977"},
          "data": {
            "title": {
              "id": "tt0106977",
              "titleType": {"id": "movie", "text": "Movie"},
              "creditCategories": [
                {
                  "credits": {
                    "edges": [
                      {
                        "node": {
                          "category": {"id": "director", "text": "Director"},
                          "name": {
                            "id": "nm0001112",
                            "nameText": {"text": "Andrew Davis"},
                            "primaryImage": {
                              "url":
                                  "https://m.media-amazon.com/images/M/MV5BMjI3OGJmNGEtNzA1Yi00ZGQ1LWIzNDYtZGY3ZWUzY2VhMzA2XkEyXkFqcGc@._V1_.jpg",
                            },
                          },
                        },
                      },
                    ],
                  },
                },
                {
                  "category": {"id": "writer"},
                  "credits": {
                    "edges": [
                      {
                        "node": {
                          "category": {"id": "writer", "text": "Writer"},
                          "name": {
                            "id": "nm0835732",
                            "nameText": {"text": "Jeb Stuart"},
                            "primaryImage": {
                              "url":
                                  "https://m.media-amazon.com/images/M/MV5BNTE4MDEzMmItZTAxMi00ZmFlLTliZmYtZGY5ODFkODA0ZDg2XkEyXkFqcGc@._V1_.jpg",
                            },
                          },
                        },
                      },
                      {
                        "node": {
                          "category": {"id": "writer"},
                          "name": {
                            "id": "nm0878638",
                            "nameText": {"text": "David Twohy"},
                          },
                        },
                      },
                      {
                        "node": {
                          "category": {"id": "writer"},
                          "name": {
                            "id": "nm0400403",
                            "nameText": {"text": "Roy Huggins"},
                            "primaryImage": null,
                          },
                        },
                      },
                    ],
                  },
                },
                {
                  "category": {"id": "cast"},
                  "credits": {
                    "edges": [
                      {
                        "node": {
                          "category": {"id": "actor", "text": "Actor"},
                          "name": {
                            "id": "nm0000148",
                            "nameText": {"text": "Harrison Ford"},
                            "primaryImage": {
                              "url":
                                  "https://m.media-amazon.com/images/M/MV5BMTY4Mjg0NjIxOV5BMl5BanBnXkFtZTcwMTM2NTI3MQ@@._V1_.jpg",
                            },
                          },
                          "characters": [
                            {"name": "Dr. Richard Kimble"},
                            {"name": "Dic K"},
                          ],
                        },
                      },
                      {
                        "node": {
                          "category": {"id": "actress"},
                          "name": {
                            "id": "nm0000688",
                            "nameText": {"text": "Sela Ward"},
                          },
                          "characters": [
                            {"name": "Helen Kimble"},
                          ],
                        },
                      },
                    ],
                  },
                },
              ],
            },
          },
          "categories": [
            {
              "id": "cast",
              "name": "Cast",

              "section": {
                "items": [
                  {
                    "id": "nm0398703",
                    "rowTitle": "Rudolf Hrusínský",
                    "imageProps": {
                      "imageModel": {
                        "url":
                            "https://m.media-amazon.com/images/M/MV5BMTY4Mjg0NjIxOV5BMl5BanBnXkFtZTcwMTM2NTI3MQ@@._V1_.jpg",
                      },
                    },
                  },
                ],
              },
            },
          ],
        },
      },
    },
  },
];

Future<Stream<String>> streamImdbHtmlOfflineData(_) =>
    Future.value(Stream.value(imdbHtmlSampleFull));
