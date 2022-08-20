import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_suggestion.dart';
import 'package:my_movie_search/utilities/web_data/jsonp_transformer.dart';
import '../../../test_data/imdb_suggestion_converter_data.dart';
import '../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Conceptual testing
////////////////////////////////////////////////////////////////////////////////

void main() {
  ///Sample tests to understand how the test framework works.
  group('stream basics', () {
    // Observe a string being represented as a stream of bytes.
    test('simple Bytesteam test', () {
      // Set up the test data.
      const testInput = 'B(a)';
      final List<List<int>> expectedOutput = [
        [66],
        [40],
        [97],
        [41]
      ];

      int currentRune = 0;
      // Compare the stream output to the expected output.
      void checkOutput(List<int> streamOutput) {
        final char = testInput.substring(currentRune, currentRune + 1);
        final rune = expectedOutput[currentRune];
        expect(
          streamOutput,
          rune,
          reason: 'String charactor $char needs to match rune $rune',
        );
        currentRune++;
      }

      final expectFn = expectAsync1<void, List<int>>(
        checkOutput,
        count: testInput.length,
      );

      // Invoke the functionality.
      final stream = emitByteStream(testInput);

      // Listen to the stream running the test function on each emitted value.
      stream.listen(
        expectFn,
        onDone: () {
          expect(
            currentRune,
            testInput.length,
            reason: 'Emitted rune count needs to equal expected runes',
          );
          // ignore: avoid_print
          print('stream done, all $currentRune elements consumed');
        },
      );
    });

    // Observe UTF8 decoding of the byte stream.
    test('UTF8 decoder test', () {
      // Set up the test data.
      const testInput = '$imdbJsonPFunction(a)';

      int currentChar = 0;
      // Compare the stream output to the expected output.
      void checkOutput(String streamOutput) {
        final expected = testInput.substring(currentChar, currentChar + 1);
        expect(
          streamOutput,
          expected,
          reason: 'Emitted string $streamOutput '
              'needs to match input string $expected',
        );
        currentChar++;
      }

      final expectFn = expectAsync1<void, String>(
        checkOutput,
        count: testInput.length,
      );

      // Invoke the functionality.
      final stream = emitByteStream(testInput).transform(utf8.decoder);

      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn);
    });

    // Observe JSON decoding of the byte stream into a Map.
    test('json decoder test', () {
      // Set up the test data.
      const testInput = imdbJsonSampleOuter;

      // Compare the stream output to the expected output.
      void checkOutput(Object? streamOutput) {
        final decodedOutput = streamOutput! as Map<dynamic, dynamic>;
        expect(
          decodedOutput[imdbCustomKeyName],
          imdbCustomKeyVal,
          reason: 'Emitted map key ${decodedOutput[imdbCustomKeyName]} '
              'needs to contain expected value $imdbCustomKeyVal',
        );
      }

      final expectFn = expectAsync1<void, Object?>(checkOutput, count: 1);

      // Invoke the functionality.
      final stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(json.decoder);

      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn);
    });

    // This is the main thing that we want to test.
    // Preceeding tests are simpler examples to see how this test was built.
    test('jsonp transformer test', () {
      // Set up the test data.
      const testInput = imdbJsonPSampleFull;

      // Compare the stream output to the expected output.
      void checkOutput(Object? streamOutput) {
        final decodedOutput = streamOutput! as Map<dynamic, dynamic>;
        expect(
          decodedOutput[imdbCustomKeyName],
          imdbCustomKeyVal,
          reason: 'Emitted map key ${decodedOutput[imdbCustomKeyName]}} '
              'needs to contain expected value $imdbCustomKeyVal',
        );
      }

      final expectFn = expectAsync1<void, Object?>(checkOutput, count: 1);

      // Invoke the functionality.
      final stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder())
          .transform(json.decoder);

      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn);
    });

    test('extract value from map test', () {
      // Set up the test data.
      const testInput = imdbJsonSampleOuter;

      // Compare the stream output to the expected output.
      void checkOutput(Object? streamOutput) {
        expect(
          streamOutput,
          imdbCustomKeyVal,
          reason: 'Emitted value $streamOutput} '
              'needs to match expected value $imdbCustomKeyVal',
        );
      }

      final expectFn = expectAsync1<void, Object?>(checkOutput, count: 1);

      // Invoke the functionality.
      final stream = emitConsolidatedByteStream(testInput)
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((outerMap) => (outerMap! as Map)[imdbCustomKeyName]);

      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestion converter', () {
    // Convert IMDB suggestions from JSON to dto.
    test('convert raw bytestream to map to DTO', () async {
      // Set up the test data.
      const testInput = imdbJsonPSampleFull;
      final expectedDTO = await expectedDTOList;

      // Compare the stream output to the expected output.
      int dtoCount = 0;
      void checkOutput(MovieResultDTO streamOutput) {
        final currentExpected = dtoCount;
        dtoCount++;
        final expectedValue = expectedDTO[currentExpected];
        final isExpectedValue = MovieResultDTOMatcher(expectedValue);
        expect(
          streamOutput,
          isExpectedValue,
          reason: 'Emitted DTO $streamOutput needs to match expected '
              'DTO[$currentExpected] ${expectedDTO[currentExpected]}',
        );
      }

      final expectFn = expectAsync1<void, MovieResultDTO>(
        checkOutput,
        count: expectedDTO.length,
        max: expectedDTO.length,
      );

      // Invoke the functionality.
      final Stream<MovieResultDTO> stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder())
          .transform(json.decoder)
          // Stream the results collection from within the map.
          .map(
            (outerMap) =>
                (outerMap! as Map)[outerElementResultsCollection] as List,
          )
          // Emit each member of the list as a seperate stream event.
          .expand((listMember) => listMember)
          // Convert each Map result to a DTO
          .map((event) => ImdbSuggestionConverter.dtoFromMap(event as Map));

      // Listen to the stream running the test function on each emitted value.
      stream.listen(expectFn);
    });
  });
}
