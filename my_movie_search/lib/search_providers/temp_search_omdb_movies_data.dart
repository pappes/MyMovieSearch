import 'dart:async';

//query string http://www.omdbapi.com/?apikey=<key>&s=wonder+woman
//json format
//Title = title/name
//imdbID = unique key
//Year = year
//Type = title type
//Poster = image url

final omdbJsonSearchInner = r'''
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
final omdbJsonSearchFull =
    ' {"Search":[ $omdbJsonSearchInner ],"totalResults":"44","Response":"True"}';
final omdbJsonSearchEmpty = '{"Response":"False","Error":"Movie not found!"}';
final omdbJsonSearchError = '{"Response":"False","Error":"Invalid API key!"}';

Future<Stream<String>> streamOmdbJsonOfflineData(String dummy) async {
  return emitOmdbJsonOfflineData(dummy);
}

Stream<String> emitOmdbJsonOfflineData(String dummy) async* {
  yield omdbJsonSearchFull;
}

Stream<String> emitOmdbJsonEmpty(String dummy) async* {
  yield omdbJsonSearchEmpty;
}

Stream<String> emitOmdbJsonError(String dummy) async* {
  yield omdbJsonSearchError;
}
