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
  "related":{"actor":{"nm0366123":{"uniqueId":"nm0366123","title":"Gábor Harsányi","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0366123"}},
      "nm0375865":{"uniqueId":"nm0375865","title":"Václav Helsus","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmYzZGYwNGEtYmRiZS00NzA1LTllODEtMDEzYTgyNTU2YmI3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0375865"}},
      "nm0398703":{"uniqueId":"nm0398703","title":"Rudolf Hrusínský","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYWY1ZTFlZGQtMGFkMy00ZTE1LTkwNzktMGEwMDhiZDQyNzk0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0398703"}},
      "nm0610846":{"uniqueId":"nm0610846","title":"Zdenek Mucha","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzBhYmVkNjktZGJlMC00MGNiLTkyYjUtMWJkYjhlMjY3MDAyXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0610846"}},
      "nm0637243":{"uniqueId":"nm0637243","title":"Jan Novotný","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTViMWQxZmUtN2I2Zi00YmEzLWFhZDktN2Y2MmJjYjZjMGUwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0637243"}},
      "nm0814162":{"uniqueId":"nm0814162","title":"Josef Somr","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDhjM2Q5N2ItZDBmZC00ZGU4LTg1MjEtNGI5ZGExMTNjOTM1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0814162"}}},
    "actress":{"nm0228686":{"uniqueId":"nm0228686","title":"Nina Divísková","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTZiMjQyOWEtNDA1Mi00MTlkLTgxZTItY2YzZjA4N2EwZTBhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0228686"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"where is the missing data!!!!!!!!!","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm0810741":{"uniqueId":"nm0810741","title":"Jitka Smutná","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNmIzNjk1MzMtZjEyYi00OTlhLTgyZGQtNDYwMjI2Y2Q4YjlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0810741"}},
      "nm1077536":{"uniqueId":"nm1077536","title":"Ivana Novácková","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1077536"}},
      "nm2920414":{"uniqueId":"nm2920414","title":"Hana Soucková","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2920414"}}},
    "art_director":{"nm0810552":{"uniqueId":"nm0810552","title":"Petr Smola","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0810552"}}},
    "camera_department":{"nm0463004":{"uniqueId":"nm0463004","title":"Vladimír Kolár","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0463004"}}},
    "cinematographer":{"nm0299592":{"uniqueId":"nm0299592","title":"Juraj Fándli","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0299592"}}},
    "composer":{"nm0880720":{"uniqueId":"nm0880720","title":"Petr Ulrych","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0880720"}}},
    "costume_designer":{"nm0532669":{"uniqueId":"nm0532669","title":"Zuzana Máchová","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0532669"}}},
    "director":{"nm1097284":{"uniqueId":"nm1097284","title":"Peter Hledík","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMWJkOGQ4Y2QtMTNkNS00ZjA2LTk0YjAtODg1NDc4M2ViMDAxXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm1097284"}}},
    "editor":{"nm2919431":{"uniqueId":"nm2919431","title":"Maros Cernák","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2919431"}}},
    "make_up_department":{"nm0833412":{"uniqueId":"nm0833412","title":"Ivo Strangmüller","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0833412"}}},
    "production_manager":{"nm2761158":{"uniqueId":"nm2761158","title":"Kamil Spácil","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNlNjBlMjktN2IxMS00MTgwLTg4NjgtNGM0M2RlOTEwZTA4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm2761158"}}},
    "sound_department":{"nm0468088":{"uniqueId":"nm0468088","title":"Radomír Koutek","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0468088"}}}}}
''',
  r'''
{"uniqueId":"tt0101001","title":"Zai shi feng liu jie","bestSource":"DataSourceType.imdbCast","type":"MovieContentType.movie","year":"1985","yearRange":"1985","runTime":"5340",
      "genres":"[\"Horror\"]",
      "userRating":"4.4","userRatingCount":"9","imageUrl":"https://m.media-amazon.com/images/M/MV5BZTA4ZTNhM2YtZjI1NC00MjJjLTg4ZWMtMGY2ZDIzNWY5Nzk3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbCast":"tt0101001"},
  "related":{"actor":{"nm1293419":{"uniqueId":"nm1293419","title":"Sha-Li Pai","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1293419"}},
      "nm2403022":{"uniqueId":"nm2403022","title":"Leng-Kuang Yin","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2403022"}},
      "nm7371229":{"uniqueId":"nm7371229","title":"Fung Chong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm7371229"}}},
    "actress":{"nm0423271":{"uniqueId":"nm0423271","title":"Maria Jo","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0423271"}},
      "nm0530839":{"uniqueId":"nm0530839","title":"Bo-Ming Ma","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0530839"}},
      "nm0948072":{"uniqueId":"nm0948072","title":"Ying-Ying Hui","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYThjYTY5N2UtMWVmMi00MjllLWIzODUtMjcxZTZkYzkzNDk4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0948072"}},
      "nm1903001":{"uniqueId":"nm1903001","title":"Lai-Fong Cheng","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1903001"}}},
    "director":{"nm0522902":{"uniqueId":"nm0522902","title":"Charles Lowe","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0522902"}}},
    "producer":{"nm4086248":{"uniqueId":"nm4086248","title":"Shi-Kuang Huang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm4086248"}}},
    "production_manager":{"nm7832339":{"uniqueId":"nm7832339","title":"Chin Sima","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm7832339"}}},
    "writer":{"nm0522902":{"uniqueId":"nm0522902","title":"Charles Lowe","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0522902"}},
      "nm7832339":{"uniqueId":"nm7832339","title":"Chin Sima","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm7832339"}}}}}
''',
  r'''
{"uniqueId":"tt0101002","title":"Joi jin gong woo","bestSource":"DataSourceType.imdbCast","type":"MovieContentType.movie","year":"1990","yearRange":"1990","runTime":"6480",
      "genres":"[\"Action\",\"Drama\"]",
      "description":"A well-known gangster is released from prison, and decides look for his daughter with the help of a troubled young woman.",
      "userRating":"6.3","userRatingCount":"187","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTQwNTRjMmUtNzIxMy00YWMxLThjZjEtYjdmN2U4ZTVhNGVlXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbCast":"tt0101002"},
  "related":{"actor":{"nm0490489":{"uniqueId":"nm0490489","title":"Andy Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzQzNDkxMjMxMl5BMl5BanBnXkFtZTYwMzMzODA3._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0490489"}},
      "nm0628747":{"uniqueId":"nm0628747","title":"David Wu","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzFiN2JjOGEtODBjNi00MGY1LWEyY2YtY2Y2MzM5OTdhNzBiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0628747"}},
      "nm0849257":{"uniqueId":"nm0849257","title":"Alan Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjM5MzYxZDYtZmQxMy00MjhkLWI4ZTYtYzRhMWRmNjI2MDg4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0849257"}},
      "nm0876600":{"uniqueId":"nm0876600","title":"Wei Tung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmJjMmViMGYtN2NiZC00MDdkLTgyYTEtMzYzNzY5MTJiOTcwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0876600"}},
      "nm0939251":{"uniqueId":"nm0939251","title":"Melvin Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTk2ODI3MzExMl5BMl5BanBnXkFtZTYwNTcwNTAz._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0939251"}},
      "nm0945189":{"uniqueId":"nm0945189","title":"Simon Yam","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTgxNDUyNDEzMl5BMl5BanBnXkFtZTcwMTk4NjAyOA@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0945189"}},
      "nm3976479":{"uniqueId":"nm3976479","title":"Chik-Sum Wong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm3976479"}}},
    "actress":{"nm0497213":{"uniqueId":"nm0497213","title":"Elizabeth Lee","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDQ3M2UyOGEtMDIwZS00NTI3LWIwZWItODkzODI3YzBmODNiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0497213"}},
      "nm0516240":{"uniqueId":"nm0516240","title":"May Mei-Mei Lo","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BNGUwY2I4MTItMDQ0ZS00NzgxLWJlY2EtNDcxNzYyOTU0NmQ4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0516240"}},
      "nm0628731":{"uniqueId":"nm0628731","title":"Carrie Ng","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BODBlZDJiYWUtOTUzYy00MDhlLWEwMjgtZDJmYzg2YTY3NjA1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0628731"}}},
    "art_director":{"nm0369130":{"uniqueId":"nm0369130","title":"John Hau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0369130"}}},
    "assistant_director":{"nm1224058":{"uniqueId":"nm1224058","title":"Hsiung Huang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm1224058"}}},
    "camera_department":{"nm0508670":{"uniqueId":"nm0508670","title":"Chi-Nin Leung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0508670"}},
      "nm0594224":{"uniqueId":"nm0594224","title":"Kin-Fai Mau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0594224"}},
      "nm10091321":{"uniqueId":"nm10091321","title":"Wai-Kwong Chan","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm10091321"}}},
    "cinematographer":{"nm0490486":{"uniqueId":"nm0490486","title":"Moon-Tong Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0490486"}},
      "nm11436615":{"uniqueId":"nm11436615","title":"Chi-Ming Leung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm11436615"}}},
    "composer":{"nm0482657":{"uniqueId":"nm0482657","title":"Violet Lam","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0482657"}}},
    "director":{"nm0156432":{"uniqueId":"nm0156432","title":"Tung Cho 'Joe' Cheung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjk2OWU2MjctMzc3Zi00NmE3LTlkMmYtZTFmOWJiZjMwN2U2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0156432"}}},
    "make_up_department":{"nm0341344":{"uniqueId":"nm0341344","title":"Rachel Griffin","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0341344"}},
      "nm4984121":{"uniqueId":"nm4984121","title":"Kin-On Siu","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm4984121"}}},
    "miscellaneous":{"nm0849331":{"uniqueId":"nm0849331","title":"Rover Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0849331"}},
      "nm2807214":{"uniqueId":"nm2807214","title":"Ji-Chiang Kuo","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2807214"}},
      "nm9248293":{"uniqueId":"nm9248293","title":"Ming Yip","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm9248293"}}},
    "producer":{"nm0849257":{"uniqueId":"nm0849257","title":"Alan Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjM5MzYxZDYtZmQxMy00MjhkLWI4ZTYtYzRhMWRmNjI2MDg4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0849257"}},
      "nm0849331":{"uniqueId":"nm0849331","title":"Rover Tang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0849331"}},
      "nm2550043":{"uniqueId":"nm2550043","title":"Stanley M. Yeh","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2550043"}}},
    "production_manager":{"nm5108288":{"uniqueId":"nm5108288","title":"Mei-Seung Lee","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm5108288"}},
      "nm5109290":{"uniqueId":"nm5109290","title":"Kai-Wing Lau","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm5109290"}}},
    "script_department":{"nm0151755":{"uniqueId":"nm0151755","title":"Kuo-Chu Chang","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjM1ZjA3NTUtZDFlYS00NzVlLWFkYWMtNTY1NDVlZmZjNTRmXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0151755"}},
      "nm0387341":{"uniqueId":"nm0387341","title":"Lin Ho","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTNlMjAxNmYtYTllYi00ZjBkLTkwNmQtOTMzNDU3MDYzN2ZlXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0387341"}},
      "nm2445533":{"uniqueId":"nm2445533","title":"Tuan Lin","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm2445533"}}},
    "stunts":{"nm0389883":{"uniqueId":"nm0389883","title":"To-Hoi Kong","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0389883"}},
      "nm0477094":{"uniqueId":"nm0477094","title":"Kin-Kwan Poon","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0477094"}},
      "nm0876600":{"uniqueId":"nm0876600","title":"Wei Tung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmJjMmViMGYtN2NiZC00MDdkLTgyYTEtMzYzNzY5MTJiOTcwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0876600"}}},
    "writer":{"nm0156432":{"uniqueId":"nm0156432","title":"Tung Cho 'Joe' Cheung","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjk2OWU2MjctMzc3Zi00NmE3LTlkMmYtZTFmOWJiZjMwN2U2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0156432"}},
      "nm0939182":{"uniqueId":"nm0939182","title":"Wong Kar-Wai","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTY4MTQyMjI4NV5BMl5BanBnXkFtZTcwNDk2MzQ2MQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"nm0939182"}}}}}
''',
];
const expectedDtoJsonStringListold = [
  r'''
{"uniqueId":"tt0101000","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.title","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"tt0101000"},
  "related":{"Art Direction by:":{"nm0810552":{"uniqueId":"nm0810552","bestSource":"DataSourceType.imdbSuggestions","title":"Petr Smola","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0810552"},"related":{}}},
    "Camera and Electrical Department:":{"nm0463004":{"uniqueId":"nm0463004","bestSource":"DataSourceType.imdbSuggestions","title":"Vladimír Kolár","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0463004"},"related":{}}},
    "Cast:":{"nm0228686":{"uniqueId":"nm0228686","bestSource":"DataSourceType.imdbSuggestions","title":"Nina Divísková","characterName":"Jirina Havlícková","type":"MovieContentType.person","creditsOrder":"92","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0228686"},"related":{}},
      "nm0275857":{"uniqueId":"nm0275857","bestSource":"DataSourceType.imdbSuggestions","title":"Radka Fiedlerová","characterName":"Severáková","type":"MovieContentType.person","creditsOrder":"83","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0275857"},"related":{}},
      "nm0366123":{"uniqueId":"nm0366123","bestSource":"DataSourceType.imdbSuggestions","title":"Gábor Harsányi","characterName":"Havlícek","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0366123"},"related":{}},
      "nm0375865":{"uniqueId":"nm0375865","bestSource":"DataSourceType.imdbSuggestions","title":"Václav Helsus","characterName":"Kos","type":"MovieContentType.person","creditsOrder":"94","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0375865"},"related":{}},
      "nm0389409":{"uniqueId":"nm0389409","bestSource":"DataSourceType.imdbSuggestions","title":"Drahomíra Hofmanová","characterName":"Beránková","type":"MovieContentType.person","creditsOrder":"90","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0389409"},"related":{}},
      "nm0398703":{"uniqueId":"nm0398703","bestSource":"DataSourceType.imdbSuggestions","title":"Rudolf Hrusínský","characterName":"Trvajik","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0398703"},"related":{}},
      "nm0575922":{"uniqueId":"nm0575922","bestSource":"DataSourceType.imdbSuggestions","title":"Tatjana Medvecká","characterName":"Jolana Marková","type":"MovieContentType.person","creditsOrder":"82","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0575922"},"related":{}},
      "nm0586261":{"uniqueId":"nm0586261","bestSource":"DataSourceType.imdbSuggestions","title":"Alena Mihulová","characterName":"Miluska","type":"MovieContentType.person","creditsOrder":"85","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0586261"},"related":{}},
      "nm0610846":{"uniqueId":"nm0610846","bestSource":"DataSourceType.imdbSuggestions","title":"Zdenek Mucha","characterName":"Josef Sulík","type":"MovieContentType.person","creditsOrder":"97","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0610846"},"related":{}},
      "nm0623158":{"uniqueId":"nm0623158","bestSource":"DataSourceType.imdbSuggestions","title":"Oldrich Navrátil","characterName":"Michal","type":"MovieContentType.person","creditsOrder":"88","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0623158"},"related":{}},
      "nm0637243":{"uniqueId":"nm0637243","bestSource":"DataSourceType.imdbSuggestions","title":"Jan Novotný","characterName":"Jindra Beránek","type":"MovieContentType.person","creditsOrder":"91","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0637243"},"related":{}},
      "nm0689763":{"uniqueId":"nm0689763","bestSource":"DataSourceType.imdbSuggestions","title":"Bronislav Poloczek","characterName":"Jarin Bohunek","type":"MovieContentType.person","creditsOrder":"87","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0689763"},"related":{}},
      "nm0810741":{"uniqueId":"nm0810741","bestSource":"DataSourceType.imdbSuggestions","title":"Jitka Smutná","characterName":"Ivanka Kosová","type":"MovieContentType.person","creditsOrder":"93","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0810741"},"related":{}},
      "nm0814162":{"uniqueId":"nm0814162","bestSource":"DataSourceType.imdbSuggestions","title":"Josef Somr","characterName":"Havlícek","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0814162"},"related":{}},
      "nm0834684":{"uniqueId":"nm0834684","bestSource":"DataSourceType.imdbSuggestions","title":"Stanislava Strobachová","characterName":"Sosnová","type":"MovieContentType.person","creditsOrder":"89","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0834684"},"related":{}},
      "nm1077536":{"uniqueId":"nm1077536","bestSource":"DataSourceType.imdbSuggestions","title":"Ivana Novácková","characterName":"Jolana Marková","type":"MovieContentType.person","creditsOrder":"95","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1077536"},"related":{}},
      "nm1189926":{"uniqueId":"nm1189926","bestSource":"DataSourceType.imdbSuggestions","title":"Jirí Kodes","characterName":"Severák","type":"MovieContentType.person","creditsOrder":"84","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1189926"},"related":{}},
      "nm2024755":{"uniqueId":"nm2024755","bestSource":"DataSourceType.imdbSuggestions","title":"Miroslava Kolárová","characterName":"Bohunková","type":"MovieContentType.person","creditsOrder":"86","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2024755"},"related":{}},
      "nm2920414":{"uniqueId":"nm2920414","bestSource":"DataSourceType.imdbSuggestions","title":"Hana Soucková","characterName":"Sulíková","type":"MovieContentType.person","creditsOrder":"96","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2920414"},"related":{}}},
    "Cinematography by:":{"nm0299592":{"uniqueId":"nm0299592","bestSource":"DataSourceType.imdbSuggestions","title":"Juraj Fándli","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0299592"},"related":{}}},
    "Costume Design by:":{"nm0532669":{"uniqueId":"nm0532669","bestSource":"DataSourceType.imdbSuggestions","title":"Zuzana Máchová","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0532669"},"related":{}}},
    "Directed by:":{"nm1097284":{"uniqueId":"nm1097284","bestSource":"DataSourceType.imdbSuggestions","title":"Peter Hledík","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1097284"},"related":{}}},
    "Film Editing by:":{"nm2919431":{"uniqueId":"nm2919431","bestSource":"DataSourceType.imdbSuggestions","title":"Maros Cernák","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2919431"},"related":{}}},
    "Music by:":{"nm0880720":{"uniqueId":"nm0880720","bestSource":"DataSourceType.imdbSuggestions","title":"Petr Ulrych","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0880720"},"related":{}}},
    "Production Management:":{"nm2761158":{"uniqueId":"nm2761158","bestSource":"DataSourceType.imdbSuggestions","title":"Kamil Spácil","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2761158"},"related":{}}},
    "Sound Department:":{"nm0468088":{"uniqueId":"nm0468088","bestSource":"DataSourceType.imdbSuggestions","title":"Radomír Koutek","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0468088"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0101001","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.title","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"tt0101001"},
  "related":{"Cast:":{"nm0423271":{"uniqueId":"nm0423271","bestSource":"DataSourceType.imdbSuggestions","title":"Maria Jo","characterName":"Chung-ah","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0423271"},"related":{}},
      "nm0530839":{"uniqueId":"nm0530839","bestSource":"DataSourceType.imdbSuggestions","title":"Bo-Ming Ma","characterName":"Jun-sik's daughter","type":"MovieContentType.person","creditsOrder":"97","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0530839"},"related":{}},
      "nm0948072":{"uniqueId":"nm0948072","bestSource":"DataSourceType.imdbSuggestions","title":"Ying-Ying Hui","type":"MovieContentType.person","creditsOrder":"96","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0948072"},"related":{}},
      "nm1293419":{"uniqueId":"nm1293419","bestSource":"DataSourceType.imdbSuggestions","title":"Sha-Li Pai","type":"MovieContentType.person","creditsOrder":"95","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1293419"},"related":{}},
      "nm1903001":{"uniqueId":"nm1903001","bestSource":"DataSourceType.imdbSuggestions","title":"Lai-Fong Cheng","characterName":"Jun-sik's wife","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1903001"},"related":{}},
      "nm2403022":{"uniqueId":"nm2403022","bestSource":"DataSourceType.imdbSuggestions","title":"Leng-Kuang Yin","type":"MovieContentType.person","creditsOrder":"94","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2403022"},"related":{}},
      "nm7371229":{"uniqueId":"nm7371229","bestSource":"DataSourceType.imdbSuggestions","title":"Fung Chong","characterName":"Jun-sik","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm7371229"},"related":{}}},
    "Directed by:":{"nm0522902":{"uniqueId":"nm0522902","bestSource":"DataSourceType.imdbSuggestions","title":"Charles Lowe","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0522902"},"related":{}}},
    "Produced by:":{"nm4086248":{"uniqueId":"nm4086248","bestSource":"DataSourceType.imdbSuggestions","title":"Shi-Kuang Huang","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm4086248"},"related":{}}},
    "Production Management:":{"nm7832339":{"uniqueId":"nm7832339","bestSource":"DataSourceType.imdbSuggestions","title":"Chin Sima","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm7832339"},"related":{}}},
    "Writing Credits:":{"nm0522902":{"uniqueId":"nm0522902","bestSource":"DataSourceType.imdbSuggestions","title":"Charles Lowe","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0522902"},"related":{}},
      "nm7832339":{"uniqueId":"nm7832339","bestSource":"DataSourceType.imdbSuggestions","title":"Chin Sima","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm7832339"},"related":{}}}}}
''',
  r'''
{"uniqueId":"tt0101002","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.title","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"tt0101002"},
  "related":{"Additional Crew:":{"nm0849331":{"uniqueId":"nm0849331","bestSource":"DataSourceType.imdbSuggestions","title":"Rover Tang","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0849331"},"related":{}},
      "nm2807214":{"uniqueId":"nm2807214","bestSource":"DataSourceType.imdbSuggestions","title":"Ji-Chiang Kuo","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2807214"},"related":{}},
      "nm9248293":{"uniqueId":"nm9248293","bestSource":"DataSourceType.imdbSuggestions","title":"Ming Yip","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm9248293"},"related":{}}},
    "Art Direction by:":{"nm0369130":{"uniqueId":"nm0369130","bestSource":"DataSourceType.imdbSuggestions","title":"John Hau","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0369130"},"related":{}}},
    "Camera and Electrical Department:":{"nm0508670":{"uniqueId":"nm0508670","bestSource":"DataSourceType.imdbSuggestions","title":"Chi-Nin Leung","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0508670"},"related":{}},
      "nm0594224":{"uniqueId":"nm0594224","bestSource":"DataSourceType.imdbSuggestions","title":"Kin-Fai Mau","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0594224"},"related":{}},
      "nm10091321":{"uniqueId":"nm10091321","bestSource":"DataSourceType.imdbSuggestions","title":"Wai-Kwong Chan","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm10091321"},"related":{}}},
    "Cast:":{"nm0150862":{"uniqueId":"nm0150862","bestSource":"DataSourceType.imdbSuggestions","title":"Dennis Chan","characterName":"Hotel Clerk","type":"MovieContentType.person","creditsOrder":"87","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0150862"},"related":{}},
      "nm0150985":{"uniqueId":"nm0150985","bestSource":"DataSourceType.imdbSuggestions","title":"Kwok-Kuen Chan","type":"MovieContentType.person","creditsOrder":"50","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0150985"},"related":{}},
      "nm0151015":{"uniqueId":"nm0151015","bestSource":"DataSourceType.imdbSuggestions","title":"Mandy Chan","characterName":"Tung's Thug","type":"MovieContentType.person","creditsOrder":"70","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0151015"},"related":{}},
      "nm0151108":{"uniqueId":"nm0151108","bestSource":"DataSourceType.imdbSuggestions","title":"Stephen C.K. Chan","characterName":"Drug Dealer","type":"MovieContentType.person","creditsOrder":"85","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0151108"},"related":{}},
      "nm0151866":{"uniqueId":"nm0151866","bestSource":"DataSourceType.imdbSuggestions","title":"Yi Chang","characterName":"Repairman (Guest star)","type":"MovieContentType.person","creditsOrder":"90","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0151866"},"related":{}},
      "nm0155264":{"uniqueId":"nm0155264","bestSource":"DataSourceType.imdbSuggestions","title":"Jing Chen","characterName":"Tung","type":"MovieContentType.person","creditsOrder":"86","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0155264"},"related":{}},
      "nm0156564":{"uniqueId":"nm0156564","bestSource":"DataSourceType.imdbSuggestions","title":"Yuk-San Cheung","characterName":"Police officer","type":"MovieContentType.person","creditsOrder":"61","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0156564"},"related":{}},
      "nm0387370":{"uniqueId":"nm0387370","bestSource":"DataSourceType.imdbSuggestions","title":"Ricky Ho","characterName":"Peter","type":"MovieContentType.person","creditsOrder":"80","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0387370"},"related":{}},
      "nm0473314":{"uniqueId":"nm0473314","bestSource":"DataSourceType.imdbSuggestions","title":"Feng Ku","characterName":"Uncle Hung","type":"MovieContentType.person","creditsOrder":"88","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0473314"},"related":{}},
      "nm0490489":{"uniqueId":"nm0490489","bestSource":"DataSourceType.imdbSuggestions","title":"Andy Lau","characterName":"Wah (Guest star)","type":"MovieContentType.person","creditsOrder":"96","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0490489"},"related":{}},
      "nm0490610":{"uniqueId":"nm0490610","bestSource":"DataSourceType.imdbSuggestions","title":"Shek-Yin Lau","type":"MovieContentType.person","creditsOrder":"55","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0490610"},"related":{}},
      "nm0497213":{"uniqueId":"nm0497213","bestSource":"DataSourceType.imdbSuggestions","title":"Elizabeth Lee","characterName":"Tsin Siu-Fung","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0497213"},"related":{}},
      "nm0504898":{"uniqueId":"nm0504898","bestSource":"DataSourceType.imdbSuggestions","title":"Pasan Leung","characterName":"Li Pang's Thug","type":"MovieContentType.person","creditsOrder":"84","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0504898"},"related":{}},
      "nm0516240":{"uniqueId":"nm0516240","bestSource":"DataSourceType.imdbSuggestions","title":"May Mei-Mei Lo","characterName":"Siu-Lung","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0516240"},"related":{}},
      "nm0519063":{"uniqueId":"nm0519063","bestSource":"DataSourceType.imdbSuggestions","title":"Long Kong","characterName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"78","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0519063"},"related":{}},
      "nm0628731":{"uniqueId":"nm0628731","bestSource":"DataSourceType.imdbSuggestions","title":"Carrie Ng","characterName":"Lung's Wife (Guest star)","type":"MovieContentType.person","creditsOrder":"93","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0628731"},"related":{}},
      "nm0628747":{"uniqueId":"nm0628747","bestSource":"DataSourceType.imdbSuggestions","title":"David Wu","characterName":"David (Guest star)","type":"MovieContentType.person","creditsOrder":"94","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0628747"},"related":{}},
      "nm0849257":{"uniqueId":"nm0849257","bestSource":"DataSourceType.imdbSuggestions","title":"Alan Tang","characterName":"Lung Ho-Tin","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0849257"},"related":{}},
      "nm0874874":{"uniqueId":"nm0874874","bestSource":"DataSourceType.imdbSuggestions","title":"Wai-Kit Tse","characterName":"Monster","type":"MovieContentType.person","creditsOrder":"82","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0874874"},"related":{}},
      "nm0876600":{"uniqueId":"nm0876600","bestSource":"DataSourceType.imdbSuggestions","title":"Wei Tung","characterName":"Cheung Yat-Lui (Guest star)","type":"MovieContentType.person","creditsOrder":"92","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0876600"},"related":{}},
      "nm0939251":{"uniqueId":"nm0939251","bestSource":"DataSourceType.imdbSuggestions","title":"Melvin Wong","characterName":"Wong (Guest star)","type":"MovieContentType.person","creditsOrder":"95","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0939251"},"related":{}},
      "nm0945189":{"uniqueId":"nm0945189","bestSource":"DataSourceType.imdbSuggestions","title":"Simon Yam","characterName":"Li Pang","type":"MovieContentType.person","creditsOrder":"97","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0945189"},"related":{}},
      "nm0950896":{"uniqueId":"nm0950896","bestSource":"DataSourceType.imdbSuggestions","title":"Yun-Chiang Peng","characterName":"Bodyguard","type":"MovieContentType.person","creditsOrder":"63","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0950896"},"related":{}},
      "nm0950963":{"uniqueId":"nm0950963","bestSource":"DataSourceType.imdbSuggestions","title":"Yee Yung","type":"MovieContentType.person","creditsOrder":"47","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0950963"},"related":{}},
      "nm0971063":{"uniqueId":"nm0971063","bestSource":"DataSourceType.imdbSuggestions","title":"Chi-Fai Chan","characterName":"Yeung Kun","type":"MovieContentType.person","creditsOrder":"89","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0971063"},"related":{}},
      "nm1022432":{"uniqueId":"nm1022432","bestSource":"DataSourceType.imdbSuggestions","title":"K.K. Wong","characterName":"Orphanage Principal","type":"MovieContentType.person","creditsOrder":"60","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1022432"},"related":{}},
      "nm13815060":{"uniqueId":"nm13815060","bestSource":"DataSourceType.imdbSuggestions","title":"Chi-Wah Ma","type":"MovieContentType.person","creditsOrder":"57","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm13815060"},"related":{}},
      "nm13815061":{"uniqueId":"nm13815061","bestSource":"DataSourceType.imdbSuggestions","title":"Kong-Kiu Lun","type":"MovieContentType.person","creditsOrder":"56","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm13815061"},"related":{}},
      "nm13815062":{"uniqueId":"nm13815062","bestSource":"DataSourceType.imdbSuggestions","title":"Francis","type":"MovieContentType.person","creditsOrder":"52","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm13815062"},"related":{}},
      "nm13815063":{"uniqueId":"nm13815063","bestSource":"DataSourceType.imdbSuggestions","title":"Chi-Lam Chan","type":"MovieContentType.person","creditsOrder":"49","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm13815063"},"related":{}},
      "nm1425478":{"uniqueId":"nm1425478","bestSource":"DataSourceType.imdbSuggestions","title":"Ernst Mausser","characterName":"Senior Police officer","type":"MovieContentType.person","creditsOrder":"66","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1425478"},"related":{}},
      "nm1550029":{"uniqueId":"nm1550029","bestSource":"DataSourceType.imdbSuggestions","title":"Chun-Kit Lee","characterName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"77","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1550029"},"related":{}},
      "nm1619312":{"uniqueId":"nm1619312","bestSource":"DataSourceType.imdbSuggestions","title":"Fu-Wai Lam","characterName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"75","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1619312"},"related":{}},
      "nm1816800":{"uniqueId":"nm1816800","bestSource":"DataSourceType.imdbSuggestions","title":"Kim Fung Wong","characterName":"Li Pang's Thug","type":"MovieContentType.person","creditsOrder":"83","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1816800"},"related":{}},
      "nm2244815":{"uniqueId":"nm2244815","bestSource":"DataSourceType.imdbSuggestions","title":"Tai-Wo Tang","characterName":"Kun's Thug","type":"MovieContentType.person","creditsOrder":"81","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2244815"},"related":{}},
      "nm2404650":{"uniqueId":"nm2404650","bestSource":"DataSourceType.imdbSuggestions","title":"Yiu King Lee","characterName":"Kun's Thug","type":"MovieContentType.person","creditsOrder":"62","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2404650"},"related":{}},
      "nm2443846":{"uniqueId":"nm2443846","bestSource":"DataSourceType.imdbSuggestions","title":"Hsin Liang","characterName":"Uncle Bill","type":"MovieContentType.person","creditsOrder":"72","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2443846"},"related":{}},
      "nm2486568":{"uniqueId":"nm2486568","bestSource":"DataSourceType.imdbSuggestions","title":"Tau Chu","characterName":"Tung's Thug","type":"MovieContentType.person","creditsOrder":"68","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2486568"},"related":{}},
      "nm2531615":{"uniqueId":"nm2531615","bestSource":"DataSourceType.imdbSuggestions","title":"Heng Li","characterName":"Tung's Thug","type":"MovieContentType.person","creditsOrder":"69","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2531615"},"related":{}},
      "nm2532191":{"uniqueId":"nm2532191","bestSource":"DataSourceType.imdbSuggestions","title":"Yung Kwan","characterName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"54","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2532191"},"related":{}},
      "nm2704001":{"uniqueId":"nm2704001","bestSource":"DataSourceType.imdbSuggestions","title":"Chi Man Ho","characterName":"Triad Elder at Funeral","type":"MovieContentType.person","creditsOrder":"73","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2704001"},"related":{}},
      "nm2803223":{"uniqueId":"nm2803223","bestSource":"DataSourceType.imdbSuggestions","title":"Yun Ho","characterName":"Triad Elder at Funeral","type":"MovieContentType.person","creditsOrder":"74","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2803223"},"related":{}},
      "nm2908077":{"uniqueId":"nm2908077","bestSource":"DataSourceType.imdbSuggestions","title":"Man-Chun Wong","characterName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"59","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2908077"},"related":{}},
      "nm3062750":{"uniqueId":"nm3062750","bestSource":"DataSourceType.imdbSuggestions","title":"Liang Chiang","type":"MovieContentType.person","creditsOrder":"51","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3062750"},"related":{}},
      "nm3063152":{"uniqueId":"nm3063152","bestSource":"DataSourceType.imdbSuggestions","title":"Wai-Man Tam","characterName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"76","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3063152"},"related":{}},
      "nm3126189":{"uniqueId":"nm3126189","bestSource":"DataSourceType.imdbSuggestions","title":"Tsan-Sang Cheung","characterName":"Police Officer","type":"MovieContentType.person","creditsOrder":"67","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3126189"},"related":{}},
      "nm3472222":{"uniqueId":"nm3472222","bestSource":"DataSourceType.imdbSuggestions","title":"Mantic Yiu","type":"MovieContentType.person","creditsOrder":"48","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3472222"},"related":{}},
      "nm3922396":{"uniqueId":"nm3922396","bestSource":"DataSourceType.imdbSuggestions","title":"Kwong-Fai Wong","characterName":"Uncle Bill's Thug","type":"MovieContentType.person","creditsOrder":"79","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3922396"},"related":{}},
      "nm3976479":{"uniqueId":"nm3976479","bestSource":"DataSourceType.imdbSuggestions","title":"Chik-Sum Wong","characterName":"Tin's Thug (Guest star)","type":"MovieContentType.person","creditsOrder":"91","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3976479"},"related":{}},
      "nm4069609":{"uniqueId":"nm4069609","bestSource":"DataSourceType.imdbSuggestions","title":"Kai San","type":"MovieContentType.person","creditsOrder":"58","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm4069609"},"related":{}},
      "nm4740363":{"uniqueId":"nm4740363","bestSource":"DataSourceType.imdbSuggestions","title":"Ming-Wai Chan","characterName":"Tung's Thug","type":"MovieContentType.person","creditsOrder":"71","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm4740363"},"related":{}},
      "nm5317525":{"uniqueId":"nm5317525","bestSource":"DataSourceType.imdbSuggestions","title":"Pang Hui","type":"MovieContentType.person","creditsOrder":"53","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm5317525"},"related":{}},
      "nm6401643":{"uniqueId":"nm6401643","bestSource":"DataSourceType.imdbSuggestions","title":"Siu Cheung","characterName":"Triad Elder at Funeral","type":"MovieContentType.person","creditsOrder":"64","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm6401643"},"related":{}},
      "nm6401786":{"uniqueId":"nm6401786","bestSource":"DataSourceType.imdbSuggestions","title":"Wah-Kon Lee","characterName":"Triad Elder at Funeral","type":"MovieContentType.person","creditsOrder":"65","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm6401786"},"related":{}}},
    "Cinematography by:":{"nm0490486":{"uniqueId":"nm0490486","bestSource":"DataSourceType.imdbSuggestions","title":"Moon-Tong Lau","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0490486"},"related":{}},
      "nm11436615":{"uniqueId":"nm11436615","bestSource":"DataSourceType.imdbSuggestions","title":"Chi-Ming Leung","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm11436615"},"related":{}}},
    "Directed by:":{"nm0156432":{"uniqueId":"nm0156432","bestSource":"DataSourceType.imdbSuggestions","title":"Tung Cho 'Joe' Cheung","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0156432"},"related":{}}},
    "Makeup Department:":{"nm0341344":{"uniqueId":"nm0341344","bestSource":"DataSourceType.imdbSuggestions","title":"Rachel Griffin","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0341344"},"related":{}},
      "nm4984121":{"uniqueId":"nm4984121","bestSource":"DataSourceType.imdbSuggestions","title":"Kin-On Siu","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm4984121"},"related":{}}},
    "Music by:":{"nm0482657":{"uniqueId":"nm0482657","bestSource":"DataSourceType.imdbSuggestions","title":"Man-Yee Lam","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0482657"},"related":{}}},
    "Produced by:":{"nm0849257":{"uniqueId":"nm0849257","bestSource":"DataSourceType.imdbSuggestions","title":"Alan Tang","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0849257"},"related":{}},
      "nm0849331":{"uniqueId":"nm0849331","bestSource":"DataSourceType.imdbSuggestions","title":"Rover Tang","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0849331"},"related":{}},
      "nm2550043":{"uniqueId":"nm2550043","bestSource":"DataSourceType.imdbSuggestions","title":"Stanley M. Yeh","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2550043"},"related":{}}},
    "Production Management:":{"nm5108288":{"uniqueId":"nm5108288","bestSource":"DataSourceType.imdbSuggestions","title":"Mei-Seung Lee","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm5108288"},"related":{}},
      "nm5109290":{"uniqueId":"nm5109290","bestSource":"DataSourceType.imdbSuggestions","title":"Kai-Wing Lau","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm5109290"},"related":{}}},
    "Script and Continuity Department:":{"nm0151755":{"uniqueId":"nm0151755","bestSource":"DataSourceType.imdbSuggestions","title":"Kuo-Chu Chang","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0151755"},"related":{}},
      "nm0387341":{"uniqueId":"nm0387341","bestSource":"DataSourceType.imdbSuggestions","title":"Lin Ho","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0387341"},"related":{}},
      "nm2445533":{"uniqueId":"nm2445533","bestSource":"DataSourceType.imdbSuggestions","title":"Tuan Lin","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2445533"},"related":{}}},
    "Second Unit Director or Assistant Director:":{"nm1224058":{"uniqueId":"nm1224058","bestSource":"DataSourceType.imdbSuggestions","title":"Hsiung Huang","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1224058"},"related":{}}},
    "Stunts:":{"nm0389883":{"uniqueId":"nm0389883","bestSource":"DataSourceType.imdbSuggestions","title":"To-Hoi Kong","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0389883"},"related":{}},
      "nm0477094":{"uniqueId":"nm0477094","bestSource":"DataSourceType.imdbSuggestions","title":"Kin-Kwan Poon","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0477094"},"related":{}},
      "nm0876600":{"uniqueId":"nm0876600","bestSource":"DataSourceType.imdbSuggestions","title":"Wei Tung","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0876600"},"related":{}}},
    "Writing Credits:":{"nm0156432":{"uniqueId":"nm0156432","bestSource":"DataSourceType.imdbSuggestions","title":"Tung Cho 'Joe' Cheung","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0156432"},"related":{}},
      "nm0939182":{"uniqueId":"nm0939182","bestSource":"DataSourceType.imdbSuggestions","title":"Kar-Wai Wong","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0939182"},"related":{}}}}}
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
