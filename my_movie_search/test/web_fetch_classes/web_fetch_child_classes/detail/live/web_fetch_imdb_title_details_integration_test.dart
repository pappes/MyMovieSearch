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
{"uniqueId":"tt0101000","bestSource":"DataSourceType.imdb","title":"Zacátek dlouhého podzimu","type":"MovieContentType.title","year":"1990","yearRange":"1990","runTime":"4860","language":"LanguageType.foreign",
      "languages":"[\"Czech\"]",
      "genres":"[\"Drama\"]","keywords":"[]",
      "userRating":"5.0","userRatingCount":"8","sources":{"DataSourceType.imdb":"tt0101000"},"related":{}}
''',
  r'''
{"uniqueId":"tt0101001","bestSource":"DataSourceType.imdb","title":"Zai shi feng liu jie","alternateTitle":"A Haunted Romance","type":"MovieContentType.title","year":"1985","yearRange":"1985","runTime":"5340","language":"LanguageType.foreign",
      "languages":"[\"Cantonese\"]",
      "genres":"[\"Horror\"]",
      "keywords":"[\"ghost\"]","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjJkYzRkNzMtZWVkYy00MmRjLWE1YTQtYmIwOWE4MTkyZWFmXkEyXkFqcGdeQXVyNzc5MjA3OA@@._V1_.jpg","sources":{"DataSourceType.imdb":"tt0101001"},"related":{}}
''',
  r'''
{"uniqueId":"tt0101002","bestSource":"DataSourceType.imdb","title":"Joi jin gong woo","alternateTitle":"Hong Kong Corruptor","type":"MovieContentType.title","year":"1990","yearRange":"1990","runTime":"6480","language":"LanguageType.someEnglish",
      "languages":"[\"Cantonese\",\"English\"]",
      "genres":"[\"Action\",\"Drama\"]",
      "keywords":"[\"gangster\"]",
      "description":"A well-known gangster is released from prison, and decides look for his daughter with the help of a troubled young woman.",
      "userRating":"6.5","userRatingCount":"159","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjM0MDE5NGYtZDQ1ZC00ZDU5LWFjMmUtOTNiN2RmMTJkMjM2XkEyXkFqcGdeQXVyMzU0NzkwMDg@._V1_.jpg","sources":{"DataSourceType.imdb":"tt0101002"},"related":{}}
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
    final future = QueryIMDBTitleDetails().readList(criteria);
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
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // actualOutput.forEach((e) => e.related = {});
      // printTestData(actualOutput, excludeCopyrightedData: true);

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
