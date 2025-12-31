import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/ms_search.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';
// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real MsSearch endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0120193","title":"Stage Fright","bestSource":"DataSourceType.imdb","alternateTitle":"Страх сцены","type":"MovieContentType.short","year":"1997","yearRange":"1997","runTime":"720","language":"LanguageType.allEnglish",
      "languages":"[\"English\"]",
      "genres":"[\"Animation\",\"Short\",\"Drama\",\"Horror\"]",
      "keywords":"[\"human\",\"dog\",\"stop motion animation\",\"stop motion\",\"independent film\"]",
      "description":"A vaudevillian's act involving the juggling of dogs is no longer a hit. He and his partner must face a brutal villain and assorted obstacles in order to secure their future.",
      "userRating":"6.8","userRatingCount":"417","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWVmZGRiOGEtZTA2Yy00ZWRhLWFiNTgtODc4MWU1NjYxMTY0L2ltYWdlXkEyXkFqcGdeQXVyNzE5ODAxOTE@._V1_.jpg","sources":{"DataSourceType.imdb":"tt0120193"}}
''',
  r'''
{"uniqueId":"tt0192145","title":"Humdrum","bestSource":"DataSourceType.imdb","alternateTitle":"Скучища","type":"MovieContentType.short","year":"1999","yearRange":"1999","runTime":"420","language":"LanguageType.allEnglish",
      "languages":"[\"English\"]",
      "genres":"[\"Animation\",\"Short\",\"Comedy\"]",
      "keywords":"[\"shadow\",\"independent film\"]",
      "description":"Two very bored shadowy characters try to think of something to do--and end up playing \"Shadow Puppets.\"",
      "userRating":"6.7","userRatingCount":"429","imageUrl":"https://m.media-amazon.com/images/M/MV5BODM3ZDExNTUtMGQyZC00YWJlLWEyYzctZGZmOGIzOWQ5Zjc5XkEyXkFqcGdeQXVyNzg5OTk2OA@@._V1_.jpg","sources":{"DataSourceType.imdb":"tt0192145"}}
''',
];

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryMsSearchMovies test', () {
    // Search for a rare movie.
    test('Run read 2 pages from MsSearch', () async {
      final criteria = SearchCriteriaDTO().fromString('humdrum');
      final actualOutput =
          await QueryMsSearchMovies(criteria).readList(limit: 1000);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList
        ..sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

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
      Settings().init();
      await Settings().cloudSettingsInitialised;

      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryMsSearchMovies(criteria).readList(limit: 10);
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
