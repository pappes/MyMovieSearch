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
{"uniqueId":"tt0376554","bestSource":"DataSourceType.imdbSearch","title":"Danehaye rize barf","type":"MovieContentType.movie","year":"2003","yearRange":"2003","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt0376554"},"related":{}}
''',
  r'''
{"uniqueId":"tt0436724","bestSource":"DataSourceType.imdbSearch","title":"Rize","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt0436724"},"related":{}}
''',
  r'''
{"uniqueId":"tt13345606","bestSource":"DataSourceType.imdbSearch","title":"Evil Dead Rise","type":"MovieContentType.movie","year":"2023","yearRange":"2023","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt13345606"},"related":{}}
''',
  r'''
{"uniqueId":"tt14761860","bestSource":"DataSourceType.imdbSearch","title":"The Big Door Prize","type":"MovieContentType.series","yearRange":"2023– ","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt14761860"},"related":{}}
''',
  r'''
{"uniqueId":"tt2078714","bestSource":"DataSourceType.imdbSearch","title":"Rize N Grind","type":"MovieContentType.movie","year":"2011","yearRange":"2011","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt2078714"},"related":{}}
''',
  r'''
{"uniqueId":"tt21043326","bestSource":"DataSourceType.imdbSearch","title":"Ride","type":"MovieContentType.series","yearRange":"2023– ","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt21043326"},"related":{}}
''',
  r'''
{"uniqueId":"tt24637510","bestSource":"DataSourceType.imdbSearch","title":"Rize","type":"MovieContentType.series","yearRange":"2022– ","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt24637510"},"related":{}}
''',
  r'''
{"uniqueId":"tt3166426","bestSource":"DataSourceType.imdbSearch","title":"Die-Rize","type":"MovieContentType.movie","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt3166426"},"related":{}}
''',
  r'''
{"uniqueId":"tt5363184","bestSource":"DataSourceType.imdbSearch","title":"Rize Action","type":"MovieContentType.movie","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt5363184"},"related":{}}
''',
  r'''
{"uniqueId":"tt7529532","bestSource":"DataSourceType.imdbSearch","title":"Tenacious D: Rize of the Fenix","type":"MovieContentType.custom","year":"2012","yearRange":"2012","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSearch":"tt7529532"},"related":{}}
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
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
    // Search for a rare movie.
    test('Run a search on IMDB that has no results', () async {
      final criteria = SearchCriteriaDTO()
          .fromString('while we re young 2014 ben stiller comedy');
      final actualOutput = await QueryIMDBSearch(criteria).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];
      expectedDTOList.clearCopyrightedData();
      actualOutput.clearCopyrightedData();

      // To update expected data, uncomment the following line
      // printTestData(actualOutput);

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
