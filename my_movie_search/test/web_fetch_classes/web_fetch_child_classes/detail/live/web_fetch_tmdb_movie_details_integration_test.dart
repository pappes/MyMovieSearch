import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_movie_detail.dart';
import 'package:my_movie_search/utilities/environment.dart';

import '../../../../test_helper.dart';
// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real TMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"-1","bestSource":"DataSourceType.tmdbMovie","title":"[tmdbMovie] Error in tmdbMovie with criteria tt0101001 interpreting web text as a map :Error in http read, HTTP status code : 404 for https://api.themoviedb.org/3/movie/tt0101001?api_key=a134ed10","type":"MovieContentType.error","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.tmdbMovie":"-1"},"related":{}}
''',
  r'''
{"uniqueId":"tt0101000","bestSource":"DataSourceType.tmdbMovie","title":"Začátek dlouhého podzimu","year":"1990","language":"LanguageType.foreign",
      "languages":"[\"Czech\"]",
      "genres":"[\"Drama\",\"Family\"]","keywords":"[]","sources":{"DataSourceType.tmdbMovie":"913986"},"related":{}}
''',
  r'''
{"uniqueId":"tt0101002","bestSource":"DataSourceType.tmdbMovie","title":"Return Engagement","alternateTitle":"再戰江湖","year":"1990","runTime":"6480","language":"LanguageType.foreign",
      "languages":"[\"Cantonese\"]",
      "genres":"[\"Crime\",\"Action\",\"Drama\"]","keywords":"[]",
      "description":"A well-known gangster is released from prison, and decides look for his daughter with the help of a troubled young woman.",
      "userRating":"6.0","userRatingCount":"4","sources":{"DataSourceType.tmdbMovie":"230839"},"related":{}}
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
    final future = QueryTMDBMovieDetails().readList(criteria);
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

  group('live QueryTMDBMovieDetails test', () {
    // Convert 3 TMDB pages into dtos.
    test('Run read 3 pages from TMDB', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();

      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);

      actualOutput[1].title = actualOutput[1].title.substring(0, 195);
      actualOutput[1].setSource(newUniqueId: "-1");
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      //print(actualOutput.toListOfDartJsonStrings(excludeCopyrightedData: false));

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 70),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
