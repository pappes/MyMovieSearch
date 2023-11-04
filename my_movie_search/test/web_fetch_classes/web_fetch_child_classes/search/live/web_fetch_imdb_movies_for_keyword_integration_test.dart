import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_movies_for_keyword.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://www.imdb.com/search/keyword/?page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main","bestSource":"DataSourceType.imdbKeywords","title":"Next »","sources":{"DataSourceType.imdbKeywords":"https://www.imdb.com/search/keyword/?page=2&sort=moviemeter,asc&keywords=enigma&explore=keywords&mode=detail&ref_=kw_nxt#main"}}
''',
  r'''
{"uniqueId":"tt0032976","bestSource":"DataSourceType.imdbKeywords","title":"Rebecca","type":"MovieContentType.title","year":"1940","yearRange":"1940","censorRating":"CensorRatingType.kids","sources":{"DataSourceType.imdbKeywords":"tt0032976"},
  "related":{"Cast:":{"nm0000021":{"uniqueId":"nm0000021","title":"Joan Fontaine","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000021"}},
      "nm0000059":{"uniqueId":"nm0000059","title":"Laurence Olivier","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000059"}},
      "nm0000752":{"uniqueId":"nm0000752","title":"Judith Anderson","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000752"}},
      "nm0001695":{"uniqueId":"nm0001695","title":"George Sanders","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001695"}}},
    "Directed by:":{"nm0000033":{"uniqueId":"nm0000033","title":"Alfred Hitchcock","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000033"}}}}}
''',
  r'''
{"uniqueId":"tt0033467","bestSource":"DataSourceType.imdbKeywords","title":"Citizen Kane","type":"MovieContentType.title","year":"1941","yearRange":"1941","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt0033467"},
  "related":{"Cast:":{"nm0000080":{"uniqueId":"nm0000080","title":"Orson Welles","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000080"}},
      "nm0001072":{"uniqueId":"nm0001072","title":"Joseph Cotten","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001072"}},
      "nm0001547":{"uniqueId":"nm0001547","title":"Agnes Moorehead","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001547"}},
      "nm0173827":{"uniqueId":"nm0173827","title":"Dorothy Comingore","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0173827"}}},
    "Directed by:":{"nm0000080":{"uniqueId":"nm0000080","title":"Orson Welles","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000080"}}}}}
''',
  r'''
{"uniqueId":"tt0037008","bestSource":"DataSourceType.imdbKeywords","title":"Laura","type":"MovieContentType.title","year":"1944","yearRange":"1944","censorRating":"CensorRatingType.kids","sources":{"DataSourceType.imdbKeywords":"tt0037008"},
  "related":{"Cast:":{"nm0000074":{"uniqueId":"nm0000074","title":"Gene Tierney","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000074"}},
      "nm0000763":{"uniqueId":"nm0000763","title":"Dana Andrews","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000763"}},
      "nm0001637":{"uniqueId":"nm0001637","title":"Vincent Price","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001637"}},
      "nm0916067":{"uniqueId":"nm0916067","title":"Clifton Webb","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0916067"}}},
    "Directed by:":{"nm0695937":{"uniqueId":"nm0695937","title":"Otto Preminger","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0695937"}}}}}
''',
  r'''
{"uniqueId":"tt0057427","bestSource":"DataSourceType.imdbKeywords","title":"The Trial","type":"MovieContentType.title","year":"1962","yearRange":"1962","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt0057427"},
  "related":{"Cast:":{"nm0000578":{"uniqueId":"nm0000578","title":"Anthony Perkins","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000578"}},
      "nm0289450":{"uniqueId":"nm0289450","title":"Arnoldo Foà","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0289450"}},
      "nm0353916":{"uniqueId":"nm0353916","title":"Jess Hahn","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0353916"}},
      "nm0443985":{"uniqueId":"nm0443985","title":"Billy Kearns","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0443985"}}},
    "Directed by:":{"nm0000080":{"uniqueId":"nm0000080","title":"Orson Welles","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000080"}}}}}
''',
  r'''
{"uniqueId":"tt0058329","bestSource":"DataSourceType.imdbKeywords","title":"Marnie","type":"MovieContentType.title","year":"1964","yearRange":"1964","censorRating":"CensorRatingType.adult","sources":{"DataSourceType.imdbKeywords":"tt0058329"},
  "related":{"Cast:":{"nm0000125":{"uniqueId":"nm0000125","title":"Sean Connery","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000125"}},
      "nm0001335":{"uniqueId":"nm0001335","title":"Tippi Hedren","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001335"}},
      "nm0300010":{"uniqueId":"nm0300010","title":"Martin Gabel","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0300010"}},
      "nm0490103":{"uniqueId":"nm0490103","title":"Louise Latham","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0490103"}}},
    "Directed by:":{"nm0000033":{"uniqueId":"nm0000033","title":"Alfred Hitchcock","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000033"}}}}}
''',
  r'''
{"uniqueId":"tt0066769","bestSource":"DataSourceType.imdbKeywords","title":"The Andromeda Strain","type":"MovieContentType.title","year":"1971","yearRange":"1971","censorRating":"CensorRatingType.kids","sources":{"DataSourceType.imdbKeywords":"tt0066769"},
  "related":{"Cast:":{"nm0003679":{"uniqueId":"nm0003679","title":"Kate Reid","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0003679"}},
      "nm0384050":{"uniqueId":"nm0384050","title":"Arthur Hill","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0384050"}},
      "nm0647921":{"uniqueId":"nm0647921","title":"James Olson","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0647921"}},
      "nm0915536":{"uniqueId":"nm0915536","title":"David Wayne","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0915536"}}},
    "Directed by:":{"nm0936404":{"uniqueId":"nm0936404","title":"Robert Wise","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0936404"}}}}}
''',
  r'''
{"uniqueId":"tt0069467","bestSource":"DataSourceType.imdbKeywords","title":"Viskningar och rop","type":"MovieContentType.title","year":"1972","yearRange":"1972","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0069467"},
  "related":{"Cast:":{"nm0027683":{"uniqueId":"nm0027683","title":"Harriet Andersson","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0027683"}},
      "nm0843306":{"uniqueId":"nm0843306","title":"Kari Sylwan","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0843306"}},
      "nm0862026":{"uniqueId":"nm0862026","title":"Ingrid Thulin","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0862026"}},
      "nm0880521":{"uniqueId":"nm0880521","title":"Liv Ullmann","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0880521"}}},
    "Directed by:":{"nm0000005":{"uniqueId":"nm0000005","title":"Ingmar Bergman","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000005"}}}}}
''',
  r'''
{"uniqueId":"tt0070917","bestSource":"DataSourceType.imdbKeywords","title":"The Wicker Man","type":"MovieContentType.title","year":"1973","yearRange":"1973","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdbKeywords":"tt0070917"},
  "related":{"Cast:":{"nm0000489":{"uniqueId":"nm0000489","title":"Christopher Lee","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000489"}},
      "nm0001180":{"uniqueId":"nm0001180","title":"Britt Ekland","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001180"}},
      "nm0162283":{"uniqueId":"nm0162283","title":"Diane Cilento","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0162283"}},
      "nm0940919":{"uniqueId":"nm0940919","title":"Edward Woodward","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0940919"}}},
    "Directed by:":{"nm0362736":{"uniqueId":"nm0362736","title":"Robin Hardy","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0362736"}}}}}
''',
  r'''
{"uniqueId":"tt0071360","bestSource":"DataSourceType.imdbKeywords","title":"The Conversation","type":"MovieContentType.title","year":"1974","yearRange":"1974","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0071360"},
  "related":{"Cast:":{"nm0000432":{"uniqueId":"nm0000432","title":"Gene Hackman","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000432"}},
      "nm0001030":{"uniqueId":"nm0001030","title":"John Cazale","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001030"}},
      "nm0002078":{"uniqueId":"nm0002078","title":"Frederic Forrest","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0002078"}},
      "nm0307255":{"uniqueId":"nm0307255","title":"Allen Garfield","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0307255"}}},
    "Directed by:":{"nm0000338":{"uniqueId":"nm0000338","title":"Francis Ford Coppola","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000338"}}}}}
''',
  r'''
{"uniqueId":"tt0073580","bestSource":"DataSourceType.imdbKeywords","title":"Professione: reporter","type":"MovieContentType.title","year":"1975","yearRange":"1975","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdbKeywords":"tt0073580"},
  "related":{"Cast:":{"nm0000197":{"uniqueId":"nm0000197","title":"Jack Nicholson","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000197"}},
      "nm0376915":{"uniqueId":"nm0376915","title":"Ian Hendry","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0376915"}},
      "nm0750192":{"uniqueId":"nm0750192","title":"Jenny Runacre","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0750192"}},
      "nm0773932":{"uniqueId":"nm0773932","title":"Maria Schneider","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0773932"}}},
    "Directed by:":{"nm0000774":{"uniqueId":"nm0000774","title":"Michelangelo Antonioni","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000774"}}}}}
''',
  r'''
{"uniqueId":"tt0074486","bestSource":"DataSourceType.imdbKeywords","title":"Eraserhead","type":"MovieContentType.title","year":"1977","yearRange":"1977","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0074486"},
  "related":{"Cast:":{"nm0060931":{"uniqueId":"nm0060931","title":"Jeanne Bates","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0060931"}},
      "nm0430535":{"uniqueId":"nm0430535","title":"Allen Joseph","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0430535"}},
      "nm0620756":{"uniqueId":"nm0620756","title":"Jack Nance","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0620756"}},
      "nm0829270":{"uniqueId":"nm0829270","title":"Charlotte Stewart","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0829270"}}},
    "Directed by:":{"nm0000186":{"uniqueId":"nm0000186","title":"David Lynch","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000186"}}}}}
''',
  r'''
{"uniqueId":"tt0074811","bestSource":"DataSourceType.imdbKeywords","title":"The Tenant","type":"MovieContentType.title","year":"1976","yearRange":"1976","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0074811"},
  "related":{"Cast:":{"nm0000254":{"uniqueId":"nm0000254","title":"Isabelle Adjani","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000254"}},
      "nm0000591":{"uniqueId":"nm0000591","title":"Roman Polanski","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000591"}},
      "nm0002048":{"uniqueId":"nm0002048","title":"Melvyn Douglas","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0002048"}},
      "nm0886888":{"uniqueId":"nm0886888","title":"Jo Van Fleet","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0886888"}}},
    "Directed by:":{"nm0000591":{"uniqueId":"nm0000591","title":"Roman Polanski","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000591"}}}}}
''',
  r'''
{"uniqueId":"tt0082085","bestSource":"DataSourceType.imdbKeywords","title":"Blow Out","type":"MovieContentType.title","year":"1981","yearRange":"1981","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0082085"},
  "related":{"Cast:":{"nm0000237":{"uniqueId":"nm0000237","title":"John Travolta","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000237"}},
      "nm0000262":{"uniqueId":"nm0000262","title":"Nancy Allen","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000262"}},
      "nm0001240":{"uniqueId":"nm0001240","title":"Dennis Franz","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001240"}},
      "nm0001475":{"uniqueId":"nm0001475","title":"John Lithgow","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001475"}}},
    "Directed by:":{"nm0000361":{"uniqueId":"nm0000361","title":"Brian De Palma","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000361"}}}}}
''',
  r'''
{"uniqueId":"tt0085933","bestSource":"DataSourceType.imdbKeywords","title":"Merry Christmas, Mr. Lawrence","type":"MovieContentType.title","year":"1983","yearRange":"1983","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0085933"},
  "related":{"Cast:":{"nm0000309":{"uniqueId":"nm0000309","title":"David Bowie","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000309"}},
      "nm0001429":{"uniqueId":"nm0001429","title":"Takeshi Kitano","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001429"}},
      "nm0002018":{"uniqueId":"nm0002018","title":"Tom Conti","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0002018"}},
      "nm0757098":{"uniqueId":"nm0757098","title":"Ryuichi Sakamoto","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0757098"}}},
    "Directed by:":{"nm0651915":{"uniqueId":"nm0651915","title":"Nagisa Ôshima","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0651915"}}}}}
''',
  r'''
{"uniqueId":"tt0098068","bestSource":"DataSourceType.imdbKeywords","title":"Parents","type":"MovieContentType.title","year":"1989","yearRange":"1989","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0098068"},
  "related":{"Cast:":{"nm0001642":{"uniqueId":"nm0001642","title":"Randy Quaid","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001642"}},
      "nm0002148":{"uniqueId":"nm0002148","title":"Mary Beth Hurt","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0002148"}},
      "nm0006800":{"uniqueId":"nm0006800","title":"Sandy Dennis","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0006800"}},
      "nm0535077":{"uniqueId":"nm0535077","title":"Bryan Madorsky","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0535077"}}},
    "Directed by:":{"nm0000837":{"uniqueId":"nm0000837","title":"Bob Balaban","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000837"}}}}}
''',
  r'''
{"uniqueId":"tt0098936","bestSource":"DataSourceType.imdbKeywords","title":"Twin Peaks","type":"MovieContentType.series","year":"1991","yearRange":"1990–1991","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0098936"},
  "related":{"Cast:":{"nm0000749":{"uniqueId":"nm0000749","title":"Mädchen Amick","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000749"}},
      "nm0000796":{"uniqueId":"nm0000796","title":"Dana Ashbrook","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000796"}},
      "nm0001492":{"uniqueId":"nm0001492","title":"Kyle MacLachlan","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001492"}},
      "nm0648920":{"uniqueId":"nm0648920","title":"Michael Ontkean","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0648920"}}}}}
''',
  r'''
{"uniqueId":"tt0099871","bestSource":"DataSourceType.imdbKeywords","title":"Jacob's Ladder","type":"MovieContentType.title","yearRange":"I 1990","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0099871"},
  "related":{"Cast:":{"nm0000209":{"uniqueId":"nm0000209","title":"Tim Robbins","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000209"}},
      "nm0000732":{"uniqueId":"nm0000732","title":"Danny Aiello","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000732"}},
      "nm0001615":{"uniqueId":"nm0001615","title":"Elizabeth Peña","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001615"}},
      "nm0002023":{"uniqueId":"nm0002023","title":"Matt Craven","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0002023"}}},
    "Directed by:":{"nm0001490":{"uniqueId":"nm0001490","title":"Adrian Lyne","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001490"}}}}}
''',
  r'''
{"uniqueId":"tt0105665","bestSource":"DataSourceType.imdbKeywords","title":"Twin Peaks: Fire Walk with Me","type":"MovieContentType.title","year":"1992","yearRange":"1992","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdbKeywords":"tt0105665"},
  "related":{"Cast:":{"nm0000749":{"uniqueId":"nm0000749","title":"Mädchen Amick","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000749"}},
      "nm0000796":{"uniqueId":"nm0000796","title":"Dana Ashbrook","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000796"}},
      "nm0498247":{"uniqueId":"nm0498247","title":"Sheryl Lee","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0498247"}},
      "nm0936403":{"uniqueId":"nm0936403","title":"Ray Wise","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0936403"}}},
    "Directed by:":{"nm0000186":{"uniqueId":"nm0000186","title":"David Lynch","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000186"}}}}}
''',
  r'''
{"uniqueId":"tt0109665","bestSource":"DataSourceType.imdbKeywords","title":"Dream Lover","type":"MovieContentType.title","year":"1993","yearRange":"1993","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0109665"},
  "related":{"Cast:":{"nm0000652":{"uniqueId":"nm0000652","title":"James Spader","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000652"}},
      "nm0000749":{"uniqueId":"nm0000749","title":"Mädchen Amick","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000749"}},
      "nm0000787":{"uniqueId":"nm0000787","title":"Bess Armstrong","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000787"}},
      "nm0499791":{"uniqueId":"nm0499791","title":"Fredric Lehne","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0499791"}}},
    "Directed by:":{"nm0443582":{"uniqueId":"nm0443582","title":"Nicholas Kazan","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0443582"}}}}}
''',
  r'''
{"uniqueId":"tt0114814","bestSource":"DataSourceType.imdbKeywords","title":"The Usual Suspects","type":"MovieContentType.title","year":"1995","yearRange":"1995","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0114814"},
  "related":{"Cast:":{"nm0000228":{"uniqueId":"nm0000228","title":"Kevin Spacey","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000228"}},
      "nm0000286":{"uniqueId":"nm0000286","title":"Stephen Baldwin","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000286"}},
      "nm0000321":{"uniqueId":"nm0000321","title":"Gabriel Byrne","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000321"}},
      "nm0001590":{"uniqueId":"nm0001590","title":"Chazz Palminteri","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001590"}}},
    "Directed by:":{"nm0001741":{"uniqueId":"nm0001741","title":"Bryan Singer","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001741"}}}}}
''',
  r'''
{"uniqueId":"tt0125664","bestSource":"DataSourceType.imdbKeywords","title":"Man on the Moon","type":"MovieContentType.title","year":"1999","yearRange":"1999","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0125664"},
  "related":{"Cast:":{"nm0000120":{"uniqueId":"nm0000120","title":"Jim Carrey","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000120"}},
      "nm0000362":{"uniqueId":"nm0000362","title":"Danny DeVito","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000362"}},
      "nm0065418":{"uniqueId":"nm0065418","title":"Gerry Becker","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0065418"}},
      "nm0671761":{"uniqueId":"nm0671761","title":"Greyson Erik Pendry","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0671761"}}},
    "Directed by:":{"nm0001232":{"uniqueId":"nm0001232","title":"Milos Forman","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001232"}}}}}
''',
  r'''
{"uniqueId":"tt0156887","bestSource":"DataSourceType.imdbKeywords","title":"Perfect Blue","type":"MovieContentType.title","year":"1997","yearRange":"1997","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0156887"},
  "related":{"Cast:":{"nm0412585":{"uniqueId":"nm0412585","title":"Junko Iwao","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0412585"}},
      "nm0559551":{"uniqueId":"nm0559551","title":"Rica Matsumoto","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0559551"}},
      "nm0875320":{"uniqueId":"nm0875320","title":"Shinpachi Tsuji","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0875320"}},
      "nm0959991":{"uniqueId":"nm0959991","title":"Masaaki Ôkura","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0959991"}}},
    "Directed by:":{"nm0464804":{"uniqueId":"nm0464804","title":"Satoshi Kon","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0464804"}}}}}
''',
  r'''
{"uniqueId":"tt0161081","bestSource":"DataSourceType.imdbKeywords","title":"What Lies Beneath","type":"MovieContentType.title","year":"2000","yearRange":"2000","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0161081"},
  "related":{"Cast:":{"nm0000148":{"uniqueId":"nm0000148","title":"Harrison Ford","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000148"}},
      "nm0000201":{"uniqueId":"nm0000201","title":"Michelle Pfeiffer","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000201"}},
      "nm0001584":{"uniqueId":"nm0001584","title":"Miranda Otto","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001584"}},
      "nm0870007":{"uniqueId":"nm0870007","title":"Katharine Towne","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0870007"}}},
    "Directed by:":{"nm0000709":{"uniqueId":"nm0000709","title":"Robert Zemeckis","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000709"}}}}}
''',
  r'''
{"uniqueId":"tt0166924","bestSource":"DataSourceType.imdbKeywords","title":"Mulholland Drive","type":"MovieContentType.title","year":"2001","yearRange":"2001","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0166924"},
  "related":{"Cast:":{"nm0005009":{"uniqueId":"nm0005009","title":"Laura Harring","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0005009"}},
      "nm0060931":{"uniqueId":"nm0060931","title":"Jeanne Bates","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0060931"}},
      "nm0857620":{"uniqueId":"nm0857620","title":"Justin Theroux","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0857620"}},
      "nm0915208":{"uniqueId":"nm0915208","title":"Naomi Watts","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0915208"}}},
    "Directed by:":{"nm0000186":{"uniqueId":"nm0000186","title":"David Lynch","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000186"}}}}}
''',
  r'''
{"uniqueId":"tt0246578","bestSource":"DataSourceType.imdbKeywords","title":"Donnie Darko","type":"MovieContentType.title","year":"2001","yearRange":"2001","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0246578"},
  "related":{"Cast:":{"nm0001521":{"uniqueId":"nm0001521","title":"Mary McDonnell","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001521"}},
      "nm0350453":{"uniqueId":"nm0350453","title":"Jake Gyllenhaal","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0350453"}},
      "nm0540441":{"uniqueId":"nm0540441","title":"Jena Malone","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0540441"}},
      "nm0651660":{"uniqueId":"nm0651660","title":"Holmes Osborne","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0651660"}}},
    "Directed by:":{"nm0446819":{"uniqueId":"nm0446819","title":"Richard Kelly","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0446819"}}}}}
''',
  r'''
{"uniqueId":"tt0252501","bestSource":"DataSourceType.imdbKeywords","title":"Hearts in Atlantis","type":"MovieContentType.title","year":"2001","yearRange":"2001","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0252501"},
  "related":{"Cast:":{"nm0000164":{"uniqueId":"nm0000164","title":"Anthony Hopkins","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000164"}},
      "nm0095561":{"uniqueId":"nm0095561","title":"Mika Boorem","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0095561"}},
      "nm0204706":{"uniqueId":"nm0204706","title":"Hope Davis","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0204706"}},
      "nm0947338":{"uniqueId":"nm0947338","title":"Anton Yelchin","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0947338"}}},
    "Directed by:":{"nm0382956":{"uniqueId":"nm0382956","title":"Scott Hicks","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0382956"}}}}}
''',
  r'''
{"uniqueId":"tt0272152","bestSource":"DataSourceType.imdbKeywords","title":"K-PAX","type":"MovieContentType.title","year":"2001","yearRange":"2001","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0272152"},
  "related":{"Cast:":{"nm0000228":{"uniqueId":"nm0000228","title":"Kevin Spacey","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000228"}},
      "nm0000313":{"uniqueId":"nm0000313","title":"Jeff Bridges","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000313"}},
      "nm0005203":{"uniqueId":"nm0005203","title":"Mary McCormack","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0005203"}},
      "nm0005569":{"uniqueId":"nm0005569","title":"Alfre Woodard","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0005569"}}},
    "Directed by:":{"nm0812200":{"uniqueId":"nm0812200","title":"Iain Softley","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0812200"}}}}}
''',
  r'''
{"uniqueId":"tt0324133","bestSource":"DataSourceType.imdbKeywords","title":"Swimming Pool","type":"MovieContentType.title","year":"2003","yearRange":"2003","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0324133"},
  "related":{"Cast:":{"nm0001097":{"uniqueId":"nm0001097","title":"Charles Dance","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001097"}},
      "nm0001648":{"uniqueId":"nm0001648","title":"Charlotte Rampling","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001648"}},
      "nm0483788":{"uniqueId":"nm0483788","title":"Jean-Marie Lamour","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0483788"}},
      "nm0756203":{"uniqueId":"nm0756203","title":"Ludivine Sagnier","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0756203"}}},
    "Directed by:":{"nm0654830":{"uniqueId":"nm0654830","title":"François Ozon","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0654830"}}}}}
''',
  r'''
{"uniqueId":"tt0337876","bestSource":"DataSourceType.imdbKeywords","title":"Birth","type":"MovieContentType.title","year":"2004","yearRange":"2004","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0337876"},
  "related":{"Cast:":{"nm0000002":{"uniqueId":"nm0000002","title":"Lauren Bacall","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000002"}},
      "nm0000173":{"uniqueId":"nm0000173","title":"Nicole Kidman","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000173"}},
      "nm0396812":{"uniqueId":"nm0396812","title":"Danny Huston","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0396812"}},
      "nm1080974":{"uniqueId":"nm1080974","title":"Cameron Bright","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1080974"}}},
    "Directed by:":{"nm0322242":{"uniqueId":"nm0322242","title":"Jonathan Glazer","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0322242"}}}}}
''',
  r'''
{"uniqueId":"tt0348593","bestSource":"DataSourceType.imdbKeywords","title":"The Door in the Floor","type":"MovieContentType.title","year":"2004","yearRange":"2004","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0348593"},
  "related":{"Cast:":{"nm0000107":{"uniqueId":"nm0000107","title":"Kim Basinger","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000107"}},
      "nm0000313":{"uniqueId":"nm0000313","title":"Jeff Bridges","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000313"}},
      "nm0287898":{"uniqueId":"nm0287898","title":"Jon Foster","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0287898"}},
      "nm1102577":{"uniqueId":"nm1102577","title":"Elle Fanning","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1102577"}}},
    "Directed by:":{"nm0931095":{"uniqueId":"nm0931095","title":"Tod Williams","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0931095"}}}}}
''',
  r'''
{"uniqueId":"tt0365686","bestSource":"DataSourceType.imdbKeywords","title":"Revolver","type":"MovieContentType.title","year":"2005","yearRange":"2005","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0365686"},
  "related":{"Cast:":{"nm0000501":{"uniqueId":"nm0000501","title":"Ray Liotta","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000501"}},
      "nm0005458":{"uniqueId":"nm0005458","title":"Jason Statham","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0005458"}},
      "nm0071275":{"uniqueId":"nm0071275","title":"André 3000","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0071275"}},
      "nm0665114":{"uniqueId":"nm0665114","title":"Vincent Pastore","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0665114"}}},
    "Directed by:":{"nm0005363":{"uniqueId":"nm0005363","title":"Guy Ritchie","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0005363"}}}}}
''',
  r'''
{"uniqueId":"tt0366627","bestSource":"DataSourceType.imdbKeywords","title":"The Jacket","type":"MovieContentType.title","year":"2005","yearRange":"2005","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0366627"},
  "related":{"Cast:":{"nm0001434":{"uniqueId":"nm0001434","title":"Kris Kristofferson","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001434"}},
      "nm0004778":{"uniqueId":"nm0004778","title":"Adrien Brody","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0004778"}},
      "nm0185819":{"uniqueId":"nm0185819","title":"Daniel Craig","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0185819"}},
      "nm0461136":{"uniqueId":"nm0461136","title":"Keira Knightley","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0461136"}}},
    "Directed by:":{"nm0562266":{"uniqueId":"nm0562266","title":"John Maybury","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0562266"}}}}}
''',
  r'''
{"uniqueId":"tt0368794","bestSource":"DataSourceType.imdbKeywords","title":"I'm Not There","type":"MovieContentType.title","year":"2007","yearRange":"2007","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0368794"},
  "related":{"Cast:":{"nm0000288":{"uniqueId":"nm0000288","title":"Christian Bale","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000288"}},
      "nm0000949":{"uniqueId":"nm0000949","title":"Cate Blanchett","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000949"}},
      "nm0005132":{"uniqueId":"nm0005132","title":"Heath Ledger","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0005132"}},
      "nm0924210":{"uniqueId":"nm0924210","title":"Ben Whishaw","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0924210"}}},
    "Directed by:":{"nm0001331":{"uniqueId":"nm0001331","title":"Todd Haynes","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001331"}}}}}
''',
  r'''
{"uniqueId":"tt0432402","bestSource":"DataSourceType.imdbKeywords","title":"Factory Girl","type":"MovieContentType.title","year":"2006","yearRange":"2006","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0432402"},
  "related":{"Cast:":{"nm0001602":{"uniqueId":"nm0001602","title":"Guy Pearce","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001602"}},
      "nm0159789":{"uniqueId":"nm0159789","title":"Hayden Christensen","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0159789"}},
      "nm0266422":{"uniqueId":"nm0266422","title":"Jimmy Fallon","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0266422"}},
      "nm1092227":{"uniqueId":"nm1092227","title":"Sienna Miller","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1092227"}}},
    "Directed by:":{"nm0382584":{"uniqueId":"nm0382584","title":"George Hickenlooper","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0382584"}}}}}
''',
  r'''
{"uniqueId":"tt0454848","bestSource":"DataSourceType.imdbKeywords","title":"Inside Man","type":"MovieContentType.title","year":"2006","yearRange":"2006","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0454848"},
  "related":{"Cast:":{"nm0000149":{"uniqueId":"nm0000149","title":"Jodie Foster","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000149"}},
      "nm0000243":{"uniqueId":"nm0000243","title":"Denzel Washington","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000243"}},
      "nm0001626":{"uniqueId":"nm0001626","title":"Christopher Plummer","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001626"}},
      "nm0654110":{"uniqueId":"nm0654110","title":"Clive Owen","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0654110"}}},
    "Directed by:":{"nm0000490":{"uniqueId":"nm0000490","title":"Spike Lee","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000490"}}}}}
''',
  r'''
{"uniqueId":"tt0481369","bestSource":"DataSourceType.imdbKeywords","title":"The Number 23","type":"MovieContentType.title","year":"2007","yearRange":"2007","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0481369"},
  "related":{"Cast:":{"nm0000120":{"uniqueId":"nm0000120","title":"Jim Carrey","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000120"}},
      "nm0000515":{"uniqueId":"nm0000515","title":"Virginia Madsen","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000515"}},
      "nm0396812":{"uniqueId":"nm0396812","title":"Danny Huston","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0396812"}},
      "nm0503567":{"uniqueId":"nm0503567","title":"Logan Lerman","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0503567"}}},
    "Directed by:":{"nm0001708":{"uniqueId":"nm0001708","title":"Joel Schumacher","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001708"}}}}}
''',
  r'''
{"uniqueId":"tt0945513","bestSource":"DataSourceType.imdbKeywords","title":"Source Code","type":"MovieContentType.title","year":"2011","yearRange":"2011","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0945513"},
  "related":{"Cast:":{"nm0267812":{"uniqueId":"nm0267812","title":"Vera Farmiga","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0267812"}},
      "nm0350453":{"uniqueId":"nm0350453","title":"Jake Gyllenhaal","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0350453"}},
      "nm0942482":{"uniqueId":"nm0942482","title":"Jeffrey Wright","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0942482"}},
      "nm1157358":{"uniqueId":"nm1157358","title":"Michelle Monaghan","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1157358"}}},
    "Directed by:":{"nm1512910":{"uniqueId":"nm1512910","title":"Duncan Jones","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1512910"}}}}}
''',
  r'''
{"uniqueId":"tt0970179","bestSource":"DataSourceType.imdbKeywords","title":"Hugo","type":"MovieContentType.title","year":"2011","yearRange":"2011","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt0970179"},
  "related":{"Cast:":{"nm0000489":{"uniqueId":"nm0000489","title":"Christopher Lee","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000489"}},
      "nm0001426":{"uniqueId":"nm0001426","title":"Ben Kingsley","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001426"}},
      "nm1631269":{"uniqueId":"nm1631269","title":"Chloë Grace Moretz","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1631269"}},
      "nm2633535":{"uniqueId":"nm2633535","title":"Asa Butterfield","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm2633535"}}},
    "Directed by:":{"nm0000217":{"uniqueId":"nm0000217","title":"Martin Scorsese","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000217"}}}}}
''',
  r'''
{"uniqueId":"tt10731256","bestSource":"DataSourceType.imdbKeywords","title":"Don't Worry Darling","type":"MovieContentType.title","yearRange":"I 2022","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt10731256"},
  "related":{"Cast:":{"nm1312575":{"uniqueId":"nm1312575","title":"Olivia Wilde","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1312575"}},
      "nm1517976":{"uniqueId":"nm1517976","title":"Chris Pine","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1517976"}},
      "nm4089170":{"uniqueId":"nm4089170","title":"Harry Styles","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm4089170"}},
      "nm6073955":{"uniqueId":"nm6073955","title":"Florence Pugh","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm6073955"}}},
    "Directed by:":{"nm1312575":{"uniqueId":"nm1312575","title":"Olivia Wilde","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1312575"}}}}}
''',
  r'''
{"uniqueId":"tt13444912","bestSource":"DataSourceType.imdbKeywords","title":"The Midnight Club","type":"MovieContentType.title","year":"2022","yearRange":"2022","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt13444912"},
  "related":{"Cast:":{"nm11332821":{"uniqueId":"nm11332821","title":"Ruth Codd","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm11332821"}},
      "nm11517225":{"uniqueId":"nm11517225","title":"Sadoc Vazkez","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm11517225"}},
      "nm7223890":{"uniqueId":"nm7223890","title":"Iman Benson","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm7223890"}},
      "nm9723807":{"uniqueId":"nm9723807","title":"Igby Rigney","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm9723807"}}}}}
''',
  r'''
{"uniqueId":"tt1518812","bestSource":"DataSourceType.imdbKeywords","title":"Meek's Cutoff","type":"MovieContentType.title","year":"2010","yearRange":"2010","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt1518812"},
  "related":{"Cast:":{"nm0001599":{"uniqueId":"nm0001599","title":"Will Patton","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001599"}},
      "nm0200452":{"uniqueId":"nm0200452","title":"Paul Dano","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0200452"}},
      "nm0339304":{"uniqueId":"nm0339304","title":"Bruce Greenwood","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0339304"}},
      "nm0931329":{"uniqueId":"nm0931329","title":"Michelle Williams","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0931329"}}},
    "Directed by:":{"nm0716980":{"uniqueId":"nm0716980","title":"Kelly Reichardt","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0716980"}}}}}
''',
  r'''
{"uniqueId":"tt1924396","bestSource":"DataSourceType.imdbKeywords","title":"The Best Offer","type":"MovieContentType.title","year":"2013","yearRange":"2013","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt1924396"},
  "related":{"Cast:":{"nm0000661":{"uniqueId":"nm0000661","title":"Donald Sutherland","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000661"}},
      "nm0001691":{"uniqueId":"nm0001691","title":"Geoffrey Rush","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001691"}},
      "nm0836343":{"uniqueId":"nm0836343","title":"Jim Sturgess","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0836343"}},
      "nm1679778":{"uniqueId":"nm1679778","title":"Sylvia Hoeks","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1679778"}}},
    "Directed by:":{"nm0868153":{"uniqueId":"nm0868153","title":"Giuseppe Tornatore","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0868153"}}}}}
''',
  r'''
{"uniqueId":"tt2084970","bestSource":"DataSourceType.imdbKeywords","title":"The Imitation Game","type":"MovieContentType.title","year":"2014","yearRange":"2014","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt2084970"},
  "related":{"Cast:":{"nm0328828":{"uniqueId":"nm0328828","title":"Matthew Goode","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0328828"}},
      "nm0461136":{"uniqueId":"nm0461136","title":"Keira Knightley","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0461136"}},
      "nm1212722":{"uniqueId":"nm1212722","title":"Benedict Cumberbatch","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1212722"}},
      "nm1395602":{"uniqueId":"nm1395602","title":"Allen Leech","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1395602"}}},
    "Directed by:":{"nm0878763":{"uniqueId":"nm0878763","title":"Morten Tyldum","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0878763"}}}}}
''',
  r'''
{"uniqueId":"tt2365580","bestSource":"DataSourceType.imdbKeywords","title":"Where'd You Go, Bernadette","type":"MovieContentType.title","year":"2019","yearRange":"2019","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt2365580"},
  "related":{"Cast:":{"nm0000949":{"uniqueId":"nm0000949","title":"Cate Blanchett","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000949"}},
      "nm0001082":{"uniqueId":"nm0001082","title":"Billy Crudup","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001082"}},
      "nm1325419":{"uniqueId":"nm1325419","title":"Kristen Wiig","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1325419"}},
      "nm8625874":{"uniqueId":"nm8625874","title":"Emma Nelson","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm8625874"}}},
    "Directed by:":{"nm0000500":{"uniqueId":"nm0000500","title":"Richard Linklater","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000500"}}}}}
''',
  r'''
{"uniqueId":"tt3262342","bestSource":"DataSourceType.imdbKeywords","title":"Loving Vincent","type":"MovieContentType.title","year":"2017","yearRange":"2017","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt3262342"},
  "related":{"Cast:":{"nm0283492":{"uniqueId":"nm0283492","title":"Jerome Flynn","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0283492"}},
      "nm0567031":{"uniqueId":"nm0567031","title":"Helen McCrory","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0567031"}},
      "nm3150488":{"uniqueId":"nm3150488","title":"Douglas Booth","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm3150488"}},
      "nm7956813":{"uniqueId":"nm7956813","title":"Robert Gulaczyk","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm7956813"}}},
    "Directed by:":{"nm1364790":{"uniqueId":"nm1364790","title":"Hugh Welchman","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1364790"}},
      "nm3699790":{"uniqueId":"nm3699790","title":"Dorota Kobiela","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm3699790"}}}}}
''',
  r'''
{"uniqueId":"tt3289956","bestSource":"DataSourceType.imdbKeywords","title":"The Autopsy of Jane Doe","type":"MovieContentType.title","year":"2016","yearRange":"2016","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt3289956"},
  "related":{"Cast:":{"nm0004051":{"uniqueId":"nm0004051","title":"Brian Cox","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0004051"}},
      "nm0386472":{"uniqueId":"nm0386472","title":"Emile Hirsch","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0386472"}},
      "nm0568385":{"uniqueId":"nm0568385","title":"Michael McElhatton","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0568385"}},
      "nm1166041":{"uniqueId":"nm1166041","title":"Ophelia Lovibond","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1166041"}}},
    "Directed by:":{"nm0004217":{"uniqueId":"nm0004217","title":"André Øvredal","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0004217"}}}}}
''',
  r'''
{"uniqueId":"tt3387648","bestSource":"DataSourceType.imdbKeywords","title":"The Taking","type":"MovieContentType.title","year":"2014","yearRange":"2014","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdbKeywords":"tt3387648"},
  "related":{"Cast:":{"nm0029391":{"uniqueId":"nm0029391","title":"Michelle Ang","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0029391"}},
      "nm0489010":{"uniqueId":"nm0489010","title":"Jill Larson","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0489010"}},
      "nm0708867":{"uniqueId":"nm0708867","title":"Anne Ramsay","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0708867"}},
      "nm1654820":{"uniqueId":"nm1654820","title":"Brett Gentile","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1654820"}}},
    "Directed by:":{"nm0733263":{"uniqueId":"nm0733263","title":"Adam Robitel","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0733263"}}}}}
''',
  r'''
{"uniqueId":"tt3613454","bestSource":"DataSourceType.imdbKeywords","title":"Zankyô no teroru","type":"MovieContentType.title","year":"2014","yearRange":"2014","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt3613454"},
  "related":{"Cast:":{"nm1516229":{"uniqueId":"nm1516229","title":"Shunsuke Sakuya","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1516229"}},
      "nm5481013":{"uniqueId":"nm5481013","title":"Kaito Ishikawa","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm5481013"}},
      "nm6160361":{"uniqueId":"nm6160361","title":"Sôma Saitô","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm6160361"}},
      "nm6662487":{"uniqueId":"nm6662487","title":"Atsumi Tanezaki","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm6662487"}}}}}
''',
  r'''
{"uniqueId":"tt4602066","bestSource":"DataSourceType.imdbKeywords","title":"The Catcher Was a Spy","type":"MovieContentType.title","year":"2018","yearRange":"2018","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt4602066"},
  "related":{"Cast:":{"nm0001567":{"uniqueId":"nm0001567","title":"Connie Nielsen","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0001567"}},
      "nm0269419":{"uniqueId":"nm0269419","title":"Pierfrancesco Favino","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0269419"}},
      "nm0748620":{"uniqueId":"nm0748620","title":"Paul Rudd","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0748620"}},
      "nm0929489":{"uniqueId":"nm0929489","title":"Tom Wilkinson","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0929489"}}},
    "Directed by:":{"nm0506802":{"uniqueId":"nm0506802","title":"Ben Lewin","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0506802"}}}}}
''',
  r'''
{"uniqueId":"tt6160448","bestSource":"DataSourceType.imdbKeywords","title":"White Noise","type":"MovieContentType.title","yearRange":"I 2022","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt6160448"},
  "related":{"Cast:":{"nm0000332":{"uniqueId":"nm0000332","title":"Don Cheadle","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000332"}},
      "nm14313990":{"uniqueId":"nm14313990","title":"Madison Gaughan","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm14313990"}},
      "nm1950086":{"uniqueId":"nm1950086","title":"Greta Gerwig","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm1950086"}},
      "nm3485845":{"uniqueId":"nm3485845","title":"Adam Driver","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm3485845"}}},
    "Directed by:":{"nm0000876":{"uniqueId":"nm0000876","title":"Noah Baumbach","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0000876"}}}}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBMoviesForKeyword test', () {
    // Search for a rare movie.
    test('Run a keyword search on IMDB that is likely to have static results',
        () async {
      final criteria = SearchCriteriaDTO().fromString('enigma');
      final actualOutput =
          await QueryIMDBMoviesForKeyword(criteria).readList(limit: 10);
      final expectedOutput = expectedDTOList;
      expectedDTOList.clearCopyrightedData();
      actualOutput.clearCopyrightedData();

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
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryIMDBMoviesForKeyword(criteria).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(
          expectedOutput,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
