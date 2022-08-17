import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/omdb.dart';
import 'package:my_movie_search/utilities/environment.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real OMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '{"source":"DataSourceType.omdb","uniqueId":"tt0436724","title":"Rize","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_SX300.jpg","related":"{}"}',
  '{"source":"DataSourceType.omdb","uniqueId":"tt7529532","title":"Tenacious D: Rize of the Fenix","type":"MovieContentType.movie","year":"2012","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZmNiZmJlYTktMDY2NC00YTlkLTlhOTMtNDZlNzA2YzFmMzcxXkEyXkFqcGdeQXVyNjE4NDU1Njk@._V1_SX300.jpg","related":"{}"}',
  '{"source":"DataSourceType.omdb","uniqueId":"tt0376554","title":"Danehaye rize barf","type":"MovieContentType.movie","year":"2003","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BYzVlZjdiYzAtODU5NC00NDg1LTk2YmQtZWI5MzlmM2IwN2M5XkEyXkFqcGdeQXVyNDQ3OTQ2MTY@._V1_SX300.jpg","related":"{}"}',
  '{"source":"DataSourceType.omdb","uniqueId":"tt2078714","title":"Rize N Grind","type":"MovieContentType.movie","year":"2011","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BYjdmNWMwMjEtMWExOC00NDAwLThlYjgtMDhiMWQ0MzE3OGI0XkEyXkFqcGdeQXVyNTM3MDMyMDQ@._V1_SX300.jpg","related":"{}"}',
  '{"source":"DataSourceType.omdb","uniqueId":"tt3166426","title":"Die-Rize","type":"MovieContentType.movie","year":"2015","languages":[],"genres":[],"keywords":[],"imageUrl":"N/A","related":"{}"}',
  '{"source":"DataSourceType.omdb","uniqueId":"tt5363184","title":"Rize Action","type":"MovieContentType.movie","year":"2016","languages":[],"genres":[],"keywords":[],"imageUrl":"N/A","related":"{}"}',
  '{"source":"DataSourceType.omdb","uniqueId":"tt8067018","title":"The Rize & Fall of Tephlon Ent","type":"MovieContentType.movie","year":"2016","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BOTJhNjAwOWQtNTlkMS00MjVkLTgwZmYtYThjZmMwNjg3MTRkXkEyXkFqcGdeQXVyODU4ODIwNzU@._V1_SX300.jpg","related":"{}"}',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryOMDBMovies search test', () {
    // Search for a rare movie.
    test('Run read 3 pages from OMDB', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();

      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QueryOMDBMovies().readList(criteria, limit: 10);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          expectedOutput.length - 2,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
