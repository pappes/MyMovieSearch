import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_search.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
r'''
{"uniqueId":"nm0000702","title":"Reese Witherspoon","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.person","sources":{"DataSourceType.imdbSearch":"nm0000702"}}
''',
r'''
{"uniqueId":"nm10913706","title":"Leon Rize","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.person","sources":{"DataSourceType.imdbSearch":"nm10913706"}}
''',
r'''
{"uniqueId":"nm1103780","title":"Rizelle Mendoza","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.person","sources":{"DataSourceType.imdbSearch":"nm1103780"}}
''',
r'''
{"uniqueId":"nm16146196","title":"RIZE","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.person","sources":{"DataSourceType.imdbSearch":"nm16146196"}}
''',
r'''
{"uniqueId":"nm7507707","title":"Rizelle Januk","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.person","sources":{"DataSourceType.imdbSearch":"nm7507707"}}
''',
r'''
{"uniqueId":"tt0376554","title":"Danehaye rize barf","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.movie","year":"2003","yearRange":"2003","sources":{"DataSourceType.imdbSearch":"tt0376554"}}
''',
r'''
{"uniqueId":"tt0436724","title":"Rize","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.movie","year":"2005","yearRange":"2005","sources":{"DataSourceType.imdbSearch":"tt0436724"}}
''',
r'''
{"uniqueId":"tt24637510","title":"Rize","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.series","year":"2022","yearRange":"2022","sources":{"DataSourceType.imdbSearch":"tt24637510"}}
''',
r'''
{"uniqueId":"tt29045530","title":"Rize of the Collapse","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.short","year":"2023","yearRange":"2023","sources":{"DataSourceType.imdbSearch":"tt29045530"}}
''',
r'''
{"uniqueId":"tt7529532","title":"Tenacious D: Rize of the Fenix","bestSource":"DataSourceType.imdbSearch","type":"MovieContentType.custom","year":"2012","yearRange":"2012","sources":{"DataSourceType.imdbSearch":"tt7529532"}}
''',
];

void main() {
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBSearch test', () {
    // Search for a rare movie.
    test(
      'Run a search on IMDB that is likely to have static results',
      () async {
        final criteria = SearchCriteriaDTO().fromString('rize');
        final actualOutput = await QueryIMDBSearch(
          criteria,
        ).readList(limit: 10);
        final expectedOutput = expectedDTOList;
        expectedDTOList.clearCopyrightedData();
        actualOutput.clearCopyrightedData();

        // To update expected data, uncomment the following line
        // printTestData(actualOutput);

        // Check the results.
        expect(
          actualOutput,
          MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 60),
          reason:
              'Emitted DTO list ${actualOutput.toPrintableString()} '
              'needs to match expected DTO list '
              '${expectedOutput.toPrintableString()}',
        );
      },
    );
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryIMDBSearch(criteria).readList(limit: 10);
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
