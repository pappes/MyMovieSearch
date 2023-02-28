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
{"uniqueId":"https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=enigma&page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main","bestSource":"DataSourceType.imdbKeywords","title":"Next »","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"{\"keyword\":enigma, \"page\":2, \"url\":https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=enigma&page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main}","sources":{"DataSourceType.imdbKeywords":"https://www.imdb.com/search/keyword/?ref_=tt_stry_kw&keywords=enigma&page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main"},"related":{}}
''',
  r'''
{"uniqueId":"tt0032976","bestSource":"DataSourceType.imdbKeywords","title":"Rebecca","type":"MovieContentType.title","year":"1940","yearRange":"1940","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A self-conscious woman juggles adjusting to her new role as an aristocrat's wife and avoiding being intimidated by his first wife's spectral presence.",
      "userRating":"8.1","userRatingCount":"139186","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTcxYWExOTMtMWFmYy00ZjgzLWI0YjktNWEzYzJkZTg0NDdmL2ltYWdlXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UY209_CR3,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0032976"},
  "related":{"Directed by:":{"nm0000033":{"uniqueId":"nm0000033","title":"Alfred Hitchcock","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000033"},"related":{}}},
    "Cast:":{"nm0000059":{"uniqueId":"nm0000059","title":"Laurence Olivier","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000059"},"related":{}},
      "nm0000021":{"uniqueId":"nm0000021","title":"Joan Fontaine","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000021"},"related":{}},
      "nm0001695":{"uniqueId":"nm0001695","title":"George Sanders","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001695"},"related":{}},
      "nm0000752":{"uniqueId":"nm0000752","title":"Judith Anderson","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000752"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0033467","bestSource":"DataSourceType.imdbKeywords","title":"Citizen Kane","type":"MovieContentType.title","year":"1941","yearRange":"1941","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Following the death of publishing tycoon Charles Foster Kane, reporters scramble to uncover the meaning of his final utterance: 'Rosebud.'",
      "userRating":"8.3","userRatingCount":"446192","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjBiOTYxZWItMzdiZi00NjlkLWIzZTYtYmFhZjhiMTljOTdkXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0033467"},
  "related":{"Directed by:":{"nm0000080":{"uniqueId":"nm0000080","title":"Orson Welles","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000080"},"related":{}}},
    "Cast:":{"nm0000080":{"uniqueId":"nm0000080","title":"Orson Welles","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000080"},"related":{}},
      "nm0001072":{"uniqueId":"nm0001072","title":"Joseph Cotten","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001072"},"related":{}},
      "nm0173827":{"uniqueId":"nm0173827","title":"Dorothy Comingore","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0173827"},"related":{}},
      "nm0001547":{"uniqueId":"nm0001547","title":"Agnes Moorehead","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001547"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0037008","bestSource":"DataSourceType.imdbKeywords","title":"Laura","type":"MovieContentType.title","year":"1944","yearRange":"1944","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A police detective falls in love with the woman whose murder he is investigating.",
      "userRating":"7.9","userRatingCount":"48525","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjYwY2VmOGEtZTM1Mi00YmZhLWFkY2QtNmNlYzA0NmE5MTNlXkEyXkFqcGdeQXVyMzg1ODEwNQ@@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0037008"},
  "related":{"Directed by:":{"nm0695937":{"uniqueId":"nm0695937","title":"Otto Preminger","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0695937"},"related":{}}},
    "Cast:":{"nm0000074":{"uniqueId":"nm0000074","title":"Gene Tierney","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000074"},"related":{}},
      "nm0000763":{"uniqueId":"nm0000763","title":"Dana Andrews","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000763"},"related":{}},
      "nm0916067":{"uniqueId":"nm0916067","title":"Clifton Webb","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0916067"},"related":{}},
      "nm0001637":{"uniqueId":"nm0001637","title":"Vincent Price","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001637"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0057427","bestSource":"DataSourceType.imdbKeywords","title":"Le procès","type":"MovieContentType.title","year":"1962","yearRange":"1962","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"An unassuming office worker is arrested and stands trial, but he is never made aware of his charges.",
      "userRating":"7.6","userRatingCount":"22315","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BN2JiZTM2ZWMtOWI5ZS00ZjI2LWI5OTktNTJjZmU2NzM4NGE2XkEyXkFqcGdeQXVyNDE0OTU3NDY@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0057427"},
  "related":{"Directed by:":{"nm0000080":{"uniqueId":"nm0000080","title":"Orson Welles","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000080"},"related":{}}},
    "Cast:":{"nm0000578":{"uniqueId":"nm0000578","title":"Anthony Perkins","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000578"},"related":{}},
      "nm0289450":{"uniqueId":"nm0289450","title":"Arnoldo Foà","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0289450"},"related":{}},
      "nm0353916":{"uniqueId":"nm0353916","title":"Jess Hahn","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0353916"},"related":{}},
      "nm0443985":{"uniqueId":"nm0443985","title":"Billy Kearns","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0443985"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0058329","bestSource":"DataSourceType.imdbKeywords","title":"Marnie","type":"MovieContentType.title","year":"1964","yearRange":"1964","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Mark marries Marnie although she is a habitual thief and has serious psychological problems, and tries to help her confront and resolve them.",
      "userRating":"7.1","userRatingCount":"50885","censorRating":"CensorRatingType.adult","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTEwMzhiMDktMzFlMi00NTE1LTlkOTItZWI5ODA2Y2E5YjUzXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0058329"},
  "related":{"Directed by:":{"nm0000033":{"uniqueId":"nm0000033","title":"Alfred Hitchcock","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000033"},"related":{}}},
    "Cast:":{"nm0001335":{"uniqueId":"nm0001335","title":"Tippi Hedren","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001335"},"related":{}},
      "nm0000125":{"uniqueId":"nm0000125","title":"Sean Connery","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000125"},"related":{}},
      "nm0300010":{"uniqueId":"nm0300010","title":"Martin Gabel","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0300010"},"related":{}},
      "nm0490103":{"uniqueId":"nm0490103","title":"Louise Latham","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0490103"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0062185","bestSource":"DataSourceType.imdbKeywords","title":"Reflections in a Golden Eye","type":"MovieContentType.title","year":"1967","yearRange":"1967","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Bizarre tale of sex, betrayal, and perversion at a military post.",
      "userRating":"6.7","userRatingCount":"7708","censorRating":"CensorRatingType.adult","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDlkZGZmM2EtOTZiNi00ZjExLTk3NmMtNzAwOGUxYzQ4N2I3XkEyXkFqcGdeQXVyMTUzMDUzNTI3._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0062185"},
  "related":{"Directed by:":{"nm0001379":{"uniqueId":"nm0001379","title":"John Huston","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001379"},"related":{}}},
    "Cast:":{"nm0000072":{"uniqueId":"nm0000072","title":"Elizabeth Taylor","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000072"},"related":{}},
      "nm0000008":{"uniqueId":"nm0000008","title":"Marlon Brando","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000008"},"related":{}},
      "nm0001417":{"uniqueId":"nm0001417","title":"Brian Keith","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001417"},"related":{}},
      "nm0364915":{"uniqueId":"nm0364915","title":"Julie Harris","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0364915"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0066769","bestSource":"DataSourceType.imdbKeywords","title":"The Andromeda Strain","type":"MovieContentType.title","year":"1971","yearRange":"1971","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A team of top scientists work feverishly in a secret, state-of-the-art laboratory to discover what has killed the citizens of a small town and learn how this deadly contagion can be stopped.",
      "userRating":"7.2","userRatingCount":"38320","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzY4NGZkOTMtNTRjNy00NWY4LWI2ZmUtODc3NWY3MTBhNzE2XkEyXkFqcGdeQXVyNTA4NzY1MzY@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0066769"},
  "related":{"Directed by:":{"nm0936404":{"uniqueId":"nm0936404","title":"Robert Wise","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0936404"},"related":{}}},
    "Cast:":{"nm0647921":{"uniqueId":"nm0647921","title":"James Olson","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0647921"},"related":{}},
      "nm0384050":{"uniqueId":"nm0384050","title":"Arthur Hill","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0384050"},"related":{}},
      "nm0915536":{"uniqueId":"nm0915536","title":"David Wayne","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0915536"},"related":{}},
      "nm0003679":{"uniqueId":"nm0003679","title":"Kate Reid","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0003679"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0069467","bestSource":"DataSourceType.imdbKeywords","title":"Viskningar och rop","type":"MovieContentType.title","year":"1972","yearRange":"1972","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"When a woman dying of cancer in early twentieth-century Sweden is visited by her two sisters, long-repressed feelings between the siblings rise to the surface.",
      "userRating":"8.0","userRatingCount":"35019","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjFmZTdlZWEtOTY0MS00MWJlLWEyOGMtZmI5ZGI1N2FiZWYxXkEyXkFqcGdeQXVyMTUzMDUzNTI3._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0069467"},
  "related":{"Directed by:":{"nm0000005":{"uniqueId":"nm0000005","title":"Ingmar Bergman","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000005"},"related":{}}},
    "Cast:":{"nm0027683":{"uniqueId":"nm0027683","title":"Harriet Andersson","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0027683"},"related":{}},
      "nm0880521":{"uniqueId":"nm0880521","title":"Liv Ullmann","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0880521"},"related":{}},
      "nm0843306":{"uniqueId":"nm0843306","title":"Kari Sylwan","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0843306"},"related":{}},
      "nm0862026":{"uniqueId":"nm0862026","title":"Ingrid Thulin","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0862026"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0070917","bestSource":"DataSourceType.imdbKeywords","title":"The Wicker Man","type":"MovieContentType.title","year":"1973","yearRange":"1973","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A puritan Police Sergeant arrives in a Scottish island village in search of a missing girl, who the Pagan locals claim never existed.",
      "userRating":"7.5","userRatingCount":"83426","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWIzY2QyNDQtOWI3Ni00MjEwLTlhYTgtZTgyMThiY2JkMTY4XkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR1,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0070917"},
  "related":{"Directed by:":{"nm0362736":{"uniqueId":"nm0362736","title":"Robin Hardy","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0362736"},"related":{}}},
    "Cast:":{"nm0940919":{"uniqueId":"nm0940919","title":"Edward Woodward","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0940919"},"related":{}},
      "nm0000489":{"uniqueId":"nm0000489","title":"Christopher Lee","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000489"},"related":{}},
      "nm0162283":{"uniqueId":"nm0162283","title":"Diane Cilento","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0162283"},"related":{}},
      "nm0001180":{"uniqueId":"nm0001180","title":"Britt Ekland","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001180"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0071360","bestSource":"DataSourceType.imdbKeywords","title":"The Conversation","type":"MovieContentType.title","year":"1974","yearRange":"1974","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A paranoid, secretive surveillance expert has a crisis of conscience when he suspects that the couple he is spying on will be murdered.",
      "userRating":"7.8","userRatingCount":"114407","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzAwZWRhZTEtOWYwMi00YzQ5LWE1MzQtM2JlZWE0Y2E4ZDg3XkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0071360"},
  "related":{"Directed by:":{"nm0000338":{"uniqueId":"nm0000338","title":"Francis Ford Coppola","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000338"},"related":{}}},
    "Cast:":{"nm0000432":{"uniqueId":"nm0000432","title":"Gene Hackman","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000432"},"related":{}},
      "nm0001030":{"uniqueId":"nm0001030","title":"John Cazale","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001030"},"related":{}},
      "nm0307255":{"uniqueId":"nm0307255","title":"Allen Garfield","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0307255"},"related":{}},
      "nm0002078":{"uniqueId":"nm0002078","title":"Frederic Forrest","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0002078"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0073580","bestSource":"DataSourceType.imdbKeywords","title":"Professione: reporter","type":"MovieContentType.title","year":"1975","yearRange":"1975","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Unable to find the war he's been asked to cover, a frustrated war correspondent takes the risky path of co-opting the identity of a dead arms-deal acquaintance.",
      "userRating":"7.5","userRatingCount":"24510","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BM2MyODc3OWEtYzRiYS00Yzc5LTliZjMtNTQ1NWFlMDRmZmVlL2ltYWdlXkEyXkFqcGdeQXVyNzM0MDQ1Mw@@._V1_UY209_CR7,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0073580"},
  "related":{"Directed by:":{"nm0000774":{"uniqueId":"nm0000774","title":"Michelangelo Antonioni","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000774"},"related":{}}},
    "Cast:":{"nm0000197":{"uniqueId":"nm0000197","title":"Jack Nicholson","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000197"},"related":{}},
      "nm0773932":{"uniqueId":"nm0773932","title":"Maria Schneider","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0773932"},"related":{}},
      "nm0750192":{"uniqueId":"nm0750192","title":"Jenny Runacre","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0750192"},"related":{}},
      "nm0376915":{"uniqueId":"nm0376915","title":"Ian Hendry","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0376915"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0074486","bestSource":"DataSourceType.imdbKeywords","title":"Eraserhead","type":"MovieContentType.title","year":"1977","yearRange":"1977","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Henry Spencer tries to survive his industrial environment, his angry girlfriend, and the unbearable screams of his newly born mutant child.",
      "userRating":"7.3","userRatingCount":"119511","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDExYzg5YjQtMzE0Yy00OWJjLThiZTctMWI5MzhjM2RmNjA4L2ltYWdlXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0074486"},
  "related":{"Directed by:":{"nm0000186":{"uniqueId":"nm0000186","title":"David Lynch","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000186"},"related":{}}},
    "Cast:":{"nm0620756":{"uniqueId":"nm0620756","title":"Jack Nance","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0620756"},"related":{}},
      "nm0829270":{"uniqueId":"nm0829270","title":"Charlotte Stewart","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0829270"},"related":{}},
      "nm0430535":{"uniqueId":"nm0430535","title":"Allen Joseph","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0430535"},"related":{}},
      "nm0060931":{"uniqueId":"nm0060931","title":"Jeanne Bates","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0060931"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0074811","bestSource":"DataSourceType.imdbKeywords","title":"The Tenant","type":"MovieContentType.title","year":"1976","yearRange":"1976","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A bureaucrat rents a Paris apartment where he finds himself drawn into a rabbit hole of dangerous paranoia.",
      "userRating":"7.6","userRatingCount":"45116","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWJlYzBjMDQtOGRhOS00OGZjLWEwMjQtY2E0MzI0ZDllYWNmXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0074811"},
  "related":{"Directed by:":{"nm0000591":{"uniqueId":"nm0000591","title":"Roman Polanski","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000591"},"related":{}}},
    "Cast:":{"nm0000591":{"uniqueId":"nm0000591","title":"Roman Polanski","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000591"},"related":{}},
      "nm0000254":{"uniqueId":"nm0000254","title":"Isabelle Adjani","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000254"},"related":{}},
      "nm0002048":{"uniqueId":"nm0002048","title":"Melvyn Douglas","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0002048"},"related":{}},
      "nm0886888":{"uniqueId":"nm0886888","title":"Jo Van Fleet","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0886888"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0082085","bestSource":"DataSourceType.imdbKeywords","title":"Blow Out","type":"MovieContentType.title","year":"1981","yearRange":"1981","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A movie sound recordist accidentally records the evidence that proves that a car accident was actually murder and consequently finds himself in danger.",
      "userRating":"7.4","userRatingCount":"56326","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmZiMmZmNjQtNGM3OC00MTFkLWIxMzktZmJhMGYzMjYwYzZmXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0082085"},
  "related":{"Directed by:":{"nm0000361":{"uniqueId":"nm0000361","title":"Brian De Palma","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000361"},"related":{}}},
    "Cast:":{"nm0000237":{"uniqueId":"nm0000237","title":"John Travolta","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000237"},"related":{}},
      "nm0000262":{"uniqueId":"nm0000262","title":"Nancy Allen","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000262"},"related":{}},
      "nm0001475":{"uniqueId":"nm0001475","title":"John Lithgow","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001475"},"related":{}},
      "nm0001240":{"uniqueId":"nm0001240","title":"Dennis Franz","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001240"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0098068","bestSource":"DataSourceType.imdbKeywords","title":"Parents","type":"MovieContentType.title","year":"1989","yearRange":"1989","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A young boy living in 1950s suburbia suspects his parents are cannibalistic murderers.",
      "userRating":"6.1","userRatingCount":"7982","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDg4ODVkODAtMTczZi00OWY4LTlhZWEtMWIxYzQ2OTlmMDc2XkEyXkFqcGdeQXVyNjMwMjk0MTQ@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0098068"},
  "related":{"Directed by:":{"nm0000837":{"uniqueId":"nm0000837","title":"Bob Balaban","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000837"},"related":{}}},
    "Cast:":{"nm0001642":{"uniqueId":"nm0001642","title":"Randy Quaid","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001642"},"related":{}},
      "nm0002148":{"uniqueId":"nm0002148","title":"Mary Beth Hurt","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0002148"},"related":{}},
      "nm0006800":{"uniqueId":"nm0006800","title":"Sandy Dennis","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0006800"},"related":{}},
      "nm0535077":{"uniqueId":"nm0535077","title":"Bryan Madorsky","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0535077"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0098936","bestSource":"DataSourceType.imdbKeywords","title":"Twin Peaks","type":"MovieContentType.series","year":"1991","yearRange":"1990–1991","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"An idiosyncratic FBI agent investigates the murder of a young woman in the even more idiosyncratic town of Twin Peaks.",
      "userRating":"8.8","userRatingCount":"201352","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTExNzk2NjcxNTNeQTJeQWpwZ15BbWU4MDcxOTczOTIx._V1_UY209_CR11,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0098936"},
  "related":{"Cast:":{"nm0001492":{"uniqueId":"nm0001492","title":"Kyle MacLachlan","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001492"},"related":{}},
      "nm0648920":{"uniqueId":"nm0648920","title":"Michael Ontkean","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0648920"},"related":{}},
      "nm0000749":{"uniqueId":"nm0000749","title":"Mädchen Amick","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000749"},"related":{}},
      "nm0000796":{"uniqueId":"nm0000796","title":"Dana Ashbrook","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000796"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0099871","bestSource":"DataSourceType.imdbKeywords","title":"Jacob's Ladder","type":"MovieContentType.title","yearRange":"I 1990","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Mourning his dead child, a haunted Vietnam War veteran attempts to uncover his past while suffering from a severe case of dissociation. To do so, he must decipher reality and life from his own dreams, delusions, and perceptions of death.",
      "userRating":"7.4","userRatingCount":"111138","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZTg5MTMyNjktNTZhOC00MGFlLWFlMTMtZGU2MjE3OWQ3NjJkXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UY209_CR1,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0099871"},
  "related":{"Directed by:":{"nm0001490":{"uniqueId":"nm0001490","title":"Adrian Lyne","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001490"},"related":{}}},
    "Cast:":{"nm0000209":{"uniqueId":"nm0000209","title":"Tim Robbins","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000209"},"related":{}},
      "nm0001615":{"uniqueId":"nm0001615","title":"Elizabeth Peña","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001615"},"related":{}},
      "nm0000732":{"uniqueId":"nm0000732","title":"Danny Aiello","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000732"},"related":{}},
      "nm0002023":{"uniqueId":"nm0002023","title":"Matt Craven","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0002023"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0105665","bestSource":"DataSourceType.imdbKeywords","title":"Twin Peaks: Fire Walk with Me","type":"MovieContentType.title","year":"1992","yearRange":"1992","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Laura Palmer's harrowing final days are chronicled one year after the murder of Teresa Banks, a resident of Twin Peaks' neighboring town.",
      "userRating":"7.2","userRatingCount":"99239","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzc5ODcyNTYtMDAwNy00MDhjLWFmOWUtNGVhMDRlYjE1YzNjXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0105665"},
  "related":{"Directed by:":{"nm0000186":{"uniqueId":"nm0000186","title":"David Lynch","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000186"},"related":{}}},
    "Cast:":{"nm0498247":{"uniqueId":"nm0498247","title":"Sheryl Lee","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0498247"},"related":{}},
      "nm0936403":{"uniqueId":"nm0936403","title":"Ray Wise","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0936403"},"related":{}},
      "nm0000749":{"uniqueId":"nm0000749","title":"Mädchen Amick","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000749"},"related":{}},
      "nm0000796":{"uniqueId":"nm0000796","title":"Dana Ashbrook","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000796"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0109665","bestSource":"DataSourceType.imdbKeywords","title":"Dream Lover","type":"MovieContentType.title","year":"1993","yearRange":"1993","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A successful businessman tries to uncover what is wrong with his wife.",
      "userRating":"6.2","userRatingCount":"5334","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTA5ZjAyMDUtOWJmMS00NWY3LWJkMjQtMDQxZmEyOTFhM2YxXkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0109665"},
  "related":{"Directed by:":{"nm0443582":{"uniqueId":"nm0443582","title":"Nicholas Kazan","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0443582"},"related":{}}},
    "Cast:":{"nm0000652":{"uniqueId":"nm0000652","title":"James Spader","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000652"},"related":{}},
      "nm0000749":{"uniqueId":"nm0000749","title":"Mädchen Amick","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000749"},"related":{}},
      "nm0499791":{"uniqueId":"nm0499791","title":"Fredric Lehne","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0499791"},"related":{}},
      "nm0000787":{"uniqueId":"nm0000787","title":"Bess Armstrong","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000787"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0114814","bestSource":"DataSourceType.imdbKeywords","title":"The Usual Suspects","type":"MovieContentType.title","year":"1995","yearRange":"1995","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A sole survivor tells of the twisty events leading up to a horrific gun battle on a boat, which began when five criminals met at a seemingly random police lineup.",
      "userRating":"8.5","userRatingCount":"1094153","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTViNjMyNmUtNDFkNC00ZDRlLThmMDUtZDU2YWE4NGI2ZjVmXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0114814"},
  "related":{"Directed by:":{"nm0001741":{"uniqueId":"nm0001741","title":"Bryan Singer","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001741"},"related":{}}},
    "Cast:":{"nm0000228":{"uniqueId":"nm0000228","title":"Kevin Spacey","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000228"},"related":{}},
      "nm0000321":{"uniqueId":"nm0000321","title":"Gabriel Byrne","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000321"},"related":{}},
      "nm0001590":{"uniqueId":"nm0001590","title":"Chazz Palminteri","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001590"},"related":{}},
      "nm0000286":{"uniqueId":"nm0000286","title":"Stephen Baldwin","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000286"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0125664","bestSource":"DataSourceType.imdbKeywords","title":"Man on the Moon","type":"MovieContentType.title","year":"1999","yearRange":"1999","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"The life and career of legendary comedian Andy Kaufman.",
      "userRating":"7.4","userRatingCount":"133030","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDI1Mjc3MzAtZDk0OS00OTZlLTlhZjktNzA3ODgwZGY2NWIwXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0125664"},
  "related":{"Directed by:":{"nm0001232":{"uniqueId":"nm0001232","title":"Milos Forman","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001232"},"related":{}}},
    "Cast:":{"nm0000120":{"uniqueId":"nm0000120","title":"Jim Carrey","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000120"},"related":{}},
      "nm0000362":{"uniqueId":"nm0000362","title":"Danny DeVito","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000362"},"related":{}},
      "nm0065418":{"uniqueId":"nm0065418","title":"Gerry Becker","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0065418"},"related":{}},
      "nm0671761":{"uniqueId":"nm0671761","title":"Greyson Erik Pendry","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0671761"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0156887","bestSource":"DataSourceType.imdbKeywords","title":"Perfect Blue","type":"MovieContentType.title","year":"1997","yearRange":"1997","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A pop singer gives up her career to become an actress, but she slowly goes insane when she starts being stalked by an obsessed fan and what seems to be a ghost of her past.",
      "userRating":"8.0","userRatingCount":"80581","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmMzOWNhNTYtYmY0My00OGJiLWIzNDUtZWRhNGY0NWFjNzFmXkEyXkFqcGdeQXVyNjUxMDQ0MTg@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0156887"},
  "related":{"Directed by:":{"nm0464804":{"uniqueId":"nm0464804","title":"Satoshi Kon","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0464804"},"related":{}}},
    "Cast:":{"nm0412585":{"uniqueId":"nm0412585","title":"Junko Iwao","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0412585"},"related":{}},
      "nm0559551":{"uniqueId":"nm0559551","title":"Rica Matsumoto","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0559551"},"related":{}},
      "nm0875320":{"uniqueId":"nm0875320","title":"Shinpachi Tsuji","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0875320"},"related":{}},
      "nm0959991":{"uniqueId":"nm0959991","title":"Masaaki Ôkura","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0959991"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0161081","bestSource":"DataSourceType.imdbKeywords","title":"What Lies Beneath","type":"MovieContentType.title","year":"2000","yearRange":"2000","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"The wife of a university research scientist believes that her lakeside Vermont home is haunted by a ghost - or that she is losing her mind.",
      "userRating":"6.6","userRatingCount":"129201","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTY4NjNkMTMtNTEyOC00NDBiLWFkZjMtZDkwYzU3OTFjOTkzXkEyXkFqcGdeQXVyNTUyMzE4Mzg@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0161081"},
  "related":{"Directed by:":{"nm0000709":{"uniqueId":"nm0000709","title":"Robert Zemeckis","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000709"},"related":{}}},
    "Cast:":{"nm0000148":{"uniqueId":"nm0000148","title":"Harrison Ford","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000148"},"related":{}},
      "nm0000201":{"uniqueId":"nm0000201","title":"Michelle Pfeiffer","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000201"},"related":{}},
      "nm0870007":{"uniqueId":"nm0870007","title":"Katharine Towne","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0870007"},"related":{}},
      "nm0001584":{"uniqueId":"nm0001584","title":"Miranda Otto","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001584"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0166924","bestSource":"DataSourceType.imdbKeywords","title":"Mulholland Drive","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"After a car wreck on the winding Mulholland Drive renders a woman amnesiac, she and a perky Hollywood-hopeful search for clues and answers across Los Angeles in a twisting venture beyond dreams and reality.",
      "userRating":"7.9","userRatingCount":"362328","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTRiMzg4NDItNTc3Zi00NjBjLTgwOWYtOGZjMTFmNGU4ODY4XkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0166924"},
  "related":{"Directed by:":{"nm0000186":{"uniqueId":"nm0000186","title":"David Lynch","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000186"},"related":{}}},
    "Cast:":{"nm0915208":{"uniqueId":"nm0915208","title":"Naomi Watts","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0915208"},"related":{}},
      "nm0005009":{"uniqueId":"nm0005009","title":"Laura Harring","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0005009"},"related":{}},
      "nm0857620":{"uniqueId":"nm0857620","title":"Justin Theroux","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0857620"},"related":{}},
      "nm0060931":{"uniqueId":"nm0060931","title":"Jeanne Bates","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0060931"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0246578","bestSource":"DataSourceType.imdbKeywords","title":"Donnie Darko","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"After narrowly escaping a bizarre accident, a troubled teenager is plagued by visions of a man in a large rabbit suit who manipulates him to commit a series of crimes.",
      "userRating":"8.0","userRatingCount":"810935","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjZlZDlkYTktMmU1My00ZDBiLWFlNjEtYTBhNjVhOTM4ZjJjXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0246578"},
  "related":{"Directed by:":{"nm0446819":{"uniqueId":"nm0446819","title":"Richard Kelly","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0446819"},"related":{}}},
    "Cast:":{"nm0350453":{"uniqueId":"nm0350453","title":"Jake Gyllenhaal","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0350453"},"related":{}},
      "nm0540441":{"uniqueId":"nm0540441","title":"Jena Malone","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0540441"},"related":{}},
      "nm0001521":{"uniqueId":"nm0001521","title":"Mary McDonnell","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001521"},"related":{}},
      "nm0651660":{"uniqueId":"nm0651660","title":"Holmes Osborne","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0651660"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0252501","bestSource":"DataSourceType.imdbKeywords","title":"Hearts in Atlantis","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Widowed Liz Garfield and her son Bobby change when mysterious stranger Ted Brautigan enters their lives.",
      "userRating":"6.9","userRatingCount":"39625","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjFjNWNmYWUtZTFlMi00ZDcxLWJkY2MtNjMwYmM0OTc5OTM1XkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0252501"},
  "related":{"Directed by:":{"nm0382956":{"uniqueId":"nm0382956","title":"Scott Hicks","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0382956"},"related":{}}},
    "Cast:":{"nm0000164":{"uniqueId":"nm0000164","title":"Anthony Hopkins","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000164"},"related":{}},
      "nm0947338":{"uniqueId":"nm0947338","title":"Anton Yelchin","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0947338"},"related":{}},
      "nm0204706":{"uniqueId":"nm0204706","title":"Hope Davis","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0204706"},"related":{}},
      "nm0095561":{"uniqueId":"nm0095561","title":"Mika Boorem","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0095561"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0272152","bestSource":"DataSourceType.imdbKeywords","title":"K-PAX","type":"MovieContentType.title","year":"2001","yearRange":"2001","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"PROT is a patient at a mental hospital who claims to be from a faraway planet named K-PAX. His psychiatrist tries to help him, only to begin to doubt his own explanations.",
      "userRating":"7.4","userRatingCount":"186609","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjE2Mjc4Y2EtN2QyNy00YTI5LWFlMjUtYjkwOTdhYTliMTliXkEyXkFqcGdeQXVyMjA0MzYwMDY@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0272152"},
  "related":{"Directed by:":{"nm0812200":{"uniqueId":"nm0812200","title":"Iain Softley","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0812200"},"related":{}}},
    "Cast:":{"nm0000228":{"uniqueId":"nm0000228","title":"Kevin Spacey","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000228"},"related":{}},
      "nm0000313":{"uniqueId":"nm0000313","title":"Jeff Bridges","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000313"},"related":{}},
      "nm0005203":{"uniqueId":"nm0005203","title":"Mary McCormack","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0005203"},"related":{}},
      "nm0005569":{"uniqueId":"nm0005569","title":"Alfre Woodard","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0005569"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0324133","bestSource":"DataSourceType.imdbKeywords","title":"Swimming Pool","type":"MovieContentType.title","year":"2003","yearRange":"2003","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A British mystery author visits her publisher's home in the South of France, where her interaction with his unusual daughter sets off some touchy dynamics.",
      "userRating":"6.7","userRatingCount":"46837","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZGNjMmUzNjQtMjJjYy00ZWYyLTlhNDAtNDk2Y2QxZWQ0Y2NiXkEyXkFqcGdeQXVyNjc5NjEzNA@@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0324133"},
  "related":{"Directed by:":{"nm0654830":{"uniqueId":"nm0654830","title":"François Ozon","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0654830"},"related":{}}},
    "Cast:":{"nm0001648":{"uniqueId":"nm0001648","title":"Charlotte Rampling","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001648"},"related":{}},
      "nm0001097":{"uniqueId":"nm0001097","title":"Charles Dance","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001097"},"related":{}},
      "nm0756203":{"uniqueId":"nm0756203","title":"Ludivine Sagnier","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0756203"},"related":{}},
      "nm0483788":{"uniqueId":"nm0483788","title":"Jean-Marie Lamour","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0483788"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0337876","bestSource":"DataSourceType.imdbKeywords","title":"Birth","type":"MovieContentType.title","year":"2004","yearRange":"2004","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A young boy attempts to convince a woman that he is her dead husband reborn.",
      "userRating":"6.2","userRatingCount":"37572","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzUzNzI4MzU4NV5BMl5BanBnXkFtZTcwMjcxMzcyMQ@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0337876"},
  "related":{"Directed by:":{"nm0322242":{"uniqueId":"nm0322242","title":"Jonathan Glazer","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0322242"},"related":{}}},
    "Cast:":{"nm0000173":{"uniqueId":"nm0000173","title":"Nicole Kidman","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000173"},"related":{}},
      "nm1080974":{"uniqueId":"nm1080974","title":"Cameron Bright","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1080974"},"related":{}},
      "nm0000002":{"uniqueId":"nm0000002","title":"Lauren Bacall","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000002"},"related":{}},
      "nm0396812":{"uniqueId":"nm0396812","title":"Danny Huston","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0396812"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0348593","bestSource":"DataSourceType.imdbKeywords","title":"The Door in the Floor","type":"MovieContentType.title","year":"2004","yearRange":"2004","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A writer's young assistant becomes both pawn and catalyst in his boss's disintegrating household.",
      "userRating":"6.6","userRatingCount":"15872","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTYyNTIxODA1M15BMl5BanBnXkFtZTYwMzY1NjY3._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0348593"},
  "related":{"Directed by:":{"nm0931095":{"uniqueId":"nm0931095","title":"Tod Williams","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0931095"},"related":{}}},
    "Cast:":{"nm0000313":{"uniqueId":"nm0000313","title":"Jeff Bridges","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000313"},"related":{}},
      "nm0000107":{"uniqueId":"nm0000107","title":"Kim Basinger","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000107"},"related":{}},
      "nm0287898":{"uniqueId":"nm0287898","title":"Jon Foster","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0287898"},"related":{}},
      "nm1102577":{"uniqueId":"nm1102577","title":"Elle Fanning","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1102577"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0365686","bestSource":"DataSourceType.imdbKeywords","title":"Revolver","type":"MovieContentType.title","year":"2005","yearRange":"2005","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Gambler Jake Green enters into a game with potentially deadly consequences.",
      "userRating":"6.3","userRatingCount":"98050","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTQ1OTA3MjM4MF5BMl5BanBnXkFtZTYwMTMxODc4._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0365686"},
  "related":{"Directed by:":{"nm0005363":{"uniqueId":"nm0005363","title":"Guy Ritchie","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0005363"},"related":{}}},
    "Cast:":{"nm0005458":{"uniqueId":"nm0005458","title":"Jason Statham","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0005458"},"related":{}},
      "nm0000501":{"uniqueId":"nm0000501","title":"Ray Liotta","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000501"},"related":{}},
      "nm0071275":{"uniqueId":"nm0071275","title":"André 3000","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0071275"},"related":{}},
      "nm0665114":{"uniqueId":"nm0665114","title":"Vincent Pastore","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0665114"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0366627","bestSource":"DataSourceType.imdbKeywords","title":"The Jacket","type":"MovieContentType.title","year":"2005","yearRange":"2005","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A Gulf war veteran is wrongly sent to a mental institution for insane criminals, where he becomes the object of a doctor's experiments, and his life is completely affected by them.",
      "userRating":"7.1","userRatingCount":"115332","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjY1ZTNiMGYtOGJjNy00MmE4LWFjYzQtOTNjYzYzZTcyNzQ5XkEyXkFqcGdeQXVyMjUzOTY1NTc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0366627"},
  "related":{"Directed by:":{"nm0562266":{"uniqueId":"nm0562266","title":"John Maybury","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0562266"},"related":{}}},
    "Cast:":{"nm0004778":{"uniqueId":"nm0004778","title":"Adrien Brody","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0004778"},"related":{}},
      "nm0461136":{"uniqueId":"nm0461136","title":"Keira Knightley","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0461136"},"related":{}},
      "nm0185819":{"uniqueId":"nm0185819","title":"Daniel Craig","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0185819"},"related":{}},
      "nm0001434":{"uniqueId":"nm0001434","title":"Kris Kristofferson","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001434"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0368794","bestSource":"DataSourceType.imdbKeywords","title":"I'm Not There","type":"MovieContentType.title","year":"2007","yearRange":"2007","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Ruminations on the life of Bob Dylan, where six characters embody a different aspect of the musician's life and work.",
      "userRating":"6.8","userRatingCount":"59622","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY4MzM2MjcwNV5BMl5BanBnXkFtZTcwODg3MDU1MQ@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0368794"},
  "related":{"Directed by:":{"nm0001331":{"uniqueId":"nm0001331","title":"Todd Haynes","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001331"},"related":{}}},
    "Cast:":{"nm0000288":{"uniqueId":"nm0000288","title":"Christian Bale","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000288"},"related":{}},
      "nm0000949":{"uniqueId":"nm0000949","title":"Cate Blanchett","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000949"},"related":{}},
      "nm0005132":{"uniqueId":"nm0005132","title":"Heath Ledger","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0005132"},"related":{}},
      "nm0924210":{"uniqueId":"nm0924210","title":"Ben Whishaw","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0924210"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0454848","bestSource":"DataSourceType.imdbKeywords","title":"Inside Man","type":"MovieContentType.title","year":"2006","yearRange":"2006","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A police detective, a bank robber, and a high-power broker enter high-stakes negotiations after the criminal's brilliant heist spirals into a hostage situation.",
      "userRating":"7.6","userRatingCount":"378867","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjc4MjA2ZDgtOGY3YS00NDYzLTlmNTEtYWMxMzcwZjgzYWNjXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0454848"},
  "related":{"Directed by:":{"nm0000490":{"uniqueId":"nm0000490","title":"Spike Lee","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000490"},"related":{}}},
    "Cast:":{"nm0000243":{"uniqueId":"nm0000243","title":"Denzel Washington","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000243"},"related":{}},
      "nm0654110":{"uniqueId":"nm0654110","title":"Clive Owen","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0654110"},"related":{}},
      "nm0000149":{"uniqueId":"nm0000149","title":"Jodie Foster","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000149"},"related":{}},
      "nm0001626":{"uniqueId":"nm0001626","title":"Christopher Plummer","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001626"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0481369","bestSource":"DataSourceType.imdbKeywords","title":"The Number 23","type":"MovieContentType.title","year":"2007","yearRange":"2007","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Walter Sparrow becomes obsessed with a novel that he believes was written about him, as more and more similarities between himself and his literary alter ego seem to arise.",
      "userRating":"6.4","userRatingCount":"205659","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDg0YzAxZGYtNTdkYy00ZmUyLWIwNDQtOTA0NGNlZGZiMjkwXkEyXkFqcGdeQXVyMjQwMjk0NjI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0481369"},
  "related":{"Directed by:":{"nm0001708":{"uniqueId":"nm0001708","title":"Joel Schumacher","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001708"},"related":{}}},
    "Cast:":{"nm0000120":{"uniqueId":"nm0000120","title":"Jim Carrey","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000120"},"related":{}},
      "nm0000515":{"uniqueId":"nm0000515","title":"Virginia Madsen","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000515"},"related":{}},
      "nm0503567":{"uniqueId":"nm0503567","title":"Logan Lerman","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0503567"},"related":{}},
      "nm0396812":{"uniqueId":"nm0396812","title":"Danny Huston","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0396812"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0945513","bestSource":"DataSourceType.imdbKeywords","title":"Source Code","type":"MovieContentType.title","year":"2011","yearRange":"2011","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A soldier wakes up in someone else's body and discovers he's part of an experimental government program to find the bomber of a commuter train within 8 minutes.",
      "userRating":"7.5","userRatingCount":"526864","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY0MTc3MzMzNV5BMl5BanBnXkFtZTcwNDE4MjE0NA@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0945513"},
  "related":{"Directed by:":{"nm1512910":{"uniqueId":"nm1512910","title":"Duncan Jones","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1512910"},"related":{}}},
    "Cast:":{"nm0350453":{"uniqueId":"nm0350453","title":"Jake Gyllenhaal","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0350453"},"related":{}},
      "nm1157358":{"uniqueId":"nm1157358","title":"Michelle Monaghan","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1157358"},"related":{}},
      "nm0267812":{"uniqueId":"nm0267812","title":"Vera Farmiga","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0267812"},"related":{}},
      "nm0942482":{"uniqueId":"nm0942482","title":"Jeffrey Wright","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0942482"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0970179","bestSource":"DataSourceType.imdbKeywords","title":"Hugo","type":"MovieContentType.title","year":"2011","yearRange":"2011","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"In 1931 Paris, an orphan living in the walls of a train station gets wrapped up in a mystery involving his late father and an automaton.",
      "userRating":"7.5","userRatingCount":"326706","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjAzNzk5MzgyNF5BMl5BanBnXkFtZTcwOTE4NDU5Ng@@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0970179"},
  "related":{"Directed by:":{"nm0000217":{"uniqueId":"nm0000217","title":"Martin Scorsese","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000217"},"related":{}}},
    "Cast:":{"nm2633535":{"uniqueId":"nm2633535","title":"Asa Butterfield","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm2633535"},"related":{}},
      "nm1631269":{"uniqueId":"nm1631269","title":"Chloë Grace Moretz","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1631269"},"related":{}},
      "nm0000489":{"uniqueId":"nm0000489","title":"Christopher Lee","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000489"},"related":{}},
      "nm0001426":{"uniqueId":"nm0001426","title":"Ben Kingsley","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001426"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt10731256","bestSource":"DataSourceType.imdbKeywords","title":"Don't Worry Darling","type":"MovieContentType.title","yearRange":"I 2022","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A 1950s housewife living with her husband in a utopian experimental community begins to worry that his glamorous company could be hiding disturbing secrets.",
      "userRating":"6.2","userRatingCount":"104456","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzFkMWUzM2ItZWFjMi00NDY0LTk2MDMtZDhkMDE2MjRlYmZlXkEyXkFqcGdeQXVyNTAzNzgwNTg@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt10731256"},
  "related":{"Directed by:":{"nm1312575":{"uniqueId":"nm1312575","title":"Olivia Wilde","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1312575"},"related":{}}},
    "Cast:":{"nm6073955":{"uniqueId":"nm6073955","title":"Florence Pugh","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm6073955"},"related":{}},
      "nm4089170":{"uniqueId":"nm4089170","title":"Harry Styles","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm4089170"},"related":{}},
      "nm1517976":{"uniqueId":"nm1517976","title":"Chris Pine","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1517976"},"related":{}},
      "nm1312575":{"uniqueId":"nm1312575","title":"Olivia Wilde","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1312575"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt1189076","bestSource":"DataSourceType.imdbKeywords","title":"Ricky","type":"MovieContentType.title","yearRange":"I 2009","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"When Katie, an ordinary woman, meets Paco, an ordinary man, something magical happens: a love story. From this union an extraordinary child is born: Ricky.",
      "userRating":"5.8","userRatingCount":"3108","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTgxNWVkYmYtMzUxNS00YTM1LTg3YjktYzQ4ODQxMWVhYmJiXkEyXkFqcGdeQXVyMTAyNTQ0MTk@._V1_UX140_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt1189076"},
  "related":{"Directed by:":{"nm0654830":{"uniqueId":"nm0654830","title":"François Ozon","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0654830"},"related":{}}},
    "Cast:":{"nm0484005":{"uniqueId":"nm0484005","title":"Alexandra Lamy","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0484005"},"related":{}},
      "nm0530365":{"uniqueId":"nm0530365","title":"Sergi López","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0530365"},"related":{}},
      "nm3274621":{"uniqueId":"nm3274621","title":"Mélusine Mayance","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm3274621"},"related":{}},
      "nm3274218":{"uniqueId":"nm3274218","title":"Arthur Peyret","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm3274218"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt13444912","bestSource":"DataSourceType.imdbKeywords","title":"The Midnight Club","type":"MovieContentType.title","year":"2022","yearRange":"2022","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"The Midnight Club follows an octet of terminally-ill teenage patients at Brightcliffe Hospice as they gather at midnight to share scary stories.",
      "userRating":"6.5","userRatingCount":"26200","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTc5OGU1YjItZmVhZi00NmE3LTk0ZWEtZDE1OGJjMTMzNDY2XkEyXkFqcGdeQXVyMTEyMjM2NDc2._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt13444912"},
  "related":{"Cast:":{"nm7223890":{"uniqueId":"nm7223890","title":"Iman Benson","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm7223890"},"related":{}},
      "nm9723807":{"uniqueId":"nm9723807","title":"Igby Rigney","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm9723807"},"related":{}},
      "nm11517225":{"uniqueId":"nm11517225","title":"Sadoc Vazkez","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm11517225"},"related":{}},
      "nm11332821":{"uniqueId":"nm11332821","title":"Ruth Codd","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm11332821"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt1924396","bestSource":"DataSourceType.imdbKeywords","title":"The Best Offer","type":"MovieContentType.title","year":"2013","yearRange":"2013","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A lonely art expert working for a mysterious and reclusive heiress finds not only her art worth examining.",
      "userRating":"7.8","userRatingCount":"121823","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTQ4MzQ3NjA0N15BMl5BanBnXkFtZTgwODQyNjQ4MDE@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt1924396"},
  "related":{"Directed by:":{"nm0868153":{"uniqueId":"nm0868153","title":"Giuseppe Tornatore","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0868153"},"related":{}}},
    "Cast:":{"nm0001691":{"uniqueId":"nm0001691","title":"Geoffrey Rush","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001691"},"related":{}},
      "nm0836343":{"uniqueId":"nm0836343","title":"Jim Sturgess","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0836343"},"related":{}},
      "nm1679778":{"uniqueId":"nm1679778","title":"Sylvia Hoeks","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1679778"},"related":{}},
      "nm0000661":{"uniqueId":"nm0000661","title":"Donald Sutherland","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000661"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt2084970","bestSource":"DataSourceType.imdbKeywords","title":"The Imitation Game","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"During World War II, the English mathematical genius Alan Turing tries to crack the German Enigma code with help from fellow mathematicians while attempting to come to terms with his troubled private life.",
      "userRating":"8.0","userRatingCount":"780104","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTgwMzFiMWYtZDhlNS00ODNkLWJiODAtZDVhNzgyNzJhYjQ4L2ltYWdlXkEyXkFqcGdeQXVyNzEzOTYxNTQ@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt2084970"},
  "related":{"Directed by:":{"nm0878763":{"uniqueId":"nm0878763","title":"Morten Tyldum","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0878763"},"related":{}}},
    "Cast:":{"nm1212722":{"uniqueId":"nm1212722","title":"Benedict Cumberbatch","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1212722"},"related":{}},
      "nm0461136":{"uniqueId":"nm0461136","title":"Keira Knightley","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0461136"},"related":{}},
      "nm0328828":{"uniqueId":"nm0328828","title":"Matthew Goode","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0328828"},"related":{}},
      "nm1395602":{"uniqueId":"nm1395602","title":"Allen Leech","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1395602"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt2365580","bestSource":"DataSourceType.imdbKeywords","title":"Where'd You Go, Bernadette","type":"MovieContentType.title","year":"2019","yearRange":"2019","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A loving mom becomes compelled to reconnect with her creative passions after years of sacrificing herself for her family. Her leap of faith takes her on an epic adventure that jump-starts her life and leads to her triumphant rediscovery.",
      "userRating":"6.5","userRatingCount":"22923","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDZiY2MyN2ItZjYyMi00YWNiLTk3NTQtNzk3YWFlOTg1MzViXkEyXkFqcGdeQXVyODk2NDQ3MTA@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt2365580"},
  "related":{"Directed by:":{"nm0000500":{"uniqueId":"nm0000500","title":"Richard Linklater","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000500"},"related":{}}},
    "Cast:":{"nm0000949":{"uniqueId":"nm0000949","title":"Cate Blanchett","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000949"},"related":{}},
      "nm0001082":{"uniqueId":"nm0001082","title":"Billy Crudup","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001082"},"related":{}},
      "nm8625874":{"uniqueId":"nm8625874","title":"Emma Nelson","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm8625874"},"related":{}},
      "nm1325419":{"uniqueId":"nm1325419","title":"Kristen Wiig","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1325419"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt2452254","bestSource":"DataSourceType.imdbKeywords","title":"Clouds of Sils Maria","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A film star comes face-to-face with an uncomfortable reflection of herself while starring in a revival of the play that launched her career.",
      "userRating":"6.7","userRatingCount":"30237","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjAwMTg3MDE0NF5BMl5BanBnXkFtZTgwNjQ1ODQyNTE@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt2452254"},
  "related":{"Directed by:":{"nm0000801":{"uniqueId":"nm0000801","title":"Olivier Assayas","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000801"},"related":{}}},
    "Cast:":{"nm0000300":{"uniqueId":"nm0000300","title":"Juliette Binoche","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000300"},"related":{}},
      "nm0829576":{"uniqueId":"nm0829576","title":"Kristen Stewart","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0829576"},"related":{}},
      "nm1631269":{"uniqueId":"nm1631269","title":"Chloë Grace Moretz","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1631269"},"related":{}},
      "nm1955257":{"uniqueId":"nm1955257","title":"Lars Eidinger","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1955257"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt3262342","bestSource":"DataSourceType.imdbKeywords","title":"Loving Vincent","type":"MovieContentType.title","year":"2017","yearRange":"2017","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"In a story depicted in oil painted animation, a young man comes to the last hometown of painter Vincent van Gogh to deliver the troubled artist's final letter and ends up investigating his final days there.",
      "userRating":"7.8","userRatingCount":"59465","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTU3NjE2NjgwN15BMl5BanBnXkFtZTgwNDYzMzEwMzI@._V1_UY209_CR1,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3262342"},
  "related":{"Directed by:":{"nm3699790":{"uniqueId":"nm3699790","title":"Dorota Kobiela","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm3699790"},"related":{}},
      "nm1364790":{"uniqueId":"nm1364790","title":"Hugh Welchman","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1364790"},"related":{}}},
    "Cast:":{"nm3150488":{"uniqueId":"nm3150488","title":"Douglas Booth","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm3150488"},"related":{}},
      "nm0283492":{"uniqueId":"nm0283492","title":"Jerome Flynn","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0283492"},"related":{}},
      "nm7956813":{"uniqueId":"nm7956813","title":"Robert Gulaczyk","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm7956813"},"related":{}},
      "nm0567031":{"uniqueId":"nm0567031","title":"Helen McCrory","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0567031"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt3289956","bestSource":"DataSourceType.imdbKeywords","title":"The Autopsy of Jane Doe","type":"MovieContentType.title","year":"2016","yearRange":"2016","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"A father and son, both coroners, are pulled into a complex mystery while attempting to identify the body of a young woman, who was apparently harboring dark secrets.",
      "userRating":"6.8","userRatingCount":"123112","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjA2MTEzMzkzM15BMl5BanBnXkFtZTgwMjM2MTM5MDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3289956"},
  "related":{"Directed by:":{"nm0004217":{"uniqueId":"nm0004217","title":"André Øvredal","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0004217"},"related":{}}},
    "Cast:":{"nm0004051":{"uniqueId":"nm0004051","title":"Brian Cox","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0004051"},"related":{}},
      "nm0386472":{"uniqueId":"nm0386472","title":"Emile Hirsch","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0386472"},"related":{}},
      "nm1166041":{"uniqueId":"nm1166041","title":"Ophelia Lovibond","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1166041"},"related":{}},
      "nm0568385":{"uniqueId":"nm0568385","title":"Michael McElhatton","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0568385"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt3387648","bestSource":"DataSourceType.imdbKeywords","title":"The Taking","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"An elderly woman battling Alzheimer's disease agrees to let a film crew document her condition, but what they discover is something far more sinister going on.",
      "userRating":"6.0","userRatingCount":"34282","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BZWQ3YmU4ZjYtZGE2Ni00NjhiLTk2NTMtYmVmYmNkNWViYzUxXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3387648"},
  "related":{"Directed by:":{"nm0733263":{"uniqueId":"nm0733263","title":"Adam Robitel","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0733263"},"related":{}}},
    "Cast:":{"nm0489010":{"uniqueId":"nm0489010","title":"Jill Larson","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0489010"},"related":{}},
      "nm0708867":{"uniqueId":"nm0708867","title":"Anne Ramsay","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0708867"},"related":{}},
      "nm0029391":{"uniqueId":"nm0029391","title":"Michelle Ang","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0029391"},"related":{}},
      "nm1654820":{"uniqueId":"nm1654820","title":"Brett Gentile","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1654820"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt3613454","bestSource":"DataSourceType.imdbKeywords","title":"Zankyô no teroru","type":"MovieContentType.title","year":"2014","yearRange":"2014","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Tokyo has been decimated by a terrorist attack, the only clue to the culprit's identity is a bizarre internet video. Two mysterious children form Sphinx, a clandestine entity determined to pull the trigger on this world.",
      "userRating":"7.8","userRatingCount":"11776","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjdhYzY0M2QtODgwZi00NDg2LTliNDQtMzA4ZTMzMzQ0MGEyXkEyXkFqcGdeQXVyMTA3OTEyODI1._V1_UY209_CR4,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt3613454"},
  "related":{"Cast:":{"nm5481013":{"uniqueId":"nm5481013","title":"Kaito Ishikawa","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm5481013"},"related":{}},
      "nm6160361":{"uniqueId":"nm6160361","title":"Sôma Saitô","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm6160361"},"related":{}},
      "nm6662487":{"uniqueId":"nm6662487","title":"Atsumi Tanezaki","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm6662487"},"related":{}},
      "nm1516229":{"uniqueId":"nm1516229","title":"Shunsuke Sakuya","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1516229"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt4602066","bestSource":"DataSourceType.imdbKeywords","title":"The Catcher Was a Spy","type":"MovieContentType.title","year":"2018","yearRange":"2018","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Former Major League Baseball player Moe Berg goes undercover in World War II Europe for the Office of Strategic Services.",
      "userRating":"6.2","userRatingCount":"10148","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BODhlNDc0ZTQtN2FiOS00OGRiLWE2YmYtZmI2ZmU1NzM5MmJlXkEyXkFqcGdeQXVyODY3Nzc0OTk@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt4602066"},
  "related":{"Directed by:":{"nm0506802":{"uniqueId":"nm0506802","title":"Ben Lewin","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0506802"},"related":{}}},
    "Cast:":{"nm0748620":{"uniqueId":"nm0748620","title":"Paul Rudd","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0748620"},"related":{}},
      "nm0269419":{"uniqueId":"nm0269419","title":"Pierfrancesco Favino","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0269419"},"related":{}},
      "nm0929489":{"uniqueId":"nm0929489","title":"Tom Wilkinson","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0929489"},"related":{}},
      "nm0001567":{"uniqueId":"nm0001567","title":"Connie Nielsen","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0001567"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt6160448","bestSource":"DataSourceType.imdbKeywords","title":"White Noise","type":"MovieContentType.title","yearRange":"I 2022","languages":"[]","genres":"[]",
      "keywords":"[\"enigma\"]",
      "description":"Dramatizes a contemporary American family's attempts to deal with the mundane conflicts of everyday life while grappling with the universal mysteries of love, death, and the possibility of happiness in an uncertain world.",
      "userRating":"5.7","userRatingCount":"34528","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDdmYjc3Y2EtM2FjYS00NGI2LTliZjgtYmQxMzJiMmUxNmI4XkEyXkFqcGdeQXVyNjY1MTg4Mzc@._V1_UY209_CR0,0,140,209_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt6160448"},
  "related":{"Directed by:":{"nm0000876":{"uniqueId":"nm0000876","title":"Noah Baumbach","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000876"},"related":{}}},
    "Cast:":{"nm3485845":{"uniqueId":"nm3485845","title":"Adam Driver","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm3485845"},"related":{}},
      "nm1950086":{"uniqueId":"nm1950086","title":"Greta Gerwig","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm1950086"},"related":{}},
      "nm0000332":{"uniqueId":"nm0000332","title":"Don Cheadle","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm0000332"},"related":{}},
      "nm14313990":{"uniqueId":"nm14313990","title":"Madison Gaughan","type":"MovieContentType.person","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.none":"nm14313990"},"related":{}}}}}
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
      // printTestData(actualOutput, excludeCopyrightedData: false);

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
