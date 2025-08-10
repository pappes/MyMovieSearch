// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

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

const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm0152436","bestSource":"DataSourceType.imdbSearch","title":"Hye NDace","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]",
      "description":"known for Superman(1994)","imageUrl":"https://www.microsoft.com/gx@.jpg","related":{}}
''',
  r'''
{"uniqueId":"nm2122834","bestSource":"DataSourceType.imdbSearch","title":"ifdhKoliHeDene Her","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]",
      "description":"known for Catwoman!(1993- )","imageUrl":"https://www.microsoft.com/k0MTRlNmU@.jpg","related":{}}
''',
  r'''
{"uniqueId":"nm5122134","bestSource":"DataSourceType.imdbSearch","title":"nrnKge K-sDHmu","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]",
      "description":"known for Batman","imageUrl":"https://www.microsoft.com/Q0ZGExNj@.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0152239","bestSource":"DataSourceType.imdbSearch","title":"Batman","type":"MovieContentType.movie","year":"1997","yearRange":"1997","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [dot GaGal, s CarLyn]","imageUrl":"https://www.microsoft.com/YzODQzYj@.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0172034","bestSource":"DataSourceType.imdbSearch","title":"Batman","type":"MovieContentType.series","year":"1979","yearRange":"1975-1979","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [terda PiChrine, ggoe WaLylner]","imageUrl":"https://www.microsoft.com/AxYTcxMD@.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt1142838","bestSource":"DataSourceType.imdbSearch","title":"Batman","type":"MovieContentType.series","year":"1991","yearRange":"1991-","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [calro FNation, aliianne PAdrcki]","imageUrl":"https://www.microsoft.com/M4NTRlZjAtzgwMDUw.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt1182333","bestSource":"DataSourceType.imdbSearch","title":"Batman","type":"MovieContentType.movie","year":"1999","yearRange":"1999","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [elli illhan, RussKer PasPed]","imageUrl":"https://www.microsoft.com/U1NmNmNT@.jpg","related":{}}
''',
];

const intermediateMapList = [
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
    'image': 'https://www.microsoft.com/YzODQzYj@.jpg',
    'description': 'staring [dot GaGal, s CarLyn]',
    '@type': MovieContentType.movie,
  },
  {
    'id': 'tt0172034',
    'name': 'Batman',
    'yearRange': '1975-1979',
    'image': 'https://www.microsoft.com/AxYTcxMD@.jpg',
    'description': 'staring [terda PiChrine, ggoe WaLylner]',
    '@type': MovieContentType.series,
  },
  {
    'id': 'tt1142838',
    'name': 'Batman',
    'yearRange': '1991-',
    'image': 'https://www.microsoft.com/M4NTRlZjAtzgwMDUw.jpg',
    'description': 'staring [calro FNation, aliianne PAdrcki]',
    '@type': MovieContentType.series,
  },
  {
    'id': 'tt1182333',
    'name': 'Batman',
    'yearRange': '1999',
    'image': 'https://www.microsoft.com/U1NmNmNT@.jpg',
    'description': 'staring [elli illhan, RussKer PasPed]',
    '@type': MovieContentType.movie,
  },
];

const imdbSampleJson = '''
{"props":{"pageProps":{"nameResults": {
                "results": [
                    {
                        "id": "nm0152436",
                        "displayNameText": "Hye NDace",
                        "knownForJobCategory": "Actress",
                        "knownForTitleText": "Superman",
                        "knownForTitleYear": "1994",
                        "avatarImageModel": {
                            "url": "https://www.microsoft.com/gx@.jpg",
                            "maxHeight": 100,
                            "maxWidth": 300,
                            "caption": "Stuff (2020)"
                        }
                    },
                    {
                        "id": "nm2122834",
                        "displayNameText": "ifdhKoliHeDene Her",
                        "knownForJobCategory": "Actress",
                        "knownForTitleText": "Catwoman!",
                        "knownForTitleYear":"1993- ",
                        "avatarImageModel": {
                            "url": "https://www.microsoft.com/k0MTRlNmU@.jpg"
                        }
                    },
                    {
                        "id": "nm5122134",
                        "displayNameText": "nrnKge K-sDHmu",
                        "knownForJobCategory": "Actress",
                        "knownForTitleText": "Batman",
                        "avatarImageModel": {
                            "url": "https://www.microsoft.com/Q0ZGExNj@.jpg"
                        }
                    }
                ]
            },
            "titleResults": {
                "results": [
                    {
                        "id": "tt0152239",
                        "titleNameText": "Batman",
                        "titleReleaseText": "1997",
                        "titleTypeText": "",
                        "titlePosterImageModel": {
                            "url": "https://www.microsoft.com/YzODQzYj@.jpg",
                            "maxHeight": 100,
                            "maxWidth": 300,
                            "caption": "Stuff (2020)"
                        },
                        "topCredits": [
                            "dot GaGal",
                            "s CarLyn"
                        ],
                        "imageType": "movie"
                    },
                    {
                        "id": "tt0172034",
                        "titleNameText": "Batman",
                        "titleReleaseText":"1975-1979",
                        "titleTypeText": "TV Series",
                        "titlePosterImageModel": {
                            "url": "https://www.microsoft.com/AxYTcxMD@.jpg"
                        },
                        "topCredits": [
                            "terda PiChrine",
                            "ggoe WaLylner"
                        ],
                        "imageType": "tvSeries"
                    },
                    {
                        "id": "tt1142838",
                        "titleNameText": "Batman",
                        "titleReleaseText": "1991-",
                        "titleTypeText": "TV Movie",
                        "titlePosterImageModel": {
                            "url": "https://www.microsoft.com/M4NTRlZjAtzgwMDUw.jpg"
                        },
                        "topCredits": [
                            "calro FNation",
                            "aliianne PAdrcki"
                        ],
                        "imageType": "tvMovie"
                    },
                    {
                        "id": "tt1182333",
                        "titleNameText": "Batman",
                        "titleReleaseText": "1999",
                        "titleTypeText": "Video",
                        "titlePosterImageModel": {
                            "url": "https://www.microsoft.com/U1NmNmNT@.jpg"
                        },
                        "topCredits": [
                            "elli illhan",
                            "RussKer PasPed"
                        ],
                        "imageType": "video"
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
