import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_keywords.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=enigma&page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main","bestSource":"DataSourceType.imdbKeywords","title":"Next »","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbKeywords":"https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=enigma&page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main"},"related":{}}
''',
  r'''
{"uniqueId":"tt0032976","bestSource":"DataSourceType.imdbKeywords","title":"Rebecca","type":"MovieContentType.title","year":"1940","yearRange":"1940","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                138,806\n    |                Gross:\n                $4.36M","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTcxYWExOTMtMWFmYy00ZjgzLWI0YjktNWEzYzJkZTg0NDdmL2ltYWdlXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UY209_CR3,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0032976"},"related":{}}
''',
  r'''
{"uniqueId":"tt0033467","bestSource":"DataSourceType.imdbKeywords","title":"Citizen Kane","type":"MovieContentType.title","year":"1941","yearRange":"1941","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                445,293\n    |                Gross:\n                $1.59M","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjBiOTYxZWItMzdiZi00NjlkLWIzZTYtYmFhZjhiMTljOTdkXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0033467"},"related":{}}
''',
  r'''
{"uniqueId":"tt0037008","bestSource":"DataSourceType.imdbKeywords","title":"Laura","type":"MovieContentType.title","year":"1944","yearRange":"1944","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                48,409\n    |                Gross:\n                $4.36M","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjYwY2VmOGEtZTM1Mi00YmZhLWFkY2QtNmNlYzA0NmE5MTNlXkEyXkFqcGdeQXVyMzg1ODEwNQ@@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0037008"},"related":{}}
''',
  r'''
{"uniqueId":"tt0057427","bestSource":"DataSourceType.imdbKeywords","title":"Le procès","type":"MovieContentType.title","year":"1962","yearRange":"1962","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                22,225","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BN2JiZTM2ZWMtOWI5ZS00ZjI2LWI5OTktNTJjZmU2NzM4NGE2XkEyXkFqcGdeQXVyNDE0OTU3NDY@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0057427"},"related":{}}
''',
  r'''
{"uniqueId":"tt0058329","bestSource":"DataSourceType.imdbKeywords","title":"Marnie","type":"MovieContentType.title","year":"1964","yearRange":"1964","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                50,692\n    |                Gross:\n                $7.00M","censorRating":"CensorRatingType.adult","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTEwMzhiMDktMzFlMi00NTE1LTlkOTItZWI5ODA2Y2E5YjUzXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0058329"},"related":{}}
''',
  r'''
{"uniqueId":"tt0066769","bestSource":"DataSourceType.imdbKeywords","title":"The Andromeda Strain","type":"MovieContentType.title","year":"1971","yearRange":"1971","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                38,214\n    |                Gross:\n                $3.42M","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzY4NGZkOTMtNTRjNy00NWY4LWI2ZmUtODc3NWY3MTBhNzE2XkEyXkFqcGdeQXVyNTA4NzY1MzY@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0066769"},"related":{}}
''',
  r'''
{"uniqueId":"tt0069467","bestSource":"DataSourceType.imdbKeywords","title":"Viskningar och rop","type":"MovieContentType.title","year":"1972","yearRange":"1972","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                34,902\n    |                Gross:\n                $1.74M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjFmZTdlZWEtOTY0MS00MWJlLWEyOGMtZmI5ZGI1N2FiZWYxXkEyXkFqcGdeQXVyMTUzMDUzNTI3._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0069467"},"related":{}}
''',
  r'''
{"uniqueId":"tt0070917","bestSource":"DataSourceType.imdbKeywords","title":"The Wicker Man","type":"MovieContentType.title","year":"1973","yearRange":"1973","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                83,146\n    |                Gross:\n                $0.06M","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWIzY2QyNDQtOWI3Ni00MjEwLTlhYTgtZTgyMThiY2JkMTY4XkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR1,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0070917"},"related":{}}
''',
  r'''
{"uniqueId":"tt0071360","bestSource":"DataSourceType.imdbKeywords","title":"The Conversation","type":"MovieContentType.title","year":"1974","yearRange":"1974","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                114,079\n    |                Gross:\n                $4.42M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzAwZWRhZTEtOWYwMi00YzQ5LWE1MzQtM2JlZWE0Y2E4ZDg3XkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0071360"},"related":{}}
''',
  r'''
{"uniqueId":"tt0073580","bestSource":"DataSourceType.imdbKeywords","title":"Professione: reporter","type":"MovieContentType.title","year":"1975","yearRange":"1975","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                24,441\n    |                Gross:\n                $0.62M","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BM2MyODc3OWEtYzRiYS00Yzc5LTliZjMtNTQ1NWFlMDRmZmVlL2ltYWdlXkEyXkFqcGdeQXVyNzM0MDQ1Mw@@._V1_UY209_CR7,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0073580"},"related":{}}
''',
  r'''
{"uniqueId":"tt0074486","bestSource":"DataSourceType.imdbKeywords","title":"Eraserhead","type":"MovieContentType.title","year":"1977","yearRange":"1977","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                119,039\n    |                Gross:\n                $7.00M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDExYzg5YjQtMzE0Yy00OWJjLThiZTctMWI5MzhjM2RmNjA4L2ltYWdlXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0074486"},"related":{}}
''',
  r'''
{"uniqueId":"tt0074811","bestSource":"DataSourceType.imdbKeywords","title":"The Tenant","type":"MovieContentType.title","year":"1976","yearRange":"1976","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                44,982\n    |                Gross:\n                $1.92M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWJlYzBjMDQtOGRhOS00OGZjLWEwMjQtY2E0MzI0ZDllYWNmXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0074811"},"related":{}}
''',
  r'''
{"uniqueId":"tt0082085","bestSource":"DataSourceType.imdbKeywords","title":"Blow Out","type":"MovieContentType.title","year":"1981","yearRange":"1981","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                55,974\n    |                Gross:\n                $13.75M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmZiMmZmNjQtNGM3OC00MTFkLWIxMzktZmJhMGYzMjYwYzZmXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0082085"},"related":{}}
''',
  r'''
{"uniqueId":"tt0085933","bestSource":"DataSourceType.imdbKeywords","title":"Merry Christmas, Mr. Lawrence","type":"MovieContentType.title","year":"1983","yearRange":"1983","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                18,280\n    |                Gross:\n                $2.31M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzY0Zjc4Y2YtNDM4Mi00NmRmLTg4Y2UtYmEyMTU0MmY3ZmM1XkEyXkFqcGdeQXVyNjQ2MjQ5NzM@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0085933"},"related":{}}
''',
  r'''
{"uniqueId":"tt0097883","bestSource":"DataSourceType.imdbKeywords","title":"Millennium","type":"MovieContentType.title","year":"1989","yearRange":"1989","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                6,562\n    |                Gross:\n                $5.78M","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzQ0MWFjYTAtMDYyYS00ZDkxLTljNDQtZjhmZWRkOWM5YmY3XkEyXkFqcGdeQXVyMTUzMDUzNTI3._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0097883"},"related":{}}
''',
  r'''
{"uniqueId":"tt0098936","bestSource":"DataSourceType.imdbKeywords","title":"Twin Peaks","type":"MovieContentType.title","year":"1991","yearRange":"1990–1991","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                200,600","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTExNzk2NjcxNTNeQTJeQWpwZ15BbWU4MDcxOTczOTIx._V1_UY209_CR11,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0098936"},"related":{}}
''',
  r'''
{"uniqueId":"tt0099871","bestSource":"DataSourceType.imdbKeywords","title":"Jacob's Ladder","type":"MovieContentType.title","yearRange":"I 1990","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                110,785\n    |                Gross:\n                $26.12M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZTg5MTMyNjktNTZhOC00MGFlLWFlMTMtZGU2MjE3OWQ3NjJkXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UY209_CR1,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0099871"},"related":{}}
''',
  r'''
{"uniqueId":"tt0105665","bestSource":"DataSourceType.imdbKeywords","title":"Twin Peaks: Fire Walk with Me","type":"MovieContentType.title","year":"1992","yearRange":"1992","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                98,936\n    |                Gross:\n                $4.16M","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzc5ODcyNTYtMDAwNy00MDhjLWFmOWUtNGVhMDRlYjE1YzNjXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0105665"},"related":{}}
''',
  r'''
{"uniqueId":"tt0109665","bestSource":"DataSourceType.imdbKeywords","title":"Dream Lover","type":"MovieContentType.title","year":"1993","yearRange":"1993","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                5,297\n    |                Gross:\n                $0.26M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTA5ZjAyMDUtOWJmMS00NWY3LWJkMjQtMDQxZmEyOTFhM2YxXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0109665"},"related":{}}
''',
  r'''
{"uniqueId":"tt0114814","bestSource":"DataSourceType.imdbKeywords","title":"The Usual Suspects","type":"MovieContentType.title","year":"1995","yearRange":"1995","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                1,091,491\n    |                Gross:\n                $23.34M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTViNjMyNmUtNDFkNC00ZDRlLThmMDUtZDU2YWE4NGI2ZjVmXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0114814"},"related":{}}
''',
  r'''
{"uniqueId":"tt0125664","bestSource":"DataSourceType.imdbKeywords","title":"Man on the Moon","type":"MovieContentType.title","year":"1999","yearRange":"1999","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                132,795\n    |                Gross:\n                $34.58M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDI1Mjc3MzAtZDk0OS00OTZlLTlhZjktNzA3ODgwZGY2NWIwXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0125664"},"related":{}}
''',
  r'''
{"uniqueId":"tt0156887","bestSource":"DataSourceType.imdbKeywords","title":"Perfect Blue","type":"MovieContentType.title","year":"1997","yearRange":"1997","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                79,920\n    |                Gross:\n                $0.78M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmMzOWNhNTYtYmY0My00OGJiLWIzNDUtZWRhNGY0NWFjNzFmXkEyXkFqcGdeQXVyNjUxMDQ0MTg@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0156887"},"related":{}}
''',
  r'''
{"uniqueId":"tt0161081","bestSource":"DataSourceType.imdbKeywords","title":"What Lies Beneath","type":"MovieContentType.title","year":"2000","yearRange":"2000","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                128,860\n    |                Gross:\n                $155.46M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTY4NjNkMTMtNTEyOC00NDBiLWFkZjMtZDkwYzU3OTFjOTkzXkEyXkFqcGdeQXVyNTUyMzE4Mzg@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0161081"},"related":{}}
''',
  r'''
{"uniqueId":"tt0166924","bestSource":"DataSourceType.imdbKeywords","title":"Mulholland Drive","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                361,268\n    |                Gross:\n                $7.22M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTRiMzg4NDItNTc3Zi00NjBjLTgwOWYtOGZjMTFmNGU4ODY4XkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0166924"},"related":{}}
''',
  r'''
{"uniqueId":"tt0246578","bestSource":"DataSourceType.imdbKeywords","title":"Donnie Darko","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                808,735\n    |                Gross:\n                $1.48M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjZlZDlkYTktMmU1My00ZDBiLWFlNjEtYTBhNjVhOTM4ZjJjXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0246578"},"related":{}}
''',
  r'''
{"uniqueId":"tt0252501","bestSource":"DataSourceType.imdbKeywords","title":"Hearts in Atlantis","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                39,524\n    |                Gross:\n                $24.19M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjFjNWNmYWUtZTFlMi00ZDcxLWJkY2MtNjMwYmM0OTc5OTM1XkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0252501"},"related":{}}
''',
  r'''
{"uniqueId":"tt0272152","bestSource":"DataSourceType.imdbKeywords","title":"K-PAX","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                186,277\n    |                Gross:\n                $50.34M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjE2Mjc4Y2EtN2QyNy00YTI5LWFlMjUtYjkwOTdhYTliMTliXkEyXkFqcGdeQXVyMjA0MzYwMDY@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0272152"},"related":{}}
''',
  r'''
{"uniqueId":"tt0324133","bestSource":"DataSourceType.imdbKeywords","title":"Swimming Pool","type":"MovieContentType.title","year":"2003","yearRange":"2003","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                46,733\n    |                Gross:\n                $10.11M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZGNjMmUzNjQtMjJjYy00ZWYyLTlhNDAtNDk2Y2QxZWQ0Y2NiXkEyXkFqcGdeQXVyNjc5NjEzNA@@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0324133"},"related":{}}
''',
  r'''
{"uniqueId":"tt0332658","bestSource":"DataSourceType.imdbKeywords","title":"Intermission","type":"MovieContentType.title","year":"2003","yearRange":"2003","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                16,050\n    |                Gross:\n                $0.90M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTUyNjQzNzYyMF5BMl5BanBnXkFtZTcwNDg0MzUyMQ@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0332658"},"related":{}}
''',
  r'''
{"uniqueId":"tt0337876","bestSource":"DataSourceType.imdbKeywords","title":"Birth","type":"MovieContentType.title","year":"2004","yearRange":"2004","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                37,458\n    |                Gross:\n                $5.01M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzUzNzI4MzU4NV5BMl5BanBnXkFtZTcwMjcxMzcyMQ@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0337876"},"related":{}}
''',
  r'''
{"uniqueId":"tt0348593","bestSource":"DataSourceType.imdbKeywords","title":"The Door in the Floor","type":"MovieContentType.title","year":"2004","yearRange":"2004","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                15,856\n    |                Gross:\n                $3.84M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTYyNTIxODA1M15BMl5BanBnXkFtZTYwMzY1NjY3._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0348593"},"related":{}}
''',
  r'''
{"uniqueId":"tt0365686","bestSource":"DataSourceType.imdbKeywords","title":"Revolver","type":"MovieContentType.title","year":"2005","yearRange":"2005","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                97,795\n    |                Gross:\n                $0.08M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTQ1OTA3MjM4MF5BMl5BanBnXkFtZTYwMTMxODc4._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0365686"},"related":{}}
''',
  r'''
{"uniqueId":"tt0366627","bestSource":"DataSourceType.imdbKeywords","title":"The Jacket","type":"MovieContentType.title","year":"2005","yearRange":"2005","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                115,115\n    |                Gross:\n                $6.30M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjY1ZTNiMGYtOGJjNy00MmE4LWFjYzQtOTNjYzYzZTcyNzQ5XkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0366627"},"related":{}}
''',
  r'''
{"uniqueId":"tt0368794","bestSource":"DataSourceType.imdbKeywords","title":"I'm Not There","type":"MovieContentType.title","year":"2007","yearRange":"2007","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                59,550\n    |                Gross:\n                $4.02M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY4MzM2MjcwNV5BMl5BanBnXkFtZTcwODg3MDU1MQ@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0368794"},"related":{}}
''',
  r'''
{"uniqueId":"tt0454848","bestSource":"DataSourceType.imdbKeywords","title":"Inside Man","type":"MovieContentType.title","year":"2006","yearRange":"2006","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                377,745\n    |                Gross:\n                $88.51M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjc4MjA2ZDgtOGY3YS00NDYzLTlmNTEtYWMxMzcwZjgzYWNjXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0454848"},"related":{}}
''',
  r'''
{"uniqueId":"tt0481369","bestSource":"DataSourceType.imdbKeywords","title":"The Number 23","type":"MovieContentType.title","year":"2007","yearRange":"2007","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                205,253\n    |                Gross:\n                $35.19M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDg0YzAxZGYtNTdkYy00ZmUyLWIwNDQtOTA0NGNlZGZiMjkwXkEyXkFqcGdeQXVyMjQwMjk0NjI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0481369"},"related":{}}
''',
  r'''
{"uniqueId":"tt0945513","bestSource":"DataSourceType.imdbKeywords","title":"Source Code","type":"MovieContentType.title","year":"2011","yearRange":"2011","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                525,785\n    |                Gross:\n                $54.71M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY0MTc3MzMzNV5BMl5BanBnXkFtZTcwNDE4MjE0NA@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0945513"},"related":{}}
''',
  r'''
{"uniqueId":"tt0970179","bestSource":"DataSourceType.imdbKeywords","title":"Hugo","type":"MovieContentType.title","year":"2011","yearRange":"2011","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                326,174\n    |                Gross:\n                $73.86M","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjAzNzk5MzgyNF5BMl5BanBnXkFtZTcwOTE4NDU5Ng@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0970179"},"related":{}}
''',
  r'''
{"uniqueId":"tt10731256","bestSource":"DataSourceType.imdbKeywords","title":"Don't Worry Darling","type":"MovieContentType.title","yearRange":"I 2022","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                100,626","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzFkMWUzM2ItZWFjMi00NDY0LTk2MDMtZDhkMDE2MjRlYmZlXkEyXkFqcGdeQXVyNTAzNzgwNTg@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt10731256"},"related":{}}
''',
  r'''
{"uniqueId":"tt13444912","bestSource":"DataSourceType.imdbKeywords","title":"The Midnight Club","type":"MovieContentType.title","year":"2022","yearRange":"2022","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                25,527","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTc5OGU1YjItZmVhZi00NmE3LTk0ZWEtZDE1OGJjMTMzNDY2XkEyXkFqcGdeQXVyMTEyMjM2NDc2._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt13444912"},"related":{}}
''',
  r'''
{"uniqueId":"tt1924396","bestSource":"DataSourceType.imdbKeywords","title":"The Best Offer","type":"MovieContentType.title","year":"2013","yearRange":"2013","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                121,476\n    |                Gross:\n                $0.09M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTQ4MzQ3NjA0N15BMl5BanBnXkFtZTgwODQyNjQ4MDE@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt1924396"},"related":{}}
''',
  r'''
{"uniqueId":"tt2084970","bestSource":"DataSourceType.imdbKeywords","title":"The Imitation Game","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                777,543\n    |                Gross:\n                $91.13M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTgwMzFiMWYtZDhlNS00ODNkLWJiODAtZDVhNzgyNzJhYjQ4L2ltYWdlXkEyXkFqcGdeQXVyNzEzOTYxNTQ@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt2084970"},"related":{}}
''',
  r'''
{"uniqueId":"tt2365580","bestSource":"DataSourceType.imdbKeywords","title":"Where'd You Go, Bernadette","type":"MovieContentType.title","year":"2019","yearRange":"2019","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                22,791\n    |                Gross:\n                $9.20M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDZiY2MyN2ItZjYyMi00YWNiLTk3NTQtNzk3YWFlOTg1MzViXkEyXkFqcGdeQXVyODk2NDQ3MTA@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt2365580"},"related":{}}
''',
  r'''
{"uniqueId":"tt2452254","bestSource":"DataSourceType.imdbKeywords","title":"Clouds of Sils Maria","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                30,196\n    |                Gross:\n                $1.81M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjAwMTg3MDE0NF5BMl5BanBnXkFtZTgwNjQ1ODQyNTE@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt2452254"},"related":{}}
''',
  r'''
{"uniqueId":"tt3262342","bestSource":"DataSourceType.imdbKeywords","title":"Loving Vincent","type":"MovieContentType.title","year":"2017","yearRange":"2017","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                59,240\n    |                Gross:\n                $6.74M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTU3NjE2NjgwN15BMl5BanBnXkFtZTgwNDYzMzEwMzI@._V1_UY209_CR1,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3262342"},"related":{}}
''',
  r'''
{"uniqueId":"tt3289956","bestSource":"DataSourceType.imdbKeywords","title":"The Autopsy of Jane Doe","type":"MovieContentType.title","year":"2016","yearRange":"2016","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                122,335\n    |                Gross:\n                $0.01M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjA2MTEzMzkzM15BMl5BanBnXkFtZTgwMjM2MTM5MDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3289956"},"related":{}}
''',
  r'''
{"uniqueId":"tt3387648","bestSource":"DataSourceType.imdbKeywords","title":"The Taking","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                34,027","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BZWQ3YmU4ZjYtZGE2Ni00NjhiLTk2NTMtYmVmYmNkNWViYzUxXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3387648"},"related":{}}
''',
  r'''
{"uniqueId":"tt3613454","bestSource":"DataSourceType.imdbKeywords","title":"Zankyô no teroru","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                11,691","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjdhYzY0M2QtODgwZi00NDg2LTliNDQtMzA4ZTMzMzQ0MGEyXkEyXkFqcGdeQXVyMTA3OTEyODI1._V1_UY209_CR4,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3613454"},"related":{}}
''',
  r'''
{"uniqueId":"tt4602066","bestSource":"DataSourceType.imdbKeywords","title":"The Catcher Was a Spy","type":"MovieContentType.title","year":"2018","yearRange":"2018","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                10,110\n    |                Gross:\n                $0.71M","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BODhlNDc0ZTQtN2FiOS00OGRiLWE2YmYtZmI2ZmU1NzM5MmJlXkEyXkFqcGdeQXVyODY3Nzc0OTk@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt4602066"},"related":{}}
''',
  r'''
{"uniqueId":"tt6160448","bestSource":"DataSourceType.imdbKeywords","title":"White Noise","type":"MovieContentType.title","yearRange":"I 2022","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Votes:\n                31,563","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDdmYjc3Y2EtM2FjYS00NGI2LTliZjgtYmQxMzJiMmUxNmI4XkEyXkFqcGdeQXVyNjY1MTg4Mzc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt6160448"},"related":{}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBKeywords test', () {
    // Search for a rare movie.
    test('Run a keyword search on IMDB that is likely to have static results',
        () async {
      final criteria = SearchCriteriaDTO().fromString('enigma');
      final actualOutput =
          await QueryIMDBKeywords().readList(criteria, limit: 10);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // Uncomment this line to update expectedOutput if sample data changes
      // printTestData(actualOutput);

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          percentMatch: 60,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
