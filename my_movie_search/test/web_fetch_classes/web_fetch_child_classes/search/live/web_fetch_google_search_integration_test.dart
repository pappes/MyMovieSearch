import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';
// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real Google endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0436724","bestSource":"DataSourceType.google","title":"Rize ","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_FMjpg_UX1000_.jpg","sources":{"DataSourceType.google":"tt0436724"},"related":{}}
''',
  r'''
{"uniqueId":"tt7529532","bestSource":"DataSourceType.google","title":"Tenacious D: Rize of the Fenix ","year":"2012","yearRange":"2012","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmNiZmJlYTktMDY2NC00YTlkLTlhOTMtNDZlNzA2YzFmMzcxXkEyXkFqcGdeQXVyNjE4NDU1Njk@._V1_FMjpg_UX1000_.jpg","sources":{"DataSourceType.google":"tt7529532"},"related":{}}
''',
  r'''
{"uniqueId":"tt8067018","bestSource":"DataSourceType.google","title":"The Rize & Fall of Tephlon Ent ","type":"MovieContentType.movie","year":"2016","yearRange":"2016","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTJhNjAwOWQtNTlkMS00MjVkLTgwZmYtYThjZmMwNjg3MTRkXkEyXkFqcGdeQXVyODU4ODIwNzU@._V1_FMjpg_UX1000_.jpg","sources":{"DataSourceType.google":"tt8067018"},"related":{}}
'''
];

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings.singleton().init());
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryGoogleMovies test', () {
    // Search for a rare movie.
    test('Run read 3 pages from Google', () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QueryGoogleMovies().readList(criteria, limit: 1000);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
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
  });
}
