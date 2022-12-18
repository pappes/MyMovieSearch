//query string https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=wonder%20woman

// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data run
       print(actualResult.toListOfDartJsonStrings(excludeCopyrightedData:false));
in test('Run dtoFromCompleteJsonMap()'*/
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm0152436","title":"Hye NDace","languages":"[]","genres":"[]","keywords":"[]",
      "description":"known for Superman(1994)","imageUrl":"https://www.microsoft.com/gx@.jpg","related":{}}
''',
  r'''
{"uniqueId":"nm2122834","title":"ifdhKoliHeDene Her","languages":"[]","genres":"[]","keywords":"[]",
      "description":"known for Catwoman!(1993- )","imageUrl":"https://www.microsoft.com/k0MTRlNmU@.jpg","related":{}}
''',
  r'''
{"uniqueId":"nm5122134","title":"nrnKge K-sDHmu","languages":"[]","genres":"[]","keywords":"[]",
      "description":"known for Batman","imageUrl":"https://www.microsoft.com/Q0ZGExNj@.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0152239","title":"Batman","type":"MovieContentType.movie","year":"1997","yearRange":"1997","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [dot GaGal, s CarLyn]","imageUrl":"https://www.microsoft.com/YzODQzYj@.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0172034","title":"Batman","type":"MovieContentType.series","year":"1979","yearRange":"1975-1979","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [terda PiChrine, ggoe WaLylner]","imageUrl":"https://www.microsoft.com/AxYTcxMD@.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt1142838","title":"Batman","type":"MovieContentType.movie","year":"1991","yearRange":"1991","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [calro FNation, aliianne PAdrcki]","imageUrl":"https://www.microsoft.com/M4NTRlZjAtzgwMDUw.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt1182333","title":"Batman","type":"MovieContentType.movie","year":"1999","yearRange":"1999","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [elli illhan, RussKer PasPed]","imageUrl":"https://www.microsoft.com/U1NmNmNT@.jpg","related":{}}
''',
];

const intermediateMapList = [
  {
    'id': 'nm0152436',
    'name': 'Hye NDace',
    'image': 'https://www.microsoft.com/gx@.jpg',
    'description': 'known for Superman(1994)'
  },
  {
    'id': 'nm2122834',
    'name': 'ifdhKoliHeDene Her',
    'image': 'https://www.microsoft.com/k0MTRlNmU@.jpg',
    'description': 'known for Catwoman!(1993- )'
  },
  {
    'id': 'nm5122134',
    'name': 'nrnKge K-sDHmu',
    'image': 'https://www.microsoft.com/Q0ZGExNj@.jpg',
    'description': 'known for Batman'
  },
  {
    'id': 'tt0152239',
    'name': 'Batman',
    'yearRange': '1997',
    'image': 'https://www.microsoft.com/YzODQzYj@.jpg',
    'description': 'staring [dot GaGal, s CarLyn]',
    '@type': MovieContentType.movie
  },
  {
    'id': 'tt0172034',
    'name': 'Batman',
    'yearRange': '1975-1979',
    'image': 'https://www.microsoft.com/AxYTcxMD@.jpg',
    'description': 'staring [terda PiChrine, ggoe WaLylner]',
    '@type': MovieContentType.series
  },
  {
    'id': 'tt1142838',
    'name': 'Batman',
    'yearRange': '1991',
    'image': 'https://www.microsoft.com/M4NTRlZjAtzgwMDUw.jpg',
    'description': 'staring [calro FNation, aliianne PAdrcki]',
    '@type': MovieContentType.movie
  },
  {
    'id': 'tt1182333',
    'name': 'Batman',
    'yearRange': '1999',
    'image': 'https://www.microsoft.com/U1NmNmNT@.jpg',
    'description': 'staring [elli illhan, RussKer PasPed]',
    '@type': MovieContentType.movie
  }
];

const imdbSampleJson = '''
{
    "props": {
        "pageProps": {
            "nameResults": {
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
                        "titleReleaseText": "1991",
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
}
''';

const imdbSearchHtmlSampleInner = '''
<tr class="findResult odd">
  <td class="primary_photo"> <a href="/title/tt0451279/?ref_=fn_tt_tt_1"><img src="https://m.media-amazon.com/images/M/MV5BMTYz...GdeQXVyODE5NzE3OTE@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt0451279/?ref_=fn_tt_tt_1">Search Woman</a> (2017) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt0074074/?ref_=fn_tt_tt_2"><img src="https://m.media-amazon.com/images/M/MV5BZjA...XkFqcGdeQXVyNjExODE1MDc@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt0074074/?ref_=fn_tt_tt_2">Search Woman</a> (1975) (TV Series) </td> 
</tr>
<tr class="findResult odd"> 
  <td class="primary_photo"> <a href="/title/tt1740828/?ref_=fn_tt_tt_3"><img src="https://m.media-amazon.com/images/M/MV5B...zM4ODM4NA@@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt1740828/?ref_=fn_tt_tt_3">Search Woman</a> (2011) (TV Movie) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt7126948/?ref_=fn_tt_tt_4"><img src="https://m.media-amazon.com/images/M/MV5BYT...QXVyMjQwMDg0Ng@@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt7126948/?ref_=fn_tt_tt_4">Search Woman 1984</a> (2020) </td> 
</tr>
<tr class="findResult odd"> 
  <td class="primary_photo"> <a href="/title/tt8752498/?ref_=fn_tt_tt_5"><img src="https://m.media-amazon.com/images/M/MV5BZTkyNmMz...GdeQXVyNzU3NjUxMzE@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt8752498/?ref_=fn_tt_tt_5">Search Woman: Bloodlines</a> (2019) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt13722802/?ref_=fn_tt_tt_6"><img src="https://m.media-amazon.com/images/S/sash/85lhIiFC....mSScRzu.png"></a> </td> 
  <td class="result_text"> <a href="/title/tt13722802/?ref_=fn_tt_tt_6">Search Woman 3</a> </td> 
</tr>
''';

const imdbSearchHtmlSampleFull = '''
<!DOCTYPE html>
<html
    xmlns:snip=true>
    </snip>
  <body id="styleguide-v2" class="fixed">


  <script id="__NEXT_DATA__" type="application/json">
$imdbSampleJson
  </script>
    <div id="wrapper">
      <div id="root" class="redesign">
        <div id="pagecontent" class="pagecontent">
          <div id="content-2-wide">
            <div id="main">
              <div class="article">
                <div  class="findSection">
                  <table class="findList">
                    <tbody> 
$imdbSearchHtmlSampleInner
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
''';

Future<Stream<String>> streamImdbSearchHtmlOfflineData(dynamic dummy) {
  return Future.value(_emitImdbSearchHtmlSample(dummy));
}

Stream<String> _emitImdbSearchHtmlSample(_) async* {
  yield imdbSearchHtmlSampleFull;
}
