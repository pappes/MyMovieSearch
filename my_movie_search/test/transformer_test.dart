import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/utilities/web_data/jsonp_transformer.dart';
import 'test_data/imdb_suggestion_converter_data.dart';
import 'test_helper.dart';

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('transformer', () {
    /// Confirms the JSONP function prefix is removed from the input (if present).
    void testPrefix(String input, String expectedOutput) {
      final decoder = JsonPDecoder();
      final actualOutput = decoder.stripPrefix(input);
      expect(actualOutput, expectedOutput, reason: decoder.toString());
    }

    /// Confirms the closing pearenthesis is removed from the input (if present).
    void testSuffix(String input, String expectedOutput) {
      final decoder = JsonPDecoder();
      // Prime the decoder so that it does not strip the prefix from the input.
      decoder.stripPrefix('(');
      final actualOutput = decoder.bufferSuffix(input);
      expect(actualOutput, expectedOutput, reason: decoder.toString());
    }

    /// Confirm removal is prefix and suffix even across multiple line of input.
    void testMultiLineConversion(List<String> lines, String expectedOutput) {
      final decoder = JsonPDecoder();
      final actualOutput = StringBuffer();
      for (final line in lines) {
        actualOutput.write(decoder.convert(line));
      }
      expect(
        actualOutput.toString(),
        expectedOutput,
        reason: 'input:$lines decoder:${decoder.toString()}',
      );
    }

    /// Confirm removal is prefix and suffix fior a single line of input.
    void testSingleLineConversion(String input, String expectedOutput) {
      testMultiLineConversion([input], expectedOutput);
    }

    // No change made where JSON text encoutered before opening Parenthesis.
    test('stripPrefix no change', () {
      testPrefix('abc', '');
      testPrefix('{abc}', '{abc}');
      testPrefix('[abc]', '[abc]');
      testPrefix('[{abc}]', '[{abc}]');
      testPrefix('{[abc]}', '{[abc]}');

      testPrefix('{()abc}', '{()abc}');
      testPrefix('[()abc]', '[()abc]');
      testPrefix('[(){abc}]', '[(){abc}]');
      testPrefix('{()[abc]}', '{()[abc]}');
      testPrefix('[{()abc}]', '[{()abc}]');
      testPrefix('{[()abc]}', '{[()abc]}');
    });
    // Strip function name and opening parenthesis.
    test('stripPrefix change required', () {
      testPrefix('jsfunction(abc', 'abc');
      testPrefix('jsfunction({abc}', '{abc}');
      testPrefix('jsfunction([abc]', '[abc]');
      testPrefix('jsfunction([{abc}]', '[{abc}]');
      testPrefix('jsfunction({[abc]}', '{[abc]}');
    });

    // No change made where closing Parenthesis is followed by JSON text.
    test('bufferSuffix no change', () {
      testSuffix('abc', 'abc');
      testSuffix('{abc}', '{abc}');
      testSuffix('[abc]', '[abc]');
      testSuffix('[{abc}]', '[{abc}]');
      testSuffix('{[abc]}', '{[abc]}');

      testSuffix('{()abc}', '{()abc}');
      testSuffix('[()abc]', '[()abc]');
      testSuffix('[(){abc}]', '[(){abc}]');
      testSuffix('{()[abc]}', '{()[abc]}');
      testSuffix('[{()abc}]', '[{()abc}]');
      testSuffix('{[()abc]}', '{[()abc]}');
    });
    // Strip closing parenthesis and keep any opening parenthesis.
    test('bufferSuffix change required', () {
      testSuffix('abc)', 'abc');
      testSuffix('{abc})', '{abc}');
      testSuffix('[abc])', '[abc]');
      testSuffix('[{abc}])', '[{abc}]');
      testSuffix('{[abc]})', '{[abc]}');
      testSuffix('()abc)', '()abc');
      testSuffix('(){abc})', '(){abc}');
      testSuffix('()[abc])', '()[abc]');
      testSuffix('()[{abc}])', '()[{abc}]');
      testSuffix('(){[abc]})', '(){[abc]}');
    });
    // No change made where JSON text encoutered before opening Parenthesis.
    test('JsonPDecoder single line no change', () {
      testSingleLineConversion('abc', '');
      testSingleLineConversion('{abc}', '{abc}');
      testSingleLineConversion('[abc]', '[abc]');
      testSingleLineConversion('[{abc}]', '[{abc}]');
      testSingleLineConversion('{[abc]}', '{[abc]}');

      testSingleLineConversion('{()abc}', '{()abc}');
      testSingleLineConversion('[()abc]', '[()abc]');
      testSingleLineConversion('[(){abc}]', '[(){abc}]');
      testSingleLineConversion('{()[abc]}', '{()[abc]}');
      testSingleLineConversion('[{()abc}]', '[{()abc}]');
      testSingleLineConversion('{[()abc]}', '{[()abc]}');

      testSingleLineConversion('{abc}()', '{abc}()');
      testSingleLineConversion('[abc]()', '[abc]()');
      testSingleLineConversion('[{abc}]()', '[{abc}]()');
      testSingleLineConversion('{[abc]}()', '{[abc]}()');
      testSingleLineConversion('[{abc}]()', '[{abc}]()');
      testSingleLineConversion('{[abc]}()', '{[abc]}()');

      testSingleLineConversion('abc)', '');
      testSingleLineConversion('{abc})', '{abc})');
      testSingleLineConversion('[abc])', '[abc])');
      testSingleLineConversion('[{abc}])', '[{abc}])');
      testSingleLineConversion('{[abc]})', '{[abc]})');
      testSingleLineConversion('{[ab)c]}', '{[ab)c]}');
    });
    // Strip function name, opening parenthesis and closing parenthesis (if present).
    test('JsonPDecoder single line change required', () {
      testSingleLineConversion('jsfunction(abc', 'abc');
      testSingleLineConversion('jsfunction({abc}', '{abc}');
      testSingleLineConversion('jsfunction([abc]', '[abc]');
      testSingleLineConversion('jsfunction([{abc}]', '[{abc}]');
      testSingleLineConversion('jsfunction({[abc]}', '{[abc]}');
      testSingleLineConversion('jsfunction({[ab)c]}', '{[ab)c]}');

      testSingleLineConversion('jsfunction(abc)', 'abc');
      testSingleLineConversion('jsfunction({abc})', '{abc}');
      testSingleLineConversion('jsfunction([abc])', '[abc]');
      testSingleLineConversion('jsfunction([{abc}])', '[{abc}]');
      testSingleLineConversion('jsfunction({[abc]})', '{[abc]}');
      testSingleLineConversion('jsfunction({[ab)c]})', '{[ab)c]}');
    });
    // Strip function name, opening parenthesis and closing parenthesis
    // even across multiple lines.
    test('JsonPDecoder multiline change required', () {
      testMultiLineConversion(['\n', 'jsfunction(abc', '\n'], 'abc\n');
      testMultiLineConversion(['\n', 'jsfunction(', 'abc'], 'abc');

      testMultiLineConversion(['jsfunction(', 'abc', ')\n'], 'abc');
      testMultiLineConversion(['jsfunction(', '(', 'abc', ')', ')\n'], '(abc)');
      testMultiLineConversion(['jsfunction(', '()', 'abc', '', ')\n'], '()abc');
    });
  });
  group('stream test', () {
    test('transformer', () async {
      // Set up the test data.
      const testInput = imdbJsonPSampleFull;
      const expectedString = imdbJsonSampleOuter;
      var emittedString = '';

      // Compare the stream output to the expected output.
      final expectFn = expectAsync1<void, String>(
        (output) {
          if (output != '') {
            emittedString += output;
            expect(
              emittedString,
              expectedString.substring(0, emittedString.length),
            );
          }
        },
        count: imdbJsonPSampleFull.length,
        max: imdbJsonPSampleFull.length,
      );

      void doneFn() {
        expect(emittedString, expectedString);
      }

      // Invoke the functionality.
      final stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder());

      stream.listen(expectFn, onDone: doneFn);
    });
  });
}
