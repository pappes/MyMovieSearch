import 'dart:convert';

// Raw data in code is generated from an external source.
// ignore_for_file: prefer_single_quotes

//query string https://www.imdb.com/title/tt0106977/fullcredits?ref_=tt_ov_st_sm

const _imdbHtmlSampleStart = ' <!DOCTYPE html> <html     <head>';
const _imdbHtmlSampleMiddle =
    ' </head> <body id="styleguide-v2" class="fixed">';
const _imdbHtmlSampleEnd = ' </body> </html>';
final imdbHtmlSampleFull =
    '$_imdbHtmlSampleStart $_imdbJsonSampleInner '
    '$_imdbHtmlSampleMiddle $_imdbHtmlSampleInner $_imdbHtmlSampleEnd';
final _imdbJsonSampleInner =
    '''
<script type="application/json">$_embeddedJson</script>
''';
const _imdbHtmlSampleInner = '';

final String _embeddedJson = jsonEncode(intermediateMapList.first);

/// The map list is intentionally left untyped so that the
/// test can demonstrate the parsing of the raw JSON.
// ignore: specify_nonobvious_property_types
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
