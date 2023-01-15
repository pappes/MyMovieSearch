import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tmdb.dart';
import 'package:my_movie_search/utilities/environment.dart';

import '../../../../test_helper.dart';
// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real TMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"11404","bestSource":"DataSourceType.tmdbSearch","title":"Driving Lessons","year":"2006","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.tmdbSearch":"11404"},"related":{}}
''',
  r'''
{"uniqueId":"2287","bestSource":"DataSourceType.tmdbSearch","title":"Rize","year":"2005","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.tmdbSearch":"2287"},"related":{}}
''',
  r'''
{"uniqueId":"405911","bestSource":"DataSourceType.tmdbSearch","title":"Cats in Riga","year":"2015","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.tmdbSearch":"405911"},"related":{}}
''',
  r'''
{"uniqueId":"409888","bestSource":"DataSourceType.tmdbSearch","title":"Tiny Snowflakes","year":"2003","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.tmdbSearch":"409888"},"related":{}}
''',
  r'''
{"uniqueId":"453289","bestSource":"DataSourceType.tmdbSearch","title":"The Rizen","year":"2017","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.tmdbSearch":"453289"},"related":{}}
''',
  r'''
{"uniqueId":"586327","bestSource":"DataSourceType.tmdbSearch","title":"The Rizen: Possession","year":"2019","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.tmdbSearch":"586327"},"related":{}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryTMDBMovies search test', () {
    // Search for a rare movie.
    test('Run read 3 pages from TMDB', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();

      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QueryTMDBMovies().readList(criteria, limit: 10);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // print(actualOutput.toListOfDartJsonStrings(excludeCopyrightedData: false));

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
