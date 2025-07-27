import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_movie_detail.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';
// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real TMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0101000","title":"Začátek dlouhého podzimu","bestSource":"DataSourceType.tmdbMovie","type":"MovieContentType.title","year":"1990","language":"LanguageType.foreign",
      "languages":"[\"Czech\"]",
      "genres":"[\"Drama\"]",
      "description":"The film about curious children who discover a sunken statue of Masaryk in a disused well was interfered with by the events of November and the filmmakers tried to incorporate their echoes into the flow of the narrative. However, the result is at times confusing, as the originally childish adventure has thus grown into a naive social poster child.",
      "userRating":"6.0","userRatingCount":"1","sources":{"DataSourceType.tmdbMovie":"913986"}}
''',
  r'''
{"uniqueId":"tt0101001","title":"A Haunted Romance","bestSource":"DataSourceType.tmdbMovie","alternateTitle":"再世風流劫","type":"MovieContentType.title","year":"1985","runTime":"5280","language":"LanguageType.foreign",
      "languages":"[\"Cantonese\"]",
      "genres":"[\"Horror\"]",
      "description":"Hong Kong horror movie from 1985.","sources":{"DataSourceType.tmdbMovie":"1341041"}}
''',
  r'''
{"uniqueId":"tt0101002","title":"Return Engagement","bestSource":"DataSourceType.tmdbMovie","alternateTitle":"再戰江湖","type":"MovieContentType.title","year":"1990","runTime":"6480","language":"LanguageType.foreign",
      "languages":"[\"Cantonese\"]",
      "genres":"[\"Crime\",\"Action\",\"Drama\"]",
      "description":"A well-known gangster is released from prison, and decides look for his daughter with the help of a troubled young woman.",
      "userRating":"6.6","userRatingCount":"7","imageUrl":"https://image.tmdb.org/t/p/w500/7zwS6ttVbgHXpgehTCcVg1f8nbM.jpg","sources":{"DataSourceType.tmdbMovie":"230839"}}
''',
];
final expectedEmptyDTOList = ListDTOConversion.decodeList(
  expectedEmptyDtoJsonStringList,
);
const expectedEmptyDtoJsonStringList = [
  r'''
{"uniqueId":"-1","bestSource":"DataSourceType.tmdbMovie","title":"[tmdbMovie] Error in QueryTMDBMovieDetails with criteria 0 convert error interpreting web text as a map :tmdb call for criteria 0 returned error:Invalid id: The pre-requisite id is invalid or not found.","type":"MovieContentType.error"}
''',
];

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (int i = 0; i < qty; i++) {
    results.add('tt010${1000 + i}');
  }
  return results;
}

/// Call TMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    // ignore: discarded_futures
    final future = QueryTMDBMovieDetails(criteria).readList();
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
  setUpAll(() async => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryTMDBMovieDetails test', () {
    // Convert 3 TMDB pages into dtos.
    test('Run read 3 pages from TMDB', () async {
      final expectedOutput =
          expectedDTOList..sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);

      //actualOutput[1].title = actualOutput[1].title.substring(0, 195);
      //actualOutput[1].setSource(newUniqueId: "-1");
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

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
      final criteria = SearchCriteriaDTO().fromString('0');
      final actualOutput = await QueryTMDBMovieDetails(
        criteria,
      ).readList(limit: 10);
      final expectedOutput = expectedEmptyDTOList;
      expectedOutput[0].uniqueId = '-1';

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
