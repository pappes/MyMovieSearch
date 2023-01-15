import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_person_detail.dart';
import 'package:my_movie_search/utilities/environment.dart';

import '../../../../test_helper.dart';
// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real TMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"nm0005454","bestSource":"DataSourceType.tmdbPerson","title":"Scott Speedman","type":"MovieContentType.person","year":"1975","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Scott Speedman (born September 1, 1975) is a British-born Canadian film and television actor. He is best known for playing Ben Covington in the coming-of-age television drama Felicity and Lycan-Vampire hybrid Michael Corvin in the gothic horror/action Underworld films.\n\nDescription above from the Wikipedia article Scott Speedman, licensed under CC-BY-SA, full list of contributors on Wikipedia.",
      "userRating":"23.657","userRatingCount":"1","sources":{"DataSourceType.tmdbPerson":"100"},"related":{}}
''',
  r'''
{"uniqueId":"nm0914455","bestSource":"DataSourceType.tmdbPerson","title":"Leonor Watling","type":"MovieContentType.person","year":"1975","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Leonor Elizabeth Ceballos Watling (born July 28, 1975) is an award-winning Spanish film actress and singer.",
      "userRating":"12.855","userRatingCount":"1","sources":{"DataSourceType.tmdbPerson":"101"},"related":{}}
''',
  r'''
{"uniqueId":"nm0001323","bestSource":"DataSourceType.tmdbPerson","title":"Debbie Harry","type":"MovieContentType.person","year":"1945","languages":"[]","genres":"[]","keywords":"[]",
      "description":"An American singer, songwriter, and actress, known as the lead singer of the new wave band Blondie.",
      "userRating":"9.059","userRatingCount":"1","sources":{"DataSourceType.tmdbPerson":"102"},"related":{}}
''',
  r'''
{"uniqueId":"-2","bestSource":"DataSourceType.tmdbPerson","title":"[QueryTMDBDetails] Error in tmdbPerson with criteria 000 interpreting web text as a map :Error in http read, HTTP status code : 404 for https://api.themoviedb.org/3/person/000?api_key=a134ed10f829ac7b27e5d16f57067951","type":"MovieContentType.error","languages":"[]","genres":"[]","keywords":"[]","related":{}}
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
    final future = QueryTMDBPersonDetails().readList(criteria);
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
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryTMDBPersonDetails test', () {
    // Convert 3 TMDB pages into dtos.
    test('Run read 3 pages from TMDB', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();
      MovieResultDTOHelpers.resetError();

      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);

      // To update expected data, uncomment the following line
      //print(actualOutput.toListOfDartJsonStrings(excludeCopyrightedData: false));

      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 80),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
