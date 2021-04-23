import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'transformer_test_data.dart';
import 'package:my_movie_search/movies/search_providers/jsonp_transformer.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////

Stream<List<int>> emitByteStream(String str) async* {
  for (var rune in str.runes.toList()) {
    yield [rune];
  }
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('transformer', () {
    testPrefix(input, expectedOutput) {
      var decoder = JsonPDecoder();
      var actualOutput = decoder.stripPrefix(input);
      expect(actualOutput, expectedOutput, reason: decoder.toString());
    }

    testSuffix(input, expectedOutput) {
      var decoder = JsonPDecoder();
      decoder.stripPrefix("(");
      var actualOutput = decoder.bufferSuffix(input);
      expect(actualOutput, expectedOutput, reason: decoder.toString());
    }

    testMultiLineConversion(List<String> lines, expectedOutput) {
      var decoder = JsonPDecoder();
      var actualOutput = "";
      lines.forEach((line) {
        actualOutput += decoder.convert(line);
      });
      expect(actualOutput, expectedOutput,
          reason: "input:$lines decoder:${decoder.toString()}");
    }

    testSingleLineConversion(input, expectedOutput) {
      testMultiLineConversion([input], expectedOutput);
    }

    test('stripPrefix no change', () {
      testPrefix("abc", "");
      testPrefix("{abc}", "{abc}");
      testPrefix("[abc]", "[abc]");
      testPrefix("[{abc}]", "[{abc}]");
      testPrefix("{[abc]}", "{[abc]}");

      testPrefix("{()abc}", "{()abc}");
      testPrefix("[()abc]", "[()abc]");
      testPrefix("[(){abc}]", "[(){abc}]");
      testPrefix("{()[abc]}", "{()[abc]}");
      testPrefix("[{()abc}]", "[{()abc}]");
      testPrefix("{[()abc]}", "{[()abc]}");
    });
    test('stripPrefix change required', () {
      testPrefix("jsfunction(abc", "abc");
      testPrefix("jsfunction({abc}", "{abc}");
      testPrefix("jsfunction([abc]", "[abc]");
      testPrefix("jsfunction([{abc}]", "[{abc}]");
      testPrefix("jsfunction({[abc]}", "{[abc]}");
    });

    test('bufferSuffix no change', () {
      testSuffix("abc", "abc");
      testSuffix("{abc}", "{abc}");
      testSuffix("[abc]", "[abc]");
      testSuffix("[{abc}]", "[{abc}]");
      testSuffix("{[abc]}", "{[abc]}");

      testSuffix("{()abc}", "{()abc}");
      testSuffix("[()abc]", "[()abc]");
      testSuffix("[(){abc}]", "[(){abc}]");
      testSuffix("{()[abc]}", "{()[abc]}");
      testSuffix("[{()abc}]", "[{()abc}]");
      testSuffix("{[()abc]}", "{[()abc]}");
    });
    test('bufferSuffix change required', () {
      testSuffix("abc)", "abc");
      testSuffix("{abc})", "{abc}");
      testSuffix("[abc])", "[abc]");
      testSuffix("[{abc}])", "[{abc}]");
      testSuffix("{[abc]})", "{[abc]}");
      testSuffix("()abc)", "()abc");
      testSuffix("(){abc})", "(){abc}");
      testSuffix("()[abc])", "()[abc]");
      testSuffix("()[{abc}])", "()[{abc}]");
      testSuffix("(){[abc]})", "(){[abc]}");
    });
    test('JsonPDecoder single line no change', () {
      testSingleLineConversion("abc", "");
      testSingleLineConversion("{abc}", "{abc}");
      testSingleLineConversion("[abc]", "[abc]");
      testSingleLineConversion("[{abc}]", "[{abc}]");
      testSingleLineConversion("{[abc]}", "{[abc]}");

      testSingleLineConversion("{()abc}", "{()abc}");
      testSingleLineConversion("[()abc]", "[()abc]");
      testSingleLineConversion("[(){abc}]", "[(){abc}]");
      testSingleLineConversion("{()[abc]}", "{()[abc]}");
      testSingleLineConversion("[{()abc}]", "[{()abc}]");
      testSingleLineConversion("{[()abc]}", "{[()abc]}");

      testSingleLineConversion("{abc}()", "{abc}()");
      testSingleLineConversion("[abc]()", "[abc]()");
      testSingleLineConversion("[{abc}]()", "[{abc}]()");
      testSingleLineConversion("{[abc]}()", "{[abc]}()");
      testSingleLineConversion("[{abc}]()", "[{abc}]()");
      testSingleLineConversion("{[abc]}()", "{[abc]}()");

      testSingleLineConversion("abc)", "");
      testSingleLineConversion("{abc})", "{abc})");
      testSingleLineConversion("[abc])", "[abc])");
      testSingleLineConversion("[{abc}])", "[{abc}])");
      testSingleLineConversion("{[abc]})", "{[abc]})");
    });
    test('JsonPDecoder single line change required', () {
      testSingleLineConversion("jsfunction(abc", "abc");
      testSingleLineConversion("jsfunction({abc}", "{abc}");
      testSingleLineConversion("jsfunction([abc]", "[abc]");
      testSingleLineConversion("jsfunction([{abc}]", "[{abc}]");
      testSingleLineConversion("jsfunction({[abc]}", "{[abc]}");

      testSingleLineConversion("jsfunction(abc)", "abc");
      testSingleLineConversion("jsfunction({abc})", "{abc}");
      testSingleLineConversion("jsfunction([abc])", "[abc]");
      testSingleLineConversion("jsfunction([{abc}])", "[{abc}]");
      testSingleLineConversion("jsfunction({[abc]})", "{[abc]}");
    });
    test('JsonPDecoder multiline change required', () {
      testMultiLineConversion(["\n", "jsfunction(abc", "\n"], "abc\n");
      testMultiLineConversion(["\n", "jsfunction(", "abc"], "abc");

      testMultiLineConversion(["jsfunction(", "abc", ")\n"], "abc");
      testMultiLineConversion(["jsfunction(", "(", "abc", ")", ")\n"], "(abc)");
      testMultiLineConversion(["jsfunction(", "()", "abc", "", ")\n"], "()abc");
    });
  });
  group('stream test', () {
    test('transformer', () async {
      String testInput = imdbJsonPSampleFull;
      Stream<String> stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder());

      var expectedString = imdbJsonSampleOuter;
      var emittedString = "";

      var expectFn = expectAsync1<void, String>((output) {
        if (output != "") {
          emittedString += output;
          expect(
              emittedString, expectedString.substring(0, emittedString.length));
        }
      }, count: imdbJsonPSampleFull.length, max: imdbJsonPSampleFull.length);

      doneFn() {
        expect(emittedString, expectedString);
      }

      stream.listen(expectFn, onDone: doneFn);
    });
  });
}
