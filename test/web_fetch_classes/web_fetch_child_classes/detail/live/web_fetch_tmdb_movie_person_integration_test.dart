import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_person_detail.dart';
import 'package:my_movie_search/utilities/settings.dart';

import '../../../../test_helper.dart';
// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real TMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"-2","title":"[tmdbPerson]","bestSource":"DataSourceType.tmdbPerson","type":"MovieContentType.error"}
''',
  r'''
{"uniqueId":"nm0001323","title":"Debbie Harry","bestSource":"DataSourceType.tmdbPerson","type":"MovieContentType.person","year":"1945",
      "description":"Deborah Ann Harry (born Angela Trimble) is an American singer, songwriter and actress, best known as the lead vocalist of the band Blondie.",
      "userRating":"0.61","userRatingCount":"1","imageUrl":"https://image.tmdb.org/t/p/w500/w496cQvkU7KvUcSVV8DMDDowVYv.jpg","sources":{"DataSourceType.tmdbPerson":"102"}}
''',
  r'''
{"uniqueId":"nm0005454","title":"Scott Speedman","bestSource":"DataSourceType.tmdbPerson","type":"MovieContentType.person","year":"1975",
      "description":"Scott Speedman (born September 1, 1975) is a British-born Canadian film and television actor. He is best known for playing Ben Covington in the coming-of-age television drama Felicity and Lycan-Vampire hybrid Michael Corvin in the gothic horror/action Underworld films.\n\nDescription above from the Wikipedia article Scott Speedman, licensed under CC-BY-SA, full list of contributors on Wikipedia.",
      "userRating":"1.535","userRatingCount":"1","imageUrl":"https://image.tmdb.org/t/p/w500/d0fzWMIzsMAXS2M04SKFMof6zQX.jpg","sources":{"DataSourceType.tmdbPerson":"100"}}
''',
  r'''
{"uniqueId":"nm0914455","title":"Leonor Watling","bestSource":"DataSourceType.tmdbPerson","type":"MovieContentType.person","year":"1975",
      "description":"Leonor Elizabeth Ceballos Watling (born July 28, 1975) is an award-winning Spanish film actress and singer.",
      "userRating":"0.8637","userRatingCount":"1","imageUrl":"https://image.tmdb.org/t/p/w500/uyEM3c37lL90by5vmuOk0XZQ83O.jpg","sources":{"DataSourceType.tmdbPerson":"101"}}
''',
];
final expectedEmptyDTOList = ListDTOConversion.decodeList(
  expectedEmptyDtoJsonStringList,
);
const expectedEmptyDtoJsonStringList = [
  r'''
{"uniqueId":"-1","bestSource":"DataSourceType.tmdbPerson","title":"[tmdbPerson] Error in QueryTMDBPersonDetails with criteria 0 convert error interpreting web text as a map :tmdb call for criteria 0 returned error:Invalid id: The pre-requisite id is invalid or not found.","type":"MovieContentType.error"}
''',
];

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (int i = 0; i < qty; i++) {
    results.add('000${100 + i}');
  }
  results.add('000');
  return results;
}

/// Call TMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    // ignore: discarded_futures
    final future = QueryTMDBPersonDetails(criteria).readList();
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
    final dtos = await future;
    queryResult.addAll(dtos);
  }
  return queryResult;
}

void main() {
  // Wait for api key to be initialised
  setUpAll(() async => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryTMDBPersonDetails test', () {
    // Convert 3 TMDB pages into dtos.
    test('Run read 3 pages from TMDB', () async {
      MovieResultDTOHelpers.resetError();

      final expectedOutput =
          expectedDTOList..sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);

      // Massage actual results to match expected results
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      actualOutput.first.title = actualOutput.first.title.substring(
        0,
        expectedOutput.first.title.length,
      );

      // To update expected data, uncomment the following line
      // printTestData(actualOutput);

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 50),
        reason:
            'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('0');
      final actualOutput = await QueryTMDBPersonDetails(
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
