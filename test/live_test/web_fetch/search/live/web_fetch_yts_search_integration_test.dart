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
{"uniqueId":"https://yts.lt/movies/sharon-1-2-3-2018","title":"Sharon 1.2.3.","bestSource":"DataSourceType.ytsSearch","type":"MovieContentType.information","year":"2018","sources":{"DataSourceType.ytsSearch":"https://yts.lt/movies/sharon-1-2-3-2018"}}
''',
];

final expectedTitleList =
    ListDTOConversion.decodeList(expectedTitleJsonStringList);
const expectedTitleJsonStringList = [
  r'''
{"uniqueId":"https://yts.lt/movies/rize-2005","bestSource":"DataSourceType.ytsSearch","title":"Rize","type":"MovieContentType.information","year":"2005","sources":{"DataSourceType.ytsSearch":"https://yts.lt/movies/rize-2005"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryYtsSearch test', () {
    // Search for a rare movie.
    test('Run read from YTS using imbd id', () async {
      final criteria = SearchCriteriaDTO().fromString('tt3127016');
      final actualOutput = await QueryYtsSearch(criteria).readList(limit: 10);

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput);

      // Check the results.
      final expectedOutput = readTestData();
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          percentMatch: 50,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run read from YTS using title', () async {
      final dataSoureLocation = getDataFileLocation(suffix: '_title.json');
      final criteria = SearchCriteriaDTO().fromString('rize 2005');
      final actualOutput = await QueryYtsSearch(criteria).readList(limit: 10);

      // To update expected data, uncomment the following line
      // writeTestData(actualOutput, location: dataSoureLocation);

      // Check the results.
      final expectedOutput = readTestData(location: dataSoureLocation);
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          percentMatch: 50,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryYtsSearch(criteria).readList(limit: 10);
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
