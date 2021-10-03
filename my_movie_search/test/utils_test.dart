import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';

import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('StringHelper', () {
    // Convert a string to a number, stripping comma seperators and
    // ignoring non numeric input.
    test('toNumber double', () {
      void testToNumber(input, expectedOutput) {
        final number = DoubleHelper.fromText(input);
        expect(number, expectedOutput);
      }

      testToNumber('0', 0);
      testToNumber('1', 1);
      testToNumber('9,999', 9999);
      testToNumber('1.0', 1.0);
      testToNumber('9,999.99', 9999.99);
      testToNumber('number', null);
    });
  });
  group('StringHelper', () {
    // Convert a string to a number, substituting num values where required.
    test('toNumber null substitution', () {
      void testToNumber(input, expectedOutput) {
        final number = DoubleHelper.fromText(input, nullValueSubstitute: -1);
        expect(number, expectedOutput);
      }

      testToNumber('0', 0);
      testToNumber('1', 1);
      testToNumber('9,999', 9999);
      testToNumber('1.0', 1.0);
      testToNumber('9,999.99', 9999.99);
      testToNumber('number', -1);
    });
    // Convert a string to a number, substituting 0 values where required.
    test('toNumber zero substitution', () {
      void testToNumber(input, expectedOutput) {
        final number = DoubleHelper.fromText(input, zeroValueSubstitute: null);
        expect(number, expectedOutput);
      }

      testToNumber('1', 1);
      testToNumber('9,999', 9999);
      testToNumber('1.0', 1.0);
      testToNumber('9,999.99', 9999.99);
      testToNumber('0', null);
    });
    // Convert a string to a number, rounding decimal values where required.
    test('toNumber int', () {
      void testToNumber(input, expectedOutput) {
        final number = DoubleHelper.fromText(input)?.round();
        expect(number, expectedOutput);
      }

      testToNumber('0', 0);
      testToNumber('1', 1);
      testToNumber('9,999', 9999);
      testToNumber('1.0', 1);
      testToNumber('9,999.99', 10000);
      testToNumber('number', null);
    });
  });

  group('ListStringHelper', () {
    group('fromJson', () {
      /// Convert JSON [input] to a [List] of [String] and compare to [expectedOutput]
      void testFromJson(String? input, List<String> expectedOutput) {
        final actual = ListHelper.fromJson(input);
        expect(actual, expectedOutput, reason: 'input ${input.toString()}');
      }

      //Convert a JSON encoded array to List<String>
      test('string array', () {
        testFromJson('""', [""]);
        testFromJson('["a"]', ["a"]);
        testFromJson('["a", "b","c"]', ["a", "b", "c"]);
        testFromJson('[""]', [""]);
      });

      //Convert empty JSON encoded value to List<String>
      test('empty', () {
        testFromJson(null, []);
        testFromJson('', []);
        testFromJson('[]', []);
        testFromJson('{}', []);
      });

      //Convert a JSON encoded array of numbers to List<String>
      test('numbers', () {
        testFromJson('[0]', ['0']);
        testFromJson('[1,2,3]', ['1', '2', '3']);
      });

      //Convert a JSON encoded objects to List<String>
      test('objects', () {
        testFromJson('[[1,2,3],[4,5,6]]', ['[1, 2, 3]', '[4, 5, 6]']);
        testFromJson('{"first":1, "second":2 }', ['1', '2']);
        testFromJson('[{"first":1, "second":2 }]', ['{first: 1, second: 2}']);
        testFromJson(
            '[{"first":"one", "second":"two" }, {"first":"eleven", "second":"twelve" }]',
            ['{first: one, second: two}', '{first: eleven, second: twelve}']);
        testFromJson(
            '[{"color":"red",	"value":"#f00"}]', ['{color: red, value: #f00}']);
      });
    });

    group('combineUnique', () {
      void testCombineUnique(
          List<String> input1, input2, List<String> expectedOutput) {
        input1.combineUnique(input2);
        expect(input1, expectedOutput,
            reason: 'input ${input1.toString()},  ${input2.toString()}');
      }

      // Combining a list with an empty list results in the original list.
      test('empty', () {
        testCombineUnique([], null, []);
        testCombineUnique([], [], []);
        testCombineUnique([''], [], ['']);
        testCombineUnique([], [''], ['']);
      });
      // Combining lists with single elements results in all elements being present.
      test('single element', () {
        testCombineUnique(['a'], [], ['a']);
        testCombineUnique([], ['a'], ['a']);
        testCombineUnique(['b'], ['a'], ['b', 'a']);
      });
      // Combining lists, each with mutiple elements results in all elements being present.
      test('multiple elements', () {
        testCombineUnique(['a', 'b', 'c'], [], ['a', 'b', 'c']);
        testCombineUnique([], ['a', 'b', 'c'], ['a', 'b', 'c']);
        testCombineUnique(
            ['a', 'b', 'c'], ['d', 'e', 'f'], ['a', 'b', 'c', 'd', 'e', 'f']);
      });
      // Combining lists, with differnt datatypes results in all elements being present.
      test('multiple elements different datatypes', () {
        testCombineUnique(['a', 'b', 'c'], [1], ['a', 'b', 'c', '1']);
        testCombineUnique([], [1, 2, 3], ['1', '2', '3']);
        testCombineUnique(
            ['a', 'b', 'c'], [1, 2, 3], ['a', 'b', 'c', '1', '2', '3']);
        testCombineUnique(
            ['a', 'b', 'c'], {'A': '1', 'B': '2'}, ['a', 'b', 'c', '1', '2']);
      });
      // Combining lists, with duplicate elements results in all elements being present once only.
      test('deduplication', () {
        testCombineUnique([], ['', ''], ['']);
        testCombineUnique(['a'], ['a'], ['a']);
        testCombineUnique(['a', 'a', 'a'], ['a'], ['a']);
        testCombineUnique(['a', 'b', 'c'], ['a', 'b', 'c'], ['a', 'b', 'c']);
        testCombineUnique(['a', 'b', 'b'], ['b', 'b', 'c'], ['a', 'b', 'c']);
      });
    });
  });
}
