import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'test_data/imdb_suggestion_converter_data.dart';
import 'test_helper.dart';

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestion query', () {
    // Read IMDB suggestions from a simulated bytestream and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = await expectedDTOList;
      final List<MovieResultDTO> queryResult = [];
      final _imdbSuggestions = QueryIMDBSuggestions();

      // Invoke the functionality.
      await _imdbSuggestions
          .readList(SearchCriteriaDTO(), source: emitImdbJsonSample)
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, ${stackTrace.toString()}'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emmitted DTO list ${queryResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });
  });
}
