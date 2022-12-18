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
const expectedDtoJsonStringList = /*[
  '{"source":"imdbSearch","uniqueId":"tt0436724","title":"Rize","year":"2005","yearRange":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_UY44_CR0,0,32,44_AL_.jpg","related":"{}"}',
  '{"source":"imdbSearch","uniqueId":"tt13606352","title":"Sehirden Uzakta","type":"episode","year":"2020","yearRange":"2020","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BN2IxN2JlNTQtMTYwNS00YzBjLThhMjMtNzVjMWU5YzgxNTJiXkEyXkFqcGdeQXVyMzY0NDIxMDc@._V1_UX32_CR0,0,32,44_AL_.jpg","related":"{}"}',
  '{"source":"imdbSearch","uniqueId":"tt0328338","title":"Rizerumain","type":"series","year":"2002","yearRange":"2002","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BYTc3MjUzMmQtYzAwMS00NGNlLWI4NWYtZjMwMGE4NjUxYTQxXkEyXkFqcGdeQXVyNjExODE1MDc@._V1_UX32_CR0,0,32,44_AL_.jpg","related":"{}"}',
  '{"source":"imdbSearch","uniqueId":"tt10638530","title":"Rizes: Ellinikoi horoi","type":"movie","year":"1977","yearRange":"1977","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BNjM2YTM2YzQtYTU3Ni00Y2Q3LWFjY2MtOWQ3ODNiZDY5N2YyXkEyXkFqcGdeQXVyNzg5OTk2OA@@._V1_UY44_CR17,0,32,44_AL_.jpg","related":"{}"}',
  '{"source":"imdbSearch","uniqueId":"tt13877772","title":"Connery Davoodian","type":"short","year":"2021","yearRange":"2021","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BOGIwNGMyODktZjM3Ni00ODRkLThiYmYtN2Y0MjA1MTY0MDcwXkEyXkFqcGdeQXVyMTI4NTQ4MTI4._V1_UY44_CR6,0,32,44_AL_.jpg","related":"{}"}',
  '{"source":"imdbSearch","uniqueId":"tt1145471","title":"Rizes kai eikones","type":"short","year":"1973","yearRange":"1973","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/S/sash/85lhIiFCmSScRzu.png","related":"{}"}',
  '{"source":"imdbSearch","uniqueId":"tt2078714","title":"Rize N Grind","year":"2011","yearRange":"2011","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BYjdmNWMwMjEtMWExOC00NDAwLThlYjgtMDhiMWQ0MzE3OGI0XkEyXkFqcGdeQXVyNTM3MDMyMDQ@._V1_UY44_CR6,0,32,44_AL_.jpg","related":"{}"}',
  '{"source":"imdbSearch","uniqueId":"tt4471908","title":"Prizefighter: The Life of Jem Belcher","year":"2022","yearRange":"2022","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BMmE2OWM4YTAtNDkzNS00YTUyLWJjZjgtYmRhZDhlZmMxMGNiXkEyXkFqcGdeQXVyMjgxOTM1MDU@._V1_UX32_CR0,0,32,44_AL_.jpg","related":"{}"}',
  '{"source":"imdbSearch","uniqueId":"tt0119081","title":"Event Horizon","year":"1997","yearRange":"1997","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZGI0NDMwNjAtNGEzNC00MzA1LTlkMjQtYjBkYTZlZjAyZWEyXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UX32_CR0,0,32,44_AL_.jpg","related":"{}"}',
  '{"source":"imdbSearch","uniqueId":"tt1551632","title":"Rizzoli & Isles","type":"series","year":"2010","yearRange":"2010","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BMjMzNzI1MjQ1MV5BMl5BanBnXkFtZTgwNjY2NDY3NTE@._V1_UY44_CR0,0,32,44_AL_.jpg","related":"{}"}',
]*/
    [
  r'''
{"uniqueId":"tt0436724","title":"Rize","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [Tommy the Clown, Larry Berry]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_.jpg","related":{}}
''',
  r'''
{"uniqueId":"tt7529532","title":"Tenacious D: Rize of the Fenix","type":"MovieContentType.movie","year":"2012","yearRange":"2012","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [Jack Black, Steve Clemmons]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmNiZmJlYTktMDY2NC00YTlkLTlhOTMtNDZlNzA2YzFmMzcxXkEyXkFqcGdeQXVyNjE4NDU1Njk@._V1_.jpg","related":{}}
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
      final actualOutput =
          await QueryIMDBSearch().readList(criteria, limit: 10);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      //print(actualOutput.toListOfDartJsonStrings(excludeData: false));
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
