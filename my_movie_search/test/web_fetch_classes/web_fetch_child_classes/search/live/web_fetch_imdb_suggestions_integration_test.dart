import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0406158","bestSource":"DataSourceType.imdbSuggestions","title":"The Prize Winner of Defiance, Ohio","type":"MovieContentType.movie","year":"2005","sources":{"DataSourceType.imdbSuggestions":"tt0406158"}}
''',
  r'''
{"uniqueId":"tt0427038","bestSource":"DataSourceType.imdbSuggestions","title":"Carlito's Way: Rise to Power","type":"MovieContentType.movie","year":"2005","sources":{"DataSourceType.imdbSuggestions":"tt0427038"}}
''',
  r'''
{"uniqueId":"tt0436724","bestSource":"DataSourceType.imdbSuggestions","title":"Rize","type":"MovieContentType.movie","year":"2005","sources":{"DataSourceType.imdbSuggestions":"tt0436724"}}
''',
  r'''
{"uniqueId":"tt0453540","bestSource":"DataSourceType.imdbSuggestions","title":"Rise of the Undead","type":"MovieContentType.movie","year":"2005","sources":{"DataSourceType.imdbSuggestions":"tt0453540"}}
''',
  r'''
{"uniqueId":"tt0468538","bestSource":"DataSourceType.imdbSuggestions","title":"Ride or Die","type":"MovieContentType.movie","year":"2005","sources":{"DataSourceType.imdbSuggestions":"tt0468538"}}
''',
  r'''
{"uniqueId":"tt0470883","bestSource":"DataSourceType.imdbSuggestions","title":"Magic Carpet Ride","type":"MovieContentType.movie","year":"2005","sources":{"DataSourceType.imdbSuggestions":"tt0470883"}}
''',
  r'''
{"uniqueId":"tt0473080","bestSource":"DataSourceType.imdbSuggestions","title":"Riot at the Rite","type":"MovieContentType.movie","year":"2005","sources":{"DataSourceType.imdbSuggestions":"tt0473080"}}
''',
  r'''
{"uniqueId":"tt0479726","bestSource":"DataSourceType.imdbSuggestions","title":"Nationwide Mercury Prize 2005","type":"MovieContentType.series","year":"2005","sources":{"DataSourceType.imdbSuggestions":"tt0479726"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBSuggestions test', () {
    // Search for a rare movie.
    test('Run read 3 pages from IMDB', () async {
      final criteria = SearchCriteriaDTO().fromString('rize 2005');
      final actualOutput =
          await QueryIMDBSuggestions(criteria).readList(limit: 10);
      final expectedOutput = expectedDTOList;
      expectedDTOList.clearCopyrightedData();
      actualOutput.clearCopyrightedData();

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
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryIMDBSuggestions(criteria).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(
          expectedOutput,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
  });
}
