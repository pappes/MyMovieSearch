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
  '{"source":"DataSourceType.imdbSuggestions","uniqueId":"tt0342272","title":"Dear Wendy","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BMTkyMDIxMzY4Ml5BMl5BanBnXkFtZTcwNTE2NTgyMQ@@._V1_.jpg","related":"{}"}',
  '{"source":"DataSourceType.imdbSuggestions","uniqueId":"tt0357110","title":"The Ballad of Jack and Rose","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BMGNlZjAxYzUtNzUyYS00ZTcwLTg3YjctNjc1MmJlZGY1ZjE0XkEyXkFqcGdeQXVyMTAwMzUyOTc@._V1_.jpg","related":"{}"}',
  '{"source":"DataSourceType.imdbSuggestions","uniqueId":"tt0371853","title":"La monja","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BNWExZWU1MGYtOWQzZC00M2QyLWJkZTQtZDA0NWVjM2EyMzk3XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_.jpg","related":"{}"}',
  '{"source":"DataSourceType.imdbSuggestions","uniqueId":"tt0402158","title":"Empire of the Wolves","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BOTc2NmYwYzctOWM0Ni00MWRjLWE4OTAtZmI2YjViNWU5ZWIwXkEyXkFqcGdeQXVyNTIzOTk5ODM@._V1_.jpg","related":"{}"}',
  '{"source":"DataSourceType.imdbSuggestions","uniqueId":"tt0406158","title":"The Prize Winner of Defiance, Ohio","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZjE1ZmNkMTgtNDRjOS00Y2JhLWFhMDgtZjg4NzFmYTI5NGZkXkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_.jpg","related":"{}"}',
  '{"source":"DataSourceType.imdbSuggestions","uniqueId":"tt0427038","title":"Carlito\'s Way: Rise to Power","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BMTQ5MTU3Njk1MF5BMl5BanBnXkFtZTcwNTYxODEzMQ@@._V1_.jpg","related":"{}"}',
  '{"source":"DataSourceType.imdbSuggestions","uniqueId":"tt0436724","title":"Rize","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_.jpg","related":"{}"}',
  '{"source":"DataSourceType.imdbSuggestions","uniqueId":"tt0470883","title":"Magic Carpet Ride","type":"MovieContentType.movie","year":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BOTM4MjY0NTQ3OF5BMl5BanBnXkFtZTcwMjI5NjkzMQ@@._V1_.jpg","related":"{}"}',
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
          await QueryIMDBSuggestions().readList(criteria, limit: 10);
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
