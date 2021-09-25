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
      testToNumber(input, expectedOutput) {
        double? number = DoubleHelper.fromText(input);
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
      testToNumber(input, expectedOutput) {
        double? number = DoubleHelper.fromText(input, nullValueSubstitute: -1);
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
      testToNumber(input, expectedOutput) {
        double? number =
            DoubleHelper.fromText(input, zeroValueSubstitute: null);
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
      testToNumber(input, expectedOutput) {
        int? number = DoubleHelper.fromText(input)?.round();
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
      testfromJson(input, List<String> expectedOutput) {
        List<String> actual = ListHelper.fromJson(input);
        expect(actual, expectedOutput, reason: 'input ${input.toString()}');
      }

      //Convert a JSON encoded array to List<String>
      test('string array', () {
        testfromJson('""', [""]);
        testfromJson('["a"]', ["a"]);
        testfromJson('["a", "b","c"]', ["a", "b", "c"]);
        testfromJson('[""]', [""]);
      });

      //Convert empty JSON encoded value to List<String>
      test('empty', () {
        testfromJson(null, []);
        testfromJson('', []);
        testfromJson('[]', []);
        testfromJson('{}', []);
      });

      //Convert a JSON encoded array of numbers to List<String>
      test('numbers', () {
        testfromJson('[0]', ['0']);
        testfromJson('[1,2,3]', ['1', '2', '3']);
      });

      //Convert a JSON encoded objects to List<String>
      test('objects', () {
        testfromJson('[[1,2,3],[4,5,6]]', ['[1, 2, 3]', '[4, 5, 6]']);
        testfromJson('{"first":1, "second":2 }', ['1', '2']);
        testfromJson('[{"first":1, "second":2 }]', ['{first: 1, second: 2}']);
        testfromJson(
            '[{"first":"one", "second":"two" }, {"first":"eleven", "second":"twelve" }]',
            ['{first: one, second: two}', '{first: eleven, second: twelve}']);
        testfromJson(
            '[{"color":"red",	"value":"#f00"}]', ['{color: red, value: #f00}']);
      });
    });

    group('combineUnique', () {
      testcombineUnique(
          List<String> input1, input2, List<String> expectedOutput) {
        input1.combineUnique(input2);
        expect(input1, expectedOutput,
            reason: 'input ${input1.toString()},  ${input2.toString()}');
      }

      // Combining a list with an empty list results in the original list.
      test('empty', () {
        testcombineUnique([], null, []);
        testcombineUnique([], [], []);
        testcombineUnique([''], [], ['']);
        testcombineUnique([], [''], ['']);
      });
      // Combining lists with single elements results in all elements being present.
      test('single element', () {
        testcombineUnique(['a'], [], ['a']);
        testcombineUnique([], ['a'], ['a']);
        testcombineUnique(['b'], ['a'], ['b', 'a']);
      });
      // Combining lists, each with mutiple elements results in all elements being present.
      test('multiple elements', () {
        testcombineUnique(['a', 'b', 'c'], [], ['a', 'b', 'c']);
        testcombineUnique([], ['a', 'b', 'c'], ['a', 'b', 'c']);
        testcombineUnique(
            ['a', 'b', 'c'], ['d', 'e', 'f'], ['a', 'b', 'c', 'd', 'e', 'f']);
      });
      // Combining lists, with differnt datatypes results in all elements being present.
      test('multiple elements different datatypes', () {
        testcombineUnique(['a', 'b', 'c'], [1], ['a', 'b', 'c', '1']);
        testcombineUnique([], [1, 2, 3], ['1', '2', '3']);
        testcombineUnique(
            ['a', 'b', 'c'], [1, 2, 3], ['a', 'b', 'c', '1', '2', '3']);
        testcombineUnique(
            ['a', 'b', 'c'], {'A': '1', 'B': '2'}, ['a', 'b', 'c', '1', '2']);
      });
      // Combining lists, with duplicate elements results in all elements being present once only.
      test('deduplication', () {
        testcombineUnique([], ['', ''], ['']);
        testcombineUnique(['a'], ['a'], ['a']);
        testcombineUnique(['a', 'a', 'a'], ['a'], ['a']);
        testcombineUnique(['a', 'b', 'c'], ['a', 'b', 'c'], ['a', 'b', 'c']);
        testcombineUnique(['a', 'b', 'b'], ['b', 'b', 'c'], ['a', 'b', 'c']);
      });
    });
  });
}
