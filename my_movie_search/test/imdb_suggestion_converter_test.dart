import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';
import 'test_data/imdb_suggestion_converter_data.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/jsonp_transformer.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_suggestion.dart';

////////////////////////////////////////////////////////////////////////////////
/// Conceptual testing
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('stream basics', () {
    test('simple Bytesteam test', () {
      String testInput = 'B(a)';
      List<List<int>> expectedOutput = [
        [66],
        [40],
        [97],
        [41]
      ];

      int currentRune = 0;
      // Compare the stream output to the expected output.
      void checkOutput(List<int> streamOutput) {
        var char = testInput.substring(currentRune, currentRune + 1);
        var rune = expectedOutput[currentRune];
        expect(
          streamOutput,
          rune,
          reason: 'String charactor $char needs to match rune $rune',
        );
        currentRune++;
      }

      var expectFn = expectAsync1<void, List<int>>(
        checkOutput,
        count: testInput.length,
      );

      var stream = emitByteStream(testInput);
      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn, onDone: () {
        expect(currentRune, testInput.length,
            reason: 'emmitted rune count needs to equal expected runes');
        print('stream done, all $currentRune elements consumed');
      });
    });

    test('UTF8 decoder test', () {
      String testInput = '$imdbJsonPFunction(a)';

      int currentChar = 0;
      // Compare the stream output to the expected output.
      void checkOutput(String streamOutput) {
        var expected = testInput.substring(currentChar, currentChar + 1);
        expect(
          streamOutput,
          expected,
          reason: 'Emmitted string $streamOutput '
              'needs to match input string $expected',
        );
        currentChar++;
      }

      var expectFn = expectAsync1<void, String>(
        checkOutput,
        count: testInput.length,
      );

      var stream = emitByteStream(testInput) // Add in UTF8 decoding to the test
          .transform(utf8.decoder);
      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn);
    });

    test('json decoder test', () {
      String testInput = imdbJsonSampleOuter;

      // Compare the stream output to the expected output.
      void checkOutput(Object? streamOutput) {
        Map decodedOutput = streamOutput as Map<dynamic, dynamic>;
        expect(
          decodedOutput[imdbCustomKeyName],
          imdbCustomKeyVal,
          reason: 'Emmitted map key ${decodedOutput[imdbCustomKeyName]} '
              'needs to contain expected value $imdbCustomKeyVal',
        );
      }

      var expectFn = expectAsync1<void, Object?>(checkOutput, count: 1);

      var stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(json.decoder);
      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn);
    });

    // This is the main thing that we want to tes.
    //Surrounding tests are just simpler examples to see ho this one was built.
    test('jsonp transformer test', () {
      String testInput = imdbJsonPSampleFull;

      // Compare the stream output to the expected output.
      void checkOutput(Object? streamOutput) {
        Map decodedOutput = streamOutput as Map<dynamic, dynamic>;
        expect(
          decodedOutput[imdbCustomKeyName],
          imdbCustomKeyVal,
          reason: 'Emmitted map key ${decodedOutput[imdbCustomKeyName]}} '
              'needs to contain expected value $imdbCustomKeyVal',
        );
      }

      var expectFn = expectAsync1<void, Object?>(checkOutput, count: 1);

      var stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder())
          .transform(json.decoder);
      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn);
    });

    test('extract value from map test', () {
      String testInput = imdbJsonSampleOuter;

      // Compare the stream output to the expected output.
      void checkOutput(Object? streamOutput) {
        expect(
          streamOutput,
          imdbCustomKeyVal,
          reason: 'Emmitted value $streamOutput} '
              'needs to match expected value $imdbCustomKeyVal',
        );
      }

      var expectFn = expectAsync1<void, Object?>(checkOutput, count: 1);

      var stream = emitConsolidatedByteStream(testInput)
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((outerMap) => (outerMap as Map)[imdbCustomKeyName]);
      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestion converter', () {
    test('convert Json to DTO', () async {
      String testInput = imdbJsonPSampleFull;

      var expectedDTO = await expectedDTOList;
      int dtoCount = 0;

      // Compare the stream output to the expected output.
      void checkOutput(MovieResultDTO streamOutput) {
        var expectedValue = expectedDTO[dtoCount];
        var isExpectedValue = MovieResultDTOMatcher(expectedValue);
        expect(
          streamOutput,
          isExpectedValue,
          reason: 'Emmitted DTO $streamOutput} '
              'needs to match expected DTO ${expectedDTO[dtoCount]}',
        );
        dtoCount++;
      }

      var expectFn = expectAsync1<void, MovieResultDTO>(
        checkOutput,
        count: expectedDTO.length,
        max: expectedDTO.length,
      );

      Stream<MovieResultDTO> stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder())
          .transform(json.decoder)
          // Stream the results collection from within the map.
          .map((outerMap) => (outerMap as Map) //
              [outer_element_results_collection])
          // Emit each member of the list as a seperate stream event.
          .expand((listMember) => listMember)
          // Convert each Map result to a DTO
          .map((event) => ImdbSuggestionConverter.dtoFromMap(event));
      stream.listen(expectFn);
    });
  });
}
