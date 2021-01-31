import 'dart:async';
import 'dart:convert';

import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/data_model/search_criteria_dto.dart';

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
final String imdbJsonPSampleFull = '''
  $imdbJsonPFunction(
    {"v":1,"q":"wonder_woman","d":[ $imdbJsonSampleInner ]}
  ) ''';
Stream<String> emitImdbJsonSample() async* {
  yield imdbJsonPSampleFull.stripJsonP();
}

extension JsonString on String {
  String stripJsonP() {
    final startIndex = this.indexOf("{");
    final endIndex = this.lastIndexOf("}");
    return this.substring(startIndex, endIndex + 1);
  }

  Map jsonDecode() => json.decode(this);
}

const outer_element_results_collection = 'd';
const inner_element_identity_element = 'id';
const inner_element_title_element = 'l';
const inner_element_year_element = 'y';
const inner_element_year_range_element = 'yr';

class QueryIMDBSuggestions {
  static executeQuery(
    StreamController<MovieResultDTO> sc,
    SearchCriteriaDTO criteria,
  ) {
    var mymap = imdbJsonPSampleFull.stripJsonP().jsonDecode();
    MovieResultDTO myDTO = MovieSuggestionConverter.fromCompleteJsonMap(mymap);
  }
}

class QueryIMDBSuggestions_temp {
  static executeQuery(
    StreamController<MovieResultDTO> sc,
    SearchCriteriaDTO criteria,
  ) async {
//    streamResponse.stream.transform(utf8.decoder); /**/
    emitImdbJsonSample()
        .transform(json.decoder)
        //TODO: build a transformer to strip JSONP https://stackoverflow.com/questions/27765878/how-to-create-a-streamtransformer-in-dart
        .expand((element) =>
            element) // expand the JSON collection and emit the single results record into a new stream
        //use map to pull query result out of query wrapper
/*        .map((map) => map[outer_element_results_collection])
        //use expand to create a list of movies from the query result
        .expand((element) =>
            element) // expand the collection of records and emit them one at a time into a new stream
        //use map to transform the list entry into a DTO
        .map((event) => MovieSuggestionConverter.fromInnerJsonMap(event))*/
        .map((event) => MovieSuggestionConverter.fromCompleteJsonMap(event))
        /*.transform(json.decoder)
        .expand((element) =>
            element) // expand each element and put them into a collection
        .map((map) => MovieResultConverter.fromJsonMap(map))*/
        .pipe(sc);
  }
}

class MovieSuggestionConverter {
  static MovieResultDTO fromCompleteJsonMap(Map map) {
    // 2 phase converter in constructor - deserialise outer json from map
    // then deserialise inner json from map
    var resultCollection = map[outer_element_results_collection];

    //Map innerJson = json.decode(resultCollection);
    var x = MovieResultDTO();
    for (Map innerJson in resultCollection) {
      x = fromMap(innerJson);
    }
    return x;
  }

  static Stream<MovieResultDTO> fromInnerJsonMap(Iterable records) async* {
    for (Map record in records) {
      yield fromMap(record);
    }
  }

  static MovieResultDTO fromMap(Map map) {
    var x = MovieResultDTO();
    x.uniqueId = map[inner_element_identity_element];
    x.title = map[inner_element_title_element];
    x.year = map[inner_element_year_element];
    x.yearRange = map[inner_element_year_range_element];
    return x;
  }
}
