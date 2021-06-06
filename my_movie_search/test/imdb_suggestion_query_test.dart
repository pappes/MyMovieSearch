import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';
import 'test_data/imdb_suggestion_converter_data.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestion query', () {
    test('Run ExecuteQuery()', () async {
      List<MovieResultDTO> queryResult = [];
      final QueryIMDBSuggestions _imdbSuggestions = QueryIMDBSuggestions();
      await _imdbSuggestions
          .readList(SearchCriteriaDTO(), source: emitImdbJsonSample)
          .then((values) => queryResult.addAll(values))
          .onError(
              (error, stackTrace) => print('$error, ${stackTrace.toString()}'));

      var expectedValue = await expectedDTOList;
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emmitted DTO list ${queryResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });
  });
}
