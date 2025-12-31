import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/google.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';
// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real Google endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
final expectedDTOTtileList = ListDTOConversion.decodeList(
  expectedDtoJsonStringLongTitleList,
);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0436724","title":"Rize ","bestSource":"DataSourceType.google","type":"MovieContentType.movie","year":"2005","yearRange":"2005","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWEzNWI4MDEtZGUyMy00ZWFhLWIxNTMtNTA2YWMxNWQwOWJkXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg","sources":{"DataSourceType.google":"tt0436724"}}
''',
  r'''
{"uniqueId":"tt2078714","title":"Rize N Grind ","bestSource":"DataSourceType.google","type":"MovieContentType.movie","year":"2011","yearRange":"2011","imageUrl":"https://m.media-amazon.com/images/M/MV5BZWNiNjE4ZWMtZGQ4Ny00MjFiLWIzNTEtZmJkMjJkZDM4MTZjXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg","sources":{"DataSourceType.google":"tt2078714"}}
''',
  r'''
{"uniqueId":"tt3166426","title":"Die-Rize | Drama, Horror, Sci-Fi","bestSource":"DataSourceType.google","type":"MovieContentType.movie","imageUrl":"https://m.media-amazon.com/images/G/01/imdb/images/social/imdb_logo.png","sources":{"DataSourceType.google":"tt3166426"}}
''',
  r'''
{"uniqueId":"tt7529532","title":"Tenacious D: Rize of the Fenix ","bestSource":"DataSourceType.google","year":"2012","yearRange":"2012","imageUrl":"https://m.media-amazon.com/images/M/MV5BMGFlNTZiMjYtZDY1Ni00MWFkLTlmNmEtZDZmOTI1Y2E0NzA3XkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg","sources":{"DataSourceType.google":"tt7529532"}}
''',
  r'''
{"uniqueId":"tt8067018","title":"The Rize & Fall of Tephlon Ent ","bestSource":"DataSourceType.google","type":"MovieContentType.movie","year":"2016","yearRange":"2016","imageUrl":"https://m.media-amazon.com/images/M/MV5BMThkYjc1ZTEtYjZlNC00NDNkLWI0M2YtNTAwY2Q1Njc5YzZjXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg","sources":{"DataSourceType.google":"tt8067018"}}
''',
];

const expectedDtoJsonStringLongTitleList = [
  r'''
{"uniqueId":"tt13211062","title":"Osamake: Romcom Where the Childhood Friend Won't Lose ","bestSource":"DataSourceType.google","type":"MovieContentType.series","year":"2021","yearRange":"2021-","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjU1Mjc0YzQtMjUwNC00YTAwLWEzMjgtNTQ0NWI1ZTFlYzhhXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg","sources":{"DataSourceType.google":"tt13211062"}}
''',
];

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryGoogleMovies test', () {
    // Search for a rare movie.
    test('Run read 3 pages from Google', () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput = await QueryGoogleMovies(
        criteria,
      ).readList(limit: 1000);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput =
          expectedDTOList..sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // printTestData(actualOutput);

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 60),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    // Search for a rare movie.
    test('long title', () async {
      final criteria = SearchCriteriaDTO().fromString('tt13211062');
      final actualOutput = await QueryGoogleMovies(
        criteria,
      ).readList(limit: 1000);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput =
          expectedDTOTtileList
            ..sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // printTestData(actualOutput);

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 60),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryGoogleMovies(
        criteria,
      ).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(expectedOutput),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
  });
}
