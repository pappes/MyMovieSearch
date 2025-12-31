import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_finder.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:quiver/iterables.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real TMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0101000","title":"Začátek dlouhého podzimu","bestSource":"DataSourceType.tmdbFinder","type":"MovieContentType.title","year":"1990","language":"LanguageType.foreign",
      "languages":"[\"cs\"]",
      "description":"The film about curious children who discover a sunken statue of Masaryk in a disused well was interfered with by the events of November and the filmmakers tried to incorporate their echoes into the flow of the narrative. However, the result is at times confusing, as the originally childish adventure has thus grown into a naive social poster child.",
      "userRating":"6.0","userRatingCount":"1","sources":{"DataSourceType.tmdbFinder":"913986"}}
''',
  r'''
{"uniqueId":"tt0101001","title":"A Haunted Romance","bestSource":"DataSourceType.tmdbFinder","alternateTitle":"再世風流劫","type":"MovieContentType.title","year":"1985","language":"LanguageType.foreign",
      "languages":"[\"cn\"]",
      "description":"Hong Kong horror movie from 1985.","sources":{"DataSourceType.tmdbFinder":"1341041"}}
''',
  r'''
{"uniqueId":"tt0101002","title":"Return Engagement","bestSource":"DataSourceType.tmdbFinder","alternateTitle":"再戰江湖","type":"MovieContentType.title","year":"1990","language":"LanguageType.foreign",
      "languages":"[\"cn\"]",
      "description":"A well-known gangster is released from prison, and decides look for his daughter with the help of a troubled young woman.",
      "userRating":"6.6","userRatingCount":"7","sources":{"DataSourceType.tmdbFinder":"230839"}}
''',
];

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (final i in range(0, qty + 1)) {
    results.add('tt010${1000 + i}');
  }
  return results;
}

/// Call TMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    final future = QueryTMDBFinder(criteria).readList();
    futures.add(future);
  }
  return futures;
}

Future<List<MovieResultDTO>> _testRead(List<String> criteria) async {
  // Call TMDB for each criteria in the list.
  final futures = _queueDetailSearch(criteria);

  // Collect the result of all the TMDB queries.
  final queryResult = <MovieResultDTO>[];
  for (final future in futures) {
    queryResult.addAll(await future);
  }
  return queryResult;
}

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryTMDBFinder test', () {
    // Convert 3 TMDB pages into dtos.
    test('Run read 3 pages from TMDB', () async {
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput =
          expectedDTOList..sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // printTestData(actualOutput);

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput = await QueryTMDBFinder(criteria).readList(limit: 10);
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
