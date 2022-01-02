import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';

import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/thread.dart';

// ignore: avoid_classes_with_only_static_members
class ThreadTest {
  static var _counter = 0;
  static Future<int> accumulate(int value) async => _counter += value;
  var _instanceCounter = 0;
  Future<int> instanceAccumulate(int value) async => _instanceCounter += value;
}

int localCounter = 0;
int globalFnAccumulateSync(int value) => localCounter += value;
Future<int> globalFnAccumulateAsync(int value) async => localCounter += value;
Future<int> globalFnAccumulateSlow(int value) async {
  return Future.delayed(
    const Duration(seconds: 2),
    () => localCounter += value,
  );
}

Future<String?> globalFnThreadName(int value) async {
  return ThreadRunner.currentThreadName;
}

class DynamicHelperTest {
  String callToString(dynamic val) => dynamicToString(val);
  static String callToString_(dynamic val) =>
      DynamicHelper.dynamicToString_(val);

  List<String> callToStringList(dynamic val) => dynamicToStringList(val);
  static List<String> callToStringList_(dynamic val) =>
      DynamicHelper.dynamicToStringList_(val);

  int callToInt(dynamic val) => dynamicToInt(val);
  static int callToInt_(dynamic val) => DynamicHelper.dynamicToInt_(val);

  double callToDouble(dynamic val) => dynamicToDouble(val);
  static double callToDouble_(dynamic val) =>
      DynamicHelper.dynamicToDouble_(val);
}

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

Future main() async {
  group('getIdFromIMDBLink', () {
    // Perform processing on another thread
    // then later check the results of that processing.
    test('check sample urls', () {
      void testGetIdFromIMDBLink(String input, expectedOutput) {
        final text = getIdFromIMDBLink(input);
        expect(text, expectedOutput);
      }

      testGetIdFromIMDBLink(
          '/title/tt0145681/?ref_=nm_sims_nm_t_9', 'tt0145681');
      testGetIdFromIMDBLink(
          '/title/tt0145682?ref_=nm_sims_nm_t_9', 'tt0145682');
      testGetIdFromIMDBLink(
          '/name/nm0145683/?ref_=nm_sims_nm_t_9', 'nm0145683');
      testGetIdFromIMDBLink('/name/nm0145684?ref_=nm_sims_nm_t_9', 'nm0145684');
    });
  });

  group('ThreadRunner', () {
    // Perform processing on another thread
    // then later check the results of that processing.
    test('run global async function', () async {
      final threader = ThreadRunner();

      final res1 = threader.run<int>(globalFnAccumulateAsync, 0); // expect 0
      final res2 = threader.run<int>(globalFnAccumulateAsync, 1); // expect 1
      final res3 = threader.run<int>(globalFnAccumulateAsync, 1); // expect 2
      final res4 = threader.run<int>(globalFnAccumulateAsync, 8); // expect 10
      expect(await res1, 0); // 0+0
      expect(await res2, 1); // 0+1
      expect(await res3, 2); // 1+1
      expect(await res4, 10); // 2+8
    });
    test('run global async function untyped', () async {
      final threader = ThreadRunner();

      final res1 = threader.run(globalFnAccumulateAsync, 0); // expect 0
      final res2 = threader.run(globalFnAccumulateAsync, 1); // expect 1
      final res3 = threader.run(globalFnAccumulateAsync, 1); // expect 2
      final res4 = threader.run(globalFnAccumulateAsync, 8); // expect 10
      expect(await res1, 0); // 0+0
      expect(await res2, 1); // 0+1
      expect(await res3, 2); // 1+1
      expect(await res4, 10); // 2+8
    });
    test('run global synchronous function', () async {
      final threader = ThreadRunner();

      final res1 = threader.run(globalFnAccumulateSync, 0); // expect 0
      final res2 = threader.run(globalFnAccumulateSync, 1); // expect 1
      final res3 = threader.run(globalFnAccumulateSync, 1); // expect 2
      final res4 = threader.run(globalFnAccumulateSync, 8); // expect 10
      expect(await res1, 0); // 0+0
      expect(await res2, 1); // 0+1
      expect(await res3, 2); // 1+1
      expect(await res4, 10); // 2+8
    });
    test('run a fast static class function maintaining state', () async {
      final threader = ThreadRunner();

      final res1 = threader.run<int>(ThreadTest.accumulate, 0); // expect 0
      final res2 = threader.run<int>(ThreadTest.accumulate, 1); // expect 1
      final res3 = threader.run<int>(ThreadTest.accumulate, 1); // expect 2
      final res4 = threader.run<int>(ThreadTest.accumulate, 8); // expect 10
      expect(await res1, 0); // 0+0
      expect(await res2, 1); // 0+1
      expect(await res3, 2); // 1+1
      expect(await res4, 10); // 2+8
    });
    test('run a fast instance class function maintaining state', () async {
      final threader = ThreadRunner();

      final instance = ThreadTest();

      final res1 =
          threader.run<int>(instance.instanceAccumulate, 0); // expect 0
      final res2 =
          threader.run<int>(instance.instanceAccumulate, 1); // expect 1
      final res3 =
          threader.run<int>(instance.instanceAccumulate, 1); // expect 1
      final res4 =
          threader.run<int>(instance.instanceAccumulate, 8); // expect 8
      expect(await res1, 0); // 0+0
      expect(await res2, 1); // 0+1
      expect(await res3, 1); // 0+1
      expect(await res4, 8); // 0+8
    });
    test('run throwaway thread', () async {
      final res1 = ThreadRunner().run(globalFnAccumulateSync, 0); // expect 0
      final res2 = ThreadRunner().run(globalFnAccumulateSync, 1); // expect 1
      final res3 = ThreadRunner().run(globalFnAccumulateSync, 1); // expect 1
      final res4 = ThreadRunner().run(globalFnAccumulateSync, 8); // expect 8
      expect(await res1, 0);
      expect(await res2, 1);
      expect(await res3, 1);
      expect(await res4, 8);
    });
    test('run one named thread', () async {
      final res1 = ThreadRunner.namedThread('z').run(globalFnAccumulateSync, 0);
      final res2 = ThreadRunner.namedThread('z').run(globalFnAccumulateSync, 1);
      final res3 = ThreadRunner.namedThread('z').run(globalFnAccumulateSync, 1);
      final res4 = ThreadRunner.namedThread('z').run(globalFnAccumulateSync, 8);
      expect(await res1, 0); // 0+0
      expect(await res2, 1); // 0+1
      expect(await res3, 2); // 1+1
      expect(await res4, 10); // 2+8
    });
    test('run a slow function on multiple named threads', () async {
      expect(ThreadRunner.currentThreadName, 'Default Thread');
      final res1 = ThreadRunner.namedThread('a').run(globalFnAccumulateSlow, 0);
      final res2 = ThreadRunner.namedThread('b').run(globalFnAccumulateSlow, 1);
      final res3 = ThreadRunner.namedThread('c').run(globalFnAccumulateSlow, 1);
      final res4 = ThreadRunner.namedThread('d').run(globalFnAccumulateSlow, 8);
      expect(await res1, 0);
      expect(await res2, 1);
      expect(await res3, 1);
      expect(await res4, 8);
    });
    test('run a slow local function on a single thread', () async {
      final threader = ThreadRunner();
      await threader.initialised;

      final res1 = threader.run(globalFnAccumulateSlow, 0); // expect 0
      final res2 = threader.run(globalFnAccumulateSlow, 1); // expect 1
      final res3 = threader.run(globalFnAccumulateSlow, 1); // expect 2
      final res4 = threader.run(globalFnAccumulateSlow, 8); // expect 10
      expect(await res1, 0); // 0+0
      expect(await res2, 1); // 0+1
      expect(await res3, 2); // 1+1
      expect(await res4, 10); // 2+8
    });
    test('run a function on a named thread', () async {
      expect(ThreadRunner.currentThreadName, 'Default Thread');
      final res1 = ThreadRunner.namedThread('a').run(globalFnThreadName, 0);
      final res2 = ThreadRunner.namedThread('b').run(globalFnThreadName, 0);
      final res3 = ThreadRunner.namedThread('c').run(globalFnThreadName, 0);
      final res4 = ThreadRunner().run(globalFnThreadName, 0);
      expect(await res1, 'a');
      expect(await res2, 'b');
      expect(await res3, 'c');
      expect(await res4, 'Unnamed Thread');
    });
  });

  group('DynamicHelper', () {
    // Convert a value to a string - non static version.
    test('dynamicToString()', () {
      void testToString(input, expectedOutput) {
        final text = DynamicHelperTest().callToString(input);
        expect(text, expectedOutput);
      }

      testToString('9', '9');
      testToString(1, '');
      testToString(1.1, '');
      testToString(null, '');
    });
    // Convert a value to a string - static version.
    test('dynamicToString_()', () {
      void testToString(input, expectedOutput) {
        final text = DynamicHelperTest.callToString_(input);
        expect(text, expectedOutput);
      }

      testToString('9', '9');
      testToString(1, '');
      testToString(1.1, '');
      testToString(null, '');
    });

    // Convert a value to List<string> - non static version.
    test('dynamicToString()', () {
      void testToStringList(input, expectedOutput) {
        final text = DynamicHelperTest().callToStringList(input);
        expect(text, expectedOutput);
      }

      testToStringList(['9'], ['9']);
      testToStringList(['9', '8'], ['9', '8']);
      testToStringList('[9,8]', ['9', '8']);
      testToStringList(1, []);
      testToStringList(1.1, []);
      testToStringList(null, []);
    });
    // Convert a value to List<string> - static version.
    test('dynamicToString_()', () {
      void testToStringList(input, expectedOutput) {
        final text = DynamicHelperTest.callToStringList_(input);
        expect(text, expectedOutput);
      }

      testToStringList(['9'], ['9']);
      testToStringList(['9', '8'], ['9', '8']);
      testToStringList('[9,8]', ['9', '8']);
      testToStringList(1, []);
      testToStringList(1.1, []);
      testToStringList(null, []);
    });

    //TODO: test string list

    // Convert a value to a int - non static version.
    test('dynamicToInt()', () {
      void testToInt(input, expectedOutput) {
        final text = DynamicHelperTest().callToInt(input);
        expect(text, expectedOutput);
      }

      testToInt('9', 9);
      testToInt(1, 1);
      testToInt(1.1, 0);
      testToInt(null, 0);
    });
    // Convert a value to a int - static version.
    test('dynamicToInt_()', () {
      void testToInt(input, expectedOutput) {
        final text = DynamicHelperTest.callToInt_(input);
        expect(text, expectedOutput);
      }

      testToInt('9', 9);
      testToInt(1, 1);
      testToInt(1.1, 0);
      testToInt(null, 0);
    });

    // Convert a value to a double - non static version.
    test('dynamicToDouble()', () {
      void testToDouble(input, expectedOutput) {
        final text = DynamicHelperTest().callToDouble(input);
        expect(text, expectedOutput);
      }

      testToDouble('9', 9);
      testToDouble(1, 1);
      testToDouble(1.1, 1.1);
      testToDouble(null, 0);
    });
    // Convert a value to a double - static version.
    test('dynamicToDouble_()', () {
      void testToDouble(input, expectedOutput) {
        final text = DynamicHelperTest.callToDouble_(input);
        expect(text, expectedOutput);
      }

      testToDouble('9', 9);
      testToDouble(1, 1);
      testToDouble(1.1, 1.1);
      testToDouble(null, 0);
    });
  });

  group('DoubleHelper', () {
    // Convert a string to a number, stripping comma seperators and
    // ignoring non numeric input.
    test('fromText()', () {
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
    // Convert a string to a number, substituting num values where required.
    test('fromText() null substitution', () {
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
    test('fromText() zero substitution', () {
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
    test('fromText() int', () {
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

  group('ListHelper', () {
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
          ['{first: one, second: two}', '{first: eleven, second: twelve}'],
        );
        testFromJson(
          '[{"color":"red",	"value":"#f00"}]',
          ['{color: red, value: #f00}'],
        );
      });
    });

    group('combineUnique', () {
      void testCombineUnique(
        List<String> input1,
        input2,
        List<String> expectedOutput,
      ) {
        input1.combineUnique(input2);
        expect(
          input1,
          expectedOutput,
          reason: 'input ${input1.toString()},  ${input2.toString()}',
        );
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
          ['a', 'b', 'c'],
          ['d', 'e', 'f'],
          ['a', 'b', 'c', 'd', 'e', 'f'],
        );
      });
      // Combining lists, with differnt datatypes results in all elements being present.
      test('multiple elements different datatypes', () {
        testCombineUnique(['a', 'b', 'c'], [1], ['a', 'b', 'c', '1']);
        testCombineUnique([], [1, 2, 3], ['1', '2', '3']);
        testCombineUnique(
          ['a', 'b', 'c'],
          [1, 2, 3],
          ['a', 'b', 'c', '1', '2', '3'],
        );
        testCombineUnique(
          ['a', 'b', 'c'],
          {'A': '1', 'B': '2'},
          ['a', 'b', 'c', '1', '2'],
        );
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
