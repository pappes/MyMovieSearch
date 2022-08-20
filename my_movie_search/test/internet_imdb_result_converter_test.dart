import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';

import 'test_data/imdb_result_converter_data.dart';
import 'test_helper.dart';

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb result converter', () {
    // Check that IMDB html input is converted to matching dto by QueryIMDBTitleDetails
    test('convert HTML to DTO', () async {
      final expectedDTO = await expectedDTOList;

      // Compare the stream output to the expected output.
      var currentExpectedValueIndex = 0;
      void checkOutput(MovieResultDTO streamOutput) {
        final expectedValue = expectedDTO[currentExpectedValueIndex];
        final isExpectedValue = MovieResultDTOMatcher(expectedValue);
        expect(
          streamOutput,
          isExpectedValue,
          reason: 'Emitted DTO ${streamOutput.toPrintableString()} '
              'needs to match expected DTO ${expectedValue.toPrintableString()}',
        );
        currentExpectedValueIndex++;
      }

      // check output against expectations.
      /*final expectFn = expectAsync1<void, MovieResultDTO>(
        checkOutput,
        count: expectedDTO.length,
        max: expectedDTO.length,
      );*/

      // Set up criteria to initialise IMDB search
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = 'tt7602562';
      final imdbResult = QueryIMDBTitleDetails();
      imdbResult.criteria = criteria;
      const testInput = htmlSampleFull;
      final str = emitByteStream(testInput).transform(utf8.decoder);

      // TODO: using mocking to test in offline mode
      // Invoke the search.
      //final stream = imdbResult.myTransformTextStreamToOutputObject(str);

      // Test the results.
      //stream.listen(expectFn);
    });
  });
}
