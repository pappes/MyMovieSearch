import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '{"source":"imdbSuggestions","uniqueId":"tt0436724","title":"Rize","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_.jpg","related":"{}"}',
  '{"source":"imdbSuggestions","uniqueId":"tt7529532","title":"Tenacious D: Rize of the Fenix","type":"MovieContentType.movie","year":"2012","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZmNiZmJlYTktMDY2NC00YTlkLTlhOTMtNDZlNzA2YzFmMzcxXkEyXkFqcGdeQXVyNjE4NDU1Njk@._V1_.jpg","related":"{}"}',
  '{"source":"imdbSuggestions","uniqueId":"nm7507707","title":"Rizelle Januk","type":"MovieContentType.person","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BYTFkMjU5M2ItODNiNC00MDQ2LTg0MzQtMzY3YWI1Yjc0NmMwXkEyXkFqcGdeQXVyNTg1NzUwMzY@._V1_.jpg","related":"{}"}',
  '{"source":"imdbSuggestions","uniqueId":"nm13126472","title":"Eden Rize","type":"MovieContentType.person","languages":[],"genres":[],"keywords":[],"related":"{}"}',
  '{"source":"imdbSuggestions","uniqueId":"tt3166426","title":"Die-Rize","type":"MovieContentType.movie","languages":[],"genres":[],"keywords":[],"related":"{}"}',
  '{"source":"imdbSuggestions","uniqueId":"nm3886028","title":"Angourie Rice","type":"MovieContentType.person","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BMzhkMTczYWEtOThmYS00MDEyLTgzZjAtODE5YTUwMmJiMjAzXkEyXkFqcGdeQXVyOTE0NjgwMjY@._V1_.jpg","related":"{}"}',
  '{"source":"imdbSuggestions","uniqueId":"nm1403335","title":"Rize","type":"MovieContentType.person","languages":[],"genres":[],"keywords":[],"related":"{}"}',
  '{"source":"imdbSuggestions","uniqueId":"tt5113044","title":"Minions: The Rise of Gru","type":"MovieContentType.movie","year":"2022","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDQyODUwM2MtNzA0YS00ZjdmLTgzMjItZWRjN2YyYWE5ZTNjXkEyXkFqcGdeQXVyMTI2MzY1MjM1._V1_.jpg","related":"{}"}',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBSuggestions test', () {
    // Search for a rare movie.
    test('Run read 3 pages from IMDB', () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QueryIMDBSuggestions().readList(criteria, limit: 10);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

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
