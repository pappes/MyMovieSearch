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
{"uniqueId":"tt0101000","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0101000"},"related":{}}
''',
  r'''
{"uniqueId":"tt0101001","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0101001"},"related":{}}
''',
  r'''
{"uniqueId":"tt0101002","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.title","sources":{"DataSourceType.imdbSuggestions":"tt0101002"},"related":{}}
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
    final future = QueryIMDBCastDetails().readList(criteria);
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

// Sort list, restrict related to2 categories with max 3 entries in each category
List<MovieResultDTO> cleanUp(List<MovieResultDTO> list) {
  return list;
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBCastDetails test', () {
    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from IMDB', () async {
      final queries = _makeQueries(3);
      final actualOutput = cleanUp(await _testRead(queries));
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following lines
      // actualOutput.forEach((e) => e.related = {});
      // print(actualOutput.toListOfDartJsonStrings(excludeCopyrightedData: true));

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
