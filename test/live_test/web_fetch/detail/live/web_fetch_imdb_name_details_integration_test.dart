import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:quiver/iterables.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBNameDetails test', () {
    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from IMDB', () async {
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);

      // To update expected data, uncomment the following lines
      // printTestData(actualOutput, includeRelated: true);

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
      final actualOutput = await QueryIMDBNameDetails(
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

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (final i in range(0, qty + 1)) {
    results.add('nm010${1000 + i}');
  }
  return results;
}

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    final future = QueryIMDBNameDetails(criteria).readList();
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

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm0101000","title":"Steve Bower","bestSource":"DataSourceType.imdb","type":"MovieContentType.person",
      "description":"Steve Bower is known for Sweet Savior (1971) and Joe (1970).","sources":{"DataSourceType.imdb":"nm0101000"},
  "related":{"Camera and Electrical Department:":{"tt0065802":{"uniqueId":"tt0065802","title":"Guess What We Learned in School Today?","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1970","yearRange":"1970","runTime":"5760",
      "genres":"[\"Comedy\"]",
      "userRating":"4.1","userRatingCount":"322","censorRating":"CensorRatingType.adult","imageUrl":"https://m.media-amazon.com/images/M/MV5BZGIwZjMzNTUtNDJkZS00OTM4LTgyOWItNDNlYWY2NGJmMWQ1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0065802"}},
      "tt0065916":{"uniqueId":"tt0065916","title":"Joe","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1970","yearRange":"1970","runTime":"6420",
      "genres":"[\"Drama\",\"Thriller\"]",
      "userRating":"6.8","userRatingCount":"4973","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmM0NzlkNjMtMDMzZS00NWFiLWJhNjgtNDE3YmJhMTIwMjVlXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0065916"}},
      "tt0066960":{"uniqueId":"tt0066960","title":"Super Dick","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":"Cry Uncle","type":"MovieContentType.movie","year":"1971","yearRange":"1971","runTime":"5220",
      "genres":"[\"Comedy\",\"Crime\",\"Mystery\"]",
      "userRating":"4.9","userRatingCount":"766","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BZWQ1NTVkYmQtMmZkZS00YjczLTllNDMtOTI3ZDNlMmE3Mzc3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0066960"}},
      "tt0067981":{"uniqueId":"tt0067981","title":"Who Killed Mary Whats'ername?","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1971","yearRange":"1971","runTime":"5400",
      "genres":"[\"Crime\",\"Mystery\",\"Thriller\"]",
      "userRating":"6.0","userRatingCount":"226","censorRating":"CensorRatingType.kids","imageUrl":"https://m.media-amazon.com/images/M/MV5BMWY5YWY5NWItY2ZhOS00OTBmLWJhZDItZGYxMDY5ZWUyNDY4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0067981"}},
      "tt0071583":{"uniqueId":"tt0071583","title":"The Groove Tube","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1974","yearRange":"1974","runTime":"4500",
      "genres":"[\"Comedy\"]",
      "userRating":"5.8","userRatingCount":"2463","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDFhMTdkODctZTdiZi00NGFkLTk4YjEtYzVmZDY3ZWRiYWYwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0071583"}},
      "tt0073006":{"uniqueId":"tt0073006","title":"Foreplay","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1975","yearRange":"1975","runTime":"4500",
      "genres":"[\"Comedy\"]",
      "userRating":"3.9","userRatingCount":"208","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjc1OWQ5YzctYWU1Zi00NThmLWI5MDItYmZhOWEwN2ZkNGE2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0073006"}},
      "tt0138121":{"uniqueId":"tt0138121","title":"Sweet Savior","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1971","yearRange":"1971","runTime":"5520",
      "genres":"[\"Crime\",\"Drama\",\"Horror\"]",
      "userRating":"4.1","userRatingCount":"252","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BN2MxYjEzM2UtMmNjMy00MzEzLThiYjctOWJjNWUzYzFlYWNjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0138121"}},
      "tt0197683":{"uniqueId":"tt0197683","title":"The Mind Blowers","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1969","yearRange":"1969","runTime":"4080",
      "genres":"[\"Comedy\",\"Fantasy\"]",
      "userRating":"3.5","userRatingCount":"19","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTA3OWZjNmUtMmQ3My00YTM5LTg0YjktYTBiMWEzMjQ2MDE1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0197683"}},
      "tt12109664":{"uniqueId":"tt12109664","title":"Annapolis: The First Year","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.short","year":"1973","yearRange":"1973","runTime":"1260",
      "genres":"[\"Documentary\",\"Short\"]","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjg4YzZlM2UtYTg0Mi00YzI4LWFhNDMtNjZjNTY3YTg4ZTNhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt12109664"}}},
    "Cinematographer:":{"tt0068006":{"uniqueId":"tt0068006","title":"You've Got to Walk It Like You Talk It or You'll Lose That Beat","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1971","yearRange":"1971","runTime":"5100",
      "genres":"[\"Drama\",\"Comedy\"]",
      "userRating":"5.2","userRatingCount":"94","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjkxN2ZjNDItYzQ4My00YzQ4LTkzOWItNGRkYzBiYWY5NTg5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0068006"}},
      "tt0070232":{"uniqueId":"tt0070232","title":"It Happened in Hollywood","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1973","yearRange":"1973","runTime":"4080",
      "genres":"[\"Adult\",\"Comedy\"]",
      "userRating":"6.4","userRatingCount":"74","censorRating":"CensorRatingType.adult","sources":{"DataSourceType.imdbSuggestions":"tt0070232"}},
      "tt0176357":{"uniqueId":"tt0176357","title":"American Playhouse","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"1980","yearRange":"1980-1994","runTime":"3660",
      "genres":"[\"Drama\"]",
      "userRating":"7.3","userRatingCount":"456","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjUzNjdlNWMtMjg5ZS00NTFlLWI3NjAtZTg4NDM5OWJmYmUwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0176357"}},
      "tt0210031":{"uniqueId":"tt0210031","title":"Events","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1970","yearRange":"1970","runTime":"5040",
      "genres":"[\"Drama\"]",
      "userRating":"5.0","userRatingCount":"43","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjkxNDg0ODA4OV5BMl5BanBnXkFtZTgwNDEzOTk1MDE@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0210031"}},
      "tt0247772":{"uniqueId":"tt0247772","title":"Thank You, M'am","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.short","year":"1977","yearRange":"1977","runTime":"840",
      "genres":"[\"Short\",\"Drama\",\"Family\"]",
      "userRating":"7.6","userRatingCount":"16","sources":{"DataSourceType.imdbSuggestions":"tt0247772"}},
      "tt0259021":{"uniqueId":"tt0259021","title":"Swingtail","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1969","yearRange":"1969","runTime":"3900",
      "userRating":"2.6","userRatingCount":"10","censorRating":"CensorRatingType.adult","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTNmNDk1YmQtYzMyMi00YjU4LTgwYWEtYmNlMDRiN2Y2MjIxXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0259021"}},
      "tt12112308":{"uniqueId":"tt12112308","title":"Naval Academy - One","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.short","year":"1971","yearRange":"1971","runTime":"780",
      "genres":"[\"Documentary\",\"Short\"]","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbSuggestions":"tt12112308"}},
      "tt36119418":{"uniqueId":"tt36119418","title":"Drama: Paralyze","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.custom","year":"1985","yearRange":"1985","runTime":"300",
      "genres":"[\"Music\"]","sources":{"DataSourceType.imdbSuggestions":"tt36119418"}}}}}
''',
  r'''
{"uniqueId":"nm0101001","title":"Steve Bower","bestSource":"DataSourceType.imdb","type":"MovieContentType.person",
      "description":"Steve Bower is known for Amazon Prime Video: Every Game, Every Goal (2019), Vintage Reds (1998) and Late Kick Off North East and Cumbria (2010).","sources":{"DataSourceType.imdb":"nm0101001"},
  "related":{"Actor:":{"tt0185830":{"uniqueId":"tt0185830","title":"Vintage Reds","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"1998","yearRange":"1998","sources":{"DataSourceType.imdbSuggestions":"tt0185830"}}},
    "Self:":{"tt0135733":{"uniqueId":"tt0135733","title":"Match of the Day","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"1964","yearRange":"1964","runTime":"4200",
      "genres":"[\"News\",\"Sport\"]",
      "userRating":"8.5","userRatingCount":"2801","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTY4NmU1M2EtNzQ4NC00ZTU2LTk5NTMtNmVlYWQ5NjVhNjFjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0135733"}},
      "tt0421396":{"uniqueId":"tt0421396","title":"Match of the Day 2","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2004","yearRange":"2004-2025","runTime":"2700",
      "genres":"[\"Sport\"]",
      "userRating":"7.6","userRatingCount":"1075","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDMyMWRhNmYtNmE5Mi00ODE2LWJjYjAtYmI5Yzk3MjA1Yzg5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0421396"}},
      "tt0445887":{"uniqueId":"tt0445887","title":"Match of the Day FA Cup","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2001","yearRange":"2001",
      "genres":"[\"Sport\"]",
      "userRating":"7.9","userRatingCount":"90","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzMyMmVlNWQtNDRkNS00Mjk0LTk5ODItOTNkNDMzNWFmYjAwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0445887"}},
      "tt0962884":{"uniqueId":"tt0962884","title":"Football Focus","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2001","yearRange":"2001",
      "genres":"[\"Sport\",\"Talk-Show\"]",
      "userRating":"6.0","userRatingCount":"186","imageUrl":"https://m.media-amazon.com/images/M/MV5BNWU3NjYyZGUtNWM4My00MmU2LTg0NjktZmYyZmVhZjI1Yzk0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0962884"}},
      "tt12464282":{"uniqueId":"tt12464282","title":"Vanarama National League Highlights Show","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2015","yearRange":"2015",
      "genres":"[\"Sport\"]","imageUrl":"https://m.media-amazon.com/images/M/MV5BODBjMzFkYTItYzE1YS00MjczLTgzNzItNmJkMzJiNzQxYzU3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt12464282"}},
      "tt15012458":{"uniqueId":"tt15012458","title":"Match of the Day Live: Premier League","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2020","yearRange":"2020",
      "genres":"[\"Sport\"]","sources":{"DataSourceType.imdbSuggestions":"tt15012458"}},
      "tt15095776":{"uniqueId":"tt15095776","title":"Match of the Day: Euro 2020","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.miniseries","year":"2021","yearRange":"2021-2021",
      "genres":"[\"Sport\"]","sources":{"DataSourceType.imdbSuggestions":"tt15095776"}},
      "tt16283186":{"uniqueId":"tt16283186","title":"Amazon Prime: Premier League","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2019","yearRange":"2019-2024",
      "genres":"[\"Sport\"]","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmMxNjRjZDgtOWRkMi00ZTk4LWIyZDMtY2ZkYzIzZjU1NWRmXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt16283186"}},
      "tt20778538":{"uniqueId":"tt20778538","title":"Channel 4 Sport: England International Football","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2022","yearRange":"2022",
      "genres":"[\"Sport\"]","sources":{"DataSourceType.imdbSuggestions":"tt20778538"}},
      "tt22897970":{"uniqueId":"tt22897970","title":"Amazon Prime Video: Every Game, Every Goal","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2019","yearRange":"2019-2024",
      "genres":"[\"Sport\"]","sources":{"DataSourceType.imdbSuggestions":"tt22897970"}},
      "tt23769844":{"uniqueId":"tt23769844","title":"Match of the Day Live: FIFA World Cup Qatar 2022","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.miniseries","year":"2022","yearRange":"2022-2022",
      "genres":"[\"Sport\"]",
      "userRating":"6.1","userRatingCount":"22","imageUrl":"https://m.media-amazon.com/images/M/MV5BM2NiODY0YjEtNjA3MC00NmI5LTlkYzUtMDk5MzNjMjc2ZTFkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt23769844"}},
      "tt32622080":{"uniqueId":"tt32622080","title":"Match of the Day Live: UEFA Euro 2024","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.miniseries","year":"2024","yearRange":"2024-2024",
      "genres":"[\"Sport\"]",
      "userRating":"5.8","userRatingCount":"11","sources":{"DataSourceType.imdbSuggestions":"tt32622080"}},
      "tt33253174":{"uniqueId":"tt33253174","title":"Motd@60","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.short","year":"2024","yearRange":"2024","runTime":"1680",
      "genres":"[\"Documentary\",\"Sport\"]",
      "userRating":"6.8","userRatingCount":"8","sources":{"DataSourceType.imdbSuggestions":"tt33253174"}},
      "tt4809740":{"uniqueId":"tt4809740","title":"2015 FIFA Women's World Cup","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2015","yearRange":"2015-2015","runTime":"5400",
      "genres":"[\"Sport\"]",
      "userRating":"6.6","userRatingCount":"45","imageUrl":"https://m.media-amazon.com/images/M/MV5BMWQxYWI2Y2ItMTg0MS00NDYxLWJlOTgtY2EwOWE0NzVhYzYzXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt4809740"}},
      "tt5371446":{"uniqueId":"tt5371446","title":"Final Score","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2001","yearRange":"2001",
      "genres":"[\"News\",\"Sport\"]",
      "userRating":"7.0","userRatingCount":"53","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjlhMTE1NTgtNmUzMy00MDZmLTgwYWItOGUzYmE0NDRiYjU0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt5371446"}},
      "tt5959044":{"uniqueId":"tt5959044","title":"The Premier League Show","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2016","yearRange":"2016",
      "genres":"[\"Sport\"]",
      "userRating":"5.7","userRatingCount":"25","imageUrl":"https://m.media-amazon.com/images/M/MV5BYThhYTJiZTUtZjFjOC00ZTk2LWFkZWQtODQ2OTYxOTI0OTg5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt5959044"}},
      "tt7653274":{"uniqueId":"tt7653274","title":"All or Nothing: Manchester City","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.miniseries","year":"2018","yearRange":"2018-2018","runTime":"3000",
      "genres":"[\"Documentary\",\"Reality-TV\",\"Sport\"]",
      "userRating":"8.1","userRatingCount":"8088","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTgwNjYyNzAyOF5BMl5BanBnXkFtZTgwNjAyMjAwNjM@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt7653274"}}}}}
''',
  r'''
{"uniqueId":"nm0101002","title":"Stone Bower","bestSource":"DataSourceType.imdb","type":"MovieContentType.person",
      "description":"Stone Bower is known for Against All Odds (1984), Death Valley (1981) and Jimmy the Kid (1982).","sources":{"DataSourceType.imdb":"nm0101002"},
  "related":{"Actor:":{"tt0077008":{"uniqueId":"tt0077008","title":"Fantasy Island","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"1977","yearRange":"1977-1984","runTime":"3600",
      "genres":"[\"Adventure\",\"Family\",\"Fantasy\"]",
      "userRating":"6.6","userRatingCount":"9757","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjExMDcxMzkxNl5BMl5BanBnXkFtZTcwMDYwNDEzMQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0077008"}},
      "tt0080424":{"uniqueId":"tt0080424","title":"Belle Starr","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1980","yearRange":"1980","runTime":"5820",
      "genres":"[\"Biography\",\"Crime\",\"Drama\"]",
      "userRating":"6.3","userRatingCount":"160","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzFlYTU1OTItYTcyZS00YTA3LWIzMWQtMDU0YzQyZjcwNDAzXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0080424"}},
      "tt0081940":{"uniqueId":"tt0081940","title":"Strike Force","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"1981","yearRange":"1981-1982","runTime":"3600",
      "genres":"[\"Action\",\"Crime\",\"Drama\"]",
      "userRating":"7.0","userRatingCount":"110","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTNmMzg0ZDgtYTBhYS00MjQyLWJjZTgtZWQ5MjhmNmY5ZjY5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0081940"}},
      "tt0086859":{"uniqueId":"tt0086859","title":"Against All Odds","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1984","yearRange":"1984","runTime":"7680",
      "genres":"[\"Action\",\"Adventure\",\"Crime\"]",
      "userRating":"5.9","userRatingCount":"14927","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYWYwOGZmY2UtMzAwZS00MjE5LThiNWItMjRlZDc5NjhmOTE4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0086859"}}},
    "Stunts:":{"tt0083805":{"uniqueId":"tt0083805","title":"Death Valley","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1981","yearRange":"1981","runTime":"5220",
      "genres":"[\"Crime\",\"Drama\",\"Horror\"]",
      "userRating":"5.5","userRatingCount":"2091","censorRating":"CensorRatingType.adult","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzY5YTlkYTgtYThkNi00ZjU1LTg2NTctYWFmNTljOGM5NGRjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0083805"}},
      "tt0085756":{"uniqueId":"tt0085756","title":"Jimmy the Kid","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1982","yearRange":"1982","runTime":"5100",
      "genres":"[\"Comedy\"]",
      "userRating":"4.8","userRatingCount":"357","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BZWI1ZmNmOGUtYjgyMS00NjY4LWJkNWMtYjI5MTVhMzRkNTk3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0085756"}},
      "tt0088115":{"uniqueId":"tt0088115","title":"Silence of the Heart","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1984","yearRange":"1984","runTime":"6000",
      "genres":"[\"Drama\"]",
      "userRating":"6.5","userRatingCount":"438","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTM2MjRhMTItNzljOC00ZmMwLTkwNjQtYmFkMTVhMTVjNDhjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0088115"}}}}}
''',
];
