import 'package:my_movie_search/data_model/movie_result_dto.dart';

void main() {
  streamTest();
}

void streamTest() async {
  Stream<String> strStream = Stream<String>.value("ok5");
  Stream<String> strstrStream = multiplyStr(strStream);
  Stream<MovieResultDTO> rStream = expandWrapper(strstrStream, expandDTO);
  print("""original type =  ${strStream.runtimeType}
         new type ${rStream.runtimeType}
         final type ${strstrStream.runtimeType}""");
  printThings(rStream);
}

Stream<MovieResultDTO> expandWrapper(
  Stream<String> str,
  Iterable<MovieResultDTO> convert(String element),
) {
  return str.expand(convert);
}

List<String> expandStr(String str) {
  List<String> lst = [];
  for (var x in [1, 2, 3, 4]) {
    lst.add("$str expanded $x");
  }
  return lst;
}

List<MovieResultDTO> expandDTO(String str) {
  List<MovieResultDTO> lst = [];
  for (var x in [1, 2, 3, 4]) {
    MovieResultDTO dto = MovieResultDTO();
    dto.title = "$str expanded $x";
    lst.add(dto);
  }
  return lst;
}

Future<void> printThings(Stream<MovieResultDTO> data) async {
  await for (MovieResultDTO x in data) {
    print(x.title);
  }
}

Stream<String> multiplyStr(Stream<String> str) async* {
  await for (String y in str) {
    for (var x in [1, 2, 3, 4]) {
      yield "$y$x";
    }
  }
}

Stream<List<String>> multiplyListStr(Stream<String> str) async* {
  List<String> lst;
  await for (String y in str) {
    for (var x in [1, 2, 3, 4]) {
      lst.add("$y$x");
    }
    yield lst;
  }
}

List<String> expandList(String str) {
  List<String> lst;
  for (var x in [1, 2, 3, 4]) {
    lst.add("$str$x");
  }
  return lst;
}

Map<String, String> expandMap(String str) {
  Map<String, String> mp;
  for (var x in [1, 2, 3, 4]) {
    mp["$x"] = "$str$x";
  }
  return mp;
}
