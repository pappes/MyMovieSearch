import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';
import 'package:my_movie_search/utilities/environment.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real Google endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '{"source":"DataSourceType.google","uniqueId":"tt0436724","title":"Rize ","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_FMjpg_UX1000_.jpg","related":"{}"}',
  '{"source":"DataSourceType.google","uniqueId":"tt7529532","title":"Tenacious D: Rize of the Fenix ","year":"2012","yearRange":"2012","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZmNiZmJlYTktMDY2NC00YTlkLTlhOTMtNDZlNzA2YzFmMzcxXkEyXkFqcGdeQXVyNjE4NDU1Njk@._V1_FMjpg_UX1000_.jpg","related":"{}"}',
  '{"source":"DataSourceType.google","uniqueId":"tt0436724","title":"Rize ","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_UY1200_CR135,0,630,1200_AL_.jpg","related":"{}"}',
  '{"source":"DataSourceType.google","uniqueId":"tt0436724","title":"Reviews: Rize - IMDb","type":"MovieContentType.movie","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_UY1200_CR135,0,630,1200_AL_.jpg","related":"{}"}',
  '{"source":"DataSourceType.google","uniqueId":"tt0436724","title":"Rize ","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_UY1200_CR135,0,630,1200_AL_.jpg","related":"{}"}',
  '{"source":"DataSourceType.google","uniqueId":"tt8067018","title":"The Rize & Fall of Tephlon Ent ","type":"MovieContentType.movie","year":"2016","yearRange":"2016","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BOTJhNjAwOWQtNTlkMS00MjVkLTgwZmYtYThjZmMwNjg3MTRkXkEyXkFqcGdeQXVyODU4ODIwNzU@._V1_FMjpg_UX1000_.jpg","related":"{}"}',
  '{"source":"DataSourceType.google","uniqueId":"tt0436724","title":"Rize ","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_UY1200_CR135,0,630,1200_AL_.jpg","related":"{}"}',
  '{"source":"DataSourceType.google","uniqueId":"tt0436724","title":"Rize ","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_UY1200_CR135,0,630,1200_AL_.jpg","related":"{}"}',
  '{"source":"DataSourceType.google","uniqueId":"tt0436724","title":"Rize ","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_UY1200_CR135,0,630,1200_AL_.jpg","related":"{}"}',
  '{"source":"DataSourceType.google","uniqueId":"tt3166426","title":"Die-Rize - IMDb","type":"MovieContentType.movie","languages":[],"genres":[],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/G/01/imdb/images/social/imdb_logo.png","related":"{}"}',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryGoogleMovies test', () {
    // Search for a rare movie.
    test('Run read 3 pages from Google', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();

      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QueryGoogleMovies().readList(criteria, limit: 1000);
      print(actualOutput.toJsonString());

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(expectedDTOList),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedDTOList.toPrintableString()}',
      );
    });
  });
}
