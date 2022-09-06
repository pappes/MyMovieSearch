import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tmdb.dart';
import 'package:my_movie_search/utilities/environment.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real TMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '{"source":"DataSourceType.tmdbMovie","uniqueId":"2287","title":"Rize","year":"2005","languages":[],"genres":[],"keywords":[],"related":"{}"}',
  '{"source":"DataSourceType.tmdbMovie","uniqueId":"409888","title":"Tiny Snowflakes","year":"2003","languages":[],"genres":[],"keywords":[],"related":"{}"}',
  '{"source":"DataSourceType.tmdbMovie","uniqueId":"586327","title":"The Rizen: Possession","year":"2019","languages":[],"genres":[],"keywords":[],"related":"{}"}',
  '{"source":"DataSourceType.tmdbMovie","uniqueId":"453289","title":"The Rizen","year":"2017","languages":[],"genres":[],"keywords":[],"related":"{}"}',
  '{"source":"DataSourceType.tmdbMovie","uniqueId":"405911","title":"Cats in Riga","year":"2015","languages":[],"genres":[],"keywords":[],"related":"{}"}',
  '{"source":"DataSourceType.tmdbMovie","uniqueId":"11404","title":"Driving Lessons","year":"2006","languages":[],"genres":[],"keywords":[],"related":"{}"}',
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
      //print(actualOutput.toJsonStrings());
      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          60, // 60% of records must match
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
