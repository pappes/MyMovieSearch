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
{"uniqueId":"tt0406158","source":"DataSourceType.imdbSuggestions","title":"The Prize Winner of Defiance, Ohio","type":"MovieContentType.movie","year":"2005","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjE1ZmNkMTgtNDRjOS00Y2JhLWFhMDgtZjg4NzFmYTI5NGZkXkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0427038","source":"DataSourceType.imdbSuggestions","title":"Carlito's Way: Rise to Power","type":"MovieContentType.movie","year":"2005","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTQ5MTU3Njk1MF5BMl5BanBnXkFtZTcwNTYxODEzMQ@@._V1_.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0436724","source":"DataSourceType.imdbSuggestions","title":"Rize","type":"MovieContentType.movie","year":"2005","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0453540","source":"DataSourceType.imdbSuggestions","title":"Rise of the Undead","type":"MovieContentType.movie","year":"2005","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjA1MjA3NjcwNV5BMl5BanBnXkFtZTcwNzM4MDkyMQ@@._V1_.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0468538","source":"DataSourceType.imdbSuggestions","title":"Ride or Die","type":"MovieContentType.movie","year":"2005","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTM5OTEwNTIxMl5BMl5BanBnXkFtZTcwNzUzMjUzMQ@@._V1_.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0470883","source":"DataSourceType.imdbSuggestions","title":"Magic Carpet Ride","type":"MovieContentType.movie","year":"2005","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTM4MjY0NTQ3OF5BMl5BanBnXkFtZTcwMjI5NjkzMQ@@._V1_.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0473080","source":"DataSourceType.imdbSuggestions","title":"Riot at the Rite","type":"MovieContentType.movie","year":"2005","languages":"[]","genres":"[]","keywords":"[]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZGQyMmY5OTQtMGJkOS00NTM2LTlmMTItNDQzNjZmNGJhZWRmXkEyXkFqcGdeQXVyMDY4MzkyNw@@._V1_.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt0479726","source":"DataSourceType.imdbSuggestions","title":"Nationwide Mercury Prize 2005","type":"MovieContentType.series","year":"2005","languages":"[]","genres":"[]","keywords":"[]","related":{}}
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
          await QueryIMDBSuggestions().readList(criteria, limit: 10);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      //print(actualOutput.toListOfDartJsonStrings(excludeCopyrightedData: false));
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
