//query string http://www.omdbapi.com/?apikey=<key>&s=wonder+woman
//json format
//Title = title/name
//imdbID = unique key
//Year = year
//Type = title type
//Poster = image url

import 'dart:convert';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '{"source": "omdb", "uniqueId": "tt0451279", "title": "Wonder Woman", "type": "movie", "year": "2017", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BMTYzODQzYjQtNTczNC00MzZhLTg1ZWYtZDUxYmQ3ZTY4NzA1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_SX300.jpg", "related": {}}',
  '{"source": "omdb", "uniqueId": "tt7126948", "title": "Wonder Woman 1984", "type": "movie", "year": "2020", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_SX300.jpg", "related": {}}',
  '{"source": "omdb", "uniqueId": "tt7126948", "title": "Wonder Woman 1984", "type": "movie", "year": "2020", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_SX300.jpg", "related": {}}',
  '{"source": "omdb", "uniqueId": "tt1186373", "title": "Wonder Woman", "type": "movie", "year": "2009", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BNzU1NmNmNTgtMTUyYS00ZmRmLTkzOWItOTY2ZWZiYjVkYzkzXkEyXkFqcGdeQXVyNjExODE1MDc@._V1_SX300.jpg", "related": {}}',
  '{"source": "omdb", "uniqueId": "tt0074074", "title": "Wonder Woman", "type": "series", "year": "1979", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BZjAxYTcxMDUtZTRmMi00NTk3LThkZTItNGNlZTQ3NWRhMjY5XkEyXkFqcGdeQXVyNjExODE1MDc@._V1_SX300.jpg", "related": {}}',
  '{"source": "omdb", "uniqueId": "tt8752498", "title": "Wonder Woman: Bloodlines", "type": "movie", "year": "2019", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BZTkyNmMzMTEtZTNjMC00NTg4LWJlNTktZDdmNzE1M2YxN2E4XkEyXkFqcGdeQXVyNzU3NjUxMzE@._V1_SX300.jpg", "related": {}}',
  '{"source": "omdb", "uniqueId": "tt1740828", "title": "Wonder Woman", "type": "movie", "year": "2011", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BMjA0MzYzNzY3OV5BMl5BanBnXkFtZTcwMzM4ODM4NA@@._V1_SX300.jpg", "related": {}}',
  '{"source": "omdb", "uniqueId": "tt3439676", "title": "Wonder Woman", "type": "movie", "year": "2013", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BMjMzODc5NjUzMF5BMl5BanBnXkFtZTgwNzQ1MjA0MTE@._V1_SX300.jpg", "related": {}}',
  '{"source": "omdb", "uniqueId": "tt0072419", "title": "Wonder Woman", "type": "movie", "year": "1974", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BMTQ3NDkxNjM0Ml5BMl5BanBnXkFtZTgwNzQxNTkwMDE@._V1_SX300.jpg", "related": {}}',
  '{"source": "omdb", "uniqueId": "tt0293979", "title": "Wonder Woman: Who\'s Afraid of Diana Prince?", "type": "movie", "year": "1967", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BYzk4Y2NkNjItZWE1OC00MDc5LWEwNGMtZDFkOGM3MTQzY2YzXkEyXkFqcGdeQXVyMTU2MjI3NTk@._V1_SX300.jpg", "related": {}}',
];

final intermediateMapList = [jsonDecode(omdbJsonSearchFull)];

const omdbJsonSearchInner = '''
  {"Title":"Wonder Woman","Year":"2017","imdbID":"tt0451279","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BMTYzODQzYjQtNTczNC00MzZhLTg1ZWYtZDUxYmQ3ZTY4NzA1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_SX300.jpg"},
  {"Title":"Wonder Woman 1984","Year":"2020","imdbID":"tt7126948","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_SX300.jpg"},
  {"Title":"Wonder Woman 1984","Year":"2020","imdbID":"tt7126948","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_SX300.jpg"},
  {"Title":"Wonder Woman","Year":"2009","imdbID":"tt1186373","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BNzU1NmNmNTgtMTUyYS00ZmRmLTkzOWItOTY2ZWZiYjVkYzkzXkEyXkFqcGdeQXVyNjExODE1MDc@._V1_SX300.jpg"},
  {"Title":"Wonder Woman","Year":"1975–1979","imdbID":"tt0074074","Type":"series","Poster":"https://m.media-amazon.com/images/M/MV5BZjAxYTcxMDUtZTRmMi00NTk3LThkZTItNGNlZTQ3NWRhMjY5XkEyXkFqcGdeQXVyNjExODE1MDc@._V1_SX300.jpg"},
  {"Title":"Wonder Woman: Bloodlines","Year":"2019","imdbID":"tt8752498","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BZTkyNmMzMTEtZTNjMC00NTg4LWJlNTktZDdmNzE1M2YxN2E4XkEyXkFqcGdeQXVyNzU3NjUxMzE@._V1_SX300.jpg"},
  {"Title":"Wonder Woman","Year":"2011","imdbID":"tt1740828","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BMjA0MzYzNzY3OV5BMl5BanBnXkFtZTcwMzM4ODM4NA@@._V1_SX300.jpg"},
  {"Title":"Wonder Woman","Year":"2013","imdbID":"tt3439676","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BMjMzODc5NjUzMF5BMl5BanBnXkFtZTgwNzQ1MjA0MTE@._V1_SX300.jpg"},
  {"Title":"Wonder Woman","Year":"1974","imdbID":"tt0072419","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BMTQ3NDkxNjM0Ml5BMl5BanBnXkFtZTgwNzQxNTkwMDE@._V1_SX300.jpg"},
  {"Title":"Wonder Woman: Who's Afraid of Diana Prince?","Year":"1967","imdbID":"tt0293979","Type":"movie","Poster":"https://m.media-amazon.com/images/M/MV5BYzk4Y2NkNjItZWE1OC00MDc5LWEwNGMtZDFkOGM3MTQzY2YzXkEyXkFqcGdeQXVyMTU2MjI3NTk@._V1_SX300.jpg"}
''';
const omdbJsonSearchFull =
    ' {"Search":[ $omdbJsonSearchInner ],"totalResults":"44","Response":"True"}';
const omdbJsonSearchEmpty = '{"Response":"False","Error":"Movie not found!"}';
const omdbJsonSearchError = '{"Response":"False","Error":"Invalid API key!"}';

Future<Stream<String>> streamOmdbJsonOfflineData(dynamic dummy) {
  return Future.value(emitOmdbJsonOfflineData(dummy));
}

Stream<String> emitOmdbJsonOfflineData(_) async* {
  yield omdbJsonSearchFull;
}

Stream<String> emitOmdbJsonEmpty(_) async* {
  yield omdbJsonSearchEmpty;
}

Stream<String> emitOmdbJsonError(_) async* {
  yield omdbJsonSearchError;
}
