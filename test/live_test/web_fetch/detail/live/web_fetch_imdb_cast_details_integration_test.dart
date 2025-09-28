import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_cast.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0101000","title":"Zacátek dlouhého podzimu","bestSource":"DataSourceType.imdbCast","type":"MovieContentType.movie","year":"1990","yearRange":"1990","runTime":"4860",
      "genres":"[\"Drama\"]",
      "userRating":"4.8","userRatingCount":"9","sources":{"DataSourceType.imdbCast":"tt0101000"},
  "related":{"Actor":{"nm0366123":{"uniqueId":"nm0366123","title":"Gábor Harsányi","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0366123"}},
      "nm0375865":{"uniqueId":"nm0375865","title":"Václav Helsus","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmYzZGYwNGEtYmRiZS00NzA1LTllODEtMDEzYTgyNTU2YmI3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0375865"}},
      "nm0398703":{"uniqueId":"nm0398703","title":"Rudolf Hrusínský","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYWY1ZTFlZGQtMGFkMy00ZTE1LTkwNzktMGEwMDhiZDQyNzk0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0398703"}},
      "nm0610846":{"uniqueId":"nm0610846","title":"Zdenek Mucha","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzBhYmVkNjktZGJlMC00MGNiLTkyYjUtMWJkYjhlMjY3MDAyXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0610846"}},
      "nm0637243":{"uniqueId":"nm0637243","title":"Jan Novotný","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTViMWQxZmUtN2I2Zi00YmEzLWFhZDktN2Y2MmJjYjZjMGUwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0637243"}},
      "nm0814162":{"uniqueId":"nm0814162","title":"Josef Somr","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDhjM2Q5N2ItZDBmZC00ZGU4LTg1MjEtNGI5ZGExMTNjOTM1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0814162"}}},
    "Actress":{"nm0228686":{"uniqueId":"nm0228686","title":"Nina Divísková","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTZiMjQyOWEtNDA1Mi00MTlkLTgxZTItY2YzZjA4N2EwZTBhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0228686"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm1077536":{"uniqueId":"nm1077536","title":"Ivana Novácková","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1077536"}},
      "nm2920414":{"uniqueId":"nm2920414","title":"Hana Soucková","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2920414"}}},
    "Art Director":{"nm0810552":{"uniqueId":"nm0810552","title":"Petr Smola","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0810552"}}},
    "Camera and Electrical Department":{"nm0463004":{"uniqueId":"nm0463004","title":"Vladimír Kolár","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0463004"}}},
    "Cast":{"nm0228686":{"uniqueId":"nm0228686","title":"Nina Divísková","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTZiMjQyOWEtNDA1Mi00MTlkLTgxZTItY2YzZjA4N2EwZTBhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0228686"}},
      "nm0275857":{"uniqueId":"nm0275857","title":"Radka Fiedlerová","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0275857"}},
      "nm0366123":{"uniqueId":"nm0366123","title":"Gábor Harsányi","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0366123"}},
      "nm0375865":{"uniqueId":"nm0375865","title":"Václav Helsus","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmYzZGYwNGEtYmRiZS00NzA1LTllODEtMDEzYTgyNTU2YmI3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0375865"}},
      "nm0389409":{"uniqueId":"nm0389409","title":"Drahomíra Hofmanová","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0389409"}},
      "nm0398703":{"uniqueId":"nm0398703","title":"Rudolf Hrusínský","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYWY1ZTFlZGQtMGFkMy00ZTE1LTkwNzktMGEwMDhiZDQyNzk0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0398703"}},
      "nm0575922":{"uniqueId":"nm0575922","title":"Tatjana Medvecká","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTVjYmY2MzctYjUxOS00YjNlLWE4YjQtODEwNGFmZDI2OThkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0575922"}},
      "nm0586261":{"uniqueId":"nm0586261","title":"Alena Mihulová","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzRjNThjZDEtM2M4Yi00MGY4LTlmNDQtNGI3MjdhNjY2MTQ0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0586261"}},
      "nm0610846":{"uniqueId":"nm0610846","title":"Zdenek Mucha","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzBhYmVkNjktZGJlMC00MGNiLTkyYjUtMWJkYjhlMjY3MDAyXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0610846"}},
      "nm0623158":{"uniqueId":"nm0623158","title":"Oldrich Navrátil","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYWE4MGI5MjgtMTI5NC00YWM0LWEyYTItMGI4NjZiNzlmNmQxXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0623158"}},
      "nm0637243":{"uniqueId":"nm0637243","title":"Jan Novotný","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTViMWQxZmUtN2I2Zi00YmEzLWFhZDktN2Y2MmJjYjZjMGUwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0637243"}},
      "nm0689763":{"uniqueId":"nm0689763","title":"Bronislav Poloczek","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTg4ODRjNmUtNzczMC00ODg4LTk3OWQtODA5ZmQwYTY0NjUzXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0689763"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0814162":{"uniqueId":"nm0814162","title":"Josef Somr","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDhjM2Q5N2ItZDBmZC00ZGU4LTg1MjEtNGI5ZGExMTNjOTM1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0814162"}},
      "nm0834684":{"uniqueId":"nm0834684","title":"Stanislava Strobachová","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0834684"}},
      "nm1077536":{"uniqueId":"nm1077536","title":"Ivana Novácková","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1077536"}},
      "nm1189926":{"uniqueId":"nm1189926","title":"Jirí Kodes","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1189926"}},
      "nm2024755":{"uniqueId":"nm2024755","title":"Miroslava Kolárová","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2024755"}},
      "nm2920414":{"uniqueId":"nm2920414","title":"Hana Soucková","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2920414"}}},
    "Cinematographer":{"nm0299592":{"uniqueId":"nm0299592","title":"Juraj Fándli","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0299592"}}},
    "Composer":{"nm0880720":{"uniqueId":"nm0880720","title":"Petr Ulrych","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0880720"}}},
    "Costume Designer":{"nm0532669":{"uniqueId":"nm0532669","title":"Zuzana Máchová","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0532669"}}},
    "Director":{"nm1097284":{"uniqueId":"nm1097284","title":"Peter Hledík","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMWJkOGQ4Y2QtMTNkNS00ZjA2LTk0YjAtODg1NDc4M2ViMDAxXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm1097284"}}},
    "Editor":{"nm2919431":{"uniqueId":"nm2919431","title":"Maros Cernák","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2919431"}}},
    "Makeup Department":{"nm0833412":{"uniqueId":"nm0833412","title":"Ivo Strangmüller","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0833412"}}},
    "Production Manager":{"nm2761158":{"uniqueId":"nm2761158","title":"Kamil Spácil","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNlNjBlMjktN2IxMS00MTgwLTg4NjgtNGM0M2RlOTEwZTA4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm2761158"}}},
    "Sound Department":{"nm0468088":{"uniqueId":"nm0468088","title":"Radomír Koutek","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0468088"}}}}}
''',
  r'''
{"uniqueId":"tt0101001","title":"Zai shi feng liu jie","bestSource":"DataSourceType.imdbCast","type":"MovieContentType.movie","year":"1985","yearRange":"1985","runTime":"5340",
      "genres":"[\"Horror\"]",
      "userRating":"4.4","userRatingCount":"9","imageUrl":"https://m.media-amazon.com/images/M/MV5BZTA4ZTNhM2YtZjI1NC00MjJjLTg4ZWMtMGY2ZDIzNWY5Nzk3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbCast":"tt0101001"},
  "related":{"Actor":{"nm1293419":{"uniqueId":"nm1293419","title":"Sha-Li Pai","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1293419"}},
      "nm2403022":{"uniqueId":"nm2403022","title":"Leng-Kuang Yin","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2403022"}},
      "nm7371229":{"uniqueId":"nm7371229","title":"Fung Chong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm7371229"}}},
    "Actress":{"nm0423271":{"uniqueId":"nm0423271","title":"Maria Jo","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0423271"}},
      "nm0530839":{"uniqueId":"nm0530839","title":"Bo-Ming Ma","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0530839"}},
      "nm0948072":{"uniqueId":"nm0948072","title":"Ying-Ying Hui","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYThjYTY5N2UtMWVmMi00MjllLWIzODUtMjcxZTZkYzkzNDk4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0948072"}},
      "nm1903001":{"uniqueId":"nm1903001","title":"Lai-Fong Cheng","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1903001"}}},
    "Cast":{"nm0423271":{"uniqueId":"nm0423271","title":"Maria Jo","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0423271"}},
      "nm0530839":{"uniqueId":"nm0530839","title":"Bo-Ming Ma","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0530839"}},
      "nm0948072":{"uniqueId":"nm0948072","title":"Ying-Ying Hui","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYThjYTY5N2UtMWVmMi00MjllLWIzODUtMjcxZTZkYzkzNDk4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0948072"}},
      "nm1293419":{"uniqueId":"nm1293419","title":"Sha-Li Pai","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1293419"}},
      "nm1903001":{"uniqueId":"nm1903001","title":"Lai-Fong Cheng","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1903001"}},
      "nm2403022":{"uniqueId":"nm2403022","title":"Leng-Kuang Yin","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2403022"}},
      "nm7371229":{"uniqueId":"nm7371229","title":"Fung Chong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm7371229"}}},
    "Director":{"nm0522902":{"uniqueId":"nm0522902","title":"Charles Lowe","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0522902"}}},
    "Producer":{"nm4086248":{"uniqueId":"nm4086248","title":"Shi-Kuang Huang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm4086248"}}},
    "Production Manager":{"nm7832339":{"uniqueId":"nm7832339","title":"Chin Sima","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm7832339"}}},
    "Writer":{"nm0522902":{"uniqueId":"nm0522902","title":"Charles Lowe","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0522902"}},
      "nm7832339":{"uniqueId":"nm7832339","title":"Chin Sima","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm7832339"}}},
    "Writers":{"nm0522902":{"uniqueId":"nm0522902","title":"Charles Lowe","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0522902"}},
      "nm7832339":{"uniqueId":"nm7832339","title":"Chin Sima","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm7832339"}}}}}
''',
  r'''
{"uniqueId":"tt0101002","title":"Joi jin gong woo","bestSource":"DataSourceType.imdbCast","type":"MovieContentType.movie","year":"1990","yearRange":"1990","runTime":"6480",
      "genres":"[\"Action\",\"Drama\"]",
      "description":"A well-known gangster is released from prison, and decides look for his daughter with the help of a troubled young woman.",
      "userRating":"6.3","userRatingCount":"187","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTQwNTRjMmUtNzIxMy00YWMxLThjZjEtYjdmN2U4ZTVhNGVlXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbCast":"tt0101002"},
  "related":{"Actor":{"nm0490489":{"uniqueId":"nm0490489","title":"Andy Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzQzNDkxMjMxMl5BMl5BanBnXkFtZTYwMzMzODA3._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0490489"}},
      "nm0628747":{"uniqueId":"nm0628747","title":"David Wu","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzFiN2JjOGEtODBjNi00MGY1LWEyY2YtY2Y2MzM5OTdhNzBiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0628747"}},
      "nm0849257":{"uniqueId":"nm0849257","title":"Alan Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjM5MzYxZDYtZmQxMy00MjhkLWI4ZTYtYzRhMWRmNjI2MDg4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0849257"}},
      "nm0876600":{"uniqueId":"nm0876600","title":"Wei Tung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmJjMmViMGYtN2NiZC00MDdkLTgyYTEtMzYzNzY5MTJiOTcwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0876600"}},
      "nm0939251":{"uniqueId":"nm0939251","title":"Melvin Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTk2ODI3MzExMl5BMl5BanBnXkFtZTYwNTcwNTAz._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0939251"}},
      "nm0945189":{"uniqueId":"nm0945189","title":"Simon Yam","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTgxNDUyNDEzMl5BMl5BanBnXkFtZTcwMTk4NjAyOA@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0945189"}},
      "nm3976479":{"uniqueId":"nm3976479","title":"Chik-Sum Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm3976479"}}},
    "Actress":{"nm0497213":{"uniqueId":"nm0497213","title":"Elizabeth Lee","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDQ3M2UyOGEtMDIwZS00NTI3LWIwZWItODkzODI3YzBmODNiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0497213"}},
      "nm0516240":{"uniqueId":"nm0516240","title":"May Mei-Mei Lo","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNGUwY2I4MTItMDQ0ZS00NzgxLWJlY2EtNDcxNzYyOTU0NmQ4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0516240"}},
      "nm0628731":{"uniqueId":"nm0628731","title":"Carrie Ng","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BODBlZDJiYWUtOTUzYy00MDhlLWEwMjgtZDJmYzg2YTY3NjA1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0628731"}}},
    "Additional Crew":{"nm0849331":{"uniqueId":"nm0849331","title":"Rover Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0849331"}},
      "nm2807214":{"uniqueId":"nm2807214","title":"Ji-Chiang Kuo","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2807214"}},
      "nm9248293":{"uniqueId":"nm9248293","title":"Ming Yip","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm9248293"}}},
    "Art Director":{"nm0369130":{"uniqueId":"nm0369130","title":"John Hau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0369130"}}},
    "Camera and Electrical Department":{"nm0508670":{"uniqueId":"nm0508670","title":"Chi-Nin Leung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0508670"}},
      "nm0594224":{"uniqueId":"nm0594224","title":"Kin-Fai Mau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0594224"}},
      "nm10091321":{"uniqueId":"nm10091321","title":"Wai-Kwong Chan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm10091321"}}},
    "Cast":{"nm0150862":{"uniqueId":"nm0150862","title":"Dennis Chan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmQyYWJhMjMtMWNkYS00OTU2LTkxZDItNTY3Y2YxNzc5Y2U4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0150862"}},
      "nm0150985":{"uniqueId":"nm0150985","title":"Kwok-Kuen Chan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BOGE3NjZkMmYtYWIzNy00NWRkLWE3OTQtNGI3OWUwMDhkZjBiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0150985"}},
      "nm0151015":{"uniqueId":"nm0151015","title":"Mandy Chan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNWU2ZWIwODQtOTkzOC00ZTZiLWFlOTUtZjc0ZmMzNTc1NmZjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0151015"}},
      "nm0151108":{"uniqueId":"nm0151108","title":"Stephen C.K. Chan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzczY2JkMGYtMzU1MC00NDdmLTg4N2EtYTBkN2I4MTY1OGJmXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0151108"}},
      "nm0151866":{"uniqueId":"nm0151866","title":"Yi Chang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BY2UxOTE3MWQtMjYyNi00YjcwLTkwNmEtNWM0MzVlNTc3MjhkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0151866"}},
      "nm0155264":{"uniqueId":"nm0155264","title":"Jing Chen","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmQ0ZTFmZmMtNWVkMS00NDkxLWFjNWMtODczYTJmZWVhZjUzXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0155264"}},
      "nm0156564":{"uniqueId":"nm0156564","title":"Yuk-San Cheung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmU5YjY5N2ItOWM1My00ZDA2LWJjNTYtOTI5NWFlMzI3NDhlXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0156564"}},
      "nm0387370":{"uniqueId":"nm0387370","title":"Ricky Ho","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDk2MDI3MjItNDQ3Ny00OTZmLWI1MjMtODEzMzFlMTkwNzZlXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0387370"}},
      "nm0473314":{"uniqueId":"nm0473314","title":"Ku Feng","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjNhZDI5ZTctMjUzNi00MGQxLWJmMWUtNThjYmYxMDE0ZWI0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0473314"}},
      "nm0490489":{"uniqueId":"nm0490489","title":"Andy Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzQzNDkxMjMxMl5BMl5BanBnXkFtZTYwMzMzODA3._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0490489"}},
      "nm0490610":{"uniqueId":"nm0490610","title":"Shek-Yin Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BN2IwOGRhZDUtNzMxMy00NTUxLTkwMTQtMjhlZmM2Y2Q5MjNlXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0490610"}},
      "nm0497213":{"uniqueId":"nm0497213","title":"Elizabeth Lee","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDQ3M2UyOGEtMDIwZS00NTI3LWIwZWItODkzODI3YzBmODNiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0497213"}},
      "nm0504898":{"uniqueId":"nm0504898","title":"Pasan Leung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjliNTg2ZjUtOWQyMC00MWNhLWJiZDQtNzNmZGI4MWU3NzVkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0504898"}},
      "nm0516240":{"uniqueId":"nm0516240","title":"May Mei-Mei Lo","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNGUwY2I4MTItMDQ0ZS00NzgxLWJlY2EtNDcxNzYyOTU0NmQ4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0516240"}},
      "nm0519063":{"uniqueId":"nm0519063","title":"Long Kong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZTU2YmY0Y2UtMjI1OS00ZDgyLTk3NWQtMmNjMzQzMTMwZmE0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0519063"}},
      "nm0628731":{"uniqueId":"nm0628731","title":"Carrie Ng","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BODBlZDJiYWUtOTUzYy00MDhlLWEwMjgtZDJmYzg2YTY3NjA1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0628731"}},
      "nm0628747":{"uniqueId":"nm0628747","title":"David Wu","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzFiN2JjOGEtODBjNi00MGY1LWEyY2YtY2Y2MzM5OTdhNzBiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0628747"}},
      "nm0849257":{"uniqueId":"nm0849257","title":"Alan Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjM5MzYxZDYtZmQxMy00MjhkLWI4ZTYtYzRhMWRmNjI2MDg4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0849257"}},
      "nm0874874":{"uniqueId":"nm0874874","title":"Wai-Kit Tse","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmMwMTgxZDQtODA4Mi00ZDQxLWJiY2MtYmRjZjVjZGYxMjU1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0874874"}},
      "nm0876600":{"uniqueId":"nm0876600","title":"Wei Tung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmJjMmViMGYtN2NiZC00MDdkLTgyYTEtMzYzNzY5MTJiOTcwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0876600"}},
      "nm0939251":{"uniqueId":"nm0939251","title":"Melvin Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTk2ODI3MzExMl5BMl5BanBnXkFtZTYwNTcwNTAz._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0939251"}},
      "nm0945189":{"uniqueId":"nm0945189","title":"Simon Yam","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTgxNDUyNDEzMl5BMl5BanBnXkFtZTcwMTk4NjAyOA@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0945189"}},
      "nm0950896":{"uniqueId":"nm0950896","title":"Yun-Chiang Peng","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDQwNmM3MDctM2RlYy00OWIyLWJiZmItYTNiZDUxMjc5YTNiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0950896"}},
      "nm0950963":{"uniqueId":"nm0950963","title":"Yee Yung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0950963"}},
      "nm0971063":{"uniqueId":"nm0971063","title":"Chi-Fai Chan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjg2YTAyYTgtZjRmOC00ZmQxLTg4ZTAtYTlmYmFiZTk1ZTI0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0971063"}},
      "nm1022432":{"uniqueId":"nm1022432","title":"K.K. Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1022432"}},
      "nm13815060":{"uniqueId":"nm13815060","title":"Chi-Wah Ma","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm13815060"}},
      "nm13815061":{"uniqueId":"nm13815061","title":"Kong-Kiu Lun","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm13815061"}},
      "nm13815062":{"uniqueId":"nm13815062","title":"Francis","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm13815062"}},
      "nm13815063":{"uniqueId":"nm13815063","title":"Chi-Lam Chan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm13815063"}},
      "nm1425478":{"uniqueId":"nm1425478","title":"Ernst Mausser","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1425478"}},
      "nm1550029":{"uniqueId":"nm1550029","title":"Chun-Kit Lee","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1550029"}},
      "nm1619312":{"uniqueId":"nm1619312","title":"Foo-Wai Lam","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZTIyNDI5MDctYmQ2Ny00YTYzLTk2YWQtNGI5YjAyZTY4Njk3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm1619312"}},
      "nm1816800":{"uniqueId":"nm1816800","title":"Kim Fung Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1816800"}},
      "nm2244815":{"uniqueId":"nm2244815","title":"Tai-Wo Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2244815"}},
      "nm2404650":{"uniqueId":"nm2404650","title":"Yiu-King Lee","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2404650"}},
      "nm2443846":{"uniqueId":"nm2443846","title":"Hsin Liang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2443846"}},
      "nm2486568":{"uniqueId":"nm2486568","title":"Tau Chu","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BODBhY2IzYzMtNDc2MC00ZGRhLTk2ZDgtZjRkYjY1ZTU1OGU1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm2486568"}},
      "nm2531615":{"uniqueId":"nm2531615","title":"Heng Li","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMWEzMmI4MGUtNmYzOS00MjI0LWFhYWItMzA0NTNlMmRlZjE2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm2531615"}},
      "nm2532191":{"uniqueId":"nm2532191","title":"Yung Kwan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYWQ3YjY2NDQtZDYzMi00ZWViLWE4YmYtYzAxNDIyOGUyNDg3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm2532191"}},
      "nm2704001":{"uniqueId":"nm2704001","title":"Chi Man Ho","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDU1YzI3YzMtMDQ5Yy00YmM0LWI5YTAtMjEwMGY1NjBlNGI5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm2704001"}},
      "nm2803223":{"uniqueId":"nm2803223","title":"Yun Ho","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjVlYTMwMjMtNzBjZi00YTc3LWFiOTEtNGU3OGEwYmMzYWQ2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm2803223"}},
      "nm2908077":{"uniqueId":"nm2908077","title":"Man-Chun Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2908077"}},
      "nm3062750":{"uniqueId":"nm3062750","title":"Liang Chiang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm3062750"}},
      "nm3063152":{"uniqueId":"nm3063152","title":"Wai-Man Tam","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm3063152"}},
      "nm3126189":{"uniqueId":"nm3126189","title":"Tsan-Sang Cheung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm3126189"}},
      "nm3472222":{"uniqueId":"nm3472222","title":"Mantic Yiu","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm3472222"}},
      "nm3922396":{"uniqueId":"nm3922396","title":"Kwong-Fai Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm3922396"}},
      "nm3976479":{"uniqueId":"nm3976479","title":"Chik-Sum Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm3976479"}},
      "nm4069609":{"uniqueId":"nm4069609","title":"Kai San","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm4069609"}},
      "nm4740363":{"uniqueId":"nm4740363","title":"Ming-Wai Chan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjU1MGJkNzEtMWYyZC00ODFkLThlMGEtZGNiNDlkZDViY2RjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm4740363"}},
      "nm5317525":{"uniqueId":"nm5317525","title":"Pang Hui","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm5317525"}},
      "nm6401643":{"uniqueId":"nm6401643","title":"Siu Cheung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm6401643"}},
      "nm6401786":{"uniqueId":"nm6401786","title":"Wah-Kon Lee","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm6401786"}}},
    "Cinematographer":{"nm0490486":{"uniqueId":"nm0490486","title":"Moon-Tong Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0490486"}},
      "nm11436615":{"uniqueId":"nm11436615","title":"Chi-Ming Leung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm11436615"}}},
    "Cinematographers":{"nm0490486":{"uniqueId":"nm0490486","title":"Moon-Tong Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0490486"}},
      "nm11436615":{"uniqueId":"nm11436615","title":"Chi-Ming Leung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm11436615"}}},
    "Composer":{"nm0482657":{"uniqueId":"nm0482657","title":"Violet Lam","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0482657"}}},
    "Director":{"nm0156432":{"uniqueId":"nm0156432","title":"Tung Cho 'Joe' Cheung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjk2OWU2MjctMzc3Zi00NmE3LTlkMmYtZTFmOWJiZjMwN2U2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0156432"}}},
    "Makeup Department":{"nm0341344":{"uniqueId":"nm0341344","title":"Rachel Griffin","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0341344"}},
      "nm4984121":{"uniqueId":"nm4984121","title":"Kin-On Siu","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm4984121"}}},
    "Producer":{"nm0849257":{"uniqueId":"nm0849257","title":"Alan Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjM5MzYxZDYtZmQxMy00MjhkLWI4ZTYtYzRhMWRmNjI2MDg4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0849257"}},
      "nm0849331":{"uniqueId":"nm0849331","title":"Rover Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0849331"}},
      "nm2550043":{"uniqueId":"nm2550043","title":"Stanley M. Yeh","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2550043"}}},
    "Producers":{"nm0849257":{"uniqueId":"nm0849257","title":"Alan Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjM5MzYxZDYtZmQxMy00MjhkLWI4ZTYtYzRhMWRmNjI2MDg4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0849257"}},
      "nm0849331":{"uniqueId":"nm0849331","title":"Rover Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0849331"}},
      "nm2550043":{"uniqueId":"nm2550043","title":"Stanley M. Yeh","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2550043"}}},
    "Production Management":{"nm5108288":{"uniqueId":"nm5108288","title":"Mei-Seung Lee","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm5108288"}},
      "nm5109290":{"uniqueId":"nm5109290","title":"Kai-Wing Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm5109290"}}},
    "Production Manager":{"nm5108288":{"uniqueId":"nm5108288","title":"Mei-Seung Lee","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm5108288"}},
      "nm5109290":{"uniqueId":"nm5109290","title":"Kai-Wing Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm5109290"}}},
    "Script and Continuity Department":{"nm0151755":{"uniqueId":"nm0151755","title":"Kuo-Chu Chang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjM1ZjA3NTUtZDFlYS00NzVlLWFkYWMtNTY1NDVlZmZjNTRmXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0151755"}},
      "nm0387341":{"uniqueId":"nm0387341","title":"Lin Ho","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTNlMjAxNmYtYTllYi00ZjBkLTkwNmQtOTMzNDU3MDYzN2ZlXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0387341"}},
      "nm2445533":{"uniqueId":"nm2445533","title":"Tuan Lin","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2445533"}}},
    "Second Unit or Assistant Director":{"nm1224058":{"uniqueId":"nm1224058","title":"Hsiung Huang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1224058"}}},
    "Stunts":{"nm0389883":{"uniqueId":"nm0389883","title":"To-Hoi Kong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0389883"}},
      "nm0477094":{"uniqueId":"nm0477094","title":"Kin-Kwan Poon","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0477094"}},
      "nm0876600":{"uniqueId":"nm0876600","title":"Wei Tung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmJjMmViMGYtN2NiZC00MDdkLTgyYTEtMzYzNzY5MTJiOTcwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0876600"}}},
    "Writer":{"nm0156432":{"uniqueId":"nm0156432","title":"Tung Cho 'Joe' Cheung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjk2OWU2MjctMzc3Zi00NmE3LTlkMmYtZTFmOWJiZjMwN2U2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0156432"}},
      "nm0939182":{"uniqueId":"nm0939182","title":"Wong Kar-Wai","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY4MTQyMjI4NV5BMl5BanBnXkFtZTcwNDk2MzQ2MQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0939182"}}},
    "Writers":{"nm0156432":{"uniqueId":"nm0156432","title":"Tung Cho 'Joe' Cheung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjk2OWU2MjctMzc3Zi00NmE3LTlkMmYtZTFmOWJiZjMwN2U2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0156432"}},
      "nm0939182":{"uniqueId":"nm0939182","title":"Wong Kar-Wai","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY4MTQyMjI4NV5BMl5BanBnXkFtZTcwNDk2MzQ2MQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0939182"}}}}}
''',
];

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (int i = 0; i < qty; i++) {
    results.add('tt010${1000 + i}');
  }
  return results;
}

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    // ignore: discarded_futures
    final future = QueryIMDBCastDetails(criteria).readList();
    futures.add(future);
  }
  return futures;
}

Future<List<MovieResultDTO>> _testRead(List<String> criteria) async {
  // Call IMDB for each criteria in the list.
  final futures = _queueDetailSearch(criteria);

  // Collect the result of all the IMDB queries.
  final queryResult = <MovieResultDTO>[];
  for (final future in futures) {
    queryResult.addAll(await future);
  }
  return queryResult;
}

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBCastDetails test', () {
    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from IMDB', () async {
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);

      // To update expected data, uncomment the following lines
      // printTestData(actualOutput);

      final expectedOutput = expectedDTOList;
      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 50),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryIMDBCastDetails(
        criteria,
      ).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(expectedOutput),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
  });
}
