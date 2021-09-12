import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';

import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('StringHelper', () {
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
    test('toNumber null substitution', () {
      testToNumber(input, expectedOutput) {
        double? number = DoubleHelper.fromText(input, nullValueSubstitute: -1);
        expect(number, expectedOutput);
      }

      testToNumber('number', -1);
    });
    test('toNumber zero substitution', () {
      testToNumber(input, expectedOutput) {
        double? number =
            DoubleHelper.fromText(input, zeroValueSubstitute: null);
        expect(number, expectedOutput);
      }

      testToNumber('0', null);
    });
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
      testfromJson(input, List<String> expectedOutput) {
        List<String> actual = ListHelper.fromJson(input);
        expect(actual, expectedOutput, reason: 'input ${input.toString()}');
      }

      test('string array', () {
        testfromJson('""', [""]);
        testfromJson('["a"]', ["a"]);
        testfromJson('["a", "b","c"]', ["a", "b", "c"]);
        testfromJson('[""]', [""]);
      });

      test('empty', () {
        testfromJson(null, []);
        testfromJson('', []);
        testfromJson('[]', []);
        testfromJson('{}', []);
      });

      test('numbers', () {
        testfromJson('[0]', ['0']);
        testfromJson('[1,2,3]', ['1', '2', '3']);
      });

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

      test('empty', () {
        testcombineUnique([], null, []);
        testcombineUnique([], [], []);
        testcombineUnique([''], [], ['']);
        testcombineUnique([], [''], ['']);
      });
      test('single element', () {
        testcombineUnique(['a'], [], ['a']);
        testcombineUnique([], ['a'], ['a']);
        testcombineUnique(['a'], ['a'], ['a']);
        testcombineUnique(['b'], ['a'], ['b', 'a']);
      });
      test('multiple elements', () {
        testcombineUnique(['a', 'b', 'c'], [], ['a', 'b', 'c']);
        testcombineUnique([], ['a', 'b', 'c'], ['a', 'b', 'c']);
        testcombineUnique(['a', 'b', 'c'], ['a', 'b', 'c'], ['a', 'b', 'c']);
        testcombineUnique(
            ['a', 'b', 'c'], ['d', 'e', 'f'], ['a', 'b', 'c', 'd', 'e', 'f']);
      });
      test('multiple elements', () {
        testcombineUnique(['a', 'b', 'c'], [1], ['a', 'b', 'c', '1']);
        testcombineUnique([], [1, 2, 3], ['1', '2', '3']);
        testcombineUnique(
            ['a', 'b', 'c'], [1, 2, 3], ['a', 'b', 'c', '1', '2', '3']);
        testcombineUnique(
            ['a', 'b', 'c'], {'A': '1', 'B': '2'}, ['a', 'b', 'c', '1', '2']);
      });
    });
  });
}
