//query string https://www.imdb.com/title/tt0106977/fullcredits?ref_=tt_ov_st_sm
// Raw data in code is generated from an external source.
// ignore_for_file: unnecessary_ignore
// ignore_for_file: unnecessary_raw_strings

import 'dart:convert';

Future<Stream<String>> streamImdbHtmlOfflineFilteredData(_) =>
    Future.value(Stream.value(jsonEncode(imdbJsonWrappedPaginatedSample)));

Future<Stream<String>> streamImdbHtmlOfflinePaginatedData(_) =>
    Future.value(Stream.value(jsonEncode(imdbJsonWrappedPaginatedSample)));

const imdbJsonWrappedPaginatedSample = {
  'data': {'name': imdbJsonInnerPaginatedSample},
};

const imdbJsonWrappedFilteredSample = {
  'data': {'name': imdbJsonInnerFilteredSample},
};

const imdbJsonInnerNameSample = <String, Object>{
  'nameText': {'text': 'Raman Rodger'},
  'primaryImage': {
    'caption': {'plainText': 'Raman Rodger'},
    'height': 1479,
    'width': 986,
    'url':
        'https://m.media-amazon.com/images/M/MV5BNWMyMGQxZVyNTAyNTY1NA@@._V1_CR243,0,986,1479_.jpg',
  },
};

const imdbJsonInnerPaginatedSample = {
  'id': 'nm1913125',
  ...imdbJsonInnerNameSample,
  'actor_credits': threeEdges,
};

const imdbJsonInnerFilteredSample = {
  'id': 'nm1913125',
  ...imdbJsonInnerNameSample,
  ...imdbJsonInnerFilteredSampleResults,
};

const imdbJsonInnerFilteredSampleResults = {
  'unreleasedCredits': [
    {
      'category': {'id': 'actor', 'text': 'Actor'},
      'credits': oneEdge,
    },
  ],
  'releasedCredits': [
    {
      'category': {'id': 'actor', 'text': 'Actor'},
      'credits': twoEdges,
    },
  ],
};

const oneEdge = {
  'total': 1,
  'edges': [imdbJsonNode1Sample],
};

const twoEdges = {
  'total': 2,
  'edges': [imdbJsonNode2Sample, imdbJsonNode3Sample],
};

const threeEdges = {
  'total': 3,
  'edges': [imdbJsonNode1Sample, imdbJsonNode2Sample, imdbJsonNode3Sample],
};

const imdbJsonNode1Sample = {
  'node': {
    'attributes': null,
    'category': {'id': 'actor', 'text': 'Actor'},
    'characters': [
      {'name': 'Willman Tryer'},
    ],
    'episodeCredits': {
      'total': 23,
      'yearRange': {'year': 2023, 'endYear': 2024},
      'displayableYears': {
        'total': 2,
        'edges': [
          {
            'node': {
              'year': '2003',
              'displayableProperty': {
                'value': {'plainText': '2003'},
              },
            },
          },
        ],
      },
    },
    'title': {
      'id': 'tt17512392',
      'canRate': {'isRatable': true},
      'certificate': {'rating': 'TV-14'},
      'originalTitleText': {'text': 'Willman Tryer'},
      'titleText': {'text': 'Willman Tryer'},
      'titleType': {
        'canHaveEpisodes': true,
        'displayableProperty': {
          'value': {'plainText': 'TV Series'},
        },
        'text': 'TV Series',
        'id': 'tvSeries',
      },
      'primaryImage': {
        'url':
            'https://m.media-amazon.com/images/M/MV5BNjZhZWMwNTMmVmXkEyXkFqcGdeQXVyMTY0Njc2MTUx._V1_.jpg',
        'height': 1351,
        'width': 1080,
        'caption': {'plainText': 'Raman Rodger in Willman Tryer (2003)'},
      },
      'ratingsSummary': {'aggregateRating': 3.3, 'voteCount': 11235},
      'releaseYear': {'year': 2003, 'endYear': null},
      'runTime': {'seconds': 2123},
      'series': null,
      'titleGenres': {
        'genres': [
          {
            'genre': {'text': 'Crime'},
          },
          {
            'genre': {'text': 'Drama'},
          },
        ],
      },
    },
  },
};
const imdbJsonNode2Sample = {
  'node': {
    'attributes': [
      {'text': 'as Raman Rodger'},
    ],
    'category': {'id': 'actor', 'text': 'Actor'},
    'characters': [
      {'name': 'Jacob'},
    ],
    'title': {
      'id': 'tt11812323',
      'canRate': {'isRatable': true},
      'certificate': null,
      'originalTitleText': {'text': 'lilly'},
      'titleText': {'text': 'lilly'},
      'titleType': {
        'canHaveEpisodes': false,
        'displayableProperty': {
          'value': {'plainText': ''},
        },
        'text': 'Movie',
        'id': 'movie',
      },
      'primaryImage': {
        'url':
            'https://m.media-amazon.com/images/M/MV5BNWFhNcGdeQXVyMTcyODY0OTE@._V1_.jpg',
        'height': 2560,
        'width': 1728,
        'caption': {'plainText': 'lilly (2002)'},
      },
      'ratingsSummary': {'aggregateRating': 7.5, 'voteCount': 2123},
      'releaseYear': {'year': 2002, 'endYear': null},
      'runTime': {'seconds': 5123},
      'series': null,
      'titleGenres': {
        'genres': [
          {
            'genre': {'text': 'Horror'},
          },
        ],
      },
    },
  },
};
const imdbJsonNode3Sample = {
  'node': {
    'attributes': [
      {'text': 'as Raman Rodger'},
    ],
    'category': {'id': 'actor', 'text': 'Actor'},
    'characters': null,
    'title': {
      'id': 'tt11123818',
      'certificate': null,
      'originalTitleText': {'text': 'Our Tupple'},
      'titleText': {'text': 'Our Tupple'},
      'titleType': {
        'canHaveEpisodes': false,
        'displayableProperty': {
          'value': {'plainText': 'TV Movie'},
        },
        'text': 'TV Movie',
        'id': 'tvMovie',
      },
      'primaryImage': {
        'url':
            'https://m.media-amazon.com/images/M/MV5BNTE0NWNhZGdeQXVyMTY1ODE1NTk@._V1_.jpg',
        'height': 2304,
        'width': 1728,
        'caption': {'plainText': 'Our Tupple (2002)'},
      },
      'ratingsSummary': {'aggregateRating': 6.7, 'voteCount': 8},
      'releaseYear': {'year': 2002, 'endYear': null},
      'runTime': null,
      'series': null,
      'titleGenres': {
        'genres': [
          {
            'genre': {'text': 'Drama'},
          },
        ],
      },
    },
  },
};



const imdbJsonInnerFilteredSampleAdhoc = {
  "props": {
    "pageProps": {
      "nmconst": "nm0000149",
      "aboveTheFold": {
        "id": "nm0000149",
        "nameText": {"text": "Jodie Foster", "__typename": "NameText"},
        "searchIndexing": {
          "disableIndexing": false,
          "__typename": "NameSearchIndexing",
        },
        "disambiguator": null,
        "knownForV2": {
          "credits": [
            {
              "creditedRoles": {
                "edges": [
                  {
                    "node": {
                      "category": {
                        "text": "Actress",
                        "__typename": "CreditCategory",
                      },
                      "__typename": "CreditedRole",
                    },
                    "__typename": "CreditedRoleEdge",
                  },
                ],
                "__typename": "CreditedRoleConnection",
              },
              "title": {
                "titleText": {
                  "text": "The Silence of the Lambs",
                  "__typename": "TitleText",
                },
                "__typename": "Title",
              },
              "__typename": "CreditV2",
            },
            {
              "creditedRoles": {
                "edges": [
                  {
                    "node": {
                      "category": {
                        "text": "Actress",
                        "__typename": "CreditCategory",
                      },
                      "__typename": "CreditedRole",
                    },
                    "__typename": "CreditedRoleEdge",
                  },
                ],
                "__typename": "CreditedRoleConnection",
              },
              "title": {
                "titleText": {"text": "The Accused", "__typename": "TitleText"},
                "__typename": "Title",
              },
              "__typename": "CreditV2",
            },
            {
              "creditedRoles": {
                "edges": [
                  {
                    "node": {
                      "category": {
                        "text": "Actress",
                        "__typename": "CreditCategory",
                      },
                      "__typename": "CreditedRole",
                    },
                    "__typename": "CreditedRoleEdge",
                  },
                ],
                "__typename": "CreditedRoleConnection",
              },
              "title": {
                "titleText": {"text": "Taxi Driver", "__typename": "TitleText"},
                "__typename": "Title",
              },
              "__typename": "CreditV2",
            },
          ],
          "__typename": "KnownForV2",
        },
        "images": {
          "total": 929,
          "edges": [
            {
              "node": {"id": "rm4563202", "__typename": "Image"},
              "__typename": "ImageEdge",
            },
          ],
          "__typename": "ImageConnection",
        },
        "primaryImage": {
          "id": "rm3507258880",
          "url":
              "https://m.media-amazon.com/images/M/MV5BMTM3MjgyOTQwNF5BMl5BanBnXkFtZTcwMDczMzEwNA@@._V1_.jpg",
          "height": 400,
          "width": 274,
          "caption": {"plainText": "Jodie Foster", "__typename": "Markdown"},
          "__typename": "Image",
        },
        "meta": {
          "canonicalId": "nm0000149",
          "publicationStatus": "PUBLISHED",
          "__typename": "NameMeta",
        },
        "bio": {
          "text": {
            "plainText":
                "Jodie Foster started her career at the age of two. For four years she made commercials and finally gave her debut as an actress in the TV series Mayberry R.F.D. (1968). In 1975 Jodie was offered the role of prostitute Iris Steensma in the movie Taxi Driver (1976). This role, for which she received an Academy Award nomination in the \"Best Supporting Actress\" category, marked a breakthrough in her career. In 1980 she graduated as the best of her class from the College Lycée Français and began to study English Literature at Yale University, from where she graduated magna cum laude in 1985. One tragic moment in her life was March 30th, 1981 when John Warnock Hinkley Jr. attempted to assassinate the President of the United States, Ronald Reagan. Hinkley was obsessed with Jodie and the movie Taxi Driver (1976), in which Travis Bickle, played by Robert De Niro, tried to shoot presidential candidate Palantine. Despite the fact that Jodie never took acting lessons, she received two Oscars before she was thirty years of age. She received her first award for her part as Sarah Tobias in The Accused (1988) and the second one for her performance as Clarice Starling in The Silence of the Lambs (1991).",
            "plaidHtml":
                "Jodie Foster started her career at the age of two. For four years she made commercials and finally gave her debut as an actress in the TV series \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0062587/?ref_=nm_ov_bio_lk\"\u003eMayberry R.F.D. (1968)\u003c/a\u003e. In 1975 Jodie was offered the role of prostitute Iris Steensma in the movie \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0075314/?ref_=nm_ov_bio_lk\"\u003eTaxi Driver (1976)\u003c/a\u003e. This role, for which she received an Academy Award nomination in the \u0026quot;Best Supporting Actress\u0026quot; category, marked a breakthrough in her career. In 1980 she graduated as the best of her class from the College Lycée Français and began to study English Literature at Yale University, from where she graduated magna cum laude in 1985. One tragic moment in her life was March 30th, 1981 when John Warnock Hinkley Jr. attempted to assassinate the President of the United States, \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/name/nm0001654/?ref_=nm_ov_bio_lk\"\u003eRonald Reagan\u003c/a\u003e. Hinkley was obsessed with Jodie and the movie \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0075314/?ref_=nm_ov_bio_lk\"\u003eTaxi Driver (1976)\u003c/a\u003e, in which Travis Bickle, played by \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/name/nm0000134/?ref_=nm_ov_bio_lk\"\u003eRobert De Niro\u003c/a\u003e, tried to shoot presidential candidate Palantine. Despite the fact that Jodie never took acting lessons, she received two Oscars before she was thirty years of age. She received her first award for her part as Sarah Tobias in \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0094608/?ref_=nm_ov_bio_lk\"\u003eThe Accused (1988)\u003c/a\u003e and the second one for her performance as Clarice Starling in \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0102926/?ref_=nm_ov_bio_lk\"\u003eThe Silence of the Lambs (1991)\u003c/a\u003e.",
            "__typename": "Markdown",
          },
          "__typename": "NameBio",
        },
        "primaryProfessions": [
          {
            "category": {
              "text": "Actress",
              "id": "actress",
              "__typename": "CreditCategory",
            },
            "__typename": "PrimaryProfession",
          },
          {
            "category": {
              "text": "Producer",
              "id": "producer",
              "__typename": "CreditCategory",
            },
            "__typename": "PrimaryProfession",
          },
          {
            "category": {
              "text": "Director",
              "id": "director",
              "__typename": "CreditCategory",
            },
            "__typename": "PrimaryProfession",
          },
        ],
        "professions": [
          {
            "profession": {
              "text": "Actress",
              "id": "+2iuvL65p90nEszaLukEz/9Nmj2lO62NenPTcidw/2k=",
              "__typename": "DisplayableProfession",
            },
            "__typename": "NameProfession",
          },
          {
            "profession": {
              "text": "Producer",
              "id": "J58WR6Xx4ET8VJezW1l62HUJrkmUvWHtk10Gev/HtZo=",
              "__typename": "DisplayableProfession",
            },
            "__typename": "NameProfession",
          },
          {
            "profession": {
              "text": "Director",
              "id": "W1jLvsNZ7YKaSv77O7dU80c2m9K79g0mIP3EomOUjuw=",
              "__typename": "DisplayableProfession",
            },
            "__typename": "NameProfession",
          },
        ],
        "birthDate": {
          "displayableProperty": {
            "value": {
              "plainText": "November 19, 1962",
              "__typename": "Markdown",
            },
            "__typename": "DisplayableDateProperty",
          },
          "date": "1962-11-19",
          "dateComponents": {
            "day": 19,
            "month": 11,
            "year": 1962,
            "isBCE": false,
            "__typename": "DateComponents",
          },
          "__typename": "DisplayableDate",
        },
        "deathDate": null,
        "deathStatus": "ALIVE",
        "meterRanking": {
          "currentRank": 737,
          "rankChange": {
            "changeDirection": "DOWN",
            "difference": 121,
            "__typename": "MeterRankChange",
          },
          "__typename": "NameMeterRanking",
        },
        "subNavBio": {"id": "mb0073848", "__typename": "NameBio"},
        "subNavTrivia": {"total": 130, "__typename": "NameTriviaConnection"},
        "subNavAwardNominations": {
          "total": 161,
          "__typename": "AwardNominationConnection",
        },
        "subNavFaqs": {"total": 12, "__typename": "AlexaQuestionConnection"},
        "videos": {"total": 91, "__typename": "VideoConnection"},
        "primaryVideos": {
          "edges": [
            {
              "node": {
                "id": "vi1749665561",
                "createdDate": "2024-02-08T22:46:18Z",
                "isMature": false,
                "runtime": {"value": 60, "__typename": "VideoRuntime"},
                "name": {
                  "value": "Oscars 2024 Best Supporting Actress Nominees",
                  "language": "en",
                  "__typename": "LocalizedString",
                },
                "description": {
                  "value":
                      "Who would you choose for Best Actress in a Supporting Role at the 96th Academy Awards between Da'Vine Joy Randolph (The Holdovers), Jodie Foster (Nyad), America Ferrera (Barbie), Emily Blunt (Oppenheimer), and Danielle Brooks (The Color Purple)?",
                  "language": "en",
                  "__typename": "LocalizedString",
                },
                "timedTextTracks": [
                  {
                    "displayName": {
                      "value": "English",
                      "language": "en-US",
                      "__typename": "LocalizedString",
                    },
                    "refTagFragment": "cc-en-US",
                    "type": "CLOSED_CAPTION",
                    "language": "en-US",
                    "url":
                        "https://assets.video.media-imdb.com/vi1749665561/en-US-manual-cc-1707432609.srt",
                    "__typename": "VideoTimedTextTrack",
                  },
                ],
                "recommendedTimedTextTrack": {
                  "displayName": {
                    "value": "English",
                    "language": "en-US",
                    "__typename": "LocalizedString",
                  },
                  "refTagFragment": "cc-en-US",
                  "type": "CLOSED_CAPTION",
                  "language": "en-US",
                  "url":
                      "https://assets.video.media-imdb.com/vi1749665561/en-US-manual-cc-1707432609.srt",
                  "__typename": "VideoTimedTextTrack",
                },
                "thumbnail": {
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BMzc5NjJhM2MtNzQwMi00YTY0LWJmMWUtYjUxYjFiY2MwYzM3XkEyXkFqcGdeQWFsZWxvZw@@._V1_.jpg",
                  "height": 1080,
                  "width": 1920,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "id": "tt31187450",
                  "titleText": {
                    "text": "Oscars 2024 Best Supporting Actress Nominees",
                    "__typename": "TitleText",
                  },
                  "originalTitleText": {
                    "text": "Oscars 2024 Best Supporting Actress Nominees",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2024,
                    "__typename": "YearRange",
                    "endYear": null,
                  },
                  "__typename": "Title",
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                },
                "playbackURLs": [
                  {
                    "displayName": {
                      "value": "1080p",
                      "language": "en-US",
                      "__typename": "LocalizedString",
                    },
                    "videoMimeType": "MP4",
                    "videoDefinition": "DEF_1080p",
                    "url":
                        "https://imdb-video.media-imdb.com/vi1749665561/1434659529640-260ouz-1707432378971.mp4?Expires=1774845598\u0026Signature=AbUzLct6xXVdAp7-SLK-wSoJwHHqMxybkt1LOUZNMu8bfJDQPQ7RE2P0SdulUBJt~plzQAD7II-c37RgieWPDVF9COqStzNVBsvNc125rbYQEdnNnGSO0ISIXJUsKBsSIOKMaqFy6yg73uO63x20qorSUD3aHL9~a0wuIdgJnYBDidz5V5TM7AH5kRPheN46MSmUvZCTGwMSnKLwqsdt~MwOKFIOeckwWOTplw0BzEhAVdwPjBWTZeOtGgsN6Zzqe68z2PsiN-JwFYXHab5HwIi-02Kub5RCdkNXSJ1yqpRfoDUqKAVc6YZtsLu2OgE29pMA~xzP-IxydmT-rFUGxw__\u0026Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
                    "metricDimensions": [
                      {
                        "name": "encoder",
                        "value": "ETS",
                        "__typename": "MetricDimension",
                      },
                    ],
                    "__typename": "PlaybackURL",
                  },
                  {
                    "displayName": {
                      "value": "AUTO",
                      "language": "en-US",
                      "__typename": "LocalizedString",
                    },
                    "videoMimeType": "M3U8",
                    "videoDefinition": "DEF_AUTO",
                    "url":
                        "https://imdb-video.media-imdb.com/vi1749665561/hls-1707432378971-master.m3u8?Expires=1774845598\u0026Signature=GcNw0JsAlZT4fv3IjnRT8FH~33sgDGmqzrQZ9RREu3sAIjkSDmDbNGarIfrqcNsvDq~8YxmaM-b15gE8TkTa0Ys2dYzII-1H49wjjKmELmdsoTBZMatUCr4VmRGIckWDwW57oqMZxqsjprhj~ALIDdoFKMmYQoCffdbkuqfrjEJlTx~KjNS84kV~fBymwXjsFLeXxNTJbd~EEr3VyFHYmlgqKKUVV6gEqYhyucFDysvlI7FITdngTXRRIuCyXvXQHgoqa7GJydVSMfR74sBEQNN7YVtHT24IdkENS6MLqXTQ5SWh2Yo24XUWFAPmGFIyz7GRTbRcBM7uo6ULQvnk7Q__\u0026Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
                    "metricDimensions": [
                      {
                        "name": "encoder",
                        "value": "ETS",
                        "__typename": "MetricDimension",
                      },
                    ],
                    "__typename": "PlaybackURL",
                  },
                  {
                    "displayName": {
                      "value": "SD",
                      "language": "en-US",
                      "__typename": "LocalizedString",
                    },
                    "videoMimeType": "MP4",
                    "videoDefinition": "DEF_SD",
                    "url":
                        "https://imdb-video.media-imdb.com/vi1749665561/1434659454657-dx9ykf-1707432378971.mp4?Expires=1774845598\u0026Signature=i8N80niHG3RLCYQlsSSkl4oGcu7imYW-IaB8jX~splndpccFBCmtiiWn4XQuu-cxYMbBTN~D1wDx2ewN2qbrsv~LkS1wF-F53XumVSFQQnI~2wXmfMtp8jWLJSuJZv8hQIgyDDwVy-BqSOodEibjmmjVdtS1ixZI2o98pmJOrFOv844YPsDleK7RpXcx0xozJMXdJaLjNOJXYLs2V65-7D2XkRXHYhR6gLyV1FFUAH4oC3pwR14WykBsIYl8f7IMfdVglwKJLZ~1ii0lG8KlDGg5nHbUfxPkoYMLnhuc-KVFECoyQNQZVjDtMXJJmIE~lL0BpeU4~~rB5IC~7ThieQ__\u0026Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
                    "metricDimensions": [
                      {
                        "name": "encoder",
                        "value": "ETS",
                        "__typename": "MetricDimension",
                      },
                    ],
                    "__typename": "PlaybackURL",
                  },
                  {
                    "displayName": {
                      "value": "720p",
                      "language": "en-US",
                      "__typename": "LocalizedString",
                    },
                    "videoMimeType": "MP4",
                    "videoDefinition": "DEF_720p",
                    "url":
                        "https://imdb-video.media-imdb.com/vi1749665561/1434659379400-8cjq25-1707432378971.mp4?Expires=1774845598\u0026Signature=mmPeO2uuQMI2yxQ~oLxGgUuIuU-mqN2TJoCc1XODyvYkXRpZtpVkFIv9lGoohqPcHQKUtxrxxtxH082B5V4QjU3dIeb72pF4GNfj4dwiVIBAeNXQXz~8YpjGKsAjAE0JkQdaO1YAG4k~p2CtZl7Mm59YGO0whPthx4B3BLhGN1UADj87yo6fR5OflK4qvQ-j6bfmsGIXl3KnqHptQQAtwV51DEh7tw6Tgs4CI7Niuzi5YHvts909q5aydp~IL5aqDkyDX2HvoUAOUQQi8PKk7rS8RjmxeZGUZFGT~9VXSLGkvK8RkuMALiHklfoq~5kzQnhmmMZ-zyJkE5CuYNMk6Q__\u0026Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
                    "metricDimensions": [
                      {
                        "name": "encoder",
                        "value": "ETS",
                        "__typename": "MetricDimension",
                      },
                    ],
                    "__typename": "PlaybackURL",
                  },
                  {
                    "displayName": {
                      "value": "480p",
                      "language": "en-US",
                      "__typename": "LocalizedString",
                    },
                    "videoMimeType": "MP4",
                    "videoDefinition": "DEF_480p",
                    "url":
                        "https://imdb-video.media-imdb.com/vi1749665561/1434659607842-pgv4ql-1707432378971.mp4?Expires=1774845598\u0026Signature=W1lB~-GMNwpym-~66EVDmwyiz9uU0MK4M-VUzavoBRlN0Yd0G87JP3pvl7irb2Lo8HnIFTZnDJUYC1M0K88vqYNOu1B-mzqcCAGLUxTEV20NmzNrfl5nuJJZQh~W2FmOc6vloBBVktWMmFw3uHVNjV4xA~5y1i-TE~UdXPbtLAj8gQAbFvncOZuY0jZFw9TBvMqqZKJ6XEbMq3ykx8gQnsFGTqAeHMFDR7uuGILIpBDs2yc6onX0~Jifa1jU~aUa115~05onxFcT8itCtYgZsj6jNJaDL~jl9qgEdnid66ud1VDisqPYX26daaD5Yj6Dk-F7BqdN7w75claYCz~z7A__\u0026Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
                    "metricDimensions": [
                      {
                        "name": "encoder",
                        "value": "ETS",
                        "__typename": "MetricDimension",
                      },
                    ],
                    "__typename": "PlaybackURL",
                  },
                ],
                "contentType": {
                  "id": "amzn1.imdb.video.contenttype.clip",
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "previewURLs": [
                  {
                    "displayName": {
                      "value": "AUTO",
                      "language": "en-US",
                      "__typename": "LocalizedString",
                    },
                    "videoMimeType": "M3U8",
                    "videoDefinition": "DEF_AUTO",
                    "url":
                        "https://imdb-video.media-imdb.com/vi1749665561/hls-preview-22e4c194-8d8e-41c0-b4a3-5e7fa740d30e.m3u8?Expires=1774845598\u0026Signature=V40NUV1pMs-xyDU1pfEyl1tmpDlBjP0T6xqER6umvJv6cAVBOsOkTP0HpYg70tnaMVmGMkoPmaGNEEGFVFWGsl8LYlmn6oRWQK870N9LMoOH4~pYqu115fcF4YzRgKHlN7aYQ0wbMBG9dqU6Q2C4XBTi-9h2-WSGn684ALL~pvc6tKSO-XpkZgjoBVSizF2lDednOpAI9Bupk~Ukiko6KSM-PimuDa4c5GpyVUcJwBeHd8dxdAERFOIrjaRPOnqXmGpeZV2Ty1ExB599UMseXM1seCJR6XbQHkK258wMF4~kEpu1uTlKKYzcJb8Mg4BfbJXRyuIin6UX3-kE0Pnv8A__\u0026Key-Pair-Id=APKAIFLZBVQZ24NQH3KA",
                    "__typename": "PlaybackURL",
                  },
                ],
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
          ],
          "__typename": "VideoConnection",
        },
        "__typename": "Name",
      },
      "mainColumnData": {
        "id": "nm0000149",
        "wins": {"total": 76, "__typename": "AwardNominationConnection"},
        "nominationsExcludeWins": {
          "total": 85,
          "__typename": "AwardNominationConnection",
        },
        "prestigiousAwardSummary": {
          "nominations": 3,
          "wins": 2,
          "award": {
            "text": "Oscar",
            "id": "aw0000016",
            "event": {"id": "ev0000003", "__typename": "AwardsEvent"},
            "__typename": "AwardDetails",
          },
          "__typename": "PrestigiousAwardSummary",
        },
        "images": {
          "total": 929,
          "edges": [
            {
              "node": {
                "id": "rm4563202",
                "url":
                    "https://m.media-amazon.com/images/M/MV5BZTBkZTJjYWEtZjVhNi00MTE3LWI2YTItMWU5ZGFjNWQ0ODJlXkEyXkFqcGc@._V1_.jpg",
                "caption": {
                  "plainText": "Jodie Foster in A Private Life (2025)",
                  "__typename": "Markdown",
                },
                "height": 2393,
                "width": 4252,
                "__typename": "Image",
              },
              "__typename": "ImageEdge",
            },
            {
              "node": {
                "id": "rm275354114",
                "url":
                    "https://m.media-amazon.com/images/M/MV5BY2U4OTVhZjMtNDgwNS00MWQ0LTkwNGQtN2Y1NWFjYmYwMGYxXkEyXkFqcGc@._V1_.jpg",
                "caption": {
                  "plainText": "Jodie Foster in True Detective (2014)",
                  "__typename": "Markdown",
                },
                "height": 5504,
                "width": 8256,
                "__typename": "Image",
              },
              "__typename": "ImageEdge",
            },
            {
              "node": {
                "id": "rm2644931585",
                "url":
                    "https://m.media-amazon.com/images/M/MV5BMTE1OWFhZjktYjE4OC00NTdjLWIyMTUtMGU5NzIzMzEwZTkzXkEyXkFqcGc@._V1_.jpg",
                "caption": {
                  "plainText": "Jodie Foster in Taxi Driver (1976)",
                  "__typename": "Markdown",
                },
                "height": 720,
                "width": 1269,
                "__typename": "Image",
              },
              "__typename": "ImageEdge",
            },
            {
              "node": {
                "id": "rm2661708801",
                "url":
                    "https://m.media-amazon.com/images/M/MV5BN2FlYmQyOTMtZTRkNS00YjdkLThjYTAtNWJjYWIzYjkzNzIyXkEyXkFqcGc@._V1_.jpg",
                "caption": {
                  "plainText": "Jodie Foster in Taxi Driver (1976)",
                  "__typename": "Markdown",
                },
                "height": 720,
                "width": 1275,
                "__typename": "Image",
              },
              "__typename": "ImageEdge",
            },
            {
              "node": {
                "id": "rm2460382209",
                "url":
                    "https://m.media-amazon.com/images/M/MV5BYjZkNjU0MDctY2E0NS00ZDExLWIxNzItMTBkNDVkMDEwNTNhXkEyXkFqcGc@._V1_.jpg",
                "caption": {
                  "plainText":
                      "Robert De Niro, Jodie Foster, and Billie Perkins in Taxi Driver (1976)",
                  "__typename": "Markdown",
                },
                "height": 720,
                "width": 1269,
                "__typename": "Image",
              },
              "__typename": "ImageEdge",
            },
            {
              "node": {
                "id": "rm2030714881",
                "url":
                    "https://m.media-amazon.com/images/M/MV5BMGE2OTg2NTAtODgxOS00NTA1LWFjZTUtNDQ2ZmU4ODhhZDVhXkEyXkFqcGc@._V1_.jpg",
                "caption": {
                  "plainText": "Jodie Foster in True Detective (2014)",
                  "__typename": "Markdown",
                },
                "height": 1280,
                "width": 1920,
                "__typename": "Image",
              },
              "__typename": "ImageEdge",
            },
            {
              "node": {
                "id": "rm1413104385",
                "url":
                    "https://m.media-amazon.com/images/M/MV5BNjBmY2ZhMTMtMWJiYi00NmU4LTlkMGUtMWEyNmY1NmJkNzM2XkEyXkFqcGc@._V1_.jpg",
                "caption": {
                  "plainText": "Jodie Foster in Night Country: Part 6 (2024)",
                  "__typename": "Markdown",
                },
                "height": 694,
                "width": 1520,
                "__typename": "Image",
              },
              "__typename": "ImageEdge",
            },
            {
              "node": {
                "id": "rm1144668929",
                "url":
                    "https://m.media-amazon.com/images/M/MV5BYzg4YTdiYWQtNWYyYi00ZGE2LTliOGYtY2UxODZiOWI4MDUzXkEyXkFqcGc@._V1_.jpg",
                "caption": {
                  "plainText": "Jodie Foster in Night Country: Part 6 (2024)",
                  "__typename": "Markdown",
                },
                "height": 588,
                "width": 1272,
                "__typename": "Image",
              },
              "__typename": "ImageEdge",
            },
            {
              "node": {
                "id": "rm389694209",
                "url":
                    "https://m.media-amazon.com/images/M/MV5BNjJmN2FhNTAtMjEyZi00ZjU0LThlOTMtYWRlZGRkMDk3NWMzXkEyXkFqcGc@._V1_.jpg",
                "caption": {
                  "plainText": "Jodie Foster in Night Country: Part 6 (2024)",
                  "__typename": "Markdown",
                },
                "height": 585,
                "width": 1272,
                "__typename": "Image",
              },
              "__typename": "ImageEdge",
            },
          ],
          "__typename": "ImageConnection",
        },
        "primaryImage": {
          "id": "rm3507258880",
          "__typename": "Image",
          "url":
              "https://m.media-amazon.com/images/M/MV5BMTM3MjgyOTQwNF5BMl5BanBnXkFtZTcwMDczMzEwNA@@._V1_.jpg",
          "height": 400,
          "width": 274,
          "caption": {"plainText": "Jodie Foster", "__typename": "Markdown"},
        },
        "nameText": {"text": "Jodie Foster", "__typename": "NameText"},
        "knownForFeatureV2": {
          "credits": [
            {
              "title": {
                "id": "tt0102926",
                "canRate": {"isRatable": true, "__typename": "CanRate"},
                "certificate": {"rating": "18", "__typename": "Certificate"},
                "originalTitleText": {
                  "text": "The Silence of the Lambs",
                  "__typename": "TitleText",
                },
                "titleText": {
                  "text": "The Silence of the Lambs",
                  "__typename": "TitleText",
                },
                "titleType": {
                  "canHaveEpisodes": false,
                  "displayableProperty": {
                    "value": {"plainText": "", "__typename": "Markdown"},
                    "__typename": "DisplayableTitleTypeProperty",
                  },
                  "text": "Movie",
                  "id": "movie",
                  "__typename": "TitleType",
                },
                "primaryImage": {
                  "id": "rm3242988544",
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BNDdhOGJhYzctYzYwZC00YmI2LWI0MjctYjg4ODdlMDExYjBlXkEyXkFqcGc@._V1_.jpg",
                  "height": 2968,
                  "width": 2011,
                  "caption": {
                    "plainText":
                        "Jodie Foster in The Silence of the Lambs (1991)",
                    "__typename": "Markdown",
                  },
                  "__typename": "Image",
                },
                "ratingsSummary": {
                  "aggregateRating": 8.6,
                  "voteCount": 1713903,
                  "__typename": "RatingsSummary",
                },
                "latestTrailer": {"id": "vi3377380121", "__typename": "Video"},
                "releaseYear": {
                  "year": 1991,
                  "endYear": null,
                  "__typename": "YearRange",
                },
                "runtime": {"seconds": 7080, "__typename": "Runtime"},
                "series": null,
                "titleGenres": {
                  "genres": [
                    {
                      "genre": {"text": "Crime", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                    {
                      "genre": {"text": "Drama", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                    {
                      "genre": {"text": "Horror", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                  ],
                  "__typename": "TitleGenres",
                },
                "productionStatus": {
                  "currentProductionStage": {
                    "id": "released",
                    "text": "Released",
                    "__typename": "ProductionStage",
                  },
                  "productionStatusHistory": [
                    {
                      "status": {
                        "id": "released",
                        "text": "Released",
                        "__typename": "ProductionStatus",
                      },
                      "__typename": "ProductionStatusHistory",
                    },
                  ],
                  "__typename": "ProductionStatusDetails",
                },
                "__typename": "Title",
              },
              "creditedRoles": {
                "edges": [
                  {
                    "node": {
                      "text": "Clarice Starling",
                      "episodeCredits": {
                        "total": 0,
                        "yearRange": null,
                        "displayableYears": {
                          "total": 0,
                          "edges": [],
                          "__typename": "DisplayableYearConnection",
                        },
                        "displayableSeasons": {
                          "total": 0,
                          "edges": [],
                          "__typename": "DisplayableSeasonConnection",
                        },
                        "__typename": "EpisodeCreditConnection",
                      },
                      "attributes": null,
                      "category": {
                        "categoryId":
                            "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                        "text": "Actress",
                        "traits": ["CAST_TRAIT"],
                        "__typename": "CreditCategory",
                      },
                      "characters": {
                        "edges": [
                          {
                            "node": {
                              "name": "Clarice Starling",
                              "__typename": "Character",
                            },
                            "__typename": "CharacterEdge",
                          },
                        ],
                        "__typename": "CharacterConnection",
                      },
                      "__typename": "CreditedRole",
                    },
                    "__typename": "CreditedRoleEdge",
                  },
                ],
                "__typename": "CreditedRoleConnection",
              },
              "__typename": "CreditV2",
            },
            {
              "title": {
                "id": "tt0094608",
                "canRate": {"isRatable": true, "__typename": "CanRate"},
                "certificate": {"rating": "18", "__typename": "Certificate"},
                "originalTitleText": {
                  "text": "The Accused",
                  "__typename": "TitleText",
                },
                "titleText": {"text": "The Accused", "__typename": "TitleText"},
                "titleType": {
                  "canHaveEpisodes": false,
                  "displayableProperty": {
                    "value": {"plainText": "", "__typename": "Markdown"},
                    "__typename": "DisplayableTitleTypeProperty",
                  },
                  "text": "Movie",
                  "id": "movie",
                  "__typename": "TitleType",
                },
                "primaryImage": {
                  "id": "rm4269548032",
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BZDU2NGRmNGYtN2JiNi00ZDcyLTllM2UtNzhiNDM4ZTU3ODMxXkEyXkFqcGc@._V1_.jpg",
                  "height": 2204,
                  "width": 1435,
                  "caption": {
                    "plainText":
                        "Jodie Foster and Kelly McGillis in The Accused (1988)",
                    "__typename": "Markdown",
                  },
                  "__typename": "Image",
                },
                "ratingsSummary": {
                  "aggregateRating": 7.1,
                  "voteCount": 42955,
                  "__typename": "RatingsSummary",
                },
                "latestTrailer": {"id": "vi678411801", "__typename": "Video"},
                "releaseYear": {
                  "year": 1988,
                  "endYear": null,
                  "__typename": "YearRange",
                },
                "runtime": {"seconds": 6660, "__typename": "Runtime"},
                "series": null,
                "titleGenres": {
                  "genres": [
                    {
                      "genre": {"text": "Crime", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                    {
                      "genre": {"text": "Drama", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                  ],
                  "__typename": "TitleGenres",
                },
                "productionStatus": {
                  "currentProductionStage": {
                    "id": "released",
                    "text": "Released",
                    "__typename": "ProductionStage",
                  },
                  "productionStatusHistory": [
                    {
                      "status": {
                        "id": "released",
                        "text": "Released",
                        "__typename": "ProductionStatus",
                      },
                      "__typename": "ProductionStatusHistory",
                    },
                  ],
                  "__typename": "ProductionStatusDetails",
                },
                "__typename": "Title",
              },
              "creditedRoles": {
                "edges": [
                  {
                    "node": {
                      "text": "Sarah Tobias",
                      "episodeCredits": {
                        "total": 0,
                        "yearRange": null,
                        "displayableYears": {
                          "total": 0,
                          "edges": [],
                          "__typename": "DisplayableYearConnection",
                        },
                        "displayableSeasons": {
                          "total": 0,
                          "edges": [],
                          "__typename": "DisplayableSeasonConnection",
                        },
                        "__typename": "EpisodeCreditConnection",
                      },
                      "attributes": null,
                      "category": {
                        "categoryId":
                            "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                        "text": "Actress",
                        "traits": ["CAST_TRAIT"],
                        "__typename": "CreditCategory",
                      },
                      "characters": {
                        "edges": [
                          {
                            "node": {
                              "name": "Sarah Tobias",
                              "__typename": "Character",
                            },
                            "__typename": "CharacterEdge",
                          },
                        ],
                        "__typename": "CharacterConnection",
                      },
                      "__typename": "CreditedRole",
                    },
                    "__typename": "CreditedRoleEdge",
                  },
                ],
                "__typename": "CreditedRoleConnection",
              },
              "__typename": "CreditV2",
            },
            {
              "title": {
                "id": "tt0075314",
                "canRate": {"isRatable": true, "__typename": "CanRate"},
                "certificate": {"rating": "18", "__typename": "Certificate"},
                "originalTitleText": {
                  "text": "Taxi Driver",
                  "__typename": "TitleText",
                },
                "titleText": {"text": "Taxi Driver", "__typename": "TitleText"},
                "titleType": {
                  "canHaveEpisodes": false,
                  "displayableProperty": {
                    "value": {"plainText": "", "__typename": "Markdown"},
                    "__typename": "DisplayableTitleTypeProperty",
                  },
                  "text": "Movie",
                  "id": "movie",
                  "__typename": "TitleType",
                },
                "primaryImage": {
                  "id": "rm3951714048",
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BZDNhMGYwM2UtMTdlZS00MGQ1LWI2YzAtODY5YWI1MjYyNzRmXkEyXkFqcGc@._V1_.jpg",
                  "height": 2871,
                  "width": 1890,
                  "caption": {
                    "plainText": "Robert De Niro in Taxi Driver (1976)",
                    "__typename": "Markdown",
                  },
                  "__typename": "Image",
                },
                "ratingsSummary": {
                  "aggregateRating": 8.2,
                  "voteCount": 1021581,
                  "__typename": "RatingsSummary",
                },
                "latestTrailer": {"id": "vi474987289", "__typename": "Video"},
                "releaseYear": {
                  "year": 1976,
                  "endYear": null,
                  "__typename": "YearRange",
                },
                "runtime": {"seconds": 6840, "__typename": "Runtime"},
                "series": null,
                "titleGenres": {
                  "genres": [
                    {
                      "genre": {"text": "Crime", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                    {
                      "genre": {"text": "Drama", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                  ],
                  "__typename": "TitleGenres",
                },
                "productionStatus": {
                  "currentProductionStage": {
                    "id": "released",
                    "text": "Released",
                    "__typename": "ProductionStage",
                  },
                  "productionStatusHistory": [
                    {
                      "status": {
                        "id": "released",
                        "text": "Released",
                        "__typename": "ProductionStatus",
                      },
                      "__typename": "ProductionStatusHistory",
                    },
                  ],
                  "__typename": "ProductionStatusDetails",
                },
                "__typename": "Title",
              },
              "creditedRoles": {
                "edges": [
                  {
                    "node": {
                      "text": "Iris",
                      "episodeCredits": {
                        "total": 0,
                        "yearRange": null,
                        "displayableYears": {
                          "total": 0,
                          "edges": [],
                          "__typename": "DisplayableYearConnection",
                        },
                        "displayableSeasons": {
                          "total": 0,
                          "edges": [],
                          "__typename": "DisplayableSeasonConnection",
                        },
                        "__typename": "EpisodeCreditConnection",
                      },
                      "attributes": null,
                      "category": {
                        "categoryId":
                            "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                        "text": "Actress",
                        "traits": ["CAST_TRAIT"],
                        "__typename": "CreditCategory",
                      },
                      "characters": {
                        "edges": [
                          {
                            "node": {"name": "Iris", "__typename": "Character"},
                            "__typename": "CharacterEdge",
                          },
                        ],
                        "__typename": "CharacterConnection",
                      },
                      "__typename": "CreditedRole",
                    },
                    "__typename": "CreditedRoleEdge",
                  },
                ],
                "__typename": "CreditedRoleConnection",
              },
              "__typename": "CreditV2",
            },
            {
              "title": {
                "id": "tt0476964",
                "canRate": {"isRatable": true, "__typename": "CanRate"},
                "certificate": {"rating": "18", "__typename": "Certificate"},
                "originalTitleText": {
                  "text": "The Brave One",
                  "__typename": "TitleText",
                },
                "titleText": {
                  "text": "The Brave One",
                  "__typename": "TitleText",
                },
                "titleType": {
                  "canHaveEpisodes": false,
                  "displayableProperty": {
                    "value": {"plainText": "", "__typename": "Markdown"},
                    "__typename": "DisplayableTitleTypeProperty",
                  },
                  "text": "Movie",
                  "id": "movie",
                  "__typename": "TitleType",
                },
                "primaryImage": {
                  "id": "rm950177024",
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BMTA4OTA4Njk4MDdeQTJeQWpwZ15BbWU3MDc0NDY1MzM@._V1_.jpg",
                  "height": 2048,
                  "width": 1387,
                  "caption": {
                    "plainText": "Jodie Foster in The Brave One (2007)",
                    "__typename": "Markdown",
                  },
                  "__typename": "Image",
                },
                "ratingsSummary": {
                  "aggregateRating": 6.7,
                  "voteCount": 66017,
                  "__typename": "RatingsSummary",
                },
                "latestTrailer": {"id": "vi2209415449", "__typename": "Video"},
                "releaseYear": {
                  "year": 2007,
                  "endYear": null,
                  "__typename": "YearRange",
                },
                "runtime": {"seconds": 7320, "__typename": "Runtime"},
                "series": null,
                "titleGenres": {
                  "genres": [
                    {
                      "genre": {"text": "Crime", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                    {
                      "genre": {"text": "Drama", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                    {
                      "genre": {"text": "Thriller", "__typename": "GenreItem"},
                      "__typename": "TitleGenre",
                    },
                  ],
                  "__typename": "TitleGenres",
                },
                "productionStatus": {
                  "currentProductionStage": {
                    "id": "released",
                    "text": "Released",
                    "__typename": "ProductionStage",
                  },
                  "productionStatusHistory": [
                    {
                      "status": {
                        "id": "pre_production",
                        "text": "Pre-production",
                        "__typename": "ProductionStatus",
                      },
                      "__typename": "ProductionStatusHistory",
                    },
                    {
                      "status": {
                        "id": "filming",
                        "text": "Filming",
                        "__typename": "ProductionStatus",
                      },
                      "__typename": "ProductionStatusHistory",
                    },
                    {
                      "status": {
                        "id": "filming",
                        "text": "Filming",
                        "__typename": "ProductionStatus",
                      },
                      "__typename": "ProductionStatusHistory",
                    },
                    {
                      "status": {
                        "id": "post_production",
                        "text": "Post-production",
                        "__typename": "ProductionStatus",
                      },
                      "__typename": "ProductionStatusHistory",
                    },
                    {
                      "status": {
                        "id": "completed",
                        "text": "Completed",
                        "__typename": "ProductionStatus",
                      },
                      "__typename": "ProductionStatusHistory",
                    },
                    {
                      "status": {
                        "id": "released",
                        "text": "Released",
                        "__typename": "ProductionStatus",
                      },
                      "__typename": "ProductionStatusHistory",
                    },
                  ],
                  "__typename": "ProductionStatusDetails",
                },
                "__typename": "Title",
              },
              "creditedRoles": {
                "edges": [
                  {
                    "node": {
                      "text": "Erica Bain",
                      "episodeCredits": {
                        "total": 0,
                        "yearRange": null,
                        "displayableYears": {
                          "total": 0,
                          "edges": [],
                          "__typename": "DisplayableYearConnection",
                        },
                        "displayableSeasons": {
                          "total": 0,
                          "edges": [],
                          "__typename": "DisplayableSeasonConnection",
                        },
                        "__typename": "EpisodeCreditConnection",
                      },
                      "attributes": null,
                      "category": {
                        "categoryId":
                            "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                        "text": "Actress",
                        "traits": ["CAST_TRAIT"],
                        "__typename": "CreditCategory",
                      },
                      "characters": {
                        "edges": [
                          {
                            "node": {
                              "name": "Erica Bain",
                              "__typename": "Character",
                            },
                            "__typename": "CharacterEdge",
                          },
                        ],
                        "__typename": "CharacterConnection",
                      },
                      "__typename": "CreditedRole",
                    },
                    "__typename": "CreditedRoleEdge",
                  },
                ],
                "__typename": "CreditedRoleConnection",
              },
              "__typename": "CreditV2",
            },
          ],
          "__typename": "KnownForV2",
        },
        "professions": [
          {
            "professionCategory": {
              "linkedCreditCategory": {
                "categoryId":
                    "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                "__typename": "CreditCategory",
              },
              "__typename": "ProfessionCategory",
            },
            "__typename": "NameProfession",
          },
          {
            "professionCategory": {
              "linkedCreditCategory": {
                "categoryId":
                    "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                "__typename": "CreditCategory",
              },
              "__typename": "ProfessionCategory",
            },
            "__typename": "NameProfession",
          },
          {
            "professionCategory": {
              "linkedCreditCategory": {
                "categoryId":
                    "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                "__typename": "CreditCategory",
              },
              "__typename": "ProfessionCategory",
            },
            "__typename": "NameProfession",
          },
        ],
        "creditSummary": {
          "totalCredits": {
            "total": 547,
            "restriction": {
              "unrestrictedTotal": 553,
              "__typename": "CreditRestriction",
            },
            "__typename": "TotalCredits",
          },
          "genres": [
            {
              "total": 132,
              "genre": {
                "genreId": "Documentary",
                "text": "Documentary",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 115,
              "genre": {
                "genreId": "Talk-Show",
                "text": "Talk-Show",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 94,
              "genre": {
                "genreId": "Comedy",
                "text": "Comedy",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 79,
              "genre": {
                "genreId": "Drama",
                "text": "Drama",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 72,
              "genre": {
                "genreId": "News",
                "text": "News",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 40,
              "genre": {
                "genreId": "Music",
                "text": "Music",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 37,
              "genre": {
                "genreId": "Short",
                "text": "Short",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 32,
              "genre": {
                "genreId": "Family",
                "text": "Family",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 29,
              "genre": {
                "genreId": "Biography",
                "text": "Biography",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 27,
              "genre": {
                "genreId": "Reality-TV",
                "text": "Reality-TV",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 26,
              "genre": {
                "genreId": "Crime",
                "text": "Crime",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 26,
              "genre": {
                "genreId": "Thriller",
                "text": "Thriller",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 23,
              "genre": {
                "genreId": "History",
                "text": "History",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 20,
              "genre": {
                "genreId": "Mystery",
                "text": "Mystery",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 18,
              "genre": {
                "genreId": "Romance",
                "text": "Romance",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 12,
              "genre": {
                "genreId": "Adventure",
                "text": "Adventure",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 8,
              "genre": {
                "genreId": "Horror",
                "text": "Horror",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 8,
              "genre": {
                "genreId": "Sci-Fi",
                "text": "Sci-Fi",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 7,
              "genre": {
                "genreId": "Western",
                "text": "Western",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 6,
              "genre": {
                "genreId": "Animation",
                "text": "Animation",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 6,
              "genre": {
                "genreId": "Fantasy",
                "text": "Fantasy",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 5,
              "genre": {
                "genreId": "Action",
                "text": "Action",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 5,
              "genre": {
                "genreId": "Game-Show",
                "text": "Game-Show",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 4,
              "genre": {
                "genreId": "Musical",
                "text": "Musical",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 4,
              "genre": {
                "genreId": "Sport",
                "text": "Sport",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
            {
              "total": 4,
              "genre": {
                "genreId": "War",
                "text": "War",
                "__typename": "GenreItem",
              },
              "__typename": "GenreSummary",
            },
          ],
          "__typename": "NameCreditSummary",
        },
        "groupings": {
          "edges": [
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                  "text": "Actress",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 84,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                  "text": "Producer",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 11,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                  "text": "Director",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 11,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.4df03a1e-b90d-4c4a-8638-29eea26a156b",
                  "text": "Soundtrack",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 7,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.2f6f759f-166d-4cf8-af96-b6ec20b99e95",
                  "text": "Voice Actor - Dubbing",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 5,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.c84ecaff-add5-4f2e-81db-102a41881fe3",
                  "text": "Writer",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 1,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.e2bf7217-c947-461b-aa58-47e27da1c78e",
                  "text": "Cinematographer",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 1,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.a7c2d410-e513-4bd7-85d5-73060ec46a84",
                  "text": "Additional Crew",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 1,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": [
                                    "CREW_TRAIT",
                                    "UNCATEGORIZED_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                  "text": "Thanks",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 12,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                  "text": "Self",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 321,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_group.6e871823-beae-458a-b972-2cdd635ec0d7",
                  "text": "Archive Footage",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "total": 93,
                  "edges": [
                    {
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "category": {
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "__typename": "CreditV2",
                      },
                      "__typename": "CreditV2Edge",
                    },
                  ],
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
          ],
          "__typename": "CreditGroupingConnection",
        },
        "released": {
          "edges": [
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                  "text": "Actress",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Narrator",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "voice",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Narrator",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt38985973",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Breakdown: 1975",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Breakdown: 1975",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1607115778",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BYjU0YjA2OWYtMGRhYy00MzMxLTk5NTItMzBjZjQ2MTVkZDM0XkEyXkFqcGc@._V1_.jpg",
                            "height": 1350,
                            "width": 1080,
                            "caption": {
                              "plainText": "Breakdown: 1975 (2025)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.8,
                            "voteCount": 1778,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2611006233",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5520, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Lilian Steiner",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Lilian Steiner",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt33852162",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Vie privée",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "A Private Life",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1128571138",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BM2Y4OWIzMTQtMzk0OC00NGM5LTgxMGUtZDM1ZDIxMGRhZjEzXkEyXkFqcGc@._V1_.jpg",
                            "height": 2866,
                            "width": 1934,
                            "caption": {
                              "plainText":
                                  "Jodie Foster in A Private Life (2025)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.1,
                            "voteCount": 3352,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3333671705",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6420, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Liz Danvers",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Liz Danvers",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 6,
                          "yearRange": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2024",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "4",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt2356777",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "18",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "True Detective",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "True Detective",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm378941696",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BYjgwYzA1NWMtNDYyZi00ZGQyLWI5NTktMDYwZjE2OTIwZWEwXkEyXkFqcGc@._V1_.jpg",
                            "height": 1031,
                            "width": 736,
                            "caption": {
                              "plainText":
                                  "Matthew McConaughey and Woody Harrelson in True Detective (2014)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8.8,
                            "voteCount": 750155,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi4042180889",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2014,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pitch",
                                  "text": "Pitch",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Bonnie Stoll",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Bonnie Stoll",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt5302918",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Nyad",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Nyad",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm770394625",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNjBmNGY5YWUtNzg0Ny00YTQ2LWIwNjctOTMzOGI3Y2E1YzFiXkEyXkFqcGc@._V1_.jpg",
                            "height": 2100,
                            "width": 1400,
                            "caption": {
                              "plainText":
                                  "Jodie Foster and Annette Bening in Nyad (2023)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.1,
                            "voteCount": 44624,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3102000921",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2023,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7260, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Biography",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "History",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Nancy Hollander",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Nancy Hollander",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt4761112",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Mauritanian",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Mauritanian",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1533860865",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNzkwZDQ1ZTMtMWFhOC00YjliLWE2ZDEtNDlmYjU2YjNkMDVlXkEyXkFqcGc@._V1_.jpg",
                            "height": 2880,
                            "width": 1944,
                            "caption": {
                              "plainText":
                                  "Tahar Rahim in The Mauritanian (2021)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.5,
                            "voteCount": 71635,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2815082521",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2021,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7740, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Biography",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Thriller",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "optioned_property",
                                  "text": "Optioned Property",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "treatment_outline",
                                  "text": "Treatment Outline",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "treatment_outline",
                                  "text": "Treatment Outline",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "The Nurse",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "The Nurse",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt5834262",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Hotel Artemis",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Hotel Artemis",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1309167360",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BOTUzNTk0ZTYtY2MwYS00NDU2LTk3NDMtZTZlMTRiYzcyYmU3XkEyXkFqcGc@._V1_.jpg",
                            "height": 2762,
                            "width": 1766,
                            "caption": {
                              "plainText":
                                  "Jodie Foster, Jeff Goldblum, Charlie Day, Sofia Boutella, Dave Bautista, and Sterling K. Brown in Hotel Artemis (2018)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.1,
                            "voteCount": 62234,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi1522776857",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2018,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5640, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Action",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Mother",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Mother",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt7801978",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Scorsese's Women",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Scorsese's Women",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Video",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Video",
                            "id": "video",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm333795840",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMzE1NjViYmYtZWVhNi00ZTE2LTllNzQtNTI0MmUyNDZlNjNiXkEyXkFqcGc@._V1_.jpg",
                            "height": 1267,
                            "width": 1080,
                            "caption": {
                              "plainText": "Scorsese's Women (2014)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.7,
                            "voteCount": 83,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2014,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 360, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Short",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Delacourt",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Delacourt",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1535108",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Elysium",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Elysium",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2317984768",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNDc2NjU0MTcwNV5BMl5BanBnXkFtZTcwMjg4MDg2OQ@@._V1_.jpg",
                            "height": 1500,
                            "width": 1012,
                            "caption": {
                              "plainText": "Matt Damon in Elysium (2013)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.6,
                            "voteCount": 490489,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi4196837657",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2013,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6540, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Action",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Sci-Fi",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "optioned_property",
                                  "text": "Optioned Property",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Penelope Longstreet",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Penelope Longstreet",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1692486",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Carnage",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Carnage",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm201437696",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTc4MjAyMDUwNl5BMl5BanBnXkFtZTcwOTQwMDMwNw@@._V1_.jpg",
                            "height": 1316,
                            "width": 887,
                            "caption": {
                              "plainText":
                                  "Jodie Foster, John C. Reilly, Kate Winslet, and Christoph Waltz in Carnage (2011)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.1,
                            "voteCount": 138181,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2855116313",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2011,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 4800, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Meredith Black",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Meredith Black",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1321860",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "12A",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Beaver",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Beaver",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2730394624",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMzc0Nzc0MjA4OF5BMl5BanBnXkFtZTcwNTEyOTYxNA@@._V1_.jpg",
                            "height": 2000,
                            "width": 1351,
                            "caption": {
                              "plainText": "Mel Gibson in The Beaver (2011)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.6,
                            "voteCount": 52161,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3568211993",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2011,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5460, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Maggie Roark",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "voice",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Maggie Roark",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2009,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2009",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "20",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0096697",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "12",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Simpsons",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Simpsons",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1730745600",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNTU2OWE0YWYtMjRlMS00NTUwLWJmZWUtODFhNzJiMGJlMzI3XkEyXkFqcGc@._V1_.jpg",
                            "height": 1500,
                            "width": 1000,
                            "caption": {
                              "plainText":
                                  "Julie Kavner, Nancy Cartwright, Dan Castellaneta, and Yeardley Smith in The Simpsons (1989)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8.6,
                            "voteCount": 467132,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi551536921",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1989,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 1320, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Animation",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Jodie Foster",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Jodie Foster",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1220220",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Motherhood",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Motherhood",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm580946176",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTk0OTYwOTA2Ml5BMl5BanBnXkFtZTcwNDgxOTg3Mg@@._V1_.jpg",
                            "height": 1860,
                            "width": 1253,
                            "caption": {
                              "plainText": "Uma Thurman in Motherhood (2009)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4.6,
                            "voteCount": 4900,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi1445790233",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2009,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5400, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Alexandra Rover",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Alexandra Rover",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0410377",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "U",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Nim's Island",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Nim's Island",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2668249345",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BY2YyY2FjMzgtM2YxNi00NWYzLWIyMzUtZGJhZTY2YWJhYTU2XkEyXkFqcGc@._V1_.jpg",
                            "height": 1500,
                            "width": 1013,
                            "caption": {
                              "plainText":
                                  "Jodie Foster, Gerard Butler, and Abigail Breslin in Nim's Island (2008)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6,
                            "voteCount": 38198,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2712797465",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2008,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5760, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Adventure",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Family",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Fantasy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "optioned_property",
                                  "text": "Optioned Property",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "development_unknown",
                                  "text": "Development Unknown",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Erica Bain",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Erica Bain",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0476964",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "18",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Brave One",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Brave One",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm950177024",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTA4OTA4Njk4MDdeQTJeQWpwZ15BbWU3MDc0NDY1MzM@._V1_.jpg",
                            "height": 2048,
                            "width": 1387,
                            "caption": {
                              "plainText":
                                  "Jodie Foster in The Brave One (2007)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.7,
                            "voteCount": 66017,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2209415449",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2007,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7320, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Thriller",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Madeleine White",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.7f6d81aa-23aa-4503-844d-38201eb08761",
                                  "text": "Actress",
                                  "traits": ["CAST_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Madeleine White",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0454848",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Inside Man",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Inside Man",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm4151512576",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZWFmMDZkYjktMjYyOS00MTM2LTg2MmQtOTUwMzJjMDlhZDY1XkEyXkFqcGc@._V1_.jpg",
                            "height": 1500,
                            "width": 1013,
                            "caption": {
                              "plainText":
                                  "Jodie Foster, Denzel Washington, and Clive Owen in Inside Man (2006)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.6,
                            "voteCount": 423554,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi495889689",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2006,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7740, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 84,
                  "pageInfo": {
                    "hasNextPage": true,
                    "endCursor":
                        "M01WKzlmSzNyUFUrdk5VUE80ZEI2ODl1Wko2a0N6U28zWGpPdXcrdzJXZz0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                  "text": "Producer",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "executive producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 8,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "1",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt31974367",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Beast in Me",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Beast in Me",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Mini Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Mini Series",
                            "id": "tvMiniSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3690508034",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZDI5MzdkMzktMjcxYi00OTcyLTljMWEtYzg2NTA5OTcwYTJkXkEyXkFqcGc@._V1_.jpg",
                            "height": 2224,
                            "width": 1500,
                            "caption": {
                              "plainText":
                                  "Claire Danes and Matthew Rhys in The Beast in Me (2025)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.4,
                            "voteCount": 64723,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2875705369",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2025,
                            "endYear": 2025,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3000, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Thriller",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "turnaround",
                                  "text": "Turnaround",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "executive producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 6,
                          "yearRange": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2024",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "4",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt2356777",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "18",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "True Detective",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "True Detective",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm378941696",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BYjgwYzA1NWMtNDYyZi00ZGQyLWI5NTktMDYwZjE2OTIwZWEwXkEyXkFqcGc@._V1_.jpg",
                            "height": 1031,
                            "width": 736,
                            "caption": {
                              "plainText":
                                  "Matthew McConaughey and Woody Harrelson in True Detective (2014)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8.8,
                            "voteCount": 750155,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi4042180889",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2014,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pitch",
                                  "text": "Pitch",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "executive producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt29134283",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Alok",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Alok",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Short",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Short",
                            "id": "short",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3310897409",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZDYxM2ZlNWYtZjI5NS00ZTY4LWEzZGYtODlmZGI0ZTQyZTY1XkEyXkFqcGc@._V1_.jpg",
                            "height": 3829,
                            "width": 2589,
                            "caption": {
                              "plainText": "Alok Vaid-Menon in Alok (2024)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.2,
                            "voteCount": 65,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 1140, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Short",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "executive producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt3146022",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "PG",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text":
                                "Be Natural: The Untold Story of Alice Guy-Blaché",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text":
                                "Be Natural: The Untold Story of Alice Guy-Blaché",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3094381569",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BOTEwMTgwZjEtZWIyMC00OThiLWFhNTQtNjljMGRkMjI4ZTU2XkEyXkFqcGc@._V1_.jpg",
                            "height": 6150,
                            "width": 4200,
                            "caption": {
                              "plainText":
                                  "Be Natural: The Untold Story of Alice Guy-Blaché (2018)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.7,
                            "voteCount": 1249,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi4115118617",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2018,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6180, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Biography",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "History",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "executive producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0476964",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "18",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Brave One",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Brave One",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm950177024",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTA4OTA4Njk4MDdeQTJeQWpwZ15BbWU3MDc0NDY1MzM@._V1_.jpg",
                            "height": 2048,
                            "width": 1387,
                            "caption": {
                              "plainText":
                                  "Jodie Foster in The Brave One (2007)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.7,
                            "voteCount": 66017,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2209415449",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2007,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7320, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Thriller",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0238924",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Dangerous Lives of Altar Boys",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Dangerous Lives of Altar Boys",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2104303104",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNmM0OWQ4NjktYjM1YS00NDk5LWFiODMtZjRhZTVkMTBhYThhXkEyXkFqcGc@._V1_.jpg",
                            "height": 520,
                            "width": 349,
                            "caption": {
                              "plainText":
                                  "The Dangerous Lives of Altar Boys (2002)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.9,
                            "voteCount": 14655,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2862612761",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2002,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6240, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "executive producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0127349",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Waking the Dead",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Waking the Dead",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2315866880",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNjRlMTczOGItNzU2ZS00ZTUxLWJkOWMtZmI1YTRkY2YwZTVkXkEyXkFqcGc@._V1_.jpg",
                            "height": 741,
                            "width": 500,
                            "caption": {
                              "plainText":
                                  "Jennifer Connelly and Billy Crudup in Waking the Dead (2000)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.4,
                            "voteCount": 7975,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2784690457",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2000,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6300, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Romance",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "executive producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0126802",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "TV-14",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Baby Dance",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Baby Dance",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Movie",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Movie",
                            "id": "tvMovie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm120669953",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNzY2N2VlMTQtZTMxYi00ODM5LWFhNWItZTgxZWFjYzlkMjNkXkEyXkFqcGc@._V1_.jpg",
                            "height": 1500,
                            "width": 1000,
                            "caption": {
                              "plainText": "The Baby Dance (1998)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.5,
                            "voteCount": 503,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1998,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5700, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0113321",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Home for the Holidays",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Home for the Holidays",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1286213632",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMDI1ZmZhMDQtMDZkMC00M2VlLWJjZDMtYmEyMWRiMDIwZGJiXkEyXkFqcGc@._V1_.jpg",
                            "height": 1500,
                            "width": 1016,
                            "caption": {
                              "plainText":
                                  "Holly Hunter in Home for the Holidays (1995)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.6,
                            "voteCount": 16219,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi550879513",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1995,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6180, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Romance",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0110638",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "12",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Nell",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Nell",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1529292032",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNTkxY2NkMmItOTNmNy00NGU0LTlhM2UtOGQwNDhmNTBmNzQ3XkEyXkFqcGc@._V1_.jpg",
                            "height": 729,
                            "width": 500,
                            "caption": {
                              "plainText":
                                  "Jodie Foster and Liam Neeson in Nell (1994)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.5,
                            "voteCount": 32419,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi948896537",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1994,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6720, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "co-producer",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.0af123ce-1605-4a51-93cf-7ad477b11832",
                                  "text": "Producer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0091513",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Mesmerized",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Mesmerized",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm968590593",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BODA2NmM3M2ItY2Y2My00Mjk5LWFkYjEtODEyNTgyZmMyYTczXkEyXkFqcGc@._V1_.jpg",
                            "height": 649,
                            "width": 432,
                            "caption": {
                              "plainText":
                                  "Jodie Foster and John Lithgow in Mesmerized (1985)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4.7,
                            "voteCount": 1138,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1985,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5640, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 11,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "Y3dJQmI4U0JLWi9saDNJS3pZeTZ0T0tNcUNkUnFFMU1xNjdmM0E0NG1ZWT0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                  "text": "Director",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2020,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2020",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "1",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt8741290",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Tales from the Loop",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Tales from the Loop",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm433633281",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTlhNzI5YjAtMDllZC00MmJjLTk4MGYtYjdiNWEyOTc3Mjc1XkEyXkFqcGc@._V1_.jpg",
                            "height": 900,
                            "width": 600,
                            "caption": {
                              "plainText": "Tales from the Loop (2020)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.4,
                            "voteCount": 26401,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3132866073",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2020,
                            "endYear": 2020,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3000, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Sci-Fi",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2017,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2017",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "4",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt2085059",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "18",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Black Mirror",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Black Mirror",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1448291329",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMWY3ZjgwMTctZTZmMS00ZTMwLTkwYWEtNTVkMDgwNjA5ODBiXkEyXkFqcGc@._V1_.jpg",
                            "height": 1350,
                            "width": 1080,
                            "caption": {
                              "plainText":
                                  "Rory Kinnear in Black Mirror (2011)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8.7,
                            "voteCount": 733688,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi308201753",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2011,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt2241351",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Money Monster",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Money Monster",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2897273856",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMjQzMzQ3Nzg5MV5BMl5BanBnXkFtZTgwMDExOTI4NzE@._V1_.jpg",
                            "height": 4096,
                            "width": 2764,
                            "caption": {
                              "plainText": "Money Monster (2016)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.5,
                            "voteCount": 111953,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3048191257",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2016,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5880, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Action",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 2,
                          "yearRange": {
                            "year": 2013,
                            "endYear": 2014,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 2,
                            "edges": [
                              {
                                "node": {
                                  "year": "2013",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 2,
                            "edges": [
                              {
                                "node": {
                                  "season": "1",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt2372162",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "18",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Orange Is the New Black",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Orange Is the New Black",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm54304257",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNjRjMTAyYjUtZDk0Mi00OGQ5LWJjNzMtMzBhNDMwMmI5NzVjXkEyXkFqcGc@._V1_.jpg",
                            "height": 2222,
                            "width": 1500,
                            "caption": {
                              "plainText":
                                  "Kate Mulgrew, Natasha Lyonne, Selenis Leyva, Laura Prepon, Taylor Schilling, Uzo Aduba, Dascha Polanco, and Danielle Brooks in Orange Is the New Black (2013)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8,
                            "voteCount": 335541,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi702005529",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2013,
                            "endYear": 2019,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "optioned_property",
                                  "text": "Optioned Property",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2014,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2014",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "2",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1856010",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "18",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "House of Cards",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "House of Cards",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm919970304",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTQ4MDczNDYwNV5BMl5BanBnXkFtZTcwNjMwMDk5OA@@._V1_.jpg",
                            "height": 2048,
                            "width": 1382,
                            "caption": {
                              "plainText":
                                  "Kevin Spacey in House of Cards (2013)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8.6,
                            "voteCount": 558053,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi1076543257",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2013,
                            "endYear": 2018,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3000, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Thriller",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1321860",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "12A",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Beaver",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Beaver",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2730394624",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMzc0Nzc0MjA4OF5BMl5BanBnXkFtZTcwNTEyOTYxNA@@._V1_.jpg",
                            "height": 2000,
                            "width": 1351,
                            "caption": {
                              "plainText": "Mel Gibson in The Beaver (2011)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.6,
                            "voteCount": 52161,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3568211993",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2011,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5460, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "script",
                                  "text": "Script",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0113321",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Home for the Holidays",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Home for the Holidays",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1286213632",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMDI1ZmZhMDQtMDZkMC00M2VlLWJjZDMtYmEyMWRiMDIwZGJiXkEyXkFqcGc@._V1_.jpg",
                            "height": 1500,
                            "width": 1016,
                            "caption": {
                              "plainText":
                                  "Holly Hunter in Home for the Holidays (1995)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.6,
                            "voteCount": 16219,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi550879513",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1995,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6180, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Romance",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0102316",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "PG",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Little Man Tate",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Little Man Tate",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm104273665",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZTk2ODRjMDYtZmVkNi00NjFlLWE0N2ItM2JiZjRkNDI2NGFmXkEyXkFqcGc@._V1_.jpg",
                            "height": 2915,
                            "width": 1921,
                            "caption": {
                              "plainText":
                                  "Jodie Foster, Dianne Wiest, and Adam Hann-Byrd in Little Man Tate (1991)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.6,
                            "voteCount": 17782,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2744516889",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1991,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5940, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "directed by",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 1988,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "1988",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "4",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0086814",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Tales from the Darkside",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Tales from the Darkside",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3987546881",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMWYwODdlMGQtODcyZS00ZTgwLWI5ZDQtMDYyY2RhNjkwMjRkXkEyXkFqcGc@._V1_.jpg",
                            "height": 1222,
                            "width": 835,
                            "caption": {
                              "plainText": "Tales from the Darkside (1983)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.4,
                            "voteCount": 7540,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3095772441",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1983,
                            "endYear": 1988,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 1800, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Fantasy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "segment \"Do Not Open This Box\"",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt4388650",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Stephen King's Golden Tales",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Stephen King's Golden Tales",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Video",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Video",
                            "id": "video",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3074366976",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNTIzNDA2N2YtNTgzYy00ODI1LWE2YjUtMDQ4MDkxYzU1MjhiXkEyXkFqcGc@._V1_.jpg",
                            "height": 451,
                            "width": 284,
                            "caption": {
                              "plainText": "Stephen King's Golden Tales (1985)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 5.9,
                            "voteCount": 129,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1985,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 8340, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Horror",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.ace5cb4c-8708-4238-9542-04641e7c8171",
                                  "text": "Director",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt27626554",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Hands of Time",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Hands of Time",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Short",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Short",
                            "id": "short",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1210888706",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BOGQzODVmZTItMzk4Mi00MDUwLWFhNGUtZjVkMTkzYWI4NzJiXkEyXkFqcGc@._V1_.jpg",
                            "height": 848,
                            "width": 1000,
                            "caption": {
                              "plainText": "Hands of Time (1978)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1978,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Short",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": null,
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 11,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "YklmT1VqZmhRZTI2VlZIeC81TjZNa2ZwTXBIZmhHd0xBc0hRRW1vN0RvUT0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.4df03a1e-b90d-4c4a-8638-29eea26a156b",
                  "text": "Soundtrack",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "performer: \"La Vie c'est Chouette\"",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.4df03a1e-b90d-4c4a-8638-29eea26a156b",
                                  "text": "Soundtrack",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt10954984",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Nope",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Nope",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1690253825",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BODRlNWRhZWUtMzdlZC00ZDIyLWFhZjMtYTcxNjI1ZDIwODhjXkEyXkFqcGc@._V1_.jpg",
                            "height": 3000,
                            "width": 1895,
                            "caption": {
                              "plainText": "Nope (2022)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.8,
                            "voteCount": 313888,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2850996761",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2022,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7800, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Horror",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Sci-Fi",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text":
                                    "performer: \"I'd Like to Be You for a Day\"",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.4df03a1e-b90d-4c4a-8638-29eea26a156b",
                                  "text": "Soundtrack",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2013,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2013",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "5",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1936911",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Todd's Pop Song Reviews",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Todd's Pop Song Reviews",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2670993153",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BM2Q3ZmFiMjItNGVmNS00NDQ5LWE3MjgtNmFiNTQzZWRkNGI2XkEyXkFqcGc@._V1_.jpg",
                            "height": 1200,
                            "width": 604,
                            "caption": {
                              "plainText": "Todd's Pop Song Reviews (2009)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8.1,
                            "voteCount": 460,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2009,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Music",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "performer: \"My Name is Tallulah\"",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.4df03a1e-b90d-4c4a-8638-29eea26a156b",
                                  "text": "Soundtrack",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1319704",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Chatroom",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Chatroom",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm198877440",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTk2MzkzNzQ0NV5BMl5BanBnXkFtZTcwODUzNTEzOQ@@._V1_.jpg",
                            "height": 2048,
                            "width": 1463,
                            "caption": {
                              "plainText":
                                  "Aaron Taylor-Johnson, Imogen Poots, and Daniel Kaluuya in Chatroom (2010)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 5.4,
                            "voteCount": 9976,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi4066090265",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2010,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5820, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Horror",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Thriller",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "optioned_property",
                                  "text": "Optioned Property",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text":
                                    "performer: \"When I Looked At Your Face (Jodie Foster Version)\"",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.4df03a1e-b90d-4c4a-8638-29eea26a156b",
                                  "text": "Soundtrack",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0076401",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Moi, Fleur bleue",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Moi, Fleur bleue",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3091064576",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BYjIxZDA4NmEtMzlhYS00ZTA5LTgxMGUtNDgxODM1YWU1MGU5XkEyXkFqcGc@._V1_.jpg",
                            "height": 3000,
                            "width": 2250,
                            "caption": {
                              "plainText": "Moi, Fleur bleue (1977)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4.9,
                            "voteCount": 236,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1977,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6000, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Romance",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text":
                                    "performer: \"I'd Like to Be You for a Day\"",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.4df03a1e-b90d-4c4a-8638-29eea26a156b",
                                  "text": "Soundtrack",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0076054",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "U",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Freaky Friday",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Freaky Friday",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1078986496",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BY2MyNDExNzAtNWY1ZC00NDJmLWIxZWMtNzgxYWVjMmUzYTBiXkEyXkFqcGc@._V1_.jpg",
                            "height": 1999,
                            "width": 1280,
                            "caption": {
                              "plainText":
                                  "Jodie Foster, John Astin, Barbara Harris, and Vicki Schreck in Freaky Friday (1976)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.3,
                            "voteCount": 15624,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2060173593",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1976,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5880, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Family",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Fantasy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "performer: \"Love\"",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.4df03a1e-b90d-4c4a-8638-29eea26a156b",
                                  "text": "Soundtrack",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0353132",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "46th Annual Academy Awards",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "46th Annual Academy Awards",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Special",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Special",
                            "id": "tvSpecial",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2675378176",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BODAyOTljMWUtNGExYS00ZTAxLWFjZGMtMjYxYzRlZmUzODQ2XkEyXkFqcGc@._V1_.jpg",
                            "height": 3546,
                            "width": 2353,
                            "caption": {
                              "plainText": "46th Annual Academy Awards (1974)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.1,
                            "voteCount": 188,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1974,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Family",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text":
                                    "performer: \"We Three Kings\", \"Away in a Manger'",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.4df03a1e-b90d-4c4a-8638-29eea26a156b",
                                  "text": "Soundtrack",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "uncredited",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 1971,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "1971",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "17",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0047736",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "TV-PG",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Gunsmoke",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Gunsmoke",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1844807426",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZmI2OTlkMGItMDY0Yi00MjcwLWEzMTEtMTYxYzg2ZDEzM2VkXkEyXkFqcGc@._V1_.jpg",
                            "height": 1257,
                            "width": 838,
                            "caption": {
                              "plainText": "Gunsmoke (1955)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8.1,
                            "voteCount": 10088,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi508213273",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1955,
                            "endYear": 1975,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Western",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 7,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "V0czSTRXWWNQSGJtMUVoZER1ZU9pbEx0R3c3VTBEZmdmbFl5aCtQTEl3RT0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.2f6f759f-166d-4cf8-af96-b6ec20b99e95",
                  "text": "Voice Actor - Dubbing",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Erica Bain",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.2f6f759f-166d-4cf8-af96-b6ec20b99e95",
                                  "text": "Voice Actor - Dubbing",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "French (France)",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0476964",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "18",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Brave One",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Brave One",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm950177024",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTA4OTA4Njk4MDdeQTJeQWpwZ15BbWU3MDc0NDY1MzM@._V1_.jpg",
                            "height": 2048,
                            "width": 1387,
                            "caption": {
                              "plainText":
                                  "Jodie Foster in The Brave One (2007)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.7,
                            "voteCount": 66017,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2209415449",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2007,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7320, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Thriller",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Madeleine White",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.2f6f759f-166d-4cf8-af96-b6ec20b99e95",
                                  "text": "Voice Actor - Dubbing",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "French (France)",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0454848",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Inside Man",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Inside Man",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm4151512576",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZWFmMDZkYjktMjYyOS00MTM2LTg2MmQtOTUwMzJjMDlhZDY1XkEyXkFqcGc@._V1_.jpg",
                            "height": 1500,
                            "width": 1013,
                            "caption": {
                              "plainText":
                                  "Jodie Foster, Denzel Washington, and Clive Owen in Inside Man (2006)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.6,
                            "voteCount": 423554,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi495889689",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2006,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7740, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Meg Altman",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.2f6f759f-166d-4cf8-af96-b6ec20b99e95",
                                  "text": "Voice Actor - Dubbing",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "French (France)",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0258000",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Panic Room",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Panic Room",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2951156992",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BODU0ZGM0MjctM2YxYy00OWY1LTk2N2YtNWE4ZWQ2ODQwMTI5XkEyXkFqcGc@._V1_.jpg",
                            "height": 3125,
                            "width": 2100,
                            "caption": {
                              "plainText": "Jodie Foster in Panic Room (2002)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.8,
                            "voteCount": 313807,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi2896101657",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2002,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6720, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Thriller",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Annabelle Bransford",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.2f6f759f-166d-4cf8-af96-b6ec20b99e95",
                                  "text": "Voice Actor - Dubbing",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "French (France)",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0110478",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "PG",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Maverick",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Maverick",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1977685760",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMjk5MzdhYWMtOWU3Yi00MTE5LWEyYTEtOGU5NWM0NWNmZDE1XkEyXkFqcGc@._V1_.jpg",
                            "height": 1650,
                            "width": 1118,
                            "caption": {
                              "plainText":
                                  "Jodie Foster, Mel Gibson, and James Garner in Maverick (1994)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7,
                            "voteCount": 125887,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3450781209",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1994,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7620, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Action",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Adventure",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Laurel",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.2f6f759f-166d-4cf8-af96-b6ec20b99e95",
                                  "text": "Voice Actor - Dubbing",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "French (France)",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0108185",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "12",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Sommersby",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Sommersby",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm345803265",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZGExZjZjYjUtZTRiNy00OGM2LTlkMDctMzZmNmRmMzc0ZGYzXkEyXkFqcGc@._V1_.jpg",
                            "height": 1500,
                            "width": 1006,
                            "caption": {
                              "plainText":
                                  "Jodie Foster and Richard Gere in Sommersby (1993)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.3,
                            "voteCount": 24739,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3079209241",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1993,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 6840, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Mystery",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Romance",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 5,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "Mit0azFLRkx5enFVSjFIeWlTeXg2TVBhYjFWeUJNZkZLcVo1cmZHdERVRT0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.c84ecaff-add5-4f2e-81db-102a41881fe3",
                  "text": "Writer",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.c84ecaff-add5-4f2e-81db-102a41881fe3",
                                  "text": "Writer",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "MAJOR_CREATIVE_INPUT_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt27626554",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Hands of Time",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Hands of Time",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Short",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Short",
                            "id": "short",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1210888706",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BOGQzODVmZTItMzk4Mi00MDUwLWFhNGUtZjVkMTkzYWI4NzJiXkEyXkFqcGc@._V1_.jpg",
                            "height": 848,
                            "width": 1000,
                            "caption": {
                              "plainText": "Hands of Time (1978)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1978,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Short",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": null,
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 1,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "c1pZczZxeC9KdFJ6NTNGbExmU3RDbmwycm5mMkpJa3NEdWpTKzNrU3FCdz0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.e2bf7217-c947-461b-aa58-47e27da1c78e",
                  "text": "Cinematographer",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": null,
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.e2bf7217-c947-461b-aa58-47e27da1c78e",
                                  "text": "Cinematographer",
                                  "traits": ["CREW_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt27626554",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Hands of Time",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Hands of Time",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Short",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Short",
                            "id": "short",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1210888706",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BOGQzODVmZTItMzk4Mi00MDUwLWFhNGUtZjVkMTkzYWI4NzJiXkEyXkFqcGc@._V1_.jpg",
                            "height": 848,
                            "width": 1000,
                            "caption": {
                              "plainText": "Hands of Time (1978)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1978,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Short",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": null,
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 1,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "NGhCZ1ViVHdoTkJ3ZnFJR1ZYOXlmRUJvTUpOQ0RBYlVPN1QxczJtYzhTcz0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.a7c2d410-e513-4bd7-85d5-73060ec46a84",
                  "text": "Additional Crew",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "presenter",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.a7c2d410-e513-4bd7-85d5-73060ec46a84",
                                  "text": "Additional Crew",
                                  "traits": [
                                    "CREW_TRAIT",
                                    "UNCATEGORIZED_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0113247",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "La haine",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "La haine",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3910646018",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BYmU2OWQwNGYtNDA1ZS00ZGJjLWFhMDAtZGI4MGRhYzY0ZDY4XkEyXkFqcGc@._V1_.jpg",
                            "height": 2844,
                            "width": 1920,
                            "caption": {
                              "plainText":
                                  "Vincent Cassel, Hubert Koundé, and Saïd Taghmaoui in La haine (1995)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8.1,
                            "voteCount": 224808,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi1231338009",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1995,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5880, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 1,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "M3FSQlE5Wkt4OVB0cDVrcU81WEJ2V0NIVkVUdjVUb25CbjRHQitvaTJpWT0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                  "text": "Thanks",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "special thanks",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2017,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2017",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "1",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt7192798",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Name That Film",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Name That Film",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1744841984",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZTdkMzA4YTItN2IyOS00YjA2LWJhNzctOThkNDgyNmJiYTBhXkEyXkFqcGc@._V1_.jpg",
                            "height": 1413,
                            "width": 1017,
                            "caption": {
                              "plainText": "Name That Film (2017)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2017,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Game-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "thanks",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt5562172",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Jewel's Catch One",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Jewel's Catch One",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm134958080",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNWJhZDUwNDMtNjE5ZS00ZTAyLTgzMzgtOTlmZmYzMjk2NGZhXkEyXkFqcGc@._V1_.jpg",
                            "height": 1463,
                            "width": 1000,
                            "caption": {
                              "plainText": "Jewel's Catch One (2016)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.5,
                            "voteCount": 138,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2016,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5100, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "very special thanks",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1861445",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "Not Rated",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "An Act of War",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "An Act of War",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2707222528",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTQ2OTMwNTcyOV5BMl5BanBnXkFtZTgwMzMxMzQ5NDE@._V1_.jpg",
                            "height": 2157,
                            "width": 1530,
                            "caption": {
                              "plainText": "An Act of War (2015)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4.8,
                            "voteCount": 1672,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2015,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5940, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Crime",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Thriller",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "special thanks",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2009,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2009",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "2",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1290326",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Rien de 9",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Rien de 9",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2681179136",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTQzMjEwMzA2MV5BMl5BanBnXkFtZTcwNzQyMDYyMw@@._V1_.jpg",
                            "height": 2500,
                            "width": 3256,
                            "caption": {
                              "plainText":
                                  "Steven Claire, Alban Greiner, Megane Lizier, Maykel Stone, Anaïs Rahm, and Dorian Martin in Rien de 9 (2008)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.1,
                            "voteCount": 34,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi494912025",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2008,
                            "endYear": 2010,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 1500, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Romance",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "the producers wish to thank",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1034325",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "12",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Phoebe in Wonderland",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Phoebe in Wonderland",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2534771200",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMjIyMjQ2NDQ0MF5BMl5BanBnXkFtZTcwNjE1NTEzMg@@._V1_.jpg",
                            "height": 1552,
                            "width": 1047,
                            "caption": {
                              "plainText":
                                  "Elle Fanning in Phoebe in Wonderland (2008)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7,
                            "voteCount": 8260,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi34865945",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2008,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5760, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "optioned_property",
                                  "text": "Optioned Property",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "post_production",
                                  "text": "Post-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "special thanks",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0912586",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "Not Rated",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Girl 27",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Girl 27",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm594989568",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNjM4OTE0Njg1OV5BMl5BanBnXkFtZTgwNTg1MTA2MDE@._V1_.jpg",
                            "height": 500,
                            "width": 360,
                            "caption": {
                              "plainText": "Girl 27 (2007)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7,
                            "voteCount": 1224,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi514638361",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2007,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5160, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Biography",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "special thanks",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0399315",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Making 'Taxi Driver'",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Making 'Taxi Driver'",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Video",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Video",
                            "id": "video",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2044140544",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNzU4MmNlYzUtYzU4MS00ZjA4LTkyNTAtNjExNDE0YmFlNTQyXkEyXkFqcGc@._V1_.jpg",
                            "height": 960,
                            "width": 681,
                            "caption": {
                              "plainText":
                                  "Robert De Niro and Jodie Foster in Making 'Taxi Driver' (1999)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.4,
                            "voteCount": 387,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1999,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 4260, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "executive of goodwill",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0276370",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Ode",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Ode",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1960500225",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMjc0NzYzOTAtNzYwNy00YzYwLWIwZjctNWUzZDBhZjY4NjJlXkEyXkFqcGc@._V1_.jpg",
                            "height": 1565,
                            "width": 1036,
                            "caption": {
                              "plainText": "Ode (1999)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.5,
                            "voteCount": 260,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1999,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 2880, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Romance",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "the producers gratefully acknowledge",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0111486",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "15",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Trevor",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Trevor",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Short",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Short",
                            "id": "short",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2628070656",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BN2Y4ZTFiYzAtYWEyNy00NjZjLWI0MDMtZmQ3NjIwMmNhNzJiXkEyXkFqcGc@._V1_.jpg",
                            "height": 1098,
                            "width": 780,
                            "caption": {
                              "plainText": "Brett Barsky in Trevor (1994)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.7,
                            "voteCount": 1690,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1994,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 1380, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Short",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "special thanks",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0107233",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "U",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text":
                                "It's All True: Based on an Unfinished Film by Orson Welles",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "It's All True",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1726250753",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BM2QwZDNlNTktYjMyMC00Njc1LTk0ZTUtNTAxZjU1NDk3NjVmXkEyXkFqcGc@._V1_.jpg",
                            "height": 1416,
                            "width": 960,
                            "caption": {
                              "plainText": "It's All True (1993)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.1,
                            "voteCount": 915,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1993,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5220, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "thanks",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0107232",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "It Was a Wonderful Life",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "It Was a Wonderful Life",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1974246656",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTM2NTM0MTEzOV5BMl5BanBnXkFtZTcwMjg4NzUyMQ@@._V1_.jpg",
                            "height": 500,
                            "width": 354,
                            "caption": {
                              "plainText": "It Was a Wonderful Life (1992)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.2,
                            "voteCount": 158,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1992,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 4920, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "we would like to thank",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.90de891d-6d5e-4711-9179-3eda18bd18e1",
                                  "text": "Thanks",
                                  "traits": ["THANKS_TRAIT"],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0166277",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Movies Are My Life",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Movies Are My Life",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3699382273",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BYzJmZTExYjAtMjQ4Ni00YzM2LWFkODctN2QzYjQxOGJhNzFkXkEyXkFqcGc@._V1_.jpg",
                            "height": 648,
                            "width": 1170,
                            "caption": {
                              "plainText": "Movies Are My Life (1978)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.8,
                            "voteCount": 66,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1978,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 12,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "L0hKelN0NlFVQmZpQ2FOQXRTTTJDYmVZRk5FUmJ1MDNYcjNvWGczK2xTdz0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                  "text": "Self",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self - Guest",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self - Guest",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 2,
                          "yearRange": {
                            "year": 2026,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2026",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt15741658",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text":
                                "The Late Show Pod Show with Stephen Colbert",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text":
                                "The Late Show Pod Show with Stephen Colbert",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Podcast Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Podcast Series",
                            "id": "podcastSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3390238465",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZTI3Nzg4NWItYjJhZC00MDNjLWJlMjQtZmZjZDJhY2FkOTlhXkEyXkFqcGc@._V1_.jpg",
                            "height": 3000,
                            "width": 3000,
                            "caption": {
                              "plainText":
                                  "The Late Show Pod Show with Stephen Colbert (2021)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4,
                            "voteCount": 45,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2021,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2026,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2026",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "1",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt11959562",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Conan O'Brien Needs a Friend",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Conan O'Brien Needs a Friend",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "Podcast Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Podcast Series",
                            "id": "podcastSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2682176257",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNzM0NDQzYTctYmRmZC00OGQ1LTkxMTQtNzEyMDlkODZkN2FkXkEyXkFqcGc@._V1_.jpg",
                            "height": 600,
                            "width": 600,
                            "caption": {
                              "plainText":
                                  "Conan O'Brien Needs a Friend (2018)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 9.1,
                            "voteCount": 395,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2018,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self - Guest",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self - Guest",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2026,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2026",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "13",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt3513388",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "TV-14",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Late Night with Seth Meyers",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Late Night with Seth Meyers",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm4165163520",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNTA4MDkxZGMtNzQ4MS00NzQzLTgzNTYtYWVkZmIzMmYyZjAyXkEyXkFqcGc@._V1_.jpg",
                            "height": 626,
                            "width": 424,
                            "caption": {
                              "plainText":
                                  "Seth Meyers in Late Night with Seth Meyers (2014)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.3,
                            "voteCount": 8627,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2014,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2026,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2026",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt31710656",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Variety's Know Their Lines",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Variety's Know Their Lines",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1569997825",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNGZlZmUyMDUtMDRhMi00NjQ3LWEyNTYtZjVlMjc2NzY2MmUyXkEyXkFqcGc@._V1_.jpg",
                            "height": 1577,
                            "width": 1065,
                            "caption": {
                              "plainText": "Variety's Know Their Lines (2023)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2023,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Short",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2026,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2026",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "15",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt34984117",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Criterion: Closet Picks",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Criterion: Closet Picks",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2636815874",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMzI2YTM5MDItMGM2Mi00MjNhLTg5N2MtYWIxODcwYzBhMmM4XkEyXkFqcGc@._V1_.jpg",
                            "height": 1365,
                            "width": 2048,
                            "caption": {
                              "plainText": "Criterion: Closet Picks (2010)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.2,
                            "voteCount": 35,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2010,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Short",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self - Guest",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self - Guest",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 2,
                          "yearRange": {
                            "year": 2017,
                            "endYear": 2026,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 2,
                            "edges": [
                              {
                                "node": {
                                  "year": "2017",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 2,
                            "edges": [
                              {
                                "node": {
                                  "season": "3",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt3697842",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "TV-PG",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "The Late Show with Stephen Colbert",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Late Show with Stephen Colbert",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm632694272",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BYjZmNDY2OTEtMTIyZC00ZDQ4LWJiZTktNzcyM2IxMDM1YWNhXkEyXkFqcGc@._V1_.jpg",
                            "height": 1440,
                            "width": 960,
                            "caption": {
                              "plainText":
                                  "Stephen Colbert in The Late Show with Stephen Colbert (2015)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.1,
                            "voteCount": 16536,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi820038425",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2015,
                            "endYear": 2026,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 2460, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self - Guest",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self - Guest",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 7,
                          "yearRange": {
                            "year": 1980,
                            "endYear": 2026,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 5,
                            "edges": [
                              {
                                "node": {
                                  "year": "1980",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0044298",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "TV-G",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Today",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Today",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1756198656",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BY2I3NWI5M2EtNDE5Yi00ZDNjLTk0OGMtMDA0OWM5ODQ0Y2Y5XkEyXkFqcGc@._V1_.jpg",
                            "height": 1440,
                            "width": 1080,
                            "caption": {
                              "plainText":
                                  "Hoda Kotb and Savannah Guthrie in Today (1952)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4.6,
                            "voteCount": 2688,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1952,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {
                            "seconds": 14400,
                            "__typename": "Runtime",
                          },
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 3,
                          "yearRange": {
                            "year": 2005,
                            "endYear": 2025,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 3,
                            "edges": [
                              {
                                "node": {
                                  "year": "2005",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt21480862",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "La boîte à questions",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "La boîte à questions",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3742305793",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZjhhNjUyMWUtYzIzMy00ZTNiLThkMDItZGZlOWRjZDhlMzRjXkEyXkFqcGc@._V1_.jpg",
                            "height": 1015,
                            "width": 983,
                            "caption": {
                              "plainText": "La boîte à questions (2004)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4.4,
                            "voteCount": 24,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2004,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Short",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0350405",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "En aparté",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "En aparté",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm4199035905",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZjcxZGFjMWYtNzFmZC00MTRhLTk3ZGYtM2I3MjkxMzNjMWQ5XkEyXkFqcGc@._V1_.jpg",
                            "height": 1763,
                            "width": 1175,
                            "caption": {
                              "plainText": "Nathalie Levy in En aparté (2001)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7,
                            "voteCount": 51,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2001,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt11443084",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "20h30 le dimanche",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "20h30 le dimanche",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm160087297",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BODU0ZGZmMWYtMWFmMy00ZjYxLWJhMGItNzhhNGNiYTZlMDM1XkEyXkFqcGc@._V1_.jpg",
                            "height": 1440,
                            "width": 960,
                            "caption": {
                              "plainText": "20h30 le dimanche (2011)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 5.9,
                            "voteCount": 17,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2011,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt6052530",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Quotidien",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Quotidien",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3458447105",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZjJhNDgwNjEtNjRjYi00Zjg2LWI0NDYtMjg3YzA1MTQxOTc2XkEyXkFqcGc@._V1_.jpg",
                            "height": 588,
                            "width": 446,
                            "caption": {
                              "plainText": "Yann Barthès in Quotidien (2016)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.3,
                            "voteCount": 179,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2016,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 5700, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self - Actor / Actor, Taxi Driver",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self - Actor",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                    {
                                      "node": {
                                        "name": "Self - Actor, Taxi Driver",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 3,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "1",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt36998986",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "18",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Mr. Scorsese",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Mr. Scorsese",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Mini Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Mini Series",
                            "id": "tvMiniSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2509287170",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZjA2NmUxOGQtZDMwYS00ZGM4LWIwZWUtMWQ3ZWMyM2M1ZjQ0XkEyXkFqcGc@._V1_.jpg",
                            "height": 2048,
                            "width": 1326,
                            "caption": {
                              "plainText":
                                  "Martin Scorsese in Mr. Scorsese (2025)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8.5,
                            "voteCount": 3868,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi1634191385",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2025,
                            "endYear": 2025,
                            "__typename": "YearRange",
                          },
                          "runtime": {
                            "seconds": 17100,
                            "__typename": "Runtime",
                          },
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Biography",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pitch",
                                  "text": "Pitch",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt35674052",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Film at Lincoln Center",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Film at Lincoln Center",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm306091778",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMDFhYWQzYzUtOGMwMC00NmU1LWI1NTUtYjkwZTA0MjU0NGI4XkEyXkFqcGc@._V1_.jpg",
                            "height": 432,
                            "width": 432,
                            "caption": {
                              "plainText": "Film at Lincoln Center (2008)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 3.6,
                            "voteCount": 12,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2008,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt4367268",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "CTV News at Six Toronto",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "CTV News at Six Toronto",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm373424641",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BOWRhYmNhMTgtOTk0OS00MjAyLWI3YWMtOWNmOGQxOTA0ZjMwXkEyXkFqcGc@._V1_.jpg",
                            "height": 711,
                            "width": 400,
                            "caption": {
                              "plainText": "CTV News at Six Toronto (2018)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 1.4,
                            "voteCount": 19,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2018,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt40987107",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Los Angeles Times: In Studio",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Los Angeles Times: In Studio",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": null,
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2023,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 319,
                  "pageInfo": {
                    "hasNextPage": true,
                    "endCursor":
                        "UXZSMGkvMERtVzdtYkpGUDNTRnN2MkZMNlo3Z3pqNENWWFZuTDhUWHBKaz0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_group.6e871823-beae-458a-b972-2cdd635ec0d7",
                  "text": "Archive Footage",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt39003298",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text":
                                "Legacy of Screams: The Evolution of Horror Movies",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text":
                                "Legacy of Screams: The Evolution of Horror Movies",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3065028610",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMDYzOTk0NWEtOTljOC00ODA1LWFiMmUtMzNjMjY3ODI0ZWZkXkEyXkFqcGc@._V1_.jpg",
                            "height": 1800,
                            "width": 1200,
                            "caption": {
                              "plainText":
                                  "Legacy of Screams: The Evolution of Horror Movies (2025)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.7,
                            "voteCount": 16,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt39101919",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Guten Morgen Österreich",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Guten Morgen Österreich",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3910902018",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMmIzMWRkZjAtZTM1OS00ZTdiLThkNWUtZmRiYTJjMmMwOWRmXkEyXkFqcGc@._V1_.jpg",
                            "height": 320,
                            "width": 600,
                            "caption": {
                              "plainText": "Guten Morgen Österreich (2016)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2016,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "1",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt38353446",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "TV We Love",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "TV We Love",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm4034375426",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BYmNiOGU3ODQtMWI1My00ZjVkLTg5ZmUtMGE4MDY2YWRlYjdiXkEyXkFqcGc@._V1_.jpg",
                            "height": 900,
                            "width": 1600,
                            "caption": {
                              "plainText": "TV We Love (2025)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 8,
                            "voteCount": 56,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3361916953",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Family",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "3",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt26424559",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Beau geste",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Beau geste",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2878486017",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNzM2NjIwZTMtOGQ4Ni00M2EyLWIyZDQtNDI0YmRiYjkyOTVmXkEyXkFqcGc@._V1_.jpg",
                            "height": 588,
                            "width": 446,
                            "caption": {
                              "plainText":
                                  "Pierre Lescure in Beau geste (2023)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4.3,
                            "voteCount": 31,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2023,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "13",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1973047",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "TV-PG",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Dish Nation",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Dish Nation",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1186423296",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNDU2ZTM0MGItZjE2Yy00NGRmLWFhZjAtOTNkZTk1NDU2NjdkXkEyXkFqcGc@._V1_.jpg",
                            "height": 1400,
                            "width": 1400,
                            "caption": {
                              "plainText":
                                  "Da Brat, Rickey Smiley, Heidi Hamilton, Frank Kramer, HeadKrack, Gary With Da Tea, and Porsha in Dish Nation (2011)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 3.6,
                            "voteCount": 748,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi390577177",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2011,
                            "endYear": 2025,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 1800, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2025",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "2",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt33096993",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Have I Got News for You",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Have I Got News for You",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3798494465",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNmMyOGRjNTAtYTYyMC00ZWZlLThmMjUtNjQ5OTliZTE4N2UwXkEyXkFqcGc@._V1_.jpg",
                            "height": 1200,
                            "width": 960,
                            "caption": {
                              "plainText":
                                  "Roy Wood Jr. in Have I Got News for You (2024)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.7,
                            "voteCount": 671,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "pre_production",
                                  "text": "Pre-production",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2024",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt31968352",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Baggage Claim",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Baggage Claim",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3875437313",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BN2QyYWY1NzItZDc5Yy00ZTAxLTljYmItOTEzNDY2Nzk0NDU3XkEyXkFqcGc@._V1_.jpg",
                            "height": 900,
                            "width": 900,
                            "caption": {
                              "plainText":
                                  "Baggage Claim in Baggage Claim (2020)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 3.3,
                            "voteCount": 15,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2020,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text":
                                    "Self - Actor / True Detective: Night Country",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                  {
                                    "text": "uncredited",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self - Actor",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                    {
                                      "node": {
                                        "name":
                                            "Self - True Detective: Night Country",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2024",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt3310362",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "ABC News Breakfast",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "ABC News Breakfast",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm277139714",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BOGFkNzRkM2QtOTdjMS00NWI4LTg5MmUtYzNiNjczMGFhNmFhXkEyXkFqcGc@._V1_.jpg",
                            "height": 508,
                            "width": 887,
                            "caption": {
                              "plainText":
                                  "Emma Rebellato and James Glenday in ABC News Breakfast (2008)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4.7,
                            "voteCount": 129,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2008,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 11,
                          "yearRange": {
                            "year": 2016,
                            "endYear": 2024,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 5,
                            "edges": [
                              {
                                "node": {
                                  "year": "2016",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 6,
                            "edges": [
                              {
                                "node": {
                                  "season": "35",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0081857",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Entertainment Tonight",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Entertainment Tonight",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1928810753",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BYmEzODg2ZjctZDIzMC00ZjE4LTg2M2UtMjI5ZmJhYWRmMjFkXkEyXkFqcGc@._V1_.jpg",
                            "height": 2880,
                            "width": 2160,
                            "caption": {
                              "plainText":
                                  "Kevin Frazier and Nischelle Turner in Entertainment Tonight (1981)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 3.6,
                            "voteCount": 3040,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi3220751129",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 1981,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 1800, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 2,
                          "yearRange": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2024",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 2,
                            "edges": [
                              {
                                "node": {
                                  "season": "22",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0320037",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": {
                            "rating": "TV-14",
                            "__typename": "Certificate",
                          },
                          "originalTitleText": {
                            "text": "Jimmy Kimmel Live!",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Jimmy Kimmel Live!",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3754257409",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BN2M1OGJiOTctNDg2Yi00M2I1LThjMTktY2NhN2VjZWU2NDllXkEyXkFqcGc@._V1_.jpg",
                            "height": 755,
                            "width": 502,
                            "caption": {
                              "plainText":
                                  "Jimmy Kimmel and Guillermo Rodriguez in Jimmy Kimmel Live! (2003)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.4,
                            "voteCount": 19713,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": {
                            "id": "vi504365849",
                            "__typename": "Video",
                          },
                          "releaseYear": {
                            "year": 2003,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Music",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self - Actor",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self - Actor",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 2,
                          "yearRange": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2024",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt1480165",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "The 7PM Project",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "The Project",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3901085185",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMTY0ZTE3NGQtMTkzMS00Y2M5LWFmY2EtYTYzZDJmOWE4MTY2XkEyXkFqcGc@._V1_.jpg",
                            "height": 1000,
                            "width": 680,
                            "caption": {
                              "plainText": "The Project (2009)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 4.1,
                            "voteCount": 987,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2009,
                            "endYear": 2025,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3600, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Comedy",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "News",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Talk-Show",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2024",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt12588424",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Compression",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Compression",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3912782593",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BZmMzOGY3MTItMTRiMC00YmM2LTg4ZDctMGM4ODk2YzEwMzk1XkEyXkFqcGc@._V1_.jpg",
                            "height": 1343,
                            "width": 900,
                            "caption": {
                              "plainText": "Compression (1995)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.4,
                            "voteCount": 16,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1995,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 240, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt30955793",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Henry Fonda for President",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Henry Fonda for President",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm2547467009",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BMzk1M2FiNTItNjljZS00NzNiLTkxYmQtMTY2NDcxYTE1ODUwXkEyXkFqcGc@._V1_.jpg",
                            "height": 2425,
                            "width": 1725,
                            "caption": {
                              "plainText": "Henry Fonda for President (2024)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 7.5,
                            "voteCount": 162,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2024,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {
                            "seconds": 11040,
                            "__typename": "Runtime",
                          },
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                              {
                                "genre": {
                                  "text": "Drama",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "completed",
                                  "text": "Completed",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2023,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2023",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "1",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt31381091",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "That Was the Year That Was",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Most Shocking Moments!",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm1588098561",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNWVjODMwNDgtZmEzNC00NDEzLTlmYTItNTM0YzM4ZDU3YmIxXkEyXkFqcGc@._V1_.jpg",
                            "height": 1080,
                            "width": 1920,
                            "caption": {
                              "plainText": "Most Shocking Moments! (2023)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2023,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 7200, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": {
                            "year": 2023,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "2023",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt5966986",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "E-penser",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "E-penser",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": {
                            "id": "rm3805297409",
                            "url":
                                "https://m.media-amazon.com/images/M/MV5BNjQxYTkyZTQtNmRkOS00YTQyLWE2NDQtZTI0Yzc4Nzg0Y2QxXkEyXkFqcGc@._V1_.jpg",
                            "height": 702,
                            "width": 788,
                            "caption": {
                              "plainText": "E-penser (2013)",
                              "__typename": "Markdown",
                            },
                            "__typename": "Image",
                          },
                          "ratingsSummary": {
                            "aggregateRating": 6.4,
                            "voteCount": 17,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2013,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 92,
                  "pageInfo": {
                    "hasNextPage": true,
                    "endCursor":
                        "L1NQdnAxZGg1NlE5RjZIb1hZcFFhaGRDY1Mxcm9sQjVlQWdvN0xjeHMvYz0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
          ],
          "__typename": "CreditGroupingConnection",
        },
        "unreleased": {
          "edges": [
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                  "text": "Self",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self - Host",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self - Host",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 1,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "year": "unknown",
                                  "__typename":
                                      "LocalizedDisplayableEpisodeYear",
                                },
                                "__typename": "DisplayableYearEdge",
                              },
                            ],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 1,
                            "edges": [
                              {
                                "node": {
                                  "season": "unknown",
                                  "__typename": "LocalizedDisplayableSeason",
                                },
                                "__typename": "DisplayableSeasonEdge",
                              },
                            ],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt0285365",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "AMC: Film Preservation Classics",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "AMC: Film Preservation Classics",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": true,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Series",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Series",
                            "id": "tvSeries",
                            "__typename": "TitleType",
                          },
                          "primaryImage": null,
                          "ratingsSummary": {
                            "aggregateRating": 7.3,
                            "voteCount": 28,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 1996,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": null,
                          "series": null,
                          "titleGenres": null,
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "released",
                                  "text": "Released",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": null,
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt31022377",
                          "canRate": {
                            "isRatable": false,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Untitled Anthony Hopkins documentary",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Untitled Anthony Hopkins documentary",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "Movie",
                            "id": "movie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": null,
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": null,
                          "runtime": null,
                          "series": null,
                          "titleGenres": {
                            "genres": [
                              {
                                "genre": {
                                  "text": "Documentary",
                                  "__typename": "GenreItem",
                                },
                                "__typename": "TitleGenre",
                              },
                            ],
                            "__typename": "TitleGenres",
                          },
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "in_production",
                              "text": "In Production",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": [
                              {
                                "status": {
                                  "id": "filming",
                                  "text": "Filming",
                                  "__typename": "ProductionStatus",
                                },
                                "__typename": "ProductionStatusHistory",
                              },
                            ],
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 2,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "NlhBcEdYT0EyUlBNZFRCQkZZRGU1Qk1zbThtZkhKM3lLOENwRnJLbEdpbz0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
            {
              "node": {
                "grouping": {
                  "groupingId":
                      "amzn1.imdb.concept.name_credit_group.6e871823-beae-458a-b972-2cdd635ec0d7",
                  "text": "Archive Footage",
                  "__typename": "CreditGrouping",
                },
                "credits": {
                  "edges": [
                    {
                      "__typename": "CreditV2Edge",
                      "node": {
                        "creditedRoles": {
                          "edges": [
                            {
                              "node": {
                                "text": "Self - Subject",
                                "category": {
                                  "categoryId":
                                      "amzn1.imdb.concept.name_credit_category.d6017bdb-c3e7-4ca5-944b-68d74b9de6b6",
                                  "text": "Self",
                                  "traits": [
                                    "SELF_TRAIT",
                                    "ADDITIONAL_APPEARANCES_TRAIT",
                                  ],
                                  "__typename": "CreditCategory",
                                },
                                "attributes": [
                                  {
                                    "text": "archive footage",
                                    "__typename":
                                        "MiscellaneousCreditAttribute",
                                  },
                                ],
                                "characters": {
                                  "edges": [
                                    {
                                      "node": {
                                        "name": "Self - Subject",
                                        "__typename": "Character",
                                      },
                                      "__typename": "CharacterEdge",
                                    },
                                  ],
                                  "__typename": "CharacterConnection",
                                },
                                "__typename": "CreditedRole",
                              },
                              "__typename": "CreditedRoleEdge",
                            },
                          ],
                          "__typename": "CreditedRoleConnection",
                        },
                        "episodeCredits": {
                          "total": 0,
                          "yearRange": null,
                          "displayableYears": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableYearConnection",
                          },
                          "displayableSeasons": {
                            "total": 0,
                            "edges": [],
                            "__typename": "DisplayableSeasonConnection",
                          },
                          "__typename": "EpisodeCreditConnection",
                        },
                        "title": {
                          "id": "tt39229190",
                          "canRate": {
                            "isRatable": true,
                            "__typename": "CanRate",
                          },
                          "certificate": null,
                          "originalTitleText": {
                            "text": "Jodie Foster, une histoire française",
                            "__typename": "TitleText",
                          },
                          "titleText": {
                            "text": "Jodie Foster, une histoire française",
                            "__typename": "TitleText",
                          },
                          "titleType": {
                            "canHaveEpisodes": false,
                            "displayableProperty": {
                              "value": {
                                "plainText": "TV Movie",
                                "__typename": "Markdown",
                              },
                              "__typename": "DisplayableTitleTypeProperty",
                            },
                            "text": "TV Movie",
                            "id": "tvMovie",
                            "__typename": "TitleType",
                          },
                          "primaryImage": null,
                          "ratingsSummary": {
                            "aggregateRating": null,
                            "voteCount": 0,
                            "__typename": "RatingsSummary",
                          },
                          "latestTrailer": null,
                          "releaseYear": {
                            "year": 2025,
                            "endYear": null,
                            "__typename": "YearRange",
                          },
                          "runtime": {"seconds": 3120, "__typename": "Runtime"},
                          "series": null,
                          "titleGenres": null,
                          "productionStatus": {
                            "currentProductionStage": {
                              "id": "released",
                              "text": "Released",
                              "__typename": "ProductionStage",
                            },
                            "productionStatusHistory": null,
                            "__typename": "ProductionStatusDetails",
                          },
                          "__typename": "Title",
                        },
                        "__typename": "CreditV2",
                      },
                    },
                  ],
                  "total": 1,
                  "pageInfo": {
                    "hasNextPage": false,
                    "endCursor":
                        "ekUxUmNlR0pERnB4U2F4NVdnMTVHMXJpMnNNVy9LeEQ2aFlTbDhYdXlKUT0=",
                    "__typename": "PageInfo",
                  },
                  "__typename": "CreditV2Connection",
                },
                "__typename": "CreditGroupingNode",
              },
              "__typename": "CreditGroupingEdge",
            },
          ],
          "__typename": "CreditGroupingConnection",
        },
        "videos": {
          "total": 91,
          "edges": [
            {
              "node": {
                "id": "vi1749665561",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "Oscars 2024 Best Supporting Actress Nominees",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 60, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 1080,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BMzc5NjJhM2MtNzQwMi00YTY0LWJmMWUtYjUxYjFiY2MwYzM3XkEyXkFqcGdeQWFsZWxvZw@@._V1_.jpg",
                  "width": 1920,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Oscars 2024 Best Supporting Actress Nominees",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "Oscars 2024 Best Supporting Actress Nominees",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2024,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi3412510489",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "5 Unforgettable Jodie Foster Performances to Watch",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 61, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 1080,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BY2UzOWU0NmMtY2RmZS00MDQ2LWJiMGMtNDBhMWFhNTc5MjhhXkEyXkFqcGdeQWplZmZscA@@._V1_.jpg",
                  "width": 1920,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "5 Unforgettable Jodie Foster Performances",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "5 Unforgettable Jodie Foster Performances",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2024,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi3890594585",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "Jodie Foster | Career Retrospective",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 140, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 1080,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BZTQ5ZDE5NzMtN2VjZC00OTcyLTg3ZjYtM2E4YjAzYzE3NTJjXkEyXkFqcGdeQW1pYnJ5YW50._V1_.jpg",
                  "width": 1920,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "IMDb Supercuts",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "IMDb Supercuts",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2018,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": true,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi817675033",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "\"Verify Your Membership\"",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 69, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 1069,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BOTU1YmI4OWItMjhkYS00YWU1LWIyN2QtMjc2MWVjZjlhNjYxXkEyXkFqcGdeQWFybm8@._V1_.jpg",
                  "width": 1782,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Hotel Artemis",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "Hotel Artemis",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2018,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi2341772825",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "\"What They Were Arguing About\"",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 93, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 480,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BMTEyNzMyODE2MTheQTJeQWpwZ15BbWU3MDU4MjY3ODY@._V1_.jpg",
                  "width": 640,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Carnage",
                    "__typename": "TitleText",
                  },
                  "titleText": {"text": "Carnage", "__typename": "TitleText"},
                  "releaseYear": {
                    "year": 2011,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi419608601",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "Flightplan",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 50, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 360,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BMzA5ZTg1MmQtNWQ4OC00YmM4LTk2OGEtOThhYmQ4ZDYwM2VlXkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_.jpg",
                  "width": 480,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2005,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi402831385",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "Flightplan",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 92, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 360,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BZDEyODk1OWQtMDc1OC00YzU2LThiYTItNDE4Mjg1NGZiYjE2XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_.jpg",
                  "width": 480,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2005,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi3875649561",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "Flightplan",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 34, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 360,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BMGYxODA4N2ItY2IxOS00NWViLWJjMTQtNWMzMjQwM2ZlMzJhXkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_.jpg",
                  "width": 480,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2005,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi3858872345",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "Flightplan",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 120, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 360,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BMGU3ZWQ1NzAtZDEyOS00YmY2LWEyM2MtMDliY2YzOWQzNDBiXkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_.jpg",
                  "width": 480,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2005,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi3218997529",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "Flightplan",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 67, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 360,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BYWIwNGRjZDAtNWNhNS00MGM1LWJlNTktOTYyMDYyNDg2NTczXkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_.jpg",
                  "width": 480,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2005,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi3202220313",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "Flightplan",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 40, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 228,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BZjNjZGYwYWYtNWI3MC00NTM4LWI0NDQtNWJkNDc3NzcxOTc5XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_.jpg",
                  "width": 304,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2005,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
            {
              "node": {
                "id": "vi3185443097",
                "contentType": {
                  "displayName": {
                    "value": "Clip",
                    "__typename": "LocalizedString",
                  },
                  "__typename": "VideoContentType",
                },
                "name": {
                  "value": "Flightplan",
                  "__typename": "LocalizedString",
                },
                "runtime": {"value": 76, "__typename": "VideoRuntime"},
                "thumbnail": {
                  "height": 228,
                  "url":
                      "https://m.media-amazon.com/images/M/MV5BYjA2MzRhNTgtYTBiNi00OWU2LTkwZTUtMzQ3OTgxNDcwZmM3XkEyXkFqcGdeQXVyNzU1NzE3NTg@._V1_.jpg",
                  "width": 303,
                  "__typename": "Thumbnail",
                },
                "primaryTitle": {
                  "originalTitleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "titleText": {
                    "text": "Flightplan",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {
                    "year": 2005,
                    "endYear": null,
                    "__typename": "YearRange",
                  },
                  "titleType": {
                    "canHaveEpisodes": false,
                    "__typename": "TitleType",
                  },
                  "__typename": "Title",
                },
                "__typename": "Video",
              },
              "__typename": "VideoEdge",
            },
          ],
          "__typename": "VideoConnection",
        },
        "height": {
          "displayableProperty": {
            "value": {"plainText": "5′ 3″ (1.60 m)", "__typename": "Markdown"},
            "__typename": "DisplayableNameHeightProperty",
          },
          "__typename": "NameHeight",
        },
        "birthDate": {
          "dateComponents": {
            "day": 19,
            "month": 11,
            "year": 1962,
            "__typename": "DateComponents",
          },
          "displayableProperty": {
            "value": {
              "plainText": "November 19, 1962",
              "__typename": "Markdown",
            },
            "__typename": "DisplayableDateProperty",
          },
          "__typename": "DisplayableDate",
        },
        "birthLocation": {
          "text": "Los Angeles, California, USA",
          "displayableProperty": {
            "value": {
              "plainText": "Los Angeles, California, USA",
              "__typename": "Markdown",
            },
            "__typename": "DisplayableLocationProperty",
          },
          "__typename": "DisplayableLocation",
        },
        "deathDate": null,
        "deathLocation": null,
        "deathCause": null,
        "akas": {
          "edges": [
            {
              "node": {
                "displayableProperty": {
                  "value": {
                    "plainText": "Jodi Foster",
                    "__typename": "Markdown",
                  },
                  "__typename": "DisplayableNameAkaProperty",
                },
                "__typename": "NameAka",
              },
              "__typename": "NameAkaEdge",
            },
            {
              "node": {
                "displayableProperty": {
                  "value": {
                    "plainText": "Jody Foster",
                    "__typename": "Markdown",
                  },
                  "__typename": "DisplayableNameAkaProperty",
                },
                "__typename": "NameAka",
              },
              "__typename": "NameAkaEdge",
            },
          ],
          "__typename": "NameAkaConnection",
        },
        "otherWorks": {
          "edges": [
            {
              "node": {
                "displayableProperty": {
                  "value": {
                    "plaidHtml": "TV commercial for Crest toothpaste",
                    "__typename": "Markdown",
                  },
                  "machineTranslatedValue": {
                    "language": {"id": "en-US"},
                    "value": {
                      "plaidHtml": "TV commercial for Crest toothpaste",
                      "__typename": "Markdown",
                    },
                    "isMachineTranslation": false,
                    "__typename": "MachineTranslatedMarkdown",
                  },
                  "__typename": "DisplayableNameOtherWorkProperty",
                },
                "__typename": "NameOtherWork",
              },
              "__typename": "NameOtherWorkEdge",
            },
          ],
          "total": 13,
          "__typename": "NameOtherWorkConnection",
        },
        "personalDetailsSpouses": [
          {
            "spouse": {
              "name": {
                "id": "nm0373312",
                "nameText": {
                  "text": "Alexandra Hedison",
                  "__typename": "NameText",
                },
                "__typename": "Name",
              },
              "asMarkdown": {
                "plainText": "Alexandra Hedison",
                "__typename": "Markdown",
              },
              "__typename": "SpouseName",
            },
            "attributes": null,
            "timeRange": {
              "displayableProperty": {
                "value": {
                  "plaidHtml": "April 19, 2014 - present",
                  "__typename": "Markdown",
                },
                "__typename": "DisplayableSpouseTimeRangeProperty",
              },
              "__typename": "DisplayableSpouseTimeRange",
            },
            "__typename": "NameSpouse",
          },
        ],
        "parents": {
          "total": 2,
          "pageInfo": {
            "hasNextPage": true,
            "endCursor": "cnMwMDAwNDM0",
            "__typename": "PageInfo",
          },
          "edges": [
            {
              "node": {
                "relationshipType": {
                  "id": "parent_is",
                  "text": "Parent",
                  "__typename": "NameRelationType",
                },
                "relationName": {
                  "name": null,
                  "displayableProperty": {
                    "value": {
                      "plainText": "Lucius Fisher Foster III",
                      "__typename": "Markdown",
                    },
                    "__typename": "DisplayableRelationNameProperty",
                  },
                  "__typename": "RelationName",
                },
                "__typename": "NameRelation",
              },
              "__typename": "NameRelationsEdge",
            },
          ],
          "__typename": "NameRelationsConnection",
        },
        "children": {
          "total": 2,
          "pageInfo": {
            "hasNextPage": true,
            "endCursor": "cnMwMDMxMjA1",
            "__typename": "PageInfo",
          },
          "edges": [
            {
              "node": {
                "relationshipType": {
                  "id": "child_is",
                  "text": "Child",
                  "__typename": "NameRelationType",
                },
                "relationName": {
                  "name": null,
                  "displayableProperty": {
                    "value": {
                      "plainText": "Kit Bernard Foster",
                      "__typename": "Markdown",
                    },
                    "__typename": "DisplayableRelationNameProperty",
                  },
                  "__typename": "RelationName",
                },
                "__typename": "NameRelation",
              },
              "__typename": "NameRelationsEdge",
            },
          ],
          "__typename": "NameRelationsConnection",
        },
        "others": {
          "total": 3,
          "pageInfo": {
            "hasNextPage": true,
            "endCursor": "cnMwMjE5ODM2",
            "__typename": "PageInfo",
          },
          "edges": [
            {
              "node": {
                "relationshipType": {
                  "id": "sibling_is",
                  "text": "Sibling",
                  "__typename": "NameRelationType",
                },
                "relationName": {
                  "name": {"id": "nm0287711", "__typename": "Name"},
                  "displayableProperty": {
                    "value": {
                      "plainText": "Buddy Foster",
                      "__typename": "Markdown",
                    },
                    "__typename": "DisplayableRelationNameProperty",
                  },
                  "__typename": "RelationName",
                },
                "__typename": "NameRelation",
              },
              "__typename": "NameRelationsEdge",
            },
          ],
          "__typename": "NameRelationsConnection",
        },
        "personalDetailsExternalLinks": {
          "edges": [],
          "total": 0,
          "__typename": "ExternalLinkConnection",
        },
        "publicityListings": {
          "total": 213,
          "__typename": "PublicityListingConnection",
        },
        "nameFilmBiography": {
          "total": 0,
          "__typename": "PublicityListingConnection",
        },
        "namePrintBiography": {
          "total": 5,
          "__typename": "PublicityListingConnection",
        },
        "namePortrayal": {
          "total": 3,
          "__typename": "PublicityListingConnection",
        },
        "publicityInterview": {
          "total": 21,
          "__typename": "PublicityListingConnection",
        },
        "publicityArticle": {
          "total": 47,
          "__typename": "PublicityListingConnection",
        },
        "publicityPictorial": {
          "total": 21,
          "__typename": "PublicityListingConnection",
        },
        "publicityMagazineCover": {
          "total": 116,
          "__typename": "PublicityListingConnection",
        },
        "demographicData": [],
        "triviaTotal": {"total": 130, "__typename": "NameTriviaConnection"},
        "trivia": {
          "edges": [
            {
              "node": {
                "displayableArticle": {
                  "body": {
                    "plaidHtml":
                        "Fluent in French by age 14, she spoke her own lines in the film \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0076401/?nm_dyk_trv\"\u003eMoi, Fleur bleue (1977)\u003c/a\u003e, the film \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0344510/?nm_dyk_trv\"\u003eA Very Long Engagement (2004)\u003c/a\u003e and the film \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0476964/?nm_dyk_trv\"\u003eThe Brave One (2007)\u003c/a\u003e. She learned Spanish at a young age. She was also fluent in Italian by age 18.",
                    "__typename": "Markdown",
                  },
                  "__typename": "DisplayableArticle",
                },
                "machineTranslatedDisplayableArticle": {
                  "body": {
                    "language": {"id": "en-US"},
                    "value": {
                      "plaidHtml":
                          "Fluent in French by age 14, she spoke her own lines in the film \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0076401/\"\u003eMoi, Fleur bleue (1977)\u003c/a\u003e, the film \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0344510/\"\u003eA Very Long Engagement (2004)\u003c/a\u003e and the film \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0476964/\"\u003eThe Brave One (2007)\u003c/a\u003e. She learned Spanish at a young age. She was also fluent in Italian by age 18.",
                      "__typename": "Markdown",
                    },
                    "isMachineTranslation": false,
                    "__typename": "MachineTranslatedMarkdown",
                  },
                  "__typename": "MachineTranslatedDisplayableArticle",
                },
                "__typename": "NameTrivia",
              },
              "__typename": "NameTriviaEdge",
            },
          ],
          "__typename": "NameTriviaConnection",
        },
        "quotesTotal": {"total": 40, "__typename": "NameQuoteConnection"},
        "quotes": {
          "edges": [
            {
              "node": {
                "displayableArticle": {
                  "body": {
                    "plaidHtml":
                        "Being understood is not the most essential thing in life.",
                    "__typename": "Markdown",
                  },
                  "__typename": "DisplayableArticle",
                },
                "machineTranslatedDisplayableArticle": {
                  "body": {
                    "language": {"id": "en-US"},
                    "value": {
                      "plaidHtml":
                          "Being understood is not the most essential thing in life.",
                      "__typename": "Markdown",
                    },
                    "isMachineTranslation": false,
                    "__typename": "MachineTranslatedMarkdown",
                  },
                  "__typename": "MachineTranslatedDisplayableArticle",
                },
                "__typename": "NameQuote",
              },
              "__typename": "NameQuoteEdge",
            },
          ],
          "__typename": "NameQuoteConnection",
        },
        "trademarksTotal": {"total": 2, "__typename": "TrademarkConnection"},
        "trademarks": {
          "edges": [
            {
              "node": {
                "displayableArticle": {
                  "body": {
                    "plaidHtml": "Husky voice",
                    "__typename": "Markdown",
                  },
                  "__typename": "DisplayableArticle",
                },
                "machineTranslatedDisplayableArticle": {
                  "body": {
                    "language": {"id": "en-US"},
                    "value": {
                      "plaidHtml": "Husky voice",
                      "__typename": "Markdown",
                    },
                    "isMachineTranslation": false,
                    "__typename": "MachineTranslatedMarkdown",
                  },
                  "__typename": "MachineTranslatedDisplayableArticle",
                },
                "__typename": "Trademark",
              },
              "__typename": "TrademarkEdge",
            },
          ],
          "__typename": "TrademarkConnection",
        },
        "nickNames": [
          {
            "displayableProperty": {
              "value": {"plainText": "Jodie F", "__typename": "Markdown"},
              "__typename": "DisplayableNickNameProperty",
            },
            "__typename": "NickName",
          },
        ],
        "titleSalariesTotal": {"total": 8, "__typename": "SalaryConnection"},
        "titleSalaries": {
          "edges": [
            {
              "node": {
                "title": {
                  "id": "tt0476964",
                  "titleText": {
                    "text": "The Brave One",
                    "__typename": "TitleText",
                  },
                  "originalTitleText": {
                    "text": "The Brave One",
                    "__typename": "TitleText",
                  },
                  "releaseYear": {"year": 2007, "__typename": "YearRange"},
                  "__typename": "Title",
                },
                "displayableProperty": {
                  "value": {
                    "plainText": "15,000,000",
                    "__typename": "Markdown",
                  },
                  "__typename": "DisplayableSalaryProperty",
                },
                "__typename": "Salary",
              },
              "__typename": "SalaryEdge",
            },
          ],
          "__typename": "SalaryConnection",
        },
        "faqs": {
          "total": 12,
          "edges": [
            {
              "node": {
                "attributeId": "age",
                "question": {
                  "plainText": "How old is Jodie Foster?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText": "62 years old",
                  "plaidHtml": "62 years old",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "date-of-birth",
                "question": {
                  "plainText": "When was Jodie Foster born?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText": "November 19, 1962",
                  "plaidHtml": "November 19, 1962",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "place-of-birth",
                "question": {
                  "plainText": "Where was Jodie Foster born?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText": "Los Angeles, California, USA",
                  "plaidHtml": "Los Angeles, California, USA",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "birth-name",
                "question": {
                  "plainText": "What is Jodie Foster's birth name?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText": "Alicia Christian Foster",
                  "plaidHtml": "Alicia Christian Foster",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "height",
                "question": {
                  "plainText": "How tall is Jodie Foster?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText": "5 feet 3 inches, or 1.60 meters",
                  "plaidHtml": "5 feet 3 inches, or 1.60 meters",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "well-known-movie-or-tv-show",
                "question": {
                  "plainText": "What is Jodie Foster known for?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText":
                      "Taxi Driver, The Accused, The Silence of the Lambs, and The Brave One",
                  "plaidHtml":
                      "\u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0075314/?ref_=nmfaq\"\u003eTaxi Driver\u003c/a\u003e, \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0094608/?ref_=nmfaq\"\u003eThe Accused\u003c/a\u003e, \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0102926/?ref_=nmfaq\"\u003eThe Silence of the Lambs\u003c/a\u003e, and \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/title/tt0476964/?ref_=nmfaq\"\u003eThe Brave One\u003c/a\u003e",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "spouse",
                "question": {
                  "plainText": "Is Jodie Foster married?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText": "Yes, to Alexandra Hedison since April 19, 2014",
                  "plaidHtml":
                      "Yes, to \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/name/nm0373312/?ref_=nmfaq\"\u003eAlexandra Hedison\u003c/a\u003e since April 19, 2014",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "children",
                "question": {
                  "plainText": "Does Jodie Foster have children?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText":
                      "Yes, 2 children, including Charlie B. Foster (26) and Kit Bernard Foster",
                  "plaidHtml":
                      "Yes, 2 children, including \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/name/nm11454226/?ref_=nmfaq\"\u003eCharlie B. Foster\u003c/a\u003e (26) and Kit Bernard Foster",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "siblings",
                "question": {
                  "plainText": "Does Jodie Foster have siblings?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText":
                      "Yes, 3 siblings, including Cindy Foster Jones, Buddy Foster, and Connie Foster",
                  "plaidHtml":
                      "Yes, 3 siblings, including \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/name/nm0427771/?ref_=nmfaq\"\u003eCindy Foster Jones\u003c/a\u003e, \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/name/nm0287711/?ref_=nmfaq\"\u003eBuddy Foster\u003c/a\u003e, and \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/name/nm0287737/?ref_=nmfaq\"\u003eConnie Foster\u003c/a\u003e",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "parents",
                "question": {
                  "plainText": "Who are Jodie Foster's parents?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText": "Lucius Fisher Foster III and Evelyn Foster",
                  "plaidHtml":
                      "Lucius Fisher Foster III and \u003ca class=\"ipc-md-link ipc-md-link--entity\" href=\"/name/nm8426365/?ref_=nmfaq\"\u003eEvelyn Foster\u003c/a\u003e",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "number-of-awards",
                "question": {
                  "plainText": "How many awards has Jodie Foster won?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText": "74 awards",
                  "plaidHtml": "74 awards",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
            {
              "node": {
                "attributeId": "number-of-nominations",
                "question": {
                  "plainText":
                      "How many award nominations has Jodie Foster received?",
                  "__typename": "Markdown",
                },
                "answer": {
                  "plainText": "157 nominations",
                  "plaidHtml": "157 nominations",
                  "__typename": "Markdown",
                },
                "__typename": "AlexaQuestion",
              },
              "__typename": "AlexaQuestionEdge",
            },
          ],
          "__typename": "AlexaQuestionConnection",
        },
        "__typename": "Name",
        "selfVerifiedData": {
          "guildAffiliations": {
            "edges": [],
            "__typename": "GuildAffiliationsConnection",
          },
          "__typename": "SelfVerifiedNameData",
        },
      },
      "nameCallToActionData": {
        "callToAction": {
          "nameImagesReels": {
            "action": {
              "label": {
                "text": "Add photos, demo reels",
                "__typename": "CallToActionText",
              },
              "url":
                  "https://pro.imdb.com/name/nm0000149?ref_=cons_nm_chgpimage\u0026rf=cons_nm_chgpimage",
              "__typename": "ActionLink",
            },
            "__typename": "LinkCallToAction",
          },
          "nameProUpsell": {
            "abbreviatedActions": [
              {
                "actionName": "upsellAction",
                "label": {
                  "text": "View contact info at IMDbPro",
                  "__typename": "CallToActionText",
                },
                "url":
                    "https://pro.imdb.com/name/nm0000149/?rf=cons_nm_contact\u0026ref_=cons_nm_contact",
                "__typename": "NamedActionLink",
              },
            ],
            "standardActions": [
              {
                "actionName": "upsellAction",
                "label": {
                  "text": "More at IMDbPro",
                  "__typename": "CallToActionText",
                },
                "url":
                    "https://pro.imdb.com/name/nm0000149/?rf=cons_nm_more\u0026ref_=cons_nm_more",
                "__typename": "NamedActionLink",
              },
              {
                "actionName": "contactInfoAction",
                "label": {
                  "text": "Contact info",
                  "__typename": "CallToActionText",
                },
                "url":
                    "https://pro.imdb.com/name/nm0000149/?rf=cons_nm_contact\u0026ref_=cons_nm_contact",
                "__typename": "NamedActionLink",
              },
              {
                "actionName": "agentInfoAction",
                "label": {
                  "text": "Agent info",
                  "__typename": "CallToActionText",
                },
                "url":
                    "https://pro.imdb.com/name/nm0000149/?rf=cons_nm_agent\u0026ref_=cons_nm_agent",
                "__typename": "NamedActionLink",
              },
              {
                "actionName": "resumeAction",
                "label": {"text": "Resume", "__typename": "CallToActionText"},
                "url":
                    "https://pro.imdb.com/name/nm0000149/?rf=cons_nm_ov_res\u0026ref_=cons_nm_ov_res",
                "__typename": "NamedActionLink",
              },
            ],
            "__typename": "MultiLinkCallToAction",
          },
          "__typename": "CallToAction",
        },
      },
      "urqlState": null,
      "fetchState": null,
    },
    "__N_SSP": true,
  },
  "page": "/name/[nmconst]",
  "query": {"ref_": "fn_t_1", "nmconst": "nm0000149"},
};
