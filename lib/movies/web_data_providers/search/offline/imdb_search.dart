import 'package:my_movie_search/movies/domain/models/movie_result_enums.dart';

Future<Stream<String>> streamImdbSearchHtmlOfflineData(_) =>
    Future.value(Stream.value(htmlSampleFull));

Future<Stream<String>> emitEmptyImdbSearchSample(_) =>
    Future.value(Stream.value(htmlSampleEmpty));

const htmlSampleEmpty =
    '$htmlSampleStart$imdbSearchJsonSampleEmpty$htmlSampleEnd';
const imdbSearchJsonSampleEmpty =
    '{"props":{"pageProps":{"nameResults":{"results":[]},'
    '"titleResults":{"results":[],"hasExactMatches":false},'
    '"companyResults":{"results":[]},"keywordResults":{"results":[]}}}}';

const htmlSampleError = '$htmlSampleStart$htmlSampleEnd';
const htmlSampleFull = '$htmlSampleStart$imdbSampleJson$htmlSampleEnd';
const htmlSampleStart = '''
<!DOCTYPE html>
<html
    xmlns:snip=true>
    </snip>
  <body id="styleguide-v2" class="fixed">
  <script id="__NEXT_DATA__" type="application/json">''';
const htmlSampleEnd = '''
</script>
    <div id="wrapper">
    </div>
  </body>
</html>
''';

const List<Map<String, Object?>> intermediateMapList = [
  {
    'id': 'nm0152436',
    'name': 'Hye NDace',
    'image': 'https://www.microsoft.com/gx@.jpg',
    'description': 'known for Superman(1994)',
    '@type': MovieContentType.person,
  },
  {
    'id': 'nm2122834',
    'name': 'ifdhKoliHeDene Her',
    'image': 'https://www.microsoft.com/k0MTRlNmU@.jpg',
    'description': 'known for Catwoman!(1993- )',
    '@type': MovieContentType.person,
  },
  {
    'id': 'nm5122134',
    'name': 'nrnKge K-sDHmu',
    'image': 'https://www.microsoft.com/Q0ZGExNj@.jpg',
    'description': 'known for Batman',
    '@type': MovieContentType.person,
  },
  {
    'id': 'tt0152239',
    'name': 'Batman',
    'yearRange': '1997',
    'duration': 6180,
    'image': 'https://www.microsoft.com/YzODQzYj@.jpg',
    'description': 'staring [dot GaGal, s CarLyn]',
    '@type': MovieContentType.movie,
  },
  {
    'id': 'tt0172034',
    'name': 'Batman',
    'yearRange': '1975-1979',
    'duration': null,
    'image': 'https://www.microsoft.com/AxYTcxMD@.jpg',
    'description': 'staring [terda PiChrine, ggoe WaLylner]',
    '@type': MovieContentType.series,
  },
  {
    'id': 'tt1142838',
    'name': 'Batman',
    'yearRange': '1991',
    'duration': null,
    'image': 'https://www.microsoft.com/M4NTRlZjAtzgwMDUw.jpg',
    'description': 'staring [calro FNation, aliianne PAdrcki]',
    '@type': MovieContentType.movie,
  },
  {
    'id': 'tt1182333',
    'name': 'Batman',
    'yearRange': '1999',
    'duration': null,
    'image': 'https://www.microsoft.com/U1NmNmNT@.jpg',
    'description': 'staring [elli illhan, RussKer PasPed]',
    '@type': MovieContentType.movie,
  },
];

const imdbSampleJson = '''
{"props":{"pageProps":{"nameResults": {
                "results": [
                    {
                        "index": "nm0152436",
                        "listItem": {
                            "bio": "known for Superman(1994)",
                            "knownFor": {
                                "originalTitleText": "Moving Mily",
                                "titleId": "tt3781238",
                                "titleText": "Moving Movily",
                                "canHaveEpisodes": false,
                                "yearRange": {
                                    "year": 2016
                                }
                            },
                            "nameId": "nm0152436",
                            "nameText": "Hye NDace",
                            "primaryImage": {
                                "url": "https://www.microsoft.com/gx@.jpg"
                            }
                        }
                    },
                    {
                        "index": "nm2122834",
                        "listItem": {
                            "bio": "known for Catwoman!(1993- )",
                            "knownFor": {
                                "originalTitleText": "Catwoman!",
                                "titleId": "tt3123238",
                                "titleText": "Catwoman",
                                "canHaveEpisodes": false,
                                "yearRange": {
                                    "year": 2016
                                }
                            },
                            "nameId": "nm2122834",
                            "nameText": "ifdhKoliHeDene Her",
                            "primaryImage": {
                                "url": "https://www.microsoft.com/k0MTRlNmU@.jpg"
                            }
                        }
                    },
                    {
                        "index": "nm5122134",
                        "listItem": {
                            "bio": "known for Batman",
                            "knownFor": {
                                "originalTitleText": "Batman!",
                                "titleId": "tt3144438",
                                "titleText": "Batman",
                                "canHaveEpisodes": false,
                                "yearRange": {
                                    "year": 2016
                                }
                            },
                            "nameId": "nm5122134",
                            "nameText": "nrnKge K-sDHmu",
                            "primaryImage": {
                                "url": "https://www.microsoft.com/Q0ZGExNj@.jpg"  
                            }
                        }
                    }
                ]
            },
            "titleResults": {
                "results": [
                    {
                      "index": "tt0152239",
                      "listItem": {
                        "titleId": "tt0152239",
                        "titleText": "Batman!",
                        "originalTitleText": "Batman",
                        "runtime": 6180,
                        "releaseYear": "1997",
                            "titleType": {
                                "canHaveEpisodes": false,
                                "id": "movie",
                                "text": ""
                            },
                        "plot": "staring [dot GaGal, s CarLyn]",
                        "primaryImage": {
                            "url": "https://www.microsoft.com/YzODQzYj@.jpg",
                            "maxHeight": 100,
                            "maxWidth": 300,
                            "caption": "Stuff (2020)"
                        },
                        "topCredits": [
                            "dot GaGal",
                            "s CarLyn"
                        ]
                      }
                    },
                    {
                      "index": "tt0172034",
                      "listItem": {
                        "titleId": "tt0172034",
                        "titleText": "Batman!",
                        "originalTitleText": "Batman",
                        "releaseYear":"1975",
                        "endYear":"1979",
                            "titleType": {
                                "canHaveEpisodes": false,
                                "id": "tvSeries",
                                "text": ""
                            },
                        "plot": "staring [terda PiChrine, ggoe WaLylner]",
                        "primaryImage": {
                            "url": "https://www.microsoft.com/AxYTcxMD@.jpg"
                        },
                        "topCredits": [
                            "terda PiChrine",
                            "ggoe WaLylner"
                        ]
                      }
                    },
                    {
                      "index": "tt1142838",
                      "listItem": {
                        "titleId": "tt1142838",
                        "titleText": "Batman!",
                        "originalTitleText": "Batman",
                        "releaseYear": "1991",
                            "titleType": {
                                "canHaveEpisodes": false,
                                "id": "tvMovie",
                                "text": ""
                            },
                        "plot": "staring [calro FNation, aliianne PAdrcki]",
                        "primaryImage": {
                            "url": "https://www.microsoft.com/M4NTRlZjAtzgwMDUw.jpg"
                        },
                        "topCredits": [
                            "calro FNation",
                            "aliianne PAdrcki"
                        ]
                      }
                    },
                    {
                      "index": "tt1182333",
                      "listItem": {
                        "titleId": "tt1182333",
                        "titleText": "Batman!",
                        "originalTitleText": "Batman",
                        "releaseYear": "1999",
                            "titleType": {
                                "canHaveEpisodes": false,
                                "id": "video",
                                "text": ""
                            },
                        "plot": "staring [elli illhan, RussKer PasPed]",
                        "primaryImage": {
                            "url": "https://www.microsoft.com/U1NmNmNT@.jpg"
                        },
                        "topCredits": [
                            "elli illhan",
                            "RussKer PasPed"
                        ]
                      }
                    }
                ]
            },
            "companyResults": {
                "results": []
            },
            "keywordResults": {
                "results": []
            }
        }
    },
    "page": "/find",
    "query": {
        "q": "superman",
        "ref_": "nv_sr_sm"
    }
}''';
