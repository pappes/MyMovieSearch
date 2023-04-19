import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/yts_search.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://yts.mx/movies/sharon-1-2-3-2018","bestSource":"DataSourceType.ytsSearch","title":"Sharon 1.2.3.","type":"MovieContentType.download","year":"2018","sources":{"DataSourceType.ytsSearch":"https://yts.mx/movies/sharon-1-2-3-2018"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryYtsSearch test', () {
    // Search for a rare movie.
    test('Run read 3 pages from IMDB', () async {
      final criteria = SearchCriteriaDTO().fromString('tt3127016');
      final actualOutput = await QueryYtsSearch(criteria).readList(limit: 10);
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
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
