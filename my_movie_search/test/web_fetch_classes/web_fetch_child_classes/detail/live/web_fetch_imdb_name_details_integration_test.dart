import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"-2","source":"DataSourceType.imdb","title":"[QueryIMDBNameDetails] Error in imdb_person with criteria nm0101000 interpreting web text as a map :imdb web scraper data not detected for criteria nm0101000","type":"MovieContentType.custom","languages":"[]","genres":"[]","keywords":"[]","related":{}}
''',
  r'''
{"uniqueId":"nm0101001","source":"DataSourceType.imdb","title":"Steve Bower","type":"MovieContentType.person","yearRange":"-","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Steve Bower is known for Vintage Reds (1998), Late Kick Off North East and Cumbria (2010) and The Search for the Holy Grail (1998).","related":{}}
''',
  r'''
{"uniqueId":"nm0101002","source":"DataSourceType.imdb","title":"Stone Bower","type":"MovieContentType.person","yearRange":"-","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Stone Bower is known for Against All Odds (1984), Death Valley (1982) and Jimmy the Kid (1982).","related":{}}
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
    final future = QueryIMDBNameDetails().readList(criteria);
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

  group('live QueryIMDBNameDetails test', () {
    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from IMDB', () async {
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following lines
      // actualOutput.forEach((e) => e.related = {});
      // print(actualOutput.toListOfDartJsonStrings());

      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(expectedOutput, related: false),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}