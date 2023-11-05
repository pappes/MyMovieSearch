// ignore_for_file: unnecessary_raw_strings

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0101000","bestSource":"DataSourceType.imdb","title":"Zacátek dlouhého podzimu","type":"MovieContentType.title","year":"1990","yearRange":"1990","runTime":"4860","language":"LanguageType.foreign","sources":{"DataSourceType.imdb":"tt0101000"}}
''',
  r'''
{"uniqueId":"tt0101001","bestSource":"DataSourceType.imdb","title":"Zai shi feng liu jie","alternateTitle":"A Haunted Romance","type":"MovieContentType.title","year":"1985","yearRange":"1985","runTime":"5340","language":"LanguageType.foreign","sources":{"DataSourceType.imdb":"tt0101001"}}
''',
  r'''
{"uniqueId":"tt0101002","bestSource":"DataSourceType.imdb","title":"Joi jin gong woo","alternateTitle":"Hong Kong Corruptor","type":"MovieContentType.title","year":"1990","yearRange":"1990","runTime":"6480","language":"LanguageType.someEnglish","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdb":"tt0101002"}}
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
    final future = QueryIMDBTitleDetails(criteria).readList();
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

  group('live QueryIMDBTitleDetails test', () {
    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from IMDB', () async {
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);
      final expectedOutput = expectedDTOList;
      expectedDTOList.clearCopyrightedData();
      actualOutput.clearCopyrightedData();

      // To update expected data, uncomment the following line
      // printTestData(actualOutput, includeRelated: false);

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryIMDBTitleDetails(criteria).readList(limit: 10);
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
