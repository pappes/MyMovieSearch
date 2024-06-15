//query string https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&q=wonder&safe=off&key=<key>
//json format
//title = title (Year) - Source
//pagemap.metatags.pageid = unique key
//undefined = year
//pagemap.metatags.og:type = title type
//pagemap.metatags.og:image = image url
//pagemap.aggregaterating.ratingvalue = userRating
//pagemap.aggregaterating.ratingcount = userRatingCount

import 'dart:convert';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
// ignore_for_file: unnecessary_raw_strings

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
final expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0120193","title":"Stage Fright","bestSource":"DataSourceType.imdb","alternateTitle":"Страх сцены","type":"MovieContentType.short","year":"1997","yearRange":"1997","runTime":"720","language":"LanguageType.allEnglish",
      "languages":"[\"English\"]",
      "genres":"[\"Animation\",\"Short\",\"Drama\",\"Horror\"]",
      "keywords":"[\"human\",\"dog\",\"stop motion animation\",\"stop motion\",\"independent film\"]",
      "description":"A vaudevillian's act involving the juggling of dogs is no longer a hit. He and his partner must face a brutal villain and assorted obstacles in order to secure their future.",
      "userRating":"6.8","userRatingCount":"417","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWVmZGRiOGEtZTA2Yy00ZWRhLWFiNTgtODc4MWU1NjYxMTY0L2ltYWdlXkEyXkFqcGdeQXVyNzE5ODAxOTE@._V1_.jpg","sources":{"DataSourceType.imdb":"tt0120193"}}
''',
  r'''
{"uniqueId":"tt0192145","title":"Humdrum","bestSource":"DataSourceType.imdb","alternateTitle":"Скучища","type":"MovieContentType.short","year":"1999","yearRange":"1999","runTime":"420","language":"LanguageType.allEnglish",
      "languages":"[\"English\"]",
      "genres":"[\"Animation\",\"Short\",\"Comedy\"]",
      "keywords":"[\"shadow\",\"independent film\"]",
      "description":"Two very bored shadowy characters try to think of something to do--and end up playing \"Shadow Puppets.\"",
      "userRating":"6.7","userRatingCount":"429","imageUrl":"https://m.media-amazon.com/images/M/MV5BODM3ZDExNTUtMGQyZC00YWJlLWEyYzctZGZmOGIzOWQ5Zjc5XkEyXkFqcGdeQXVyNzg5OTk2OA@@._V1_.jpg","sources":{"DataSourceType.imdb":"tt0192145"}}
''',
];

final expectedErrorDTOList = ListDTOConversion.decodeList([
  '''
{
  "uniqueId": "-1", 
  "title": "Unknown MsSearch error - potential API change! type 'Null' is not a subtype of type 'Map<dynamic, dynamic>' in type cast {error: {code: 400, message: Request contains an invalid argument., errors: [{message: Request contains an invalid argument., domain: global, reason: badRequest}], status: INVALID_ARGUMENT}}"
}
'''
]);

final intermediateMapList = [jsonDecode(jsonSampleFull)];
final intermediateEmptyMapList = [jsonDecode(jsonSampleEmpty)];
final intermediateErrorMapList = [jsonDecode(jsonSampleError)];

const jsonSampleFull = ' $jsonSearchPrefix '
    '$jsonSearchInner $jsonSearchSuffix';

Future<Stream<String>> streamJsonOfflineData(_) =>
    Future.value(Stream.value(jsonSampleFull));

const jsonSearchPrefix = '[';
const jsonSearchSuffix = ']';
const jsonSampleError = '''
{
  "error": {
    "code": 400,
    "message": "Request contains an invalid argument.",
    "errors": [
      {
        "message": "Request contains an invalid argument.",
        "domain": "global",
        "reason": "badRequest"
      }
    ],
    "status": "INVALID_ARGUMENT"
  }
}
''';
const jsonSampleEmpty = ' $jsonSearchPrefix  $jsonSearchSuffix ';

const jsonSearchInner = r'''

    {
        "uniqueId": "tt0192145",
        "title": "Humdrum",
        "bestSource": "DataSourceType.imdb",
        "alternateTitle": "Скучища",
        "type": "MovieContentType.short",
        "year": "1999",
        "yearRange": "1999",
        "runTime": "420",
        "language": "LanguageType.allEnglish",
        "languages": "[\"English\"]",
        "genres": "[\"Animation\",\"Short\",\"Comedy\"]",
        "keywords": "[\"shadow\",\"independent film\"]",
        "description": "Two very bored shadowy characters try to think of something to do--and end up playing \"Shadow Puppets.\"",
        "userRating": "6.7",
        "userRatingCount": "429",
        "imageUrl": "https://m.media-amazon.com/images/M/MV5BODM3ZDExNTUtMGQyZC00YWJlLWEyYzctZGZmOGIzOWQ5Zjc5XkEyXkFqcGdeQXVyNzg5OTk2OA@@._V1_.jpg",
        "sources": {
            "DataSourceType.imdb": "tt0192145"
        },
        "related": {
            "Cast:": [
                {
                    "uniqueId": "nm0402973",
                    "title": "Moray Hunter",
                    "bestSource": "DataSourceType.imdbSuggestions",
                    "type": "MovieContentType.person",
                    "creditsOrder": "100",
                    "imageUrl": "https://m.media-amazon.com/images/M/MV5BZTM4ZjllYzQtMjRlZC00ZTY1LWFmNTQtZDFkZWU4MjM0NDE0XkEyXkFqcGdeQXVyNzE0MTg2MDM@._V1_.jpg",
                    "sources": {
                        "DataSourceType.imdbSuggestions": "nm0402973"
                    }
                },
                {
                    "uniqueId": "nm0229970",
                    "title": "Jack Docherty",
                    "bestSource": "DataSourceType.imdbSuggestions",
                    "type": "MovieContentType.person",
                    "creditsOrder": "99",
                    "imageUrl": "https://m.media-amazon.com/images/M/MV5BODQ1MTU1MTAtNGEwYS00MGM1LWJlYjYtZmQ4NWRlZTc3ZWMwXkEyXkFqcGdeQXVyNjUxMjc1OTM@._V1_.jpg",
                    "sources": {
                        "DataSourceType.imdbSuggestions": "nm0229970"
                    }
                }
            ],
            "Directed by:": [
                {
                    "uniqueId": "nm0668849",
                    "title": "Peter Peake",
                    "bestSource": "DataSourceType.imdbSuggestions",
                    "type": "MovieContentType.person",
                    "creditsOrder": "100",
                    "sources": {
                        "DataSourceType.imdbSuggestions": "nm0668849"
                    }
                }
            ],
            "Suggestions:": [
                {
                    "uniqueId": "tt1279499",
                    "title": "This Way Up",
                    "bestSource": "DataSourceType.imdbSuggestions",
                    "type": "MovieContentType.short",
                    "year": "2008",
                    "yearRange": "2008",
                    "runTime": "540",
                    "genres": "[\"Animation\",\"Short\"]",
                    "userRating": "6.9",
                    "userRatingCount": "1674",
                    "censorRating": "CensorRatingType.family",
                    "imageUrl": "https://m.media-amazon.com/images/M/MV5BNWU1YmZjZWQtN2RiMS00NDNiLWIzMzMtM2ZkZmJhNjg5YzViXkEyXkFqcGdeQXVyNDE5MTU2MDE@._V1_.jpg",
                    "sources": {
                        "DataSourceType.imdbSuggestions": "tt1279499"
                    }
                },
                {
                    "uniqueId": "tt0296874",
                    "title": "Strange Invaders",
                    "bestSource": "DataSourceType.imdbSuggestions",
                    "type": "MovieContentType.short",
                    "year": "2001",
                    "yearRange": "2001",
                    "runTime": "480",
                    "genres": "[\"Animation\",\"Short\",\"Comedy\"]",
                    "userRating": "6.4",
                    "userRatingCount": "659",
                    "imageUrl": "https://m.media-amazon.com/images/M/MV5BMTA2MzIzMzAyMjBeQTJeQWpwZ15BbWU4MDY5MjA5Mzcx._V1_.jpg",
                    "sources": {
                        "DataSourceType.imdbSuggestions": "tt0296874"
                    }
                }
            ]
        }
    },
    {
        "uniqueId": "tt0120193",
        "title": "Stage Fright",
        "bestSource": "DataSourceType.imdb",
        "alternateTitle": "Страх сцены",
        "type": "MovieContentType.short",
        "year": "1997",
        "yearRange": "1997",
        "runTime": "720",
        "language": "LanguageType.allEnglish",
        "languages": "[\"English\"]",
        "genres": "[\"Animation\",\"Short\",\"Drama\",\"Horror\"]",
        "keywords": "[\"human\",\"dog\",\"stop motion animation\",\"stop motion\",\"independent film\"]",
        "description": "A vaudevillian's act involving the juggling of dogs is no longer a hit. He and his partner must face a brutal villain and assorted obstacles in order to secure their future.",
        "userRating": "6.8",
        "userRatingCount": "417",
        "imageUrl": "https://m.media-amazon.com/images/M/MV5BOWVmZGRiOGEtZTA2Yy00ZWRhLWFiNTgtODc4MWU1NjYxMTY0L2ltYWdlXkEyXkFqcGdeQXVyNzE5ODAxOTE@._V1_.jpg"
    }

''';
