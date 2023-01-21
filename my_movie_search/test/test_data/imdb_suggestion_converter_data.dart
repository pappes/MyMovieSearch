import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_suggestion.dart';

////////////////////////////////////////////////////////////////////////////////
/// Test Data
////////////////////////////////////////////////////////////////////////////////

//query string https://sg.media-imdb.com/suggests/w/wonder%20woman.json
//json format
//1 = title/name
//id = unique  key (tt=tile/nm=name/vi=video)
//s = supplementary info (biography, actors or trailer duration
//y = year
//yr = year range for series
//q = title type
//i = image with dimensions)

List<MovieResultDTO> jsonMapToDto(
  Iterable<Map<dynamic, dynamic>> records,
) {
  final result = <MovieResultDTO>[];
  for (final record in records) {
    result.add(ImdbSuggestionConverter.dtoFromMap(record));
  }
  return result;
}

final expectedDTOList = jsonMapToDto(expectedDTOMap);
final expectedDTOStream = Stream.value(expectedDTOList);
final expectedDTOMap = [
  {
    "l": "Imdb Offline Suggestions 1984",
    "id": "tt7324958",
    "s": "Gal Gadot, Chris Pine",
    "y": 2020,
    "q": "feature",
    "vt": 35,
    "i": [
      "https://m.media-amazon.com/images/M/MV5B...Q3MTUy._V1_.jpg",
      2764,
      4096
    ],
    "v": [
      {
        "l": "4K Trailer",
        "id": "vi3142238457",
        "s": "2:31",
        "i": [
          "https://m.media-amazon.com/images/M/MV5B...Rvb2xpbmhk._V1_.jpg",
          1404,
          790
        ]
      },
      {
        "l": "Opening Scene",
        "id": "vi311233143",
        "s": "3:26",
        "i": [
          "https://m.media-amazon.com/images/M/MV5B...QWRvb2xpbmhk._V1_.jpg",
          1343,
          756
        ]
      },
      {
        "l": "Imdb Offline Suggestions 1984",
        "id": "vi2112630409",
        "s": "1:32",
        "i": [
          "https://m.media-amazon.com/images/M/MV5B...Zmxvdw@@._V1_.jpg",
          1920,
          1080
        ]
      }
    ]
  },
  {
    "l": "Imdb Offline Suggestions",
    "id": "tt0354259",
    "s": "Gal Gadot, Chris Pine",
    "y": 2017,
    "q": "feature",
    "vt": 23,
    "i": [
      "https://m.media-amazon.com/images/M/MV5B...zE3OTE@._V1_.jpg",
      2025,
      3000
    ],
    "v": [
      {
        "l": "Rise of the Suggestion",
        "id": "vi1152331457",
        "s": "2:36",
        "i": [
          "https://m.media-amazon.com/images/M/MV5B...NzZXI@._V1_.jpg",
          1492,
          788
        ]
      },
      {
        "l": "Meet Maxwell Lord: The 'Imdb Offline Suggestions 1984' Big Bad",
        "id": "vi217223649",
        "s": "3:57",
        "i": [
          "https://m.media-amazon.com/images/M/MV5B...ZWxvZw@@._V1_.jpg",
          1920,
          1080
        ]
      },
      {
        "l": "Official Suggestion Trailer",
        "id": "vi1102331413",
        "s": "2:30",
        "i": [
          "https://m.media-amazon.com/images/M/MV5B...TI2MTU@._V1_.jpg",
          1280,
          720
        ]
      }
    ]
  },
  {
    "l": "Imdb Offline Suggestions",
    "id": "tt1344858",
    "s": "Pedro Pascal, Adrianne Palicki",
    "y": 2011,
    "q": "TV movie",
    "i": [
      "https://m.media-amazon.com/images/M/MV5B...DM4NA@@._V1_.jpg",
      761,
      1800
    ]
  },
  {
    "l": "Imdb Offline Suggestions",
    "id": "tt0374054",
    "s": "Lynda Carter, Lyle Waggoner",
    "y": 1975,
    "yr": "1975-1979",
    "q": "TV series",
    "i": [
      "https://m.media-amazon.com/images/M/MV5B...ODE1MDc@._V1_.jpg",
      702,
      998
    ]
  },
  {
    "l": "Imdb Offline Suggestions: Bloodlines",
    "id": "tt8354458",
    "s": "Rosario Dawson, Jeffrey Donovan",
    "y": 2019,
    "q": "feature",
    "i": [
      "https://m.media-amazon.com/images/M/MV5BZ...UxMzE@._V1_.jpg",
      1365,
      2048
    ]
  },
  {
    "l": "Imdb Offline Suggestions",
    "id": "tt0374459",
    "s": "Cathy Lee Crosby, Kaz Garas",
    "y": 1974,
    "q": "TV movie",
    "i": [
      "https://m.media-amazon.com/images/M/MV5B...kwMDE@._V1_.jpg",
      353,
      500
    ]
  },
  {
    "l": "Imdb Offline Suggestions",
    "id": "tt1384353",
    "s": "Keri Russell, Nathan Fillion",
    "y": 2009,
    "q": "video",
    "i": [
      "https://m.media-amazon.com/images/M/MV5B...xODE1MDc@._V1_.jpg",
      500,
      741
    ]
  },
  {
    "l": "Jennifer Wenger",
    "id": "nm2128254",
    "s": "Actress, Jimmy Kimmel Live! (2006-2007)",
    "i": [
      "https://m.media-amazon.com/images/M/MV5B...cxNQ@@._V1_.jpg",
      640,
      428
    ]
  }
];

const String imdbJsonSampleInner = '''
  {"l":"Imdb Offline Suggestions 1984","id":"tt7324958","s":"Gal Gadot, Chris Pine","y":2020,"q":"feature","vt":35
      ,"i":["https://m.media-amazon.com/images/M/MV5B...Q3MTUy._V1_.jpg",2764,4096]
      ,"v":
      [
          {"l":"4K Trailer","id":"vi3142238457","s":"2:31","i":["https://m.media-amazon.com/images/M/MV5B...xpbmhk._V1_.jpg",1404,790]},
          {"l":"Opening Scene","id":"vi311233143","s":"3:26","i":["https://m.media-amazon.com/images/M/MV5B...pbmhk._V1_.jpg",1343,756]},
          {"l":"Imdb Offline Suggestions 1984","id":"vi2112630409","s":"1:32","i":["https://m.media-amazon.com/images/M/MV5B...xvdw@@._V1_.jpg",1920,1080]}
      ]},
  {"l":"Imdb Offline Suggestions","id":"tt0354259","s":"Gal Gadot, Chris Pine","y":2017,"q":"feature","vt":23
      ,"i":["https://m.media-amazon.com/images/M/MV5B...zE3OTE@._V1_.jpg",2025,3000]
      ,"v":
      [
          {"l":"Rise of the Suggestion","id":"vi1152331457","s":"2:36"
              ,"i":["https://m.media-amazon.com/images/M/MV5B...zZXI@._V1_.jpg",1492,788]},
          {"l":"Meet Maxwell Lord: The 'Imdb Offline Suggestions 1984' Big Bad","id":"vi217223649","s":"3:57"
              ,"i":["https://m.media-amazon.com/images/M/MV5B...xvZw@@._V1_.jpg",1920,1080]},
          {"l":"Official Suggestion Trailer","id":"vi1102331413","s":"2:30","i":["https://m.media-amazon.com/images/M/MV5B...OTI2MTU@._V1_.jpg",1280,720]}
      ]},
  {"l":"Imdb Offline Suggestions","id":"tt1344858","s":"Pedro Pascal, Adrianne Palicki","y":2011,"q":"TV movie"
      ,"i":["https://m.media-amazon.com/images/M/MV5B...DM4NA@@._V1_.jpg",761,1800]},
  {"l":"Imdb Offline Suggestions","id":"tt0374054","s":"Lynda Carter, Lyle Waggoner","y":1975,"yr":"1975-1979","q":"TV series"
      ,"i":["https://m.media-amazon.com/images/M/MV5B...ODE1MDc@._V1_.jpg",702,998]},
  {"l":"Imdb Offline Suggestions: Bloodlines","id":"tt8354458","s":"Rosario Dawson, Jeffrey Donovan","y":2019,"q":"feature"
      ,"i":["https://m.media-amazon.com/images/M/MV5BZ...UxMzE@._V1_.jpg",1365,2048]},
  {"l":"Imdb Offline Suggestions","id":"tt0374459","s":"Cathy Lee Crosby, Kaz Garas","y":1974,"q":"TV movie"
      ,"i":["https://m.media-amazon.com/images/M/MV5B...kwMDE@._V1_.jpg",353,500]},
  {"l":"Imdb Offline Suggestions","id":"tt1384353","s":"Keri Russell, Nathan Fillion","y":2009,"q":"video"
      ,"i":["https://m.media-amazon.com/images/M/MV5B...xODE1MDc@._V1_.jpg",500,741]},
  {"l":"Jennifer Wenger","id":"nm2128254","s":"Actress, Jimmy Kimmel Live! (2006-2007)"
      ,"i":["https://m.media-amazon.com/images/M/MV5B...cxNQ@@._V1_.jpg",640,428]}
''';
const String imdbJsonPFunction = r'imdb$wonder_woman';
const String imdbCustomKeyName = 'Cust';
const String imdbCustomKeyVal = 'jsonpPTest';
const String imdbJsonSampleOuter =
    '{"v":1,"q":"imdb_offline_suggestions","d":[ $imdbJsonSampleInner ],"$imdbCustomKeyName":"$imdbCustomKeyVal"}';
const String imdbJsonPSampleFull = '$imdbJsonPFunction($imdbJsonSampleOuter)';

Future<Stream<String>> emitImdbSuggestionJsonPSample(dynamic dummy) {
  return Future.value(Stream.value(imdbJsonPSampleFull));
}
