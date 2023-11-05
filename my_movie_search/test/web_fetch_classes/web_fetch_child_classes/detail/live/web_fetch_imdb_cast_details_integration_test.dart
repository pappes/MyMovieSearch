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
{"uniqueId":"tt0101000","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.title","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"tt0101000"},
  "related":{"Art Direction by:":{"nm0810552":{"uniqueId":"nm0810552","bestSource":"DataSourceType.imdbSuggestions","title":"Petr Smola","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0810552"},"related":{}}},
    "Camera and Electrical Department:":{"nm0463004":{"uniqueId":"nm0463004","bestSource":"DataSourceType.imdbSuggestions","title":"Vladimír Kolár","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0463004"},"related":{}}},
    "Cast:":{"nm0228686":{"uniqueId":"nm0228686","bestSource":"DataSourceType.imdbSuggestions","title":"Nina Divísková","charactorName":"Jirina Havlícková","type":"MovieContentType.person","creditsOrder":"92","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0228686"},"related":{}},
      "nm0275857":{"uniqueId":"nm0275857","bestSource":"DataSourceType.imdbSuggestions","title":"Radka Fiedlerová","charactorName":"Severáková","type":"MovieContentType.person","creditsOrder":"83","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0275857"},"related":{}},
      "nm0366123":{"uniqueId":"nm0366123","bestSource":"DataSourceType.imdbSuggestions","title":"Gábor Harsányi","charactorName":"Havlícek","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0366123"},"related":{}},
      "nm0375865":{"uniqueId":"nm0375865","bestSource":"DataSourceType.imdbSuggestions","title":"Václav Helsus","charactorName":"Kos","type":"MovieContentType.person","creditsOrder":"94","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0375865"},"related":{}},
      "nm0389409":{"uniqueId":"nm0389409","bestSource":"DataSourceType.imdbSuggestions","title":"Drahomíra Hofmanová","charactorName":"Beránková","type":"MovieContentType.person","creditsOrder":"90","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0389409"},"related":{}},
      "nm0398703":{"uniqueId":"nm0398703","bestSource":"DataSourceType.imdbSuggestions","title":"Rudolf Hrusínský","charactorName":"Trvajik","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0398703"},"related":{}},
      "nm0575922":{"uniqueId":"nm0575922","bestSource":"DataSourceType.imdbSuggestions","title":"Tatjana Medvecká","charactorName":"Jolana Marková","type":"MovieContentType.person","creditsOrder":"82","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0575922"},"related":{}},
      "nm0586261":{"uniqueId":"nm0586261","bestSource":"DataSourceType.imdbSuggestions","title":"Alena Mihulová","charactorName":"Miluska","type":"MovieContentType.person","creditsOrder":"85","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0586261"},"related":{}},
      "nm0610846":{"uniqueId":"nm0610846","bestSource":"DataSourceType.imdbSuggestions","title":"Zdenek Mucha","charactorName":"Josef Sulík","type":"MovieContentType.person","creditsOrder":"97","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0610846"},"related":{}},
      "nm0623158":{"uniqueId":"nm0623158","bestSource":"DataSourceType.imdbSuggestions","title":"Oldrich Navrátil","charactorName":"Michal","type":"MovieContentType.person","creditsOrder":"88","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0623158"},"related":{}},
      "nm0637243":{"uniqueId":"nm0637243","bestSource":"DataSourceType.imdbSuggestions","title":"Jan Novotný","charactorName":"Jindra Beránek","type":"MovieContentType.person","creditsOrder":"91","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0637243"},"related":{}},
      "nm0689763":{"uniqueId":"nm0689763","bestSource":"DataSourceType.imdbSuggestions","title":"Bronislav Poloczek","charactorName":"Jarin Bohunek","type":"MovieContentType.person","creditsOrder":"87","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0689763"},"related":{}},
      "nm0810741":{"uniqueId":"nm0810741","bestSource":"DataSourceType.imdbSuggestions","title":"Jitka Smutná","charactorName":"Ivanka Kosová","type":"MovieContentType.person","creditsOrder":"93","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0810741"},"related":{}},
      "nm0814162":{"uniqueId":"nm0814162","bestSource":"DataSourceType.imdbSuggestions","title":"Josef Somr","charactorName":"Havlícek","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0814162"},"related":{}},
      "nm0834684":{"uniqueId":"nm0834684","bestSource":"DataSourceType.imdbSuggestions","title":"Stanislava Strobachová","charactorName":"Sosnová","type":"MovieContentType.person","creditsOrder":"89","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0834684"},"related":{}},
      "nm1077536":{"uniqueId":"nm1077536","bestSource":"DataSourceType.imdbSuggestions","title":"Ivana Novácková","charactorName":"Jolana Marková","type":"MovieContentType.person","creditsOrder":"95","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1077536"},"related":{}},
      "nm1189926":{"uniqueId":"nm1189926","bestSource":"DataSourceType.imdbSuggestions","title":"Jirí Kodes","charactorName":"Severák","type":"MovieContentType.person","creditsOrder":"84","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1189926"},"related":{}},
      "nm2024755":{"uniqueId":"nm2024755","bestSource":"DataSourceType.imdbSuggestions","title":"Miroslava Kolárová","charactorName":"Bohunková","type":"MovieContentType.person","creditsOrder":"86","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2024755"},"related":{}},
      "nm2920414":{"uniqueId":"nm2920414","bestSource":"DataSourceType.imdbSuggestions","title":"Hana Soucková","charactorName":"Sulíková","type":"MovieContentType.person","creditsOrder":"96","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2920414"},"related":{}}},
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
  "related":{"Cast:":{"nm0423271":{"uniqueId":"nm0423271","bestSource":"DataSourceType.imdbSuggestions","title":"Maria Jo","charactorName":"Chung-ah","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0423271"},"related":{}},
      "nm0530839":{"uniqueId":"nm0530839","bestSource":"DataSourceType.imdbSuggestions","title":"Bo-Ming Ma","charactorName":"Jun-sik's daughter","type":"MovieContentType.person","creditsOrder":"97","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0530839"},"related":{}},
      "nm0948072":{"uniqueId":"nm0948072","bestSource":"DataSourceType.imdbSuggestions","title":"Ying-Ying Hui","type":"MovieContentType.person","creditsOrder":"96","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0948072"},"related":{}},
      "nm1293419":{"uniqueId":"nm1293419","bestSource":"DataSourceType.imdbSuggestions","title":"Sha-Li Pai","type":"MovieContentType.person","creditsOrder":"95","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1293419"},"related":{}},
      "nm1903001":{"uniqueId":"nm1903001","bestSource":"DataSourceType.imdbSuggestions","title":"Lai-Fong Cheng","charactorName":"Jun-sik's wife","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1903001"},"related":{}},
      "nm2403022":{"uniqueId":"nm2403022","bestSource":"DataSourceType.imdbSuggestions","title":"Leng-Kuang Yin","type":"MovieContentType.person","creditsOrder":"94","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2403022"},"related":{}},
      "nm7371229":{"uniqueId":"nm7371229","bestSource":"DataSourceType.imdbSuggestions","title":"Fung Chong","charactorName":"Jun-sik","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm7371229"},"related":{}}},
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
    "Cast:":{"nm0150862":{"uniqueId":"nm0150862","bestSource":"DataSourceType.imdbSuggestions","title":"Dennis Chan","charactorName":"Hotel Clerk","type":"MovieContentType.person","creditsOrder":"87","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0150862"},"related":{}},
      "nm0150985":{"uniqueId":"nm0150985","bestSource":"DataSourceType.imdbSuggestions","title":"Kwok-Kuen Chan","type":"MovieContentType.person","creditsOrder":"50","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0150985"},"related":{}},
      "nm0151015":{"uniqueId":"nm0151015","bestSource":"DataSourceType.imdbSuggestions","title":"Mandy Chan","charactorName":"Tung's Thug","type":"MovieContentType.person","creditsOrder":"70","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0151015"},"related":{}},
      "nm0151108":{"uniqueId":"nm0151108","bestSource":"DataSourceType.imdbSuggestions","title":"Stephen C.K. Chan","charactorName":"Drug Dealer","type":"MovieContentType.person","creditsOrder":"85","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0151108"},"related":{}},
      "nm0151866":{"uniqueId":"nm0151866","bestSource":"DataSourceType.imdbSuggestions","title":"Yi Chang","charactorName":"Repairman (Guest star)","type":"MovieContentType.person","creditsOrder":"90","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0151866"},"related":{}},
      "nm0155264":{"uniqueId":"nm0155264","bestSource":"DataSourceType.imdbSuggestions","title":"Jing Chen","charactorName":"Tung","type":"MovieContentType.person","creditsOrder":"86","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0155264"},"related":{}},
      "nm0156564":{"uniqueId":"nm0156564","bestSource":"DataSourceType.imdbSuggestions","title":"Yuk-San Cheung","charactorName":"Police officer","type":"MovieContentType.person","creditsOrder":"61","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0156564"},"related":{}},
      "nm0387370":{"uniqueId":"nm0387370","bestSource":"DataSourceType.imdbSuggestions","title":"Ricky Ho","charactorName":"Peter","type":"MovieContentType.person","creditsOrder":"80","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0387370"},"related":{}},
      "nm0473314":{"uniqueId":"nm0473314","bestSource":"DataSourceType.imdbSuggestions","title":"Feng Ku","charactorName":"Uncle Hung","type":"MovieContentType.person","creditsOrder":"88","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0473314"},"related":{}},
      "nm0490489":{"uniqueId":"nm0490489","bestSource":"DataSourceType.imdbSuggestions","title":"Andy Lau","charactorName":"Wah (Guest star)","type":"MovieContentType.person","creditsOrder":"96","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0490489"},"related":{}},
      "nm0490610":{"uniqueId":"nm0490610","bestSource":"DataSourceType.imdbSuggestions","title":"Shek-Yin Lau","type":"MovieContentType.person","creditsOrder":"55","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0490610"},"related":{}},
      "nm0497213":{"uniqueId":"nm0497213","bestSource":"DataSourceType.imdbSuggestions","title":"Elizabeth Lee","charactorName":"Tsin Siu-Fung","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0497213"},"related":{}},
      "nm0504898":{"uniqueId":"nm0504898","bestSource":"DataSourceType.imdbSuggestions","title":"Pasan Leung","charactorName":"Li Pang's Thug","type":"MovieContentType.person","creditsOrder":"84","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0504898"},"related":{}},
      "nm0516240":{"uniqueId":"nm0516240","bestSource":"DataSourceType.imdbSuggestions","title":"May Mei-Mei Lo","charactorName":"Siu-Lung","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0516240"},"related":{}},
      "nm0519063":{"uniqueId":"nm0519063","bestSource":"DataSourceType.imdbSuggestions","title":"Long Kong","charactorName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"78","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0519063"},"related":{}},
      "nm0628731":{"uniqueId":"nm0628731","bestSource":"DataSourceType.imdbSuggestions","title":"Carrie Ng","charactorName":"Lung's Wife (Guest star)","type":"MovieContentType.person","creditsOrder":"93","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0628731"},"related":{}},
      "nm0628747":{"uniqueId":"nm0628747","bestSource":"DataSourceType.imdbSuggestions","title":"David Wu","charactorName":"David (Guest star)","type":"MovieContentType.person","creditsOrder":"94","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0628747"},"related":{}},
      "nm0849257":{"uniqueId":"nm0849257","bestSource":"DataSourceType.imdbSuggestions","title":"Alan Tang","charactorName":"Lung Ho-Tin","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0849257"},"related":{}},
      "nm0874874":{"uniqueId":"nm0874874","bestSource":"DataSourceType.imdbSuggestions","title":"Wai-Kit Tse","charactorName":"Monster","type":"MovieContentType.person","creditsOrder":"82","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0874874"},"related":{}},
      "nm0876600":{"uniqueId":"nm0876600","bestSource":"DataSourceType.imdbSuggestions","title":"Wei Tung","charactorName":"Cheung Yat-Lui (Guest star)","type":"MovieContentType.person","creditsOrder":"92","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0876600"},"related":{}},
      "nm0939251":{"uniqueId":"nm0939251","bestSource":"DataSourceType.imdbSuggestions","title":"Melvin Wong","charactorName":"Wong (Guest star)","type":"MovieContentType.person","creditsOrder":"95","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0939251"},"related":{}},
      "nm0945189":{"uniqueId":"nm0945189","bestSource":"DataSourceType.imdbSuggestions","title":"Simon Yam","charactorName":"Li Pang","type":"MovieContentType.person","creditsOrder":"97","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0945189"},"related":{}},
      "nm0950896":{"uniqueId":"nm0950896","bestSource":"DataSourceType.imdbSuggestions","title":"Yun-Chiang Peng","charactorName":"Bodyguard","type":"MovieContentType.person","creditsOrder":"63","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0950896"},"related":{}},
      "nm0950963":{"uniqueId":"nm0950963","bestSource":"DataSourceType.imdbSuggestions","title":"Yee Yung","type":"MovieContentType.person","creditsOrder":"47","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0950963"},"related":{}},
      "nm0971063":{"uniqueId":"nm0971063","bestSource":"DataSourceType.imdbSuggestions","title":"Chi-Fai Chan","charactorName":"Yeung Kun","type":"MovieContentType.person","creditsOrder":"89","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0971063"},"related":{}},
      "nm1022432":{"uniqueId":"nm1022432","bestSource":"DataSourceType.imdbSuggestions","title":"K.K. Wong","charactorName":"Orphanage Principal","type":"MovieContentType.person","creditsOrder":"60","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1022432"},"related":{}},
      "nm13815060":{"uniqueId":"nm13815060","bestSource":"DataSourceType.imdbSuggestions","title":"Chi-Wah Ma","type":"MovieContentType.person","creditsOrder":"57","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm13815060"},"related":{}},
      "nm13815061":{"uniqueId":"nm13815061","bestSource":"DataSourceType.imdbSuggestions","title":"Kong-Kiu Lun","type":"MovieContentType.person","creditsOrder":"56","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm13815061"},"related":{}},
      "nm13815062":{"uniqueId":"nm13815062","bestSource":"DataSourceType.imdbSuggestions","title":"Francis","type":"MovieContentType.person","creditsOrder":"52","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm13815062"},"related":{}},
      "nm13815063":{"uniqueId":"nm13815063","bestSource":"DataSourceType.imdbSuggestions","title":"Chi-Lam Chan","type":"MovieContentType.person","creditsOrder":"49","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm13815063"},"related":{}},
      "nm1425478":{"uniqueId":"nm1425478","bestSource":"DataSourceType.imdbSuggestions","title":"Ernst Mausser","charactorName":"Senior Police officer","type":"MovieContentType.person","creditsOrder":"66","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1425478"},"related":{}},
      "nm1550029":{"uniqueId":"nm1550029","bestSource":"DataSourceType.imdbSuggestions","title":"Chun-Kit Lee","charactorName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"77","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1550029"},"related":{}},
      "nm1619312":{"uniqueId":"nm1619312","bestSource":"DataSourceType.imdbSuggestions","title":"Fu-Wai Lam","charactorName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"75","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1619312"},"related":{}},
      "nm1816800":{"uniqueId":"nm1816800","bestSource":"DataSourceType.imdbSuggestions","title":"Kim Fung Wong","charactorName":"Li Pang's Thug","type":"MovieContentType.person","creditsOrder":"83","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm1816800"},"related":{}},
      "nm2244815":{"uniqueId":"nm2244815","bestSource":"DataSourceType.imdbSuggestions","title":"Tai-Wo Tang","charactorName":"Kun's Thug","type":"MovieContentType.person","creditsOrder":"81","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2244815"},"related":{}},
      "nm2404650":{"uniqueId":"nm2404650","bestSource":"DataSourceType.imdbSuggestions","title":"Yiu King Lee","charactorName":"Kun's Thug","type":"MovieContentType.person","creditsOrder":"62","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2404650"},"related":{}},
      "nm2443846":{"uniqueId":"nm2443846","bestSource":"DataSourceType.imdbSuggestions","title":"Hsin Liang","charactorName":"Uncle Bill","type":"MovieContentType.person","creditsOrder":"72","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2443846"},"related":{}},
      "nm2486568":{"uniqueId":"nm2486568","bestSource":"DataSourceType.imdbSuggestions","title":"Tau Chu","charactorName":"Tung's Thug","type":"MovieContentType.person","creditsOrder":"68","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2486568"},"related":{}},
      "nm2531615":{"uniqueId":"nm2531615","bestSource":"DataSourceType.imdbSuggestions","title":"Heng Li","charactorName":"Tung's Thug","type":"MovieContentType.person","creditsOrder":"69","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2531615"},"related":{}},
      "nm2532191":{"uniqueId":"nm2532191","bestSource":"DataSourceType.imdbSuggestions","title":"Yung Kwan","charactorName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"54","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2532191"},"related":{}},
      "nm2704001":{"uniqueId":"nm2704001","bestSource":"DataSourceType.imdbSuggestions","title":"Chi Man Ho","charactorName":"Triad Elder at Funeral","type":"MovieContentType.person","creditsOrder":"73","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2704001"},"related":{}},
      "nm2803223":{"uniqueId":"nm2803223","bestSource":"DataSourceType.imdbSuggestions","title":"Yun Ho","charactorName":"Triad Elder at Funeral","type":"MovieContentType.person","creditsOrder":"74","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2803223"},"related":{}},
      "nm2908077":{"uniqueId":"nm2908077","bestSource":"DataSourceType.imdbSuggestions","title":"Man-Chun Wong","charactorName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"59","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm2908077"},"related":{}},
      "nm3062750":{"uniqueId":"nm3062750","bestSource":"DataSourceType.imdbSuggestions","title":"Liang Chiang","type":"MovieContentType.person","creditsOrder":"51","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3062750"},"related":{}},
      "nm3063152":{"uniqueId":"nm3063152","bestSource":"DataSourceType.imdbSuggestions","title":"Wai-Man Tam","charactorName":"Li Pang's Henchman","type":"MovieContentType.person","creditsOrder":"76","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3063152"},"related":{}},
      "nm3126189":{"uniqueId":"nm3126189","bestSource":"DataSourceType.imdbSuggestions","title":"Tsan-Sang Cheung","charactorName":"Police Officer","type":"MovieContentType.person","creditsOrder":"67","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3126189"},"related":{}},
      "nm3472222":{"uniqueId":"nm3472222","bestSource":"DataSourceType.imdbSuggestions","title":"Mantic Yiu","type":"MovieContentType.person","creditsOrder":"48","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3472222"},"related":{}},
      "nm3922396":{"uniqueId":"nm3922396","bestSource":"DataSourceType.imdbSuggestions","title":"Kwong-Fai Wong","charactorName":"Uncle Bill's Thug","type":"MovieContentType.person","creditsOrder":"79","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3922396"},"related":{}},
      "nm3976479":{"uniqueId":"nm3976479","bestSource":"DataSourceType.imdbSuggestions","title":"Chik-Sum Wong","charactorName":"Tin's Thug (Guest star)","type":"MovieContentType.person","creditsOrder":"91","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm3976479"},"related":{}},
      "nm4069609":{"uniqueId":"nm4069609","bestSource":"DataSourceType.imdbSuggestions","title":"Kai San","type":"MovieContentType.person","creditsOrder":"58","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm4069609"},"related":{}},
      "nm4740363":{"uniqueId":"nm4740363","bestSource":"DataSourceType.imdbSuggestions","title":"Ming-Wai Chan","charactorName":"Tung's Thug","type":"MovieContentType.person","creditsOrder":"71","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm4740363"},"related":{}},
      "nm5317525":{"uniqueId":"nm5317525","bestSource":"DataSourceType.imdbSuggestions","title":"Pang Hui","type":"MovieContentType.person","creditsOrder":"53","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm5317525"},"related":{}},
      "nm6401643":{"uniqueId":"nm6401643","bestSource":"DataSourceType.imdbSuggestions","title":"Siu Cheung","charactorName":"Triad Elder at Funeral","type":"MovieContentType.person","creditsOrder":"64","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm6401643"},"related":{}},
      "nm6401786":{"uniqueId":"nm6401786","bestSource":"DataSourceType.imdbSuggestions","title":"Wah-Kon Lee","charactorName":"Triad Elder at Funeral","type":"MovieContentType.person","creditsOrder":"65","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm6401786"},"related":{}}},
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
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryIMDBCastDetails(criteria).readList(limit: 10);
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
