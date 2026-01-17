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

final intermediateErrorList = [jsonDecode(jsonSampleEmpty)];

final intermediateMovieList = [jsonDecode(tvdbJsonSearchMovie)];
final intermediateSeriesList = [jsonDecode(tvdbJsonSearchSeries)];
final intermediateEpisodeList = [jsonDecode(tvdbJsonSearchEpisode)];
final intermediatePersonList = [jsonDecode(tvdbJsonSearchPerson)];

const jsonSampleEmpty = '''
{
  "status": "failure",
  "message": "NotFoundException: not found",
  "data": null
}''';
const jsonSampleError =
    '{"status_code":7,"status_message":'
    '"Invalid API key: You must be granted a valid key.","success":false}';

const jsonSampleFull = tvdbJsonSearchMovie;
Future<Stream<String>> streamTvdbJsonOfflineData(_) =>
    Future.value(Stream.value(jsonSampleFull));


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

const tvdbJsonSearchMovie = '''
{
  "status": "success",
  "data": {
    "id": 2658,
    "name": "Run Lola Run",
    "image": "https://artworks.thetvdb.com/banners/movies/2658/posters/2658.jpg",
    "runtime": 81,
    "status": {
      "id": 5,
      "name": "Released",
      "recordType": "movie",
      "keepUpdated": true
    },
    "year": "1998",
    "genres": [
      {
        "id": 19,
        "name": "Action"
      },
      {
        "id": 12,
        "name": "Drama"
      },
      {
        "id": 24,
        "name": "Thriller"
      }
    ],
    "remoteIds": [
      {
        "id": "tt0130827",
        "type": 2,
        "sourceName": "IMDB"
      },
      {
        "id": "104",
        "type": 10,
        "sourceName": "TheMovieDB.com"
      }
    ],
    "contentRatings": null,
    "originalLanguage": "eng",
    "spoken_languages": [
      "deu",
      "eng",
      "jpn"
    ]
  }
}
''';

const tvdbJsonSearchSeries = '''
{
  "status": "success",
  "data": {
    "id": 397060,
    "name": "Wednesday",
    "image": "https://artworks.thetvdb.com/banners/v4/series/397060/posters/632dbd876738d.jpg",
    "firstAired": "2022-11-23",
    "lastAired": "2025-09-03",
    "status": {
      "id": 1,
      "name": "Continuing",
      "recordType": "series",
      "keepUpdated": true
    },
    "originalLanguage": "eng",
    "averageRuntime": 54,
    "overview": "... Wednesday Addams ...",
    "year": "2022",
    "genres": [
      {
        "id": 6,
        "name": "Horror"
      },
      {
        "id": 10,
        "name": "Fantasy"
      },
      {
        "id": 12,
        "name": "Drama"
      },
      {
        "id": 15,
        "name": "Comedy"
      },
      {
        "id": 31,
        "name": "Mystery"
      }
    ],
    "remoteIds": [
      {
        "id": "10.5240/6AAB-2C51-277B-F331-1F19-1",
        "type": 13,
        "sourceName": "EIDR"
      },
      {
        "id": "tt13443470",
        "type": 2,
        "sourceName": "IMDB"
      },
      {
        "id": "wednesdaynetflix",
        "type": 9,
        "sourceName": "Instagram"
      },
      {
        "id": "81231974",
        "type": 4,
        "sourceName": "Netflix"
      },
      {
        "id": "https://www.netflix.com/title/81231974",
        "type": 4,
        "sourceName": "Official Website"
      },
      {
        "id": "WednesdayTVSeries",
        "type": 7,
        "sourceName": "Reddit"
      },
      {
        "id": "119051",
        "type": 12,
        "sourceName": "TheMovieDB.com"
      },
      {
        "id": "53647",
        "type": 19,
        "sourceName": "TV Maze"
      },
      {
        "id": "Q105553568",
        "type": 18,
        "sourceName": "Wikidata"
      },
      {
        "id": "Wednesday_(TV_series)",
        "type": 24,
        "sourceName": "Wikipedia"
      },
      {
        "id": "wednesdayaddams",
        "type": 6,
        "sourceName": "X (Twitter)"
      }
    ],
    "contentRatings": [
      {
        "id": 218,
        "name": "12",
        "country": "esp",
        "description": "Not recommended for viewers under the age of 12",
        "contentType": "",
        "order": 0,
        "fullname": null
      },
      {
        "id": 74,
        "name": "-12",
        "country": "fra",
        "description": "Not recommended for children under 12",
        "contentType": "",
        "order": 0,
        "fullname": null
      },
      {
        "id": 171,
        "name": "12",
        "country": "pol",
        "description": "For minors from age 12",
        "contentType": "",
        "order": 0,
        "fullname": null
      },
      {
        "id": 246,
        "name": "TV-14",
        "country": "usa",
        "description": "Not suitable for children under 14",
        "contentType": "",
        "order": 0,
        "fullname": null
      }
    ]
  }
}
''';
