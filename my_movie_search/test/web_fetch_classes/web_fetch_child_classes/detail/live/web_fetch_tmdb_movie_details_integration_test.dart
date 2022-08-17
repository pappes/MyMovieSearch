import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_finder.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_movie_detail.dart';
import 'package:my_movie_search/utilities/environment.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real TMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '{"source":"DataSourceType.tmdbMovie","uniqueId":"913986","alternateId":"tt0101000","title":"Začátek dlouhého podzimu (Začátek dlouhého podzimu","year":"1990","languages":["cs","{english_name: Czech, iso_639_1: cs, name: Český}"],"genres":["Drama","Family"],"keywords":[],"related":"{}"}',
  '{"source":"DataSourceType.tmdbMovie","uniqueId":"-1","title":"[QueryTMDBDetails] Error in tmdbMovie with criteria tt0101001 interpreting web text as a map :Error in http read, HTTP status code : 404 for https://api.themoviedb.org/3/movie/tt0101001?api_key=a","type":"MovieContentType.custom","languages":[],"genres":[],"keywords":[],"related":"{}"}',
  '{"source":"DataSourceType.tmdbMovie","uniqueId":"230839","alternateId":"tt0101002","title":"再戰江湖 (Return Engagement","year":"1990","runTime":"6480","languages":["cn","{english_name: Cantonese, iso_639_1: cn, name: 广州话 / 廣州話}"],"genres":["Crime","Action","Drama"],"keywords":[],"description":"A well-known gangster is released from prison, and decides look for his daughter with the help of a troubled young woman.","userRating":"6.0","userRatingCount":"4","related":"{}"}',
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

      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);
      actualOutput[1].title = actualOutput[1].title.substring(0, 195);
      actualOutput[1].uniqueId = "-1";
      actualOutput[1].uniqueId = "-1";
      print(actualOutput.toJsonString());
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(expectedOutput),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
