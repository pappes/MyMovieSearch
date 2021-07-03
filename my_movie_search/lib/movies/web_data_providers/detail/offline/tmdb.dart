//query string https://api.themoviedb.org/3/movie/{movieID]?api_key={api_key}&query=home
//json format
//title = title/name
//id = unique key
//release_date = date the movie was released e.g. "2019-06-28",
//vote_average = User rating
//vote_count =  Count of users taht have rated
//poster_path = image url fragment
//backdrop_path = alternate image url fragment
//video = indicator of low quality movie (true/false)
//adult = indicator of adult content (true/false)
//genre_ids = list of numeric ids that need to be correlated with another web service call e.g. [28, 12, 878]
//original_language = language spoken during the movie (iso_639_1) e.g. "en"
//original_title = previous title assigned to the movie
//overview = synopsis of the movie plot
//popularity = raking to indcate how popular the movie is e.g. "280.151",

final tmdbJsonSearchInner = r'''
  {"adult":false,
  "backdrop_path":null,
  "belongs_to_collection":null,
  "budget":0,
  "genres":[{"id":16,"name":"Animation"}],
  "homepage":"",
  "id":284821,
  "imdb_id":"tt2503234",
  "original_language":"en",
  "original_title":"Winnie the Pooh - 123's",
  "overview":"Winnie the Pooh and friends teach counting.",
  "popularity":2.164,
  "poster_path":"/gj8pk74zOUJYZsGZJn8WY7V4PZR.jpg",
  "production_companies":[{"id":3475,"logo_path":"/jTPNzDEn7eHmp3nEXEEtkHm6jLg.png",
  "name":"Disney Television Animation","origin_country":"US"}],
  "production_countries":[{"iso_3166_1":"US","name":"United States of America"}],
  "release_date":"2004-10-12",
  "revenue":0,
  "runtime":30,
  "spoken_languages":[],
  "status":"Released",
  "tagline":"",
  "title":"Winnie the Pooh - 123's",
  "video":true,
  "vote_average":6.8,
  "vote_count":10}

{"adult":false,
  "backdrop_path":"/lhsrT0SbPaqmBMHLd5N83j8XAFy.jpg",
  "belongs_to_collection":null,
  "budget":1530000,
  "genres":[{"id":28,"name":"Action"},{"id":18,"name":"Drama"},{"id":53,"name":"Thriller"}],
  "homepage":"",
  "id":104,
  "imdb_id":"tt0130827",
  "original_language":"de",
  "original_title":"Lola rennt",
  "overview":"Lola receives a phone call from her boyfriend Manni. He lost 100,000 DM in a subway train that belongs to a very bad guy. She has 20 minutes to raise this amount and meet Manni. Otherwise, he will rob a store to get the money. Three different alternatives may happen depending on some minor event along Lola's run.",
  "popularity":9.313,
  "poster_path":"/yBt6rkxRTP15nyOZOJt9pOgXDW0.jpg",
  "production_companies":[{"id":96,  "logo_path":"/9ps82gVzUeNdkjmLzoGDQLiLDio.png",  "name":"X Filme Creative Pool",
  "origin_country":"DE"},{"id":46,  "logo_path":"/3xFdKHLXPGHEbrAkmsepGE8974Y.png",  "name":"WDR",  "origin_country":"DE"}],
  "production_countries":[{"iso_3166_1":"DE",  "name":"Germany"}],
  "release_date":"1998-03-03",
  "revenue":7267585,
  "runtime":81,
  "spoken_languages":[{"english_name":"German",  "iso_639_1":"de",  "name":"Deutsch"},
  {"english_name":"English",  "iso_639_1":"en",  "name":"English"},
  {"english_name":"Japanese",  "iso_639_1":"ja",  "name":"日本語"}],
  "status":"Released",
  "tagline":"Every second of every day you're faced with a decision that can change your life.",
  "title":"Run Lola Run",
  "video":false,
  "vote_average":7.3,
  "vote_count":1537}
''';

final tmdbJsonSearchFull =
    ' { "page": 1, "results": [ $tmdbJsonSearchInner ], "total_pages": 12, "total_results": 340 } ';
final tmdbJsonSearchEmpty =
    '{"success":false,"status_code":34,"status_message":"The resource you requested could not be found."}';
final tmdbJsonSearchError =
    '{"status_code":7,"status_message":"Invalid API key: You must be granted a valid key.","success":false}';

Stream<String> streamTmdbJsonOfflineData(dynamic dummy) {
  return emitTmdbJsonOfflineData(dummy);
}

Stream<String> emitTmdbJsonOfflineData(dynamic dummy) async* {
  yield tmdbJsonSearchFull;
}

Stream<String> emitTmdbJsonEmpty(dynamic dummy) async* {
  yield tmdbJsonSearchEmpty;
}

Stream<String> emitTmdbJsonError(dynamic dummy) async* {
  yield tmdbJsonSearchError;
}
