import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/omdb.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';
// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real OMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0376554","bestSource":"DataSourceType.omdb","title":"Danehaye rize barf","type":"MovieContentType.movie","year":"2003","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzVlZjdiYzAtODU5NC00NDg1LTk2YmQtZWI5MzlmM2IwN2M5XkEyXkFqcGdeQXVyNDQ3OTQ2MTY@._V1_SX300.jpg","sources":{"DataSourceType.omdb":"tt0376554"},"related":{}}
''',
  r'''
{"uniqueId":"tt0436724","bestSource":"DataSourceType.omdb","title":"Rize","type":"MovieContentType.movie","year":"2005","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_SX300.jpg","sources":{"DataSourceType.omdb":"tt0436724"},"related":{}}
''',
  r'''
{"uniqueId":"tt2078714","bestSource":"DataSourceType.omdb","title":"Rize N Grind","type":"MovieContentType.movie","year":"2011","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjdmNWMwMjEtMWExOC00NDAwLThlYjgtMDhiMWQ0MzE3OGI0XkEyXkFqcGdeQXVyNTM3MDMyMDQ@._V1_SX300.jpg","sources":{"DataSourceType.omdb":"tt2078714"},"related":{}}
''',
  r'''
{"uniqueId":"tt3166426","bestSource":"DataSourceType.omdb","title":"Die-Rize","type":"MovieContentType.movie","year":"2015","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"N/A","sources":{"DataSourceType.omdb":"tt3166426"},"related":{}}
''',
  r'''
{"uniqueId":"tt5363184","bestSource":"DataSourceType.omdb","title":"Rize Action","type":"MovieContentType.movie","year":"2016","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"N/A","sources":{"DataSourceType.omdb":"tt5363184"},"related":{}}
''',
  r'''
{"uniqueId":"tt7529532","bestSource":"DataSourceType.omdb","title":"Tenacious D: Rize of the Fenix","type":"MovieContentType.movie","year":"2012","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmNiZmJlYTktMDY2NC00YTlkLTlhOTMtNDZlNzA2YzFmMzcxXkEyXkFqcGdeQXVyNjE4NDU1Njk@._V1_SX300.jpg","sources":{"DataSourceType.omdb":"tt7529532"},"related":{}}
''',
  r'''
{"uniqueId":"tt8067018","bestSource":"DataSourceType.omdb","title":"The Rize & Fall of Tephlon Ent","type":"MovieContentType.movie","year":"2016","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTJhNjAwOWQtNTlkMS00MjVkLTgwZmYtYThjZmMwNjg3MTRkXkEyXkFqcGdeQXVyODU4ODIwNzU@._V1_SX300.jpg","sources":{"DataSourceType.omdb":"tt8067018"},"related":{}}
''',
];

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings.singleton().init());
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryOMDBMovies search test', () {
    // Search for a rare movie.
    test('Run read 3 pages from OMDB', () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QueryOMDBMovies().readList(criteria, limit: 10);
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
