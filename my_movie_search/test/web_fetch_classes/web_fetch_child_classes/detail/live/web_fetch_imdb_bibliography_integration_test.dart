import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_bibliography.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm0101000","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0101000"},
  "related":{"Camera and Electrical Department":{"tt0065802":{"uniqueId":"tt0065802","bestSource":"DataSourceType.imdbSuggestions","title":"Guess What We Learned in School Today?","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0065802"}},
      "tt0065916":{"uniqueId":"tt0065916","bestSource":"DataSourceType.imdbSuggestions","title":"Joe","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0065916"}},
      "tt0066960":{"uniqueId":"tt0066960","bestSource":"DataSourceType.imdbSuggestions","title":"Cry Uncle","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0066960"}},
      "tt0067981":{"uniqueId":"tt0067981","bestSource":"DataSourceType.imdbSuggestions","title":"Who Killed Mary Whats'ername?","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0067981"}},
      "tt0071583":{"uniqueId":"tt0071583","bestSource":"DataSourceType.imdbSuggestions","title":"The Groove Tube","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0071583"}},
      "tt0073006":{"uniqueId":"tt0073006","bestSource":"DataSourceType.imdbSuggestions","title":"Foreplay","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0073006"}},
      "tt0138121":{"uniqueId":"tt0138121","bestSource":"DataSourceType.imdbSuggestions","title":"Sweet Savior","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0138121"}},
      "tt0197683":{"uniqueId":"tt0197683","bestSource":"DataSourceType.imdbSuggestions","title":"The Mind Blowers","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0197683"}},
      "tt12109664":{"uniqueId":"tt12109664","bestSource":"DataSourceType.imdbSuggestions","title":"Annapolis: The First Year","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt12109664"}}},
    "Cinematographer":{"tt0068006":{"uniqueId":"tt0068006","bestSource":"DataSourceType.imdbSuggestions","title":"You've Got to Walk It Like You Talk It or You'll Lose That Beat","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0068006"}},
      "tt0070232":{"uniqueId":"tt0070232","bestSource":"DataSourceType.imdbSuggestions","title":"It Happened in Hollywood","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0070232"}},
      "tt0176357":{"uniqueId":"tt0176357","bestSource":"DataSourceType.imdbSuggestions","title":"American Playhouse","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0176357"}},
      "tt0210031":{"uniqueId":"tt0210031","bestSource":"DataSourceType.imdbSuggestions","title":"Events","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0210031"}},
      "tt0247772":{"uniqueId":"tt0247772","bestSource":"DataSourceType.imdbSuggestions","title":"Thank You, M'am","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0247772"}},
      "tt0259021":{"uniqueId":"tt0259021","bestSource":"DataSourceType.imdbSuggestions","title":"Swingtail","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0259021"}},
      "tt12112308":{"uniqueId":"tt12112308","bestSource":"DataSourceType.imdbSuggestions","title":"Naval Academy - One","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt12112308"}}}}}
''',
  r'''
{"uniqueId":"nm0101001","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0101001"},
  "related":{"Actor":{"tt0185830":{"uniqueId":"tt0185830","bestSource":"DataSourceType.imdbSuggestions","title":"Vintage Reds","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0185830"}}},
    "Archive footage":{"tt4809740":{"uniqueId":"tt4809740","bestSource":"DataSourceType.imdbSuggestions","title":"2015 FIFA Women's World Cup","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt4809740"}},
      "tt5371446":{"uniqueId":"tt5371446","bestSource":"DataSourceType.imdbSuggestions","title":"Final Score","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt5371446"}}},
    "Self":{"tt0135733":{"uniqueId":"tt0135733","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0135733"}},
      "tt0140762":{"uniqueId":"tt0140762","bestSource":"DataSourceType.imdbSuggestions","title":"The Search for the Holy Grail","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0140762"}},
      "tt0182643":{"uniqueId":"tt0182643","bestSource":"DataSourceType.imdbSuggestions","title":"Talk of the Devils","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0182643"}},
      "tt0191679":{"uniqueId":"tt0191679","bestSource":"DataSourceType.imdbSuggestions","title":"The Boss, the Players, and You","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0191679"}},
      "tt0191691":{"uniqueId":"tt0191691","bestSource":"DataSourceType.imdbSuggestions","title":"Friday Supplement","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0191691"}},
      "tt0300177":{"uniqueId":"tt0300177","bestSource":"DataSourceType.imdbSuggestions","title":"Manchester United: Beyond the Promised Land","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0300177"}},
      "tt0421396":{"uniqueId":"tt0421396","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day 2","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0421396"}},
      "tt0445887":{"uniqueId":"tt0445887","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day FA Cup","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0445887"}},
      "tt0962884":{"uniqueId":"tt0962884","bestSource":"DataSourceType.imdbSuggestions","title":"Football Focus","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0962884"}},
      "tt12464282":{"uniqueId":"tt12464282","bestSource":"DataSourceType.imdbSuggestions","title":"Vanarama National League Highlights Show","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt12464282"}},
      "tt12734666":{"uniqueId":"tt12734666","bestSource":"DataSourceType.imdbSuggestions","title":"Late Kick Off North East and Cumbria","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt12734666"}},
      "tt14201318":{"uniqueId":"tt14201318","bestSource":"DataSourceType.imdbSuggestions","title":"MOTD2 Extra","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt14201318"}},
      "tt15012446":{"uniqueId":"tt15012446","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day Live: The Championship","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt15012446"}},
      "tt15012458":{"uniqueId":"tt15012458","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day Live: Premier League","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt15012458"}},
      "tt15078074":{"uniqueId":"tt15078074","bestSource":"DataSourceType.imdbSuggestions","title":"BBC Sport: Africa Cup of Nations 2010","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt15078074"}},
      "tt15095776":{"uniqueId":"tt15095776","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day: Euro 2020","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt15095776"}},
      "tt16709676":{"uniqueId":"tt16709676","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day: Euro 2012","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt16709676"}},
      "tt1747648":{"uniqueId":"tt1747648","bestSource":"DataSourceType.imdbSuggestions","title":"The Football League Show","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt1747648"}},
      "tt1927606":{"uniqueId":"tt1927606","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day: 2010 FIFA World Cup","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt1927606"}},
      "tt20778538":{"uniqueId":"tt20778538","bestSource":"DataSourceType.imdbSuggestions","title":"Channel 4 Sport: England International Football","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt20778538"}},
      "tt21038766":{"uniqueId":"tt21038766","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day: 2014 FIFA World Cup","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt21038766"}},
      "tt22897970":{"uniqueId":"tt22897970","bestSource":"DataSourceType.imdbSuggestions","title":"Amazon Prime Video: Every Game, Every Goal","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt22897970"}},
      "tt23769844":{"uniqueId":"tt23769844","bestSource":"DataSourceType.imdbSuggestions","title":"Match of the Day Live: FIFA World Cup Qatar 2022","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt23769844"}},
      "tt2418842":{"uniqueId":"tt2418842","bestSource":"DataSourceType.imdbSuggestions","title":"The League Cup Show","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt2418842"}},
      "tt4569792":{"uniqueId":"tt4569792","bestSource":"DataSourceType.imdbSuggestions","title":"The Women's Football Show","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt4569792"}},
      "tt4809740":{"uniqueId":"tt4809740","bestSource":"DataSourceType.imdbSuggestions","title":"2015 FIFA Women's World Cup","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt4809740"}},
      "tt4906718":{"uniqueId":"tt4906718","bestSource":"DataSourceType.imdbSuggestions","title":"Women's FA Cup","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt4906718"}},
      "tt5371446":{"uniqueId":"tt5371446","bestSource":"DataSourceType.imdbSuggestions","title":"Final Score","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt5371446"}},
      "tt5959044":{"uniqueId":"tt5959044","bestSource":"DataSourceType.imdbSuggestions","title":"The Premier League Show","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt5959044"}},
      "tt6497894":{"uniqueId":"tt6497894","bestSource":"DataSourceType.imdbSuggestions","title":"Football World Cup","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt6497894"}},
      "tt7092750":{"uniqueId":"tt7092750","bestSource":"DataSourceType.imdbSuggestions","title":"Summer of Sport: Women's Euro 2017","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt7092750"}},
      "tt7653274":{"uniqueId":"tt7653274","bestSource":"DataSourceType.imdbSuggestions","title":"All or Nothing: Manchester City","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt7653274"}}}}}
''',
  r'''
{"uniqueId":"nm0101002","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.person","sources":{"DataSourceType.imdbSuggestions":"nm0101002"},
  "related":{"Actor":{"tt0077008":{"uniqueId":"tt0077008","bestSource":"DataSourceType.imdbSuggestions","title":"Fantasy Island","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0077008"}},
      "tt0080424":{"uniqueId":"tt0080424","bestSource":"DataSourceType.imdbSuggestions","title":"Belle Starr","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0080424"}},
      "tt0081940":{"uniqueId":"tt0081940","bestSource":"DataSourceType.imdbSuggestions","title":"Strike Force","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0081940"}},
      "tt0086859":{"uniqueId":"tt0086859","bestSource":"DataSourceType.imdbSuggestions","title":"Against All Odds","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0086859"}}},
    "Stunts":{"tt0083805":{"uniqueId":"tt0083805","bestSource":"DataSourceType.imdbSuggestions","title":"Death Valley","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0083805"}},
      "tt0085756":{"uniqueId":"tt0085756","bestSource":"DataSourceType.imdbSuggestions","title":"Jimmy the Kid","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0085756"}},
      "tt0088115":{"uniqueId":"tt0088115","bestSource":"DataSourceType.imdbSuggestions","title":"Silence of the Heart","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0088115"}}}}}
''',
];

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (int i = 0; i < qty; i++) {
    results.add('nm010${1000 + i}');
  }
  return results;
}

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    final future = QueryIMDBBibliographyDetails(criteria).readList();
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

  group('live QueryIMDBBibliographyDetails test', () {
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
  });
}
