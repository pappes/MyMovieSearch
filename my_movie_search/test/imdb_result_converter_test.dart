import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';

import 'test_helper.dart';
import 'test_data/imdb_result_converter_data.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb result converter', () {
    test('convert HTML to DTO', () async {
      String testInput = htmlSampleFull;
      final imdbResult = QueryIMDBTitleDetails();
      final criteria = SearchCriteriaDTO();

      var expectedDTO = await expectedDTOList;
      int dtoCount = 0;

      // Compare the stream output to the expected output.
      void checkOutput(MovieResultDTO streamOutput) {
        var expectedValue = expectedDTO[dtoCount];
        var isExpectedValue = MovieResultDTOMatcher(expectedValue);
        expect(
          streamOutput,
          isExpectedValue,
          reason: 'Emmitted DTO $streamOutput '
              'needs to match expected DTO ${expectedDTO[dtoCount]}',
        );
        dtoCount++;
      }

      var expectFn = expectAsync1<void, MovieResultDTO>(
        checkOutput,
        count: expectedDTO.length,
        max: expectedDTO.length,
      );

      criteria.criteriaTitle = 'tt7602562';
      imdbResult.baseTestSetCriteria(criteria);

      Stream<String> str = emitByteStream(testInput).transform(utf8.decoder);
      Stream<MovieResultDTO> stream =
          imdbResult.baseTransformTextStreamToOutput(str);

      stream.listen(expectFn);
    });
  });
}
