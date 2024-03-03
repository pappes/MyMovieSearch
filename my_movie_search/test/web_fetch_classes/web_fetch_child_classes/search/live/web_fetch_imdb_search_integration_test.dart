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
{"uniqueId":"tt0436724","bestSource":"DataSourceType.imdbSearch","title":"Rize","type":"MovieContentType.movie","year":"2005","yearRange":"2005","sources":{"DataSourceType.imdbSearch":"tt0436724"}}
''',
  r'''
{"uniqueId":"tt2078714","bestSource":"DataSourceType.imdbSearch","title":"Rize N Grind","type":"MovieContentType.movie","year":"2011","yearRange":"2011","sources":{"DataSourceType.imdbSearch":"tt2078714"}}
''',
  r'''
{"uniqueId":"tt24637510","bestSource":"DataSourceType.imdbSearch","title":"Rize","type":"MovieContentType.series","yearRange":"2022– ","sources":{"DataSourceType.imdbSearch":"tt24637510"}}
''',
  r'''
{"uniqueId":"tt29045530","bestSource":"DataSourceType.imdbSearch","title":"Rize of the Collapse","type":"MovieContentType.short","year":"2023","yearRange":"2023","sources":{"DataSourceType.imdbSearch":"tt29045530"}}
''',
  r'''
{"uniqueId":"tt3166426","bestSource":"DataSourceType.imdbSearch","title":"Die-Rize","type":"MovieContentType.movie","sources":{"DataSourceType.imdbSearch":"tt3166426"}}
''',
  r'''
{"uniqueId":"tt4173306","bestSource":"DataSourceType.imdbSearch","title":"The Rizen","type":"MovieContentType.movie","year":"2017","yearRange":"2017","sources":{"DataSourceType.imdbSearch":"tt4173306"}}
''',
  r'''
{"uniqueId":"tt4521338","bestSource":"DataSourceType.imdbSearch","title":"The Rizen: Possession","type":"MovieContentType.movie","year":"2019","yearRange":"2019","sources":{"DataSourceType.imdbSearch":"tt4521338"}}
''',
  r'''
{"uniqueId":"tt5363184","bestSource":"DataSourceType.imdbSearch","title":"Rize Action","type":"MovieContentType.movie","sources":{"DataSourceType.imdbSearch":"tt5363184"}}
''',
  r'''
{"uniqueId":"tt7529532","bestSource":"DataSourceType.imdbSearch","title":"Tenacious D: Rize of the Fenix","type":"MovieContentType.custom","year":"2012","yearRange":"2012","sources":{"DataSourceType.imdbSearch":"tt7529532"}}
''',
  r'''
{"uniqueId":"tt8067018","bestSource":"DataSourceType.imdbSearch","title":"The Rize & Fall of Tephlon Ent","type":"MovieContentType.movie","year":"2016","yearRange":"2016","sources":{"DataSourceType.imdbSearch":"tt8067018"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBSearch test', () {
    // Search for a rare movie.
    test('Run a search on IMDB that is likely to have static results',
        () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput = await QueryIMDBSearch(criteria).readList(limit: 10);
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
      final actualOutput = await QueryIMDBSearch(criteria).readList(limit: 10);
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
