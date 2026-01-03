//query string https://api4.thetvdb.com/v4/search/remoteid/tt13443470

//json format
// description:

// For movies {data:[{movie:{...}}]}
// aliases	[...]
// id	integer($int64)
// image	string
// lastUpdated	string
// name	string
// nameTranslations	[...]
// overviewTranslations	[...]
// score	number($double)
// slug	string
// status	Status{...}
// runtime	integer
// nullable: true
// year	string

// For series {data:[{series:{...}}]}
// aliases	[...]
// averageRuntime	integer
// nullable: true
// country	string
// defaultSeasonType	integer($int64)
// episodes	[...]
// firstAired	string  e.g. "2020-12-20"
// id	integer
// image	string
// isOrderRandomized	boolean
// lastAired	string e.g. "2020-12-20"
// lastUpdated	string
// name	string
// nameTranslations	[...]
// nextAired	string
// originalCountry	string
// originalLanguage	string
// overviewTranslations	[...]
// score	number($double)
// slug	string
// status	Status{...}
// year	string

// For episodes {data:[{episode:{...}}]}
// absoluteNumber	integer
// aired	string
// airsAfterSeason	integer
// airsBeforeEpisode	integer
// airsBeforeSeason	integer
// finaleType	string (season, midseason, or series)
// id	integer($int64)
// image	string
// imageType	integer
// nullable: true
// isMovie	integer($int64)
// lastUpdated	string
// linkedMovie	integer
// name	string
// nameTranslations	[...]
// number	integer
// overview	string **
// overviewTranslations	[...]
// runtime	integer
// nullable: true
// seasonNumber	integer
// seasons	[...]
// seriesId	integer($int64)
// seasonName	string
// year	string

import 'dart:convert';

final intermediateMovieList = [jsonDecode(tvdbJsonSearchMovie)];
final intermediateSeriesList = [jsonDecode(tvdbJsonSearchSeries)];
final intermediateEpisodeList = [jsonDecode(tvdbJsonSearchEpisode)];
final intermediatePersonList = [jsonDecode(tvdbJsonSearchPerson)];

const jsonSampleEmpty = '	{  "status": "success",  "data": null}';
const jsonSampleError =
    '{"status_code":7,"status_message":'
    '"Invalid API key: You must be granted a valid key.","success":false}';

const jsonSampleFull = tvdbJsonSearchMovie;
Future<Stream<String>> streamTvdbJsonOfflineData(_) =>
    Future.value(Stream.value(jsonSampleFull));

const tvdbJsonSearchMovie = '''
{
  "status": "success",
  "data": [
    {
      "movie": {
        "id": 2658,
        "name": "Run Lola Run",
        "image": "https://artworks.thetvdb.com/banners/movies/2658/posters/2658.jpg",
        "runtime": 81,
        "lastUpdated": "2024-07-21 07:30:54",
        "year": "1998"
      }
    }
  ]
}
''';
const tvdbJsonSearchSeries = '''
{
  "status": "success",
  "data": [
    {
      "series": {
        "id": 397060,
        "name": "Wednesday",
        "image": "https://artworks.thetvdb.com/banners/v4/series/397060/posters/632dbd876738d.jpg",
        "firstAired": "2022-11-23",
        "lastAired": "2025-09-03",
        "originalLanguage": "eng",
        "averageRuntime": 54,
        "overview": "... Wednesday Addams ...",
        "year": "2022"
      }
    }
  ]
}
''';
const tvdbJsonSearchEpisode = '''
{
  "status": "success",
  "data": [
    {
      "episode": {
        "id": 8437958,
        "seriesId": 397060,
        "name": null,
        "aired": "2022-11-23",
        "runtime": null,
        "image": null,
        "isMovie": 0,
        "seasons": null
      }
    }
  ]
}
''';

const tvdbJsonSearchPerson = '''
{
  "status": "success",
  "data": [
    {
      "people": {
        "id": 253451,
        "name": "Jodie Foster",
        "image": "/banners/person/253451/5f949bf86d19f.jpg",
        "score": 0
      }
    }
  ]
}
''';
