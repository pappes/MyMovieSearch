import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

//import 'package:my_movie_search/search_providers/jsonp_transformer_fusion.dart';
//import 'package:my_movie_search/search_providers/jsonp_transformer_rot.dart';
import 'package:my_movie_search/search_providers/jsonp_transformer.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/search_imdb_suggestion_converter.dart';

////////////////////////////////////////////////////////////////////////////////
/// Test Data
////////////////////////////////////////////////////////////////////////////////

//query string https://sg.media-imdb.com/suggests/w/wonder%20woman.json
//json format
//1 = title/name
//id = unique  key (tt=tile/nm=name/vi=video)
//s = supplimentary info (biography, actors or trailer duration
//y = year
//yr = year range for series
//q = title type
//i = image with dimentions)

final expectedDTOList = expectedDTOStream.toList();
final expectedDTOStream = MovieSuggestionConverter.fromInnerJsonMap([
  {
    "l": "Wonder Woman 1984",
    "id": "tt7126948",
    "s": "Gal Gadot, Chris Pine",
    "y": 2020,
    "q": "feature",
    "vt": 35,
    "i": [
      "https://m.media-amazon.com/images/M/MV5BNWY2NWE0NWEtZGUwMC00NWMwLTkyNzUtNmIxMmIyYzA0MjNiXkEyXkFqcGdeQXVyMTA2OTQ3MTUy._V1_.jpg",
      2764,
      4096
    ],
    "v": [
      {
        "l": "4K Trailer",
        "id": "vi3944268057",
        "s": "2:31",
        "i": [
          "https://m.media-amazon.com/images/M/MV5BMzVkZTY5YzMtMThkZS00YmI1LWEwMWUtNDhhOGQ3N2MwMmRlXkEyXkFqcGdeQWRvb2xpbmhk._V1_.jpg",
          1404,
          790
        ]
      },
      {
        "l": "Opening Scene",
        "id": "vi321831193",
        "s": "3:26",
        "i": [
          "https://m.media-amazon.com/images/M/MV5BODNjNmI0N2MtYTlkYi00YzgxLTg4NTAtMTFiNWRkY2U0NjVmXkEyXkFqcGdeQWRvb2xpbmhk._V1_.jpg",
          1343,
          756
        ]
      },
      {
        "l": "Wonder Woman 1984",
        "id": "vi2517680409",
        "s": "1:32",
        "i": [
          "https://m.media-amazon.com/images/M/MV5BOGE3NTkyNTYtMGI2ZC00MGY2LWExZDAtY2VkZWI2YTBlNzAxXkEyXkFqcGdeQVRoaXJkUGFydHlJbmdlc3Rpb25Xb3JrZmxvdw@@._V1_.jpg",
          1920,
          1080
        ]
      }
    ]
  },
  {
    "l": "Wonder Woman",
    "id": "tt0451279",
    "s": "Gal Gadot, Chris Pine",
    "y": 2017,
    "q": "feature",
    "vt": 23,
    "i": [
      "https://m.media-amazon.com/images/M/MV5BMTYzODQzYjQtNTczNC00MzZhLTg1ZWYtZDUxYmQ3ZTY4NzA1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_.jpg",
      2025,
      3000
    ],
    "v": [
      {
        "l": "Rise of the Warrior",
        "id": "vi1553381657",
        "s": "2:36",
        "i": [
          "https://m.media-amazon.com/images/M/MV5BZWVhYzE0NzgtM2U1Yi00OWM1LWJlZTUtZmNkNWZhM2VkMDczXkEyXkFqcGdeQW1yb3NzZXI@._V1_.jpg",
          1492,
          788
        ]
      },
      {
        "l": "Meet Maxwell Lord: The 'Wonder Woman 1984' Big Bad",
        "id": "vi237027609",
        "s": "3:57",
        "i": [
          "https://m.media-amazon.com/images/M/MV5BYjQ3NGRmZTctYWRiNi00ODgxLTg4OWUtZWViYmZiMDJhODg2XkEyXkFqcGdeQWFsZWxvZw@@._V1_.jpg",
          1920,
          1080
        ]
      },
      {
        "l": "Official Origin Trailer",
        "id": "vi1901311513",
        "s": "2:30",
        "i": [
          "https://m.media-amazon.com/images/M/MV5BMDdhNDBhYzQtOWI4Yy00MjMyLWE4ZDYtMzU1ODllMTljZTMxXkEyXkFqcGdeQXVyMjM4OTI2MTU@._V1_.jpg",
          1280,
          720
        ]
      }
    ]
  },
  {
    "l": "Wonder Woman",
    "id": "tt1740828",
    "s": "Pedro Pascal, Adrianne Palicki",
    "y": 2011,
    "q": "TV movie",
    "i": [
      "https://m.media-amazon.com/images/M/MV5BMjA0MzYzNzY3OV5BMl5BanBnXkFtZTcwMzM4ODM4NA@@._V1_.jpg",
      761,
      1800
    ]
  },
  {
    "l": "Wonder Woman",
    "id": "tt0074074",
    "s": "Lynda Carter, Lyle Waggoner",
    "y": 1975,
    "yr": "1975-1979",
    "q": "TV series",
    "i": [
      "https://m.media-amazon.com/images/M/MV5BZjAxYTcxMDUtZTRmMi00NTk3LThkZTItNGNlZTQ3NWRhMjY5XkEyXkFqcGdeQXVyNjExODE1MDc@._V1_.jpg",
      702,
      998
    ]
  },
  {
    "l": "Wonder Woman: Bloodlines",
    "id": "tt8752498",
    "s": "Rosario Dawson, Jeffrey Donovan",
    "y": 2019,
    "q": "feature",
    "i": [
      "https://m.media-amazon.com/images/M/MV5BZTkyNmMzMTEtZTNjMC00NTg4LWJlNTktZDdmNzE1M2YxN2E4XkEyXkFqcGdeQXVyNzU3NjUxMzE@._V1_.jpg",
      1365,
      2048
    ]
  },
  {
    "l": "Wonder Woman",
    "id": "tt0072419",
    "s": "Cathy Lee Crosby, Kaz Garas",
    "y": 1974,
    "q": "TV movie",
    "i": [
      "https://m.media-amazon.com/images/M/MV5BMTQ3NDkxNjM0Ml5BMl5BanBnXkFtZTgwNzQxNTkwMDE@._V1_.jpg",
      353,
      500
    ]
  },
  {
    "l": "Wonder Woman",
    "id": "tt1186373",
    "s": "Keri Russell, Nathan Fillion",
    "y": 2009,
    "q": "video",
    "i": [
      "https://m.media-amazon.com/images/M/MV5BNzU1NmNmNTgtMTUyYS00ZmRmLTkzOWItOTY2ZWZiYjVkYzkzXkEyXkFqcGdeQXVyNjExODE1MDc@._V1_.jpg",
      500,
      741
    ]
  },
  {
    "l": "Jennifer Wenger",
    "id": "nm2628854",
    "s": "Actress, Jimmy Kimmel Live! (2006-2007)",
    "i": [
      "https://m.media-amazon.com/images/M/MV5BMjk0MTRlNmUtNGNmNy00OTA2LTg0MWEtMWE2M2M5YmUyMDJkL2ltYWdlXkEyXkFqcGdeQXVyNjY1ODcxNQ@@._V1_.jpg",
      640,
      428
    ]
  }
]);

final String imdbJsonSampleInner = r'''
  {"l":"Wonder Woman 1984","id":"tt7126948","s":"Gal Gadot, Chris Pine","y":2020,"q":"feature","vt":35
      ,"i":["https://m.media-amazon.com/images/M/MV5BNWY2NWE0NWEtZGUwMC00NWMwLTkyNzUtNmIxMmIyYzA0MjNiXkEyXkFqcGdeQXVyMTA2OTQ3MTUy._V1_.jpg",2764,4096]
      ,"v":
      [
          {"l":"4K Trailer","id":"vi3944268057","s":"2:31","i":["https://m.media-amazon.com/images/M/MV5BMzVkZTY5YzMtMThkZS00YmI1LWEwMWUtNDhhOGQ3N2MwMmRlXkEyXkFqcGdeQWRvb2xpbmhk._V1_.jpg",1404,790]},
          {"l":"Opening Scene","id":"vi321831193","s":"3:26","i":["https://m.media-amazon.com/images/M/MV5BODNjNmI0N2MtYTlkYi00YzgxLTg4NTAtMTFiNWRkY2U0NjVmXkEyXkFqcGdeQWRvb2xpbmhk._V1_.jpg",1343,756]},
          {"l":"Wonder Woman 1984","id":"vi2517680409","s":"1:32","i":["https://m.media-amazon.com/images/M/MV5BOGE3NTkyNTYtMGI2ZC00MGY2LWExZDAtY2VkZWI2YTBlNzAxXkEyXkFqcGdeQVRoaXJkUGFydHlJbmdlc3Rpb25Xb3JrZmxvdw@@._V1_.jpg",1920,1080]}
      ]},
  {"l":"Wonder Woman","id":"tt0451279","s":"Gal Gadot, Chris Pine","y":2017,"q":"feature","vt":23
      ,"i":["https://m.media-amazon.com/images/M/MV5BMTYzODQzYjQtNTczNC00MzZhLTg1ZWYtZDUxYmQ3ZTY4NzA1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_.jpg",2025,3000]
      ,"v":
      [
          {"l":"Rise of the Warrior","id":"vi1553381657","s":"2:36"
              ,"i":["https://m.media-amazon.com/images/M/MV5BZWVhYzE0NzgtM2U1Yi00OWM1LWJlZTUtZmNkNWZhM2VkMDczXkEyXkFqcGdeQW1yb3NzZXI@._V1_.jpg",1492,788]},
          {"l":"Meet Maxwell Lord: The 'Wonder Woman 1984' Big Bad","id":"vi237027609","s":"3:57"
              ,"i":["https://m.media-amazon.com/images/M/MV5BYjQ3NGRmZTctYWRiNi00ODgxLTg4OWUtZWViYmZiMDJhODg2XkEyXkFqcGdeQWFsZWxvZw@@._V1_.jpg",1920,1080]},
          {"l":"Official Origin Trailer","id":"vi1901311513","s":"2:30","i":["https://m.media-amazon.com/images/M/MV5BMDdhNDBhYzQtOWI4Yy00MjMyLWE4ZDYtMzU1ODllMTljZTMxXkEyXkFqcGdeQXVyMjM4OTI2MTU@._V1_.jpg",1280,720]}
      ]},
  {"l":"Wonder Woman","id":"tt1740828","s":"Pedro Pascal, Adrianne Palicki","y":2011,"q":"TV movie"
      ,"i":["https://m.media-amazon.com/images/M/MV5BMjA0MzYzNzY3OV5BMl5BanBnXkFtZTcwMzM4ODM4NA@@._V1_.jpg",761,1800]},
  {"l":"Wonder Woman","id":"tt0074074","s":"Lynda Carter, Lyle Waggoner","y":1975,"yr":"1975-1979","q":"TV series"
      ,"i":["https://m.media-amazon.com/images/M/MV5BZjAxYTcxMDUtZTRmMi00NTk3LThkZTItNGNlZTQ3NWRhMjY5XkEyXkFqcGdeQXVyNjExODE1MDc@._V1_.jpg",702,998]},
  {"l":"Wonder Woman: Bloodlines","id":"tt8752498","s":"Rosario Dawson, Jeffrey Donovan","y":2019,"q":"feature"
      ,"i":["https://m.media-amazon.com/images/M/MV5BZTkyNmMzMTEtZTNjMC00NTg4LWJlNTktZDdmNzE1M2YxN2E4XkEyXkFqcGdeQXVyNzU3NjUxMzE@._V1_.jpg",1365,2048]},
  {"l":"Wonder Woman","id":"tt0072419","s":"Cathy Lee Crosby, Kaz Garas","y":1974,"q":"TV movie"
      ,"i":["https://m.media-amazon.com/images/M/MV5BMTQ3NDkxNjM0Ml5BMl5BanBnXkFtZTgwNzQxNTkwMDE@._V1_.jpg",353,500]},
  {"l":"Wonder Woman","id":"tt1186373","s":"Keri Russell, Nathan Fillion","y":2009,"q":"video"
      ,"i":["https://m.media-amazon.com/images/M/MV5BNzU1NmNmNTgtMTUyYS00ZmRmLTkzOWItOTY2ZWZiYjVkYzkzXkEyXkFqcGdeQXVyNjExODE1MDc@._V1_.jpg",500,741]},
  {"l":"Jennifer Wenger","id":"nm2628854","s":"Actress, Jimmy Kimmel Live! (2006-2007)"
      ,"i":["https://m.media-amazon.com/images/M/MV5BMjk0MTRlNmUtNGNmNy00OTA2LTg0MWEtMWE2M2M5YmUyMDJkL2ltYWdlXkEyXkFqcGdeQXVyNjY1ODcxNQ@@._V1_.jpg",640,428]}
''';
final String imdbJsonPFunction = r'imdb$wonder_woman';
final String imdbCustomKeyName = 'Cust';
final String imdbCustomKeyVal = 'jsonpPTest';
final String imdbJsonSampleOuter =
    '{"v":1,"q":"wonder_woman","d":[ $imdbJsonSampleInner ],"$imdbCustomKeyName":"$imdbCustomKeyVal"}';
final String imdbJsonPSampleFull = ' $imdbJsonPFunction($imdbJsonSampleOuter) ';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////

/*Stream<String> emitString(String str) async* {
  yield str;
}*/

/* TODO: test executeQuery()
class QueryIMDBSuggestions_temp {
  static executeQuery(
    StreamController<MovieResultDTO> sc,
    SearchCriteriaDTO criteria,
  ) async {
    emitImdbJsonSample()
        .transform(json.decoder)
        .transform(json.decoder)
        .expand((element) =>
            element) // expand the JSON collection and emit the single results record into a new stream
        .pipe(sc);
  }
}
*/

class MovieResultDTOMatcher extends Matcher {
  MovieResultDTO expected;
  MovieResultDTO _actual;

  MovieResultDTOMatcher(this.expected);

  @override
  Description describe(Description description) {
    return description
        .add("has expected MovieResultDTO content = ${expected.toMap()}");
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map<dynamic, dynamic> matchState, bool verbose) {
    return mismatchDescription
        .add("has actual emitted MovieResultDTO = ${_actual.toMap()}");
  }

  @override
  bool matches(actual, Map matchState) {
    _actual = actual;
    matchState['actual'] =
        _actual is MovieResultDTO ? _actual : MovieResultDTO().toUnknown();
    return _actual.compareTo(expected);
  }
}

Stream<List<int>> emitByteStream(String str) async* {
  for (var rune in str.runes.toList()) {
    yield [rune];
  }
}

Stream<List<int>> emitConsolidatedByteStream(String str) async* {
  List<int> lst = [];

  for (var rune in str.runes.toList()) {
    lst.add(rune);
  }
  yield lst;
}

////////////////////////////////////////////////////////////////////////////////
/// Conceptual testing
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('stream basics', () {
    test('simple Bytesteam test', () {
      String testInput = 'B(a)';
      List<List<int>> expectedOutput = [
        [66],
        [40],
        [97],
        [41]
      ];
      var stream = emitByteStream(testInput);

      int runeCount = 0;
      var expectFn = expectAsync1<void, List<int>>((output) {
        expect(output, expectedOutput[runeCount]);
        runeCount++;
      }, count: testInput.length);
      stream.listen(expectFn, onDone: () {
        expect(runeCount, testInput.length);
        print('stream done, all $runeCount elements consumed');
      });
    });

    test('UTF8 test', () {
      String testInput = '$imdbJsonPFunction(a)';
      var stream = emitByteStream(testInput).transform(utf8.decoder);

      int runeCount = 0;
      var expectFn = expectAsync1<void, String>((output) {
        expect(output, testInput.substring(runeCount++, runeCount));
      }, count: testInput.length);
      stream.listen(expectFn);
    });

    test('json test', () {
      String testInput = imdbJsonSampleOuter;
      var stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(json.decoder);

      var expectFn = expectAsync1<void, Object>((output) {
        Map decodedOutput =
            output; // explicit cast from type Object to type Map
        expect(decodedOutput[imdbCustomKeyName], imdbCustomKeyVal);
      }, count: 1);
      stream.listen(expectFn);
    });

    test('outer map test', () {
      String testInput = imdbJsonSampleOuter;
      var stream = emitConsolidatedByteStream(testInput)
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((outerMap) => (outerMap as Map)[imdbCustomKeyName]);

      var expectFn = expectAsync1<void, Object>((output) {
        expect(output, imdbCustomKeyVal);
      }, count: 1);
      stream.listen(expectFn);
    });
/*
    test('jsonp transformer test', () {
      return;
      String testInput = imdbJsonPSampleFull;
      var stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(jsonp.decoder)
          .transform(json.decoder);

      var expectFn = expectAsync1<void, Object>((output) {
        Map decodedOutput =
            output; // explicit cast from type Object to type Map
        expect(decodedOutput[imdbCustomKeyName], imdbCustomKeyVal);
      }, count: 1);
      stream.listen(expectFn);
    });*/
  });

////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('transformer', () {
    testPrefix(input, output) {
      expect(JsonPDecoder().stripPrefix(input), output);
    }

    testSuffix(input, output) {
      var decoder = JsonPDecoder();
      decoder.stripPrefix("(");
      expect(decoder.bufferSuffix(input), output);
    }

    test('stripPrefix no change', () {
      testPrefix("abc", "abc");
      testPrefix("{abc}", "{abc}");
      testPrefix("[abc]", "[abc]");
      testPrefix("[{abc}]", "[{abc}]");
      testPrefix("{[abc]}", "{[abc]}");

      testPrefix("{()abc}", "{()abc}");
      testPrefix("[()abc]", "[()abc]");
      testPrefix("[(){abc}]", "[(){abc}]");
      testPrefix("{()[abc]}", "{()[abc]}");
      testPrefix("[{()abc}]", "[{()abc}]");
      testPrefix("{[()abc]}", "{[()abc]}");
    });
    test('stripPrefix change required', () {
      testPrefix("jsfunction(abc", "abc");
      testPrefix("jsfunction({abc}", "{abc}");
      testPrefix("jsfunction([abc]", "[abc]");
      testPrefix("jsfunction([{abc}]", "[{abc}]");
      testPrefix("jsfunction({[abc]}", "{[abc]}");
    });

    test('bufferSuffix no change', () {
      testSuffix("abc", "abc");
      testSuffix("{abc}", "{abc}");
      testSuffix("[abc]", "[abc]");
      testSuffix("[{abc}]", "[{abc}]");
      testSuffix("{[abc]}", "{[abc]}");

      testSuffix("{()abc}", "{()abc}");
      testSuffix("[()abc]", "[()abc]");
      testSuffix("[(){abc}]", "[(){abc}]");
      testSuffix("{()[abc]}", "{()[abc]}");
      testSuffix("[{()abc}]", "[{()abc}]");
      testSuffix("{[()abc]}", "{[()abc]}");
    });
    test('bufferSuffix change required', () {
      testSuffix("abc)", "abc");
      testSuffix("{abc})", "{abc}");
      testSuffix("[abc])", "[abc]");
      testSuffix("[{abc}])", "[{abc}]");
      testSuffix("{[abc]})", "{[abc]}");
    });
  });
  group('imdb suggestion', () {
    test('extractor', () async {
      String testInput =
          imdbJsonSampleOuter; // TODO: switch to imdbJsonPSampleFull;
      Stream<MovieResultDTO> stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          //.transform(jsonp.decoder)
          .transform(json.decoder)
          .map(
              (outerMap) => (outerMap as Map)[outer_element_results_collection])
          .expand((element) =>
              element) // Emit each element from the list as a seperate stream event
          .map((event) => MovieSuggestionConverter.fromMap(event));
      // .map((event) => (event as Map).toMovieResultDTO());

      var expectedDTO = await expectedDTOList;
      int dtoCount = 0;
      var expectFn = expectAsync1<void, MovieResultDTO>((output) {
        var expectedValue = expectedDTO[dtoCount++];
        var isExpectedValue = MovieResultDTOMatcher(expectedValue);
        expect(output, isExpectedValue);
      }, count: expectedDTO.length, max: expectedDTO.length);
      stream.listen(expectFn);
    });
    test('transformer', () async {
      String testInput =
          imdbJsonSampleOuter; // TODO: switch to imdbJsonPSampleFull;
      Stream<MovieResultDTO> stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder())
          //.transform(JsonPCodec().decoder)
          .transform(json.decoder)
          .map(
              (outerMap) => (outerMap as Map)[outer_element_results_collection])
          .expand((element) =>
              element) // Emit each element from the list as a seperate stream event
          .map((event) => MovieSuggestionConverter.fromMap(event));
      // .map((event) => (event as Map).toMovieResultDTO());

      var expectedDTO = await expectedDTOList;
      int dtoCount = 0;
      var expectFn = expectAsync1<void, MovieResultDTO>((output) {
        var expectedValue = expectedDTO[dtoCount++];
        var isExpectedValue = MovieResultDTOMatcher(expectedValue);
        expect(output, isExpectedValue);
      }, count: expectedDTO.length, max: expectedDTO.length);
      stream.listen(expectFn);
    });
  });
}
