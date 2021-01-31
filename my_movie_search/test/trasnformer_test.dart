import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/search_providers/jsonp_transformer.dart';
import 'dart:async';
import 'dart:convert';

//query string https://sg.media-imdb.com/suggests/w/wonder%20woman.json
//json format
//1 = title/name
//id = unique  key (tt=tile/nm=name/vi=video)
//s = supplimentary info (biography, actors or trailer duration
//y = year
//yr = year range for series
//q = title type
//i = image with dimentions)

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
final String imdbJsonPSampleOuter =
    '{"v":1,"q":"wonder_woman","d":[ $imdbJsonSampleInner ]}';
final String imdbJsonPSampleFull =
    ' $imdbJsonPFunction($imdbJsonPSampleOuter) ';
Stream<String> emitString(String str) async* {
  yield str;
}

Stream<List<int>> yieldList(int x) async* {
  yield [x];
}

Stream<List<int>> emitByteStream(String str) async* {
  str.runes.forEach((element) {
    yieldList(element);
  });
}

/*
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

class SubjectUnderTest {
  int i = 0;
  doSomething(x, y) {
    i++;
    print('$x, $y');
  }
}

void main() {
  test('simple test', () {
    print('starting simple test...');
    String testInput = 'B(a)';
    List<List<int>> expectedOutput = [
      [66],
      [40],
      [97],
      [41]
    ];

    var stream = emitByteStream(testInput); //.transform(utf8.decoder);

    int i = 0;
    /*var expectFn = expectAsync1<void, List<int>>((output) {
      expect(output, expectedOutput[i]);
      i++;
    }, count: 2, max: 40);
    stream.listen(expectFn, onDone: () {
      print('stream done');
    });*/
    var consumeFn = (output) {
      print(output);
    };
    stream.listen(consumeFn, onDone: () {
      print('stream done');
    });

    new Timer(new Duration(seconds: 5), () {});
    print('finshed simple test...');
  });

  test('async test, check a function with 2 parameters', () {
    var sut = new SubjectUnderTest();
    var fun = expectAsync2(sut.doSomething,
        count: 2, max: 2, id: 'check doSomething');

    new Timer(new Duration(milliseconds: 200), () {
      fun(1, 2);
      expect(sut.i, greaterThan(0));
    });

    new Timer(new Duration(milliseconds: 100), () {
      fun(3, 4);
      expect(sut.i, greaterThan(0));
    });
  });
}

/*
  test('JsonP wrapper is stripped', () async {
    String testInput = imdbJsonPSampleFull;
    print(imdbJsonPFunction);
    List<String> expectedOutput = [imdbJsonPSampleOuter];

    testInput = 'B(a)';
    expectedOutput = [testInput];
//    Stream<String> stream = emitString(testInput).transform(jsonp.decoder);
    var stream = emitByteStream(testInput).transform(utf8.decoder);

    //  await expectLater(stream, emitsInOrder(expectedOutput));

//    List<Record> expectedRecords = [record1, record2, record3];
    int i = 0;
    stream.listen(expectAsync1<void, String>((output) {
      expect(output, testInput);
      i++;
    }, count: 3, max: 4));
/*
  for (int i = 0; i < 6; i++) {
    wordTracker.nextWord();
  }*/
  });
}*/

/*
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
*/
