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
{"uniqueId":"https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=enigma&page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main","bestSource":"DataSourceType.imdbKeywords","title":"Next »","languages":"[]","genres":"[]","keywords":"[]",
      "description":"{\"keyword\":enigma, \"page\":2, \"url\":https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=enigma&page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main}","sources":{"DataSourceType.imdbKeywords":"https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=enigma&page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main"},"related":{}}
''',
  r'''
{"uniqueId":"tt0032976","bestSource":"DataSourceType.imdbKeywords","title":"Rebecca","type":"MovieContentType.title","year":"1940","yearRange":"1940","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A self-conscious woman juggles adjusting to her new role as an aristocrat's wife and avoiding being intimidated by his first wife's spectral presence.","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTcxYWExOTMtMWFmYy00ZjgzLWI0YjktNWEzYzJkZTg0NDdmL2ltYWdlXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UY209_CR3,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0032976"},"related":{}}
''',
  r'''
{"uniqueId":"tt0033467","bestSource":"DataSourceType.imdbKeywords","title":"Citizen Kane","type":"MovieContentType.title","year":"1941","yearRange":"1941","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Following the death of publishing tycoon Charles Foster Kane, reporters scramble to uncover the meaning of his final utterance: 'Rosebud.'","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjBiOTYxZWItMzdiZi00NjlkLWIzZTYtYmFhZjhiMTljOTdkXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0033467"},"related":{}}
''',
  r'''
{"uniqueId":"tt0037008","bestSource":"DataSourceType.imdbKeywords","title":"Laura","type":"MovieContentType.title","year":"1944","yearRange":"1944","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A police detective falls in love with the woman whose murder he is investigating.","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjYwY2VmOGEtZTM1Mi00YmZhLWFkY2QtNmNlYzA0NmE5MTNlXkEyXkFqcGdeQXVyMzg1ODEwNQ@@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0037008"},"related":{}}
''',
  r'''
{"uniqueId":"tt0057427","bestSource":"DataSourceType.imdbKeywords","title":"Le procès","type":"MovieContentType.title","year":"1962","yearRange":"1962","languages":"[]","genres":"[]","keywords":"[]",
      "description":"An unassuming office worker is arrested and stands trial, but he is never made aware of his charges.","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BN2JiZTM2ZWMtOWI5ZS00ZjI2LWI5OTktNTJjZmU2NzM4NGE2XkEyXkFqcGdeQXVyNDE0OTU3NDY@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0057427"},"related":{}}
''',
  r'''
{"uniqueId":"tt0058329","bestSource":"DataSourceType.imdbKeywords","title":"Marnie","type":"MovieContentType.title","year":"1964","yearRange":"1964","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Mark marries Marnie although she is a habitual thief and has serious psychological problems, and tries to help her confront and resolve them.","censorRating":"CensorRatingType.adult","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTEwMzhiMDktMzFlMi00NTE1LTlkOTItZWI5ODA2Y2E5YjUzXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0058329"},"related":{}}
''',
  r'''
{"uniqueId":"tt0066769","bestSource":"DataSourceType.imdbKeywords","title":"The Andromeda Strain","type":"MovieContentType.title","year":"1971","yearRange":"1971","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A team of top scientists work feverishly in a secret, state-of-the-art laboratory to discover what has killed the citizens of a small town and learn how this deadly contagion can be stopped.","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzY4NGZkOTMtNTRjNy00NWY4LWI2ZmUtODc3NWY3MTBhNzE2XkEyXkFqcGdeQXVyNTA4NzY1MzY@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0066769"},"related":{}}
''',
  r'''
{"uniqueId":"tt0069467","bestSource":"DataSourceType.imdbKeywords","title":"Viskningar och rop","type":"MovieContentType.title","year":"1972","yearRange":"1972","languages":"[]","genres":"[]","keywords":"[]",
      "description":"When a woman dying of cancer in early twentieth-century Sweden is visited by her two sisters, long-repressed feelings between the siblings rise to the surface.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjFmZTdlZWEtOTY0MS00MWJlLWEyOGMtZmI5ZGI1N2FiZWYxXkEyXkFqcGdeQXVyMTUzMDUzNTI3._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0069467"},"related":{}}
''',
  r'''
{"uniqueId":"tt0070917","bestSource":"DataSourceType.imdbKeywords","title":"The Wicker Man","type":"MovieContentType.title","year":"1973","yearRange":"1973","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A puritan Police Sergeant arrives in a Scottish island village in search of a missing girl, who the Pagan locals claim never existed.","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWIzY2QyNDQtOWI3Ni00MjEwLTlhYTgtZTgyMThiY2JkMTY4XkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR1,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0070917"},"related":{}}
''',
  r'''
{"uniqueId":"tt0071360","bestSource":"DataSourceType.imdbKeywords","title":"The Conversation","type":"MovieContentType.title","year":"1974","yearRange":"1974","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A paranoid, secretive surveillance expert has a crisis of conscience when he suspects that the couple he is spying on will be murdered.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzAwZWRhZTEtOWYwMi00YzQ5LWE1MzQtM2JlZWE0Y2E4ZDg3XkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0071360"},"related":{}}
''',
  r'''
{"uniqueId":"tt0073580","bestSource":"DataSourceType.imdbKeywords","title":"Professione: reporter","type":"MovieContentType.title","year":"1975","yearRange":"1975","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Unable to find the war he's been asked to cover, a frustrated war correspondent takes the risky path of co-opting the identity of a dead arms-deal acquaintance.","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BM2MyODc3OWEtYzRiYS00Yzc5LTliZjMtNTQ1NWFlMDRmZmVlL2ltYWdlXkEyXkFqcGdeQXVyNzM0MDQ1Mw@@._V1_UY209_CR7,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0073580"},"related":{}}
''',
  r'''
{"uniqueId":"tt0074486","bestSource":"DataSourceType.imdbKeywords","title":"Eraserhead","type":"MovieContentType.title","year":"1977","yearRange":"1977","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Henry Spencer tries to survive his industrial environment, his angry girlfriend, and the unbearable screams of his newly born mutant child.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDExYzg5YjQtMzE0Yy00OWJjLThiZTctMWI5MzhjM2RmNjA4L2ltYWdlXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0074486"},"related":{}}
''',
  r'''
{"uniqueId":"tt0074811","bestSource":"DataSourceType.imdbKeywords","title":"The Tenant","type":"MovieContentType.title","year":"1976","yearRange":"1976","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A bureaucrat rents a Paris apartment where he finds himself drawn into a rabbit hole of dangerous paranoia.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWJlYzBjMDQtOGRhOS00OGZjLWEwMjQtY2E0MzI0ZDllYWNmXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0074811"},"related":{}}
''',
  r'''
{"uniqueId":"tt0082085","bestSource":"DataSourceType.imdbKeywords","title":"Blow Out","type":"MovieContentType.title","year":"1981","yearRange":"1981","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A movie sound recordist accidentally records the evidence that proves that a car accident was actually murder and consequently finds himself in danger.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmZiMmZmNjQtNGM3OC00MTFkLWIxMzktZmJhMGYzMjYwYzZmXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0082085"},"related":{}}
''',
  r'''
{"uniqueId":"tt0085933","bestSource":"DataSourceType.imdbKeywords","title":"Merry Christmas, Mr. Lawrence","type":"MovieContentType.title","year":"1983","yearRange":"1983","languages":"[]","genres":"[]","keywords":"[]",
      "description":"During W.W. II, a British colonel tries to bridge the cultural divides between a British P.O.W. and the Japanese camp commander in order to avoid blood-shed.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzY0Zjc4Y2YtNDM4Mi00NmRmLTg4Y2UtYmEyMTU0MmY3ZmM1XkEyXkFqcGdeQXVyNjQ2MjQ5NzM@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0085933"},"related":{}}
''',
  r'''
{"uniqueId":"tt0097883","bestSource":"DataSourceType.imdbKeywords","title":"Millennium","type":"MovieContentType.title","year":"1989","yearRange":"1989","languages":"[]","genres":"[]","keywords":"[]",
      "description":"An NTSB investigator seeking the cause of an airline disaster meets a warrior woman from 1000 years in the future.","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzQ0MWFjYTAtMDYyYS00ZDkxLTljNDQtZjhmZWRkOWM5YmY3XkEyXkFqcGdeQXVyMTUzMDUzNTI3._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0097883"},"related":{}}
''',
  r'''
{"uniqueId":"tt0098936","bestSource":"DataSourceType.imdbKeywords","title":"Twin Peaks","type":"MovieContentType.title","year":"1991","yearRange":"1990–1991","languages":"[]","genres":"[]","keywords":"[]",
      "description":"An idiosyncratic FBI agent investigates the murder of a young woman in the even more idiosyncratic town of Twin Peaks.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTExNzk2NjcxNTNeQTJeQWpwZ15BbWU4MDcxOTczOTIx._V1_UY209_CR11,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0098936"},"related":{}}
''',
  r'''
{"uniqueId":"tt0099871","bestSource":"DataSourceType.imdbKeywords","title":"Jacob's Ladder","type":"MovieContentType.title","yearRange":"I 1990","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Mourning his dead child, a haunted Vietnam War veteran attempts to uncover his past while suffering from a severe case of dissociation. To do so, he must decipher reality and life from his own dreams, delusions, and perceptions of death.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZTg5MTMyNjktNTZhOC00MGFlLWFlMTMtZGU2MjE3OWQ3NjJkXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UY209_CR1,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0099871"},"related":{}}
''',
  r'''
{"uniqueId":"tt0105665","bestSource":"DataSourceType.imdbKeywords","title":"Twin Peaks: Fire Walk with Me","type":"MovieContentType.title","year":"1992","yearRange":"1992","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Laura Palmer's harrowing final days are chronicled one year after the murder of Teresa Banks, a resident of Twin Peaks' neighboring town.","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzc5ODcyNTYtMDAwNy00MDhjLWFmOWUtNGVhMDRlYjE1YzNjXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0105665"},"related":{}}
''',
  r'''
{"uniqueId":"tt0109665","bestSource":"DataSourceType.imdbKeywords","title":"Dream Lover","type":"MovieContentType.title","year":"1993","yearRange":"1993","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A successful businessman tries to uncover what is wrong with his wife.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTA5ZjAyMDUtOWJmMS00NWY3LWJkMjQtMDQxZmEyOTFhM2YxXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0109665"},"related":{}}
''',
  r'''
{"uniqueId":"tt0114814","bestSource":"DataSourceType.imdbKeywords","title":"The Usual Suspects","type":"MovieContentType.title","year":"1995","yearRange":"1995","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A sole survivor tells of the twisty events leading up to a horrific gun battle on a boat, which began when five criminals met at a seemingly random police lineup.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTViNjMyNmUtNDFkNC00ZDRlLThmMDUtZDU2YWE4NGI2ZjVmXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0114814"},"related":{}}
''',
  r'''
{"uniqueId":"tt0125664","bestSource":"DataSourceType.imdbKeywords","title":"Man on the Moon","type":"MovieContentType.title","year":"1999","yearRange":"1999","languages":"[]","genres":"[]","keywords":"[]",
      "description":"The life and career of legendary comedian Andy Kaufman.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDI1Mjc3MzAtZDk0OS00OTZlLTlhZjktNzA3ODgwZGY2NWIwXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0125664"},"related":{}}
''',
  r'''
{"uniqueId":"tt0156887","bestSource":"DataSourceType.imdbKeywords","title":"Perfect Blue","type":"MovieContentType.title","year":"1997","yearRange":"1997","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A pop singer gives up her career to become an actress, but she slowly goes insane when she starts being stalked by an obsessed fan and what seems to be a ghost of her past.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmMzOWNhNTYtYmY0My00OGJiLWIzNDUtZWRhNGY0NWFjNzFmXkEyXkFqcGdeQXVyNjUxMDQ0MTg@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0156887"},"related":{}}
''',
  r'''
{"uniqueId":"tt0161081","bestSource":"DataSourceType.imdbKeywords","title":"What Lies Beneath","type":"MovieContentType.title","year":"2000","yearRange":"2000","languages":"[]","genres":"[]","keywords":"[]",
      "description":"The wife of a university research scientist believes that her lakeside Vermont home is haunted by a ghost - or that she is losing her mind.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTY4NjNkMTMtNTEyOC00NDBiLWFkZjMtZDkwYzU3OTFjOTkzXkEyXkFqcGdeQXVyNTUyMzE4Mzg@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0161081"},"related":{}}
''',
  r'''
{"uniqueId":"tt0166924","bestSource":"DataSourceType.imdbKeywords","title":"Mulholland Drive","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]","keywords":"[]",
      "description":"After a car wreck on the winding Mulholland Drive renders a woman amnesiac, she and a perky Hollywood-hopeful search for clues and answers across Los Angeles in a twisting venture beyond dreams and reality.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTRiMzg4NDItNTc3Zi00NjBjLTgwOWYtOGZjMTFmNGU4ODY4XkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0166924"},"related":{}}
''',
  r'''
{"uniqueId":"tt0246578","bestSource":"DataSourceType.imdbKeywords","title":"Donnie Darko","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]","keywords":"[]",
      "description":"After narrowly escaping a bizarre accident, a troubled teenager is plagued by visions of a man in a large rabbit suit who manipulates him to commit a series of crimes.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjZlZDlkYTktMmU1My00ZDBiLWFlNjEtYTBhNjVhOTM4ZjJjXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0246578"},"related":{}}
''',
  r'''
{"uniqueId":"tt0252501","bestSource":"DataSourceType.imdbKeywords","title":"Hearts in Atlantis","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Widowed Liz Garfield and her son Bobby change when mysterious stranger Ted Brautigan enters their lives.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjFjNWNmYWUtZTFlMi00ZDcxLWJkY2MtNjMwYmM0OTc5OTM1XkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0252501"},"related":{}}
''',
  r'''
{"uniqueId":"tt0272152","bestSource":"DataSourceType.imdbKeywords","title":"K-PAX","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]","keywords":"[]",
      "description":"PROT is a patient at a mental hospital who claims to be from a faraway planet named K-PAX. His psychiatrist tries to help him, only to begin to doubt his own explanations.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjE2Mjc4Y2EtN2QyNy00YTI5LWFlMjUtYjkwOTdhYTliMTliXkEyXkFqcGdeQXVyMjA0MzYwMDY@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0272152"},"related":{}}
''',
  r'''
{"uniqueId":"tt0324133","bestSource":"DataSourceType.imdbKeywords","title":"Swimming Pool","type":"MovieContentType.title","year":"2003","yearRange":"2003","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A British mystery author visits her publisher's home in the South of France, where her interaction with his unusual daughter sets off some touchy dynamics.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZGNjMmUzNjQtMjJjYy00ZWYyLTlhNDAtNDk2Y2QxZWQ0Y2NiXkEyXkFqcGdeQXVyNjc5NjEzNA@@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0324133"},"related":{}}
''',
  r'''
{"uniqueId":"tt0332658","bestSource":"DataSourceType.imdbKeywords","title":"Intermission","type":"MovieContentType.title","year":"2003","yearRange":"2003","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A variety of losers in Dublin have harrowingly farcical intersecting stories of love, greed and violence.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTUyNjQzNzYyMF5BMl5BanBnXkFtZTcwNDg0MzUyMQ@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0332658"},"related":{}}
''',
  r'''
{"uniqueId":"tt0337876","bestSource":"DataSourceType.imdbKeywords","title":"Birth","type":"MovieContentType.title","year":"2004","yearRange":"2004","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A young boy attempts to convince a woman that he is her dead husband reborn.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzUzNzI4MzU4NV5BMl5BanBnXkFtZTcwMjcxMzcyMQ@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0337876"},"related":{}}
''',
  r'''
{"uniqueId":"tt0348593","bestSource":"DataSourceType.imdbKeywords","title":"The Door in the Floor","type":"MovieContentType.title","year":"2004","yearRange":"2004","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A writer's young assistant becomes both pawn and catalyst in his boss's disintegrating household.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTYyNTIxODA1M15BMl5BanBnXkFtZTYwMzY1NjY3._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0348593"},"related":{}}
''',
  r'''
{"uniqueId":"tt0365686","bestSource":"DataSourceType.imdbKeywords","title":"Revolver","type":"MovieContentType.title","year":"2005","yearRange":"2005","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Gambler Jake Green enters into a game with potentially deadly consequences.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTQ1OTA3MjM4MF5BMl5BanBnXkFtZTYwMTMxODc4._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0365686"},"related":{}}
''',
  r'''
{"uniqueId":"tt0366627","bestSource":"DataSourceType.imdbKeywords","title":"The Jacket","type":"MovieContentType.title","year":"2005","yearRange":"2005","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A Gulf war veteran is wrongly sent to a mental institution for insane criminals, where he becomes the object of a doctor's experiments, and his life is completely affected by them.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjY1ZTNiMGYtOGJjNy00MmE4LWFjYzQtOTNjYzYzZTcyNzQ5XkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0366627"},"related":{}}
''',
  r'''
{"uniqueId":"tt0368794","bestSource":"DataSourceType.imdbKeywords","title":"I'm Not There","type":"MovieContentType.title","year":"2007","yearRange":"2007","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Ruminations on the life of Bob Dylan, where six characters embody a different aspect of the musician's life and work.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY4MzM2MjcwNV5BMl5BanBnXkFtZTcwODg3MDU1MQ@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0368794"},"related":{}}
''',
  r'''
{"uniqueId":"tt0454848","bestSource":"DataSourceType.imdbKeywords","title":"Inside Man","type":"MovieContentType.title","year":"2006","yearRange":"2006","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A police detective, a bank robber, and a high-power broker enter high-stakes negotiations after the criminal's brilliant heist spirals into a hostage situation.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjc4MjA2ZDgtOGY3YS00NDYzLTlmNTEtYWMxMzcwZjgzYWNjXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0454848"},"related":{}}
''',
  r'''
{"uniqueId":"tt0481369","bestSource":"DataSourceType.imdbKeywords","title":"The Number 23","type":"MovieContentType.title","year":"2007","yearRange":"2007","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Walter Sparrow becomes obsessed with a novel that he believes was written about him, as more and more similarities between himself and his literary alter ego seem to arise.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDg0YzAxZGYtNTdkYy00ZmUyLWIwNDQtOTA0NGNlZGZiMjkwXkEyXkFqcGdeQXVyMjQwMjk0NjI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0481369"},"related":{}}
''',
  r'''
{"uniqueId":"tt0945513","bestSource":"DataSourceType.imdbKeywords","title":"Source Code","type":"MovieContentType.title","year":"2011","yearRange":"2011","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A soldier wakes up in someone else's body and discovers he's part of an experimental government program to find the bomber of a commuter train within 8 minutes.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY0MTc3MzMzNV5BMl5BanBnXkFtZTcwNDE4MjE0NA@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0945513"},"related":{}}
''',
  r'''
{"uniqueId":"tt0970179","bestSource":"DataSourceType.imdbKeywords","title":"Hugo","type":"MovieContentType.title","year":"2011","yearRange":"2011","languages":"[]","genres":"[]","keywords":"[]",
      "description":"In 1931 Paris, an orphan living in the walls of a train station gets wrapped up in a mystery involving his late father and an automaton.","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjAzNzk5MzgyNF5BMl5BanBnXkFtZTcwOTE4NDU5Ng@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0970179"},"related":{}}
''',
  r'''
{"uniqueId":"tt10731256","bestSource":"DataSourceType.imdbKeywords","title":"Don't Worry Darling","type":"MovieContentType.title","yearRange":"I 2022","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A 1950s housewife living with her husband in a utopian experimental community begins to worry that his glamorous company could be hiding disturbing secrets.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzFkMWUzM2ItZWFjMi00NDY0LTk2MDMtZDhkMDE2MjRlYmZlXkEyXkFqcGdeQXVyNTAzNzgwNTg@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt10731256"},"related":{}}
''',
  r'''
{"uniqueId":"tt13444912","bestSource":"DataSourceType.imdbKeywords","title":"The Midnight Club","type":"MovieContentType.title","year":"2022","yearRange":"2022","languages":"[]","genres":"[]","keywords":"[]",
      "description":"The Midnight Club follows an octet of terminally-ill teenage patients at Brightcliffe Hospice as they gather at midnight to share scary stories.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTc5OGU1YjItZmVhZi00NmE3LTk0ZWEtZDE1OGJjMTMzNDY2XkEyXkFqcGdeQXVyMTEyMjM2NDc2._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt13444912"},"related":{}}
''',
  r'''
{"uniqueId":"tt1924396","bestSource":"DataSourceType.imdbKeywords","title":"The Best Offer","type":"MovieContentType.title","year":"2013","yearRange":"2013","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A lonely art expert working for a mysterious and reclusive heiress finds not only her art worth examining.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTQ4MzQ3NjA0N15BMl5BanBnXkFtZTgwODQyNjQ4MDE@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt1924396"},"related":{}}
''',
  r'''
{"uniqueId":"tt2084970","bestSource":"DataSourceType.imdbKeywords","title":"The Imitation Game","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]","keywords":"[]",
      "description":"During World War II, the English mathematical genius Alan Turing tries to crack the German Enigma code with help from fellow mathematicians while attempting to come to terms with his troubled private life.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTgwMzFiMWYtZDhlNS00ODNkLWJiODAtZDVhNzgyNzJhYjQ4L2ltYWdlXkEyXkFqcGdeQXVyNzEzOTYxNTQ@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt2084970"},"related":{}}
''',
  r'''
{"uniqueId":"tt2365580","bestSource":"DataSourceType.imdbKeywords","title":"Where'd You Go, Bernadette","type":"MovieContentType.title","year":"2019","yearRange":"2019","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A loving mom becomes compelled to reconnect with her creative passions after years of sacrificing herself for her family. Her leap of faith takes her on an epic adventure that jump-starts her life and leads to her triumphant rediscovery.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDZiY2MyN2ItZjYyMi00YWNiLTk3NTQtNzk3YWFlOTg1MzViXkEyXkFqcGdeQXVyODk2NDQ3MTA@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt2365580"},"related":{}}
''',
  r'''
{"uniqueId":"tt2452254","bestSource":"DataSourceType.imdbKeywords","title":"Clouds of Sils Maria","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A film star comes face-to-face with an uncomfortable reflection of herself while starring in a revival of the play that launched her career.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjAwMTg3MDE0NF5BMl5BanBnXkFtZTgwNjQ1ODQyNTE@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt2452254"},"related":{}}
''',
  r'''
{"uniqueId":"tt3262342","bestSource":"DataSourceType.imdbKeywords","title":"Loving Vincent","type":"MovieContentType.title","year":"2017","yearRange":"2017","languages":"[]","genres":"[]","keywords":"[]",
      "description":"In a story depicted in oil painted animation, a young man comes to the last hometown of painter Vincent van Gogh to deliver the troubled artist's final letter and ends up investigating his final days there.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTU3NjE2NjgwN15BMl5BanBnXkFtZTgwNDYzMzEwMzI@._V1_UY209_CR1,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3262342"},"related":{}}
''',
  r'''
{"uniqueId":"tt3289956","bestSource":"DataSourceType.imdbKeywords","title":"The Autopsy of Jane Doe","type":"MovieContentType.title","year":"2016","yearRange":"2016","languages":"[]","genres":"[]","keywords":"[]",
      "description":"A father and son, both coroners, are pulled into a complex mystery while attempting to identify the body of a young woman, who was apparently harboring dark secrets.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjA2MTEzMzkzM15BMl5BanBnXkFtZTgwMjM2MTM5MDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3289956"},"related":{}}
''',
  r'''
{"uniqueId":"tt3387648","bestSource":"DataSourceType.imdbKeywords","title":"The Taking","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]","keywords":"[]",
      "description":"An elderly woman battling Alzheimer's disease agrees to let a film crew document her condition, but what they discover is something far more sinister going on.","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BZWQ3YmU4ZjYtZGE2Ni00NjhiLTk2NTMtYmVmYmNkNWViYzUxXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3387648"},"related":{}}
''',
  r'''
{"uniqueId":"tt3613454","bestSource":"DataSourceType.imdbKeywords","title":"Zankyô no teroru","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Tokyo has been decimated by a terrorist attack, the only clue to the culprit's identity is a bizarre internet video. Two mysterious children form Sphinx, a clandestine entity determined to pull the trigger on this world.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjdhYzY0M2QtODgwZi00NDg2LTliNDQtMzA4ZTMzMzQ0MGEyXkEyXkFqcGdeQXVyMTA3OTEyODI1._V1_UY209_CR4,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3613454"},"related":{}}
''',
  r'''
{"uniqueId":"tt4602066","bestSource":"DataSourceType.imdbKeywords","title":"The Catcher Was a Spy","type":"MovieContentType.title","year":"2018","yearRange":"2018","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Former Major League Baseball player Moe Berg goes undercover in World War II Europe for the Office of Strategic Services.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BODhlNDc0ZTQtN2FiOS00OGRiLWE2YmYtZmI2ZmU1NzM5MmJlXkEyXkFqcGdeQXVyODY3Nzc0OTk@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt4602066"},"related":{}}
''',
  r'''
{"uniqueId":"tt6160448","bestSource":"DataSourceType.imdbKeywords","title":"White Noise","type":"MovieContentType.title","yearRange":"I 2022","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Dramatizes a contemporary American family's attempts to deal with the mundane conflicts of everyday life while grappling with the universal mysteries of love, death, and the possibility of happiness in an uncertain world.","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDdmYjc3Y2EtM2FjYS00NGI2LTliZjgtYmQxMzJiMmUxNmI4XkEyXkFqcGdeQXVyNjY1MTg4Mzc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt6160448"},"related":{}}
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
      // printTestData(actualOutput, excludeCopyrightedData: true);

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
