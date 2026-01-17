import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/stream_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

import '../test_helper.dart';

class ThreadTest {
  static var _counter = 0;
  static Future<int> accumulate(int value) async => _counter += value;
  var _instanceCounter = 0;
  Future<int> instanceAccumulate(int value) async => _instanceCounter += value;
}

int localCounter = 0;
int globalFnAccumulateSync(int value) => localCounter += value;
Future<int> globalFnAccumulateAsync(int value) async => localCounter += value;
Future<int> globalFnAccumulateSlow(int value) =>
    Future.delayed(const Duration(seconds: 2), () => localCounter += value);

Future<String?> globalFnThreadName(int value) async =>
    ThreadRunner.currentThreadName;

class DynamicHelperTest {
  String callToString(dynamic val) => dynamicToString(val);
  static String callToString_(dynamic val) => DynamicHelper.toString_(val);

  List<String> callToStringList(dynamic val) => dynamicToStringList(val);
  static List<String> callToStringList_(dynamic val) =>
      DynamicHelper.toStringList_(val);

  int callToInt(dynamic val) => dynamicToInt(val);
  static int callToInt_(dynamic val) => DynamicHelper.toInt_(val);

  double callToDouble(dynamic val) => dynamicToDouble(val);
  static double callToDouble_(dynamic val) => DynamicHelper.toDouble_(val);
}

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

Future<void> main() async {
  group('DurationHelper', () {
    // Formatted time includes the correct values.
    test('toFormattedTime converts duration to string', () {
      const input = Duration(
        days: 10,
        hours: 20,
        minutes: 30,
        seconds: 40,
        milliseconds: 50,
        microseconds: 60,
      );
      const expectedOutput = '260:30:40';
      expect(input.toFormattedTime(), expectedOutput);
    });
    // All ISO duration components can be encoded except year and month.
    test('fromIso8601 values from a string', () {
      const input = 'P1W3DT20H30M40S';
      const expectedOutput = Duration(
        days: 10,
        hours: 20,
        minutes: 30,
        seconds: 40,
      );
      expect(Duration.zero.fromIso8601(input), expectedOutput);
    });
  });

  group('dom extensions', () {
    // dom componenets can be referenced by enum.
    final dom = parse('''
<html>
 <body>
  <a href=https://stuff.com>this is a alink </a>
</html>
''');
    test('getAttribute uses the enum to identify the attribute to extract', () {
      const expectedOutput = 'https://stuff.com';
      final anchors = dom.body!.getElementsByType(ElementType.anchor);
      final anchorElement = anchors.first;
      final url = anchorElement.getAttribute(AttributeType.address);
      expect(url, expectedOutput);
    });
  });

  group('enum extensions', () {
    // dom componenets can be referenced by enum.
    test('getEnumValue converts a qualified string to an enumeration', () {
      expect(
        ElementType.values.byFullName('ElementType.anchor'),
        ElementType.anchor,
      );
    });
    test('getEnumValue converts a string to an enumeration', () {
      expect(ElementType.values.byFullName('anchor'), ElementType.anchor);
    });
    test('getEnumValue accepts null', () {
      expect(ElementType.values.byFullName(null), null);
    });
    test('getEnumValue accepts empty string', () {
      expect(ElementType.values.byFullName(''), null);
    });
    test('getEnumValue rejects invalid string', () {
      expect(
        () => ElementType.values.byFullName('invalid'),
        throwsArgumentError,
      );
    });
  });

  group('SteamHelper printStream', () {
    Future<void> testPrint(
      String input,
      String expectedValue, [
      String? expectedError,
    ]) async {
      final actualOutput = emitStringChars(input);
      final doublePrint = actualOutput
          .printStream('print1:')
          .printStream('print2:');
      final revivedStream = doublePrint.toList().then(Stream.fromIterable);

      await expectLater(
        revivedStream,
        completion(emitsInOrder(expectedValue.characters.toList())),
      );
    }

    // Ensure that stream can be observed multiple times and not cause issues.
    test(
      'printStream outputs the same stream',
      () async {
        const input = 'abc';
        const output = 'abc';
        await testPrint(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  group('SteamHelper printStreamFuture', () {
    Future<void> testPrint(
      String input,
      String expectedValue, [
      String? expectedError,
    ]) async {
      final actualOutput = Future.delayed(
        const Duration(seconds: 1),
        () => emitStringChars(input),
      );
      final doublePrint = actualOutput
          .printStreamFuture('print1:')
          .printStreamFuture('print2:')
          .then((stream) => stream.toList())
          .then(Stream.fromIterable);

      expect(
        doublePrint,
        completion(emitsInOrder(expectedValue.characters.toList())),
      );
    }

    // Ensure that stream can be observed multiple times and not cause issues.
    test(
      'printStream outputs the same stream',
      () async {
        const input = 'abc';
        const output = 'abc';
        await testPrint(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  group('OnlineOfflineSelector', () {
    // Ensure correct function is selected.
    String fnOnline() => 'online';
    String fnOffline() => 'offline';
    test('default select to online', () {
      final selecter = OnlineOfflineSelector();
      final fn = selecter.select(fnOnline, fnOffline);
      expect(fn(), 'online');
    });
    test('default init(null) to  select to online', () {
      OnlineOfflineSelector.init(null);
      final selecter = OnlineOfflineSelector();
      final fn = selecter.select(fnOnline, fnOffline);
      expect(fn(), 'online');
    });
    test('override select to offline', () {
      OnlineOfflineSelector.init('true');
      final selecter = OnlineOfflineSelector();
      final fn = selecter.select(fnOnline, fnOffline);
      expect(fn(), 'offline');
    });
    test('override select to online', () {
      OnlineOfflineSelector.init('true');
      OnlineOfflineSelector.init('false');
      final selecter = OnlineOfflineSelector();
      final fn = selecter.select(fnOnline, fnOffline);
      expect(fn(), 'online');
    });
    test('override select to offline uppercase', () {
      OnlineOfflineSelector.init('TRUE');
      final selecter = OnlineOfflineSelector();
      final fn = selecter.select(fnOnline, fnOffline);
      expect(fn(), 'offline');
    });
  });

  group('ThreadRunner', () {
    // Perform processing on another thread
    // then later check the results of that processing.
    test('run global async function', () {
      final threader = ThreadRunner();

      final res1 = threader.run<int>(globalFnAccumulateAsync, 0); // expect 0
      final res2 = threader.run<int>(globalFnAccumulateAsync, 1); // expect 1
      final res3 = threader.run<int>(globalFnAccumulateAsync, 1); // expect 2
      final res4 = threader.run<int>(globalFnAccumulateAsync, 8); // expect 10
      expect(res1, completion(0)); // 0+0
      expect(res2, completion(1)); // 0+1
      expect(res3, completion(2)); // 1+1
      expect(res4, completion(10)); // 2+8
    });
    test('run global async function untyped', () {
      final threader = ThreadRunner();

      final res1 = threader.run(globalFnAccumulateAsync, 0); // expect 0
      final res2 = threader.run(globalFnAccumulateAsync, 1); // expect 1
      final res3 = threader.run(globalFnAccumulateAsync, 1); // expect 2
      final res4 = threader.run(globalFnAccumulateAsync, 8); // expect 10
      expect(res1, completion(0)); // 0+0
      expect(res2, completion(1)); // 0+1
      expect(res3, completion(2)); // 1+1
      expect(res4, completion(10)); // 2+8
    });
    test('run global synchronous function', () {
      final threader = ThreadRunner();

      final res1 = threader.run(globalFnAccumulateSync, 0); // expect 0
      final res2 = threader.run(globalFnAccumulateSync, 1); // expect 1
      final res3 = threader.run(globalFnAccumulateSync, 1); // expect 2
      final res4 = threader.run(globalFnAccumulateSync, 8); // expect 10
      expect(res1, completion(0)); // 0+0
      expect(res2, completion(1)); // 0+1
      expect(res3, completion(2)); // 1+1
      expect(res4, completion(10)); // 2+8
    });
    test('run a fast static class function maintaining state', () {
      final threader = ThreadRunner();

      final res1 = threader.run<int>(ThreadTest.accumulate, 0); // expect 0
      final res2 = threader.run<int>(ThreadTest.accumulate, 1); // expect 1
      final res3 = threader.run<int>(ThreadTest.accumulate, 1); // expect 2
      final res4 = threader.run<int>(ThreadTest.accumulate, 8); // expect 10
      expect(res1, completion(0)); // 0+0
      expect(res2, completion(1)); // 0+1
      expect(res3, completion(2)); // 1+1
      expect(res4, completion(10)); // 2+8
    });
    test('run a fast instance class function maintaining state', () {
      final threader = ThreadRunner();

      final instance = ThreadTest();

      final res1 = threader.run<int>(
        instance.instanceAccumulate,
        0,
      ); // expect 0
      final res2 = threader.run<int>(
        instance.instanceAccumulate,
        1,
      ); // expect 1
      final res3 = threader.run<int>(
        instance.instanceAccumulate,
        1,
      ); // expect 1
      final res4 = threader.run<int>(
        instance.instanceAccumulate,
        8,
      ); // expect 8
      expect(res1, completion(0)); // 0+0
      expect(res2, completion(1)); // 0+1
      expect(res3, completion(1)); // 0+1
      expect(res4, completion(8)); // 0+8
    });
    test('run throwaway thread', () {
      final res1 = ThreadRunner().run(globalFnAccumulateSync, 0); // expect 0
      final res2 = ThreadRunner().run(globalFnAccumulateSync, 1); // expect 1
      final res3 = ThreadRunner().run(globalFnAccumulateSync, 1); // expect 1
      final res4 = ThreadRunner().run(globalFnAccumulateSync, 8); // expect 8
      expect(res1, completion(0));
      expect(res2, completion(1));
      expect(res3, completion(1));
      expect(res4, completion(8));
    });
    test('run one named thread', () {
      final res1 = ThreadRunner.namedThread('z').run(globalFnAccumulateSync, 0);
      final res2 = ThreadRunner.namedThread('z').run(globalFnAccumulateSync, 1);
      final res3 = ThreadRunner.namedThread('z').run(globalFnAccumulateSync, 1);
      final res4 = ThreadRunner.namedThread('z').run(globalFnAccumulateSync, 8);
      expect(res1, completion(0)); // 0+0
      expect(res2, completion(1)); // 0+1
      expect(res3, completion(2)); // 1+1
      expect(res4, completion(10)); // 2+8
    });
    test('run a slow function on multiple named threads', () {
      expect(ThreadRunner.currentThreadName, 'Default Thread');
      final res1 = ThreadRunner.namedThread('a').run(globalFnAccumulateSlow, 0);
      final res2 = ThreadRunner.namedThread('b').run(globalFnAccumulateSlow, 1);
      final res3 = ThreadRunner.namedThread('c').run(globalFnAccumulateSlow, 1);
      final res4 = ThreadRunner.namedThread('d').run(globalFnAccumulateSlow, 8);
      expect(res1, completion(0));
      expect(res2, completion(1));
      expect(res3, completion(1));
      expect(res4, completion(8));
    });
    test('run a slow local function on a single thread', () async {
      final threader = ThreadRunner();
      await threader.initialised;

      final res1 = threader.run(globalFnAccumulateSlow, 0); // expect 0
      final res2 = threader.run(globalFnAccumulateSlow, 1); // expect 1
      final res3 = threader.run(globalFnAccumulateSlow, 1); // expect 2
      final res4 = threader.run(globalFnAccumulateSlow, 8); // expect 10
      expect(res1, completion(0)); // 0+0
      expect(res2, completion(1)); // 0+1
      expect(res3, completion(2)); // 1+1
      expect(res4, completion(10)); // 2+8
    });
    test('run a function on a named thread', () {
      expect(ThreadRunner.currentThreadName, 'Default Thread');
      final res1 = ThreadRunner.namedThread('a').run(globalFnThreadName, 0);
      final res2 = ThreadRunner.namedThread('b').run(globalFnThreadName, 0);
      final res3 = ThreadRunner.namedThread('c').run(globalFnThreadName, 0);
      final res4 = ThreadRunner().run(globalFnThreadName, 0);
      expect(res1, completion('a'));
      expect(res2, completion('b'));
      expect(res3, completion('c'));
      expect(res4, completion('Unnamed Thread'));
    });
  });

  group('DynamicHelper', () {
    // Convert a value to a string - non static version.
    test('dynamicToString()', () {
      void testToString(dynamic input, String expectedOutput) =>
          expect(DynamicHelperTest().callToString(input), expectedOutput);

      testToString('9', '9');
      testToString(1, '');
      testToString(1.1, '');
      testToString(null, '');
    });
    // Convert a value to a string - static version.
    test('dynamicToString_()', () {
      void testToString(dynamic input, String expectedOutput) =>
          expect(DynamicHelperTest.callToString_(input), expectedOutput);

      testToString('9', '9');
      testToString(1, '');
      testToString(1.1, '');
      testToString(null, '');
    });

    // Convert a value to List<string> - non static version.
    test('dynamicToString()', () {
      void testToStringList(dynamic input, List<String> expectedOutput) =>
          expect(DynamicHelperTest().callToStringList(input), expectedOutput);

      testToStringList(['9'], ['9']);
      testToStringList(['9', '8'], ['9', '8']);
      testToStringList('[9,8]', ['9', '8']);
      testToStringList(1, []);
      testToStringList(1.1, []);
      testToStringList(null, []);
    });
    // Convert a value to List<string> - static version.
    test('dynamicToString_()', () {
      void testToStringList(dynamic input, List<String> expectedOutput) =>
          expect(DynamicHelperTest.callToStringList_(input), expectedOutput);

      testToStringList(['9'], ['9']);
      testToStringList(['9', '8'], ['9', '8']);
      testToStringList('[9,8]', ['9', '8']);
      testToStringList(1, []);
      testToStringList(1.1, []);
      testToStringList(null, []);
    });

    // Convert a value to a int - non static version.
    test('dynamicToInt()', () {
      void testToInt(dynamic input, int expectedOutput) =>
          expect(DynamicHelperTest().callToInt(input), expectedOutput);

      testToInt('9', 9);
      testToInt(1, 1);
      testToInt(1.1, 0);
      testToInt(null, 0);
    });
    // Convert a value to a int - static version.
    test('dynamicToInt_()', () {
      void testToInt(dynamic input, int expectedOutput) =>
          expect(DynamicHelperTest.callToInt_(input), expectedOutput);

      testToInt('9', 9);
      testToInt(1, 1);
      testToInt(1.1, 0);
      testToInt(null, 0);
    });

    // Convert a value to a double - non static version.
    test('dynamicToDouble()', () {
      void testToDouble(dynamic input, double expectedOutput) =>
          expect(DynamicHelperTest().callToDouble(input), expectedOutput);

      testToDouble('9', 9);
      testToDouble(1, 1);
      testToDouble(1.1, 1.1);
      testToDouble(null, 0);
    });
    // Convert a value to a double - static version.
    test('dynamicToDouble_()', () {
      void testToDouble(dynamic input, double expectedOutput) =>
          expect(DynamicHelperTest.callToDouble_(input), expectedOutput);

      testToDouble('9', 9);
      testToDouble(1, 1);
      testToDouble(1.1, 1.1);
      testToDouble(null, 0);
    });
  });

  group('IntHelper', () {
    // Convert a string to a number, stripping comma seperators,
    // rounding decimals and ignoring non numeric input.
    test('fromText()', () {
      void testToNumber(String? input, int? expectedOutput) =>
          expect(IntHelper.fromText(input), expectedOutput);

      testToNumber('0', 0);
      testToNumber('1', 1);
      testToNumber('9,999', 9999);
      testToNumber('1.0', 1);
      testToNumber('9,999.99', 10000);
      testToNumber('number', null);
      testToNumber(null, null);
    });
  });

  group('DoubleHelper', () {
    // Convert a string to a number, stripping comma seperators and
    // ignoring non numeric input.
    test('fromText()', () {
      void testToNumber(String? input, double? expectedOutput) =>
          expect(DoubleHelper.fromText(input), expectedOutput);

      testToNumber('0', 0);
      testToNumber('1', 1);
      testToNumber('9,999', 9999);
      testToNumber('1.0', 1);
      testToNumber('9,999.99', 9999.99);
      testToNumber('number', null);
      testToNumber(null, null);
    });
    // Convert a string to a number, substituting num values where required.
    test('fromText() null substitution', () {
      void testToNumber(String input, double expectedOutput) => expect(
        DoubleHelper.fromText(input, nullValueSubstitute: -1),
        expectedOutput,
      );

      testToNumber('0', 0);
      testToNumber('1', 1);
      testToNumber('9,999', 9999);
      testToNumber('1.0', 1);
      testToNumber('9,999.99', 9999.99);
      testToNumber('number', -1);
    });
    // Convert a string to a number, substituting 0 values where required.
    test('fromText() zero substitution', () {
      void testToNumber(String input, double? expectedOutput) => expect(
        DoubleHelper.fromText(input, zeroValueSubstitute: null),
        expectedOutput,
      );

      testToNumber('1', 1);
      testToNumber('9,999', 9999);
      testToNumber('1.0', 1);
      testToNumber('9,999.99', 9999.99);
      testToNumber('0', null);
    });
    // Convert a string to a number, rounding decimal values where required.
    test('fromText() int', () {
      void testToNumber(String input, int? expectedOutput) =>
          expect(DoubleHelper.fromText(input)?.round(), expectedOutput);

      testToNumber('0', 0);
      testToNumber('1', 1);
      testToNumber('9,999', 9999);
      testToNumber('1.0', 1);
      testToNumber('9,999.99', 10000);
      testToNumber('number', null);
    });
  });

  group('OptionalStringHelper', () {
    // Convert a string to a numeric year, stripping comma seperators and
    // ignoring non numeric input.
    test('getYear()', () {
      void testToNumber(String? input, int? expectedOutput) =>
          expect(input.getYear(), expectedOutput, reason: 'input = $input');

      testToNumber('0000', 0);
      testToNumber('0001', 1);
      testToNumber('2010', 2010);
      testToNumber('(2010)', 2010);
      testToNumber('2011-2014', 2014);
      testToNumber('(2011-2014)', 2014);
      testToNumber('2015-', 2015);
      testToNumber('(2015-)', 2015);
      testToNumber('(2015- )', 2015);
      testToNumber('number', null);
      testToNumber('2011\r\n2014', 2014);
      testToNumber('2011\n2014', 2014);
      testToNumber('2011\r2014', 2014);
      testToNumber(null, null);
    });
  });

  group('StringHelper', () {
    test('removeYear()', () {
      void testRemoveYear(
        String input,
        String expectedOutput, {
        String substitution = 'none',
      }) {
        if ('none' == substitution) {
          final number = input.removeYear();
          expect(number, expectedOutput, reason: 'input = $input');
        } else {
          final number = input.removeYear(substitution);
          expect(
            number,
            expectedOutput,
            reason: "input = $input, '$substitution'",
          );
        }
      }

      testRemoveYear('2001 a space odyssey', '  a space odyssey');
      testRemoveYear(
        '2010: The year we made contact (sequal to 2001 a space odyssey)',
        ' : The year we made contact (sequal to   a space odyssey)',
      );
      testRemoveYear('2010', ' ');
      testRemoveYear('(2010)', '( )');
      testRemoveYear('2011-2014', ' - ');
      testRemoveYear('(2011-2014)', '( - )');
      testRemoveYear('2015-', ' -');
      testRemoveYear('(2015-)', '( -)');
      testRemoveYear('(2015- )', '( - )');
      testRemoveYear('number', 'number');
      testRemoveYear('2011\r\n2014', ' \r\n ');
      testRemoveYear('2011\n2014', ' \n ');
      testRemoveYear('2011\r2014', ' \r ');
      testRemoveYear('(2001)', '( )');
      testRemoveYear('', '', substitution: 'null');
      testRemoveYear('', '', substitution: '');
      testRemoveYear('', '', substitution: ' ');
      testRemoveYear('(2001)', '( )', substitution: ' ');
      testRemoveYear('(2001)', '()', substitution: '');
    });
    test('removePunctuation()', () {
      void testRemovePunctuation(
        String input,
        String expectedOutput, {
        String substitution = 'none',
      }) {
        if ('none' == substitution) {
          final number = input.removePunctuation();
          expect(number, expectedOutput, reason: 'input = $input');
        } else {
          final number = input.removePunctuation(substitution);
          expect(
            number,
            expectedOutput,
            reason: "input = $input, '$substitution'",
          );
        }
      }

      testRemovePunctuation(' 2001 a space odyssey ', ' 2001 a space odyssey ');
      testRemovePunctuation(
        '2010: The year we made contact (sequal to 2001 a space odyssey)',
        '2010  The year we made contact  sequal to 2001 a space odyssey ',
      );
      testRemovePunctuation(r'~`!@#$%^&*()_+-=', '                ');
      testRemovePunctuation(r'~`!@#$%^&*()_+-=', '', substitution: '');
      testRemovePunctuation('\r\n\t', '   ');
      testRemovePunctuation('\r\n\t', '---', substitution: '-');
    });

    test('addColonIfNeeded()', () {
      void testAddColonIfNeeded(String input, String expectedOutput) {
        final result = input.addColonIfNeeded();
        expect(result, expectedOutput, reason: 'input = $input');
      }

      testAddColonIfNeeded('Title', 'Title:');
      testAddColonIfNeeded('Title:', 'Title:');
      testAddColonIfNeeded('', ':');
    });

    test('reduceWhitespace()', () {
      void testReduceWhitespace(
        String input,
        String expectedOutput, {
        String substitution = 'none',
      }) {
        if ('none' == substitution) {
          final number = input.reduceWhitespace();
          expect(number, expectedOutput, reason: 'input = $input');
        } else {
          final number = input.reduceWhitespace(substitution);
          expect(
            number,
            expectedOutput,
            reason: "input = $input, '$substitution'",
          );
        }
      }

      testReduceWhitespace(' .       . ', '. .');
      testReduceWhitespace(' .  . ', '.-.', substitution: '-');
      testReduceWhitespace(' 2001 a space odyssey ', '2001 a space odyssey');
      testReduceWhitespace(
        '2010  The year we made contact  sequal to 2001 a space odyssey ',
        '2010 The year we made contact sequal to 2001 a space odyssey',
      );
      testReduceWhitespace(
        ' .\r\n\t\v\u{00a0}  \r\n\t\v\u{00a0}  \r\n\t\v\u{00a0}  . ',
        '. .',
      );
    });
  });

  group('ListHelper', () {
    group('trimJoin', () {
      // Find timJoin removes trailing whitepsace.
      test('empty collection', () {
        expect(<String>[].trimJoin(), '');
      });
      test('just whitespace', () {
        expect([' ', ' '].trimJoin(), '');
      });
      test('no whitespace', () {
        expect(['a', ' ', 'b'].trimJoin(), 'a b');
      });
      test('separator whitespace', () {
        expect(['a', ' ', 'b'].trimJoin(' '), 'a   b');
      });
      test('begining whitespace', () {
        expect([' - ', 'a', ' ', 'b'].trimJoin(' ', ' -'), 'a   b');
      });
      test('end whitespace', () {
        expect(['a', ' ', 'b', ' - '].trimJoin(' ', ' -'), 'a   b');
      });
    });
    group('fromJson', () {
      /// Convert JSON [input] to a [List] of [String]
      /// and compare to [expectedOutput]
      void testFromJson(String? input, List<String> expectedOutput) => expect(
        StringIterableHelper.fromJson(input),
        expectedOutput,
        reason: 'input $input',
      );

      // Convert a JSON encoded array to List<String>
      test('string array', () {
        testFromJson('""', ['']);
        testFromJson('["a"]', ['a']);
        testFromJson('["a", "b","c"]', ['a', 'b', 'c']);
        testFromJson('[""]', ['']);
      });

      // Convert empty JSON encoded value to List<String>
      test('empty', () {
        testFromJson(null, []);
        testFromJson('', []);
        testFromJson('[]', []);
        testFromJson('{}', []);
      });

      // Convert a JSON encoded array of numbers to List<String>
      test('numbers', () {
        testFromJson('[0]', ['0']);
        testFromJson('[1,2,3]', ['1', '2', '3']);
      });

      // Convert a JSON encoded objects to List<String>
      test('objects', () {
        testFromJson('[[1,2,3],[4,5,6]]', ['[1, 2, 3]', '[4, 5, 6]']);
        testFromJson('{"first":1, "second":2 }', ['1', '2']);
        testFromJson('[{"first":1, "second":2 }]', ['{first: 1, second: 2}']);
        testFromJson(
          '[{"first":"one", "second":"two" }, '
          '{"first":"eleven", "second":"twelve" }]',
          ['{first: one, second: two}', '{first: eleven, second: twelve}'],
        );
        testFromJson('[{"color":"red",	"value":"#f00"}]', [
          '{color: red, value: #f00}',
        ]);
      });
    });

    group('combineUnique', () {
      void testCombineUnique(
        List<String> input1,
        dynamic input2,
        List<String> expectedOutput,
      ) {
        input1.combineUnique(input2);
        expect(input1, expectedOutput, reason: 'input $input1,  $input2');
      }

      // Combining a list with an empty list results in the original list.
      test('empty', () {
        testCombineUnique([], null, []);
        testCombineUnique([], <void>[], []);
        testCombineUnique([''], <void>[], ['']);
        testCombineUnique([], [''], ['']);
      });
      // Combining lists with single elements
      // results in all elements being present.
      test('single element', () {
        testCombineUnique(['a'], <void>[], ['a']);
        testCombineUnique([], ['a'], ['a']);
        testCombineUnique(['b'], ['a'], ['b', 'a']);
      });
      // Combining lists, each with mutiple elements
      // results in all elements being present.
      test('multiple elements', () {
        testCombineUnique(['a', 'b', 'c'], <void>[], ['a', 'b', 'c']);
        testCombineUnique([], ['a', 'b', 'c'], ['a', 'b', 'c']);
        testCombineUnique(['a', 'b', 'c'], ['d', 'e', 'f'], [
          'a',
          'b',
          'c',
          'd',
          'e',
          'f',
        ]);
      });
      // Combining lists, with differnt datatypes
      // results in all elements being present.
      test('multiple elements different datatypes', () {
        testCombineUnique(['a', 'b', 'c'], [1], ['a', 'b', 'c', '1']);
        testCombineUnique([], [1, 2, 3], ['1', '2', '3']);
        testCombineUnique(['a', 'b', 'c'], [1, 2, 3], [
          'a',
          'b',
          'c',
          '1',
          '2',
          '3',
        ]);
        testCombineUnique(['a', 'b', 'c'], {'A': '1', 'B': '2'}, [
          'a',
          'b',
          'c',
          '1',
          '2',
        ]);
      });
      // Combining lists, with duplicate elements
      // results in all elements being present once only.
      test('deduplication', () {
        testCombineUnique([], ['', ''], ['']);
        testCombineUnique(['a'], ['a'], ['a']);
        testCombineUnique(['a', 'a', 'a'], ['a'], ['a']);
        testCombineUnique(['a', 'b', 'c'], ['a', 'b', 'c'], ['a', 'b', 'c']);
        testCombineUnique(['a', 'b', 'b'], ['b', 'b', 'c'], ['a', 'b', 'c']);
      });
    });
  });

  group('TreeHelper', () {
    final simpleMap = {'marco': 'polo'};
    final complexMap = [
      'needle', //this list entry should not match - the value has no "key"
      {
        'text': {'exposition': 'blahblahblah', 'summary': 'concise'},
        'needlesstosay': 'thisisnotahaystack',
        'thisisaneedle': ['this', 'is', 'a', 'haystack'],
        'needle': 'haystack1',
        'marco': [
          {'marco': 'polo'},
          {'vac': 'polio'},
          {'a': 'b', 'needle': 2, 123: 456, 'needle123': 'haystack456'},
          {
            'needle': {'haystacks': 'haystack3'},
          },
        ],
      },
      {
        'pond',
        {
          'barn': {
            'horse': 'stall',
            'needle': {'haystack4'},
            'dog': 'house',
          },
        },
        'tree',
      },
      'haystack',
    ];

    group('deepSearch', () {
      // Find a value in a map when there are no other values.
      test('simple map search', () {
        expect(TreeHelper(simpleMap).deepSearch('marco'), ['polo']);
      });
      // Find a value in a list when there are no other values.
      test('simple list->map search', () {
        expect(TreeHelper([simpleMap]).deepSearch('marco'), ['polo']);
      });
      // Find a value with a non-string key.
      test('non string key search', () {
        expect(TreeHelper(complexMap).deepSearch(123), [456]);
      });

      // Search for value in an empty list.
      test('empty list search', () {
        final list = <void>[];
        expect(TreeHelper(list).deepSearch('marco'), null);
      });
      // Search for value in an empty map.
      test('empty map search', () {
        final map = <void, void>{};
        expect(TreeHelper(map).deepSearch('marco'), null);
      });
      // Search for value in an empty set.
      test('empty set search', () {
        final set = <void>{};
        expect(TreeHelper(set).deepSearch('marco'), null);
      });

      // Search for a missing value in a tree.
      test('complex tree search with no match', () {
        expect(TreeHelper(complexMap).deepSearch('need'), null);
      });

      // Find a single matching value in a tree.
      test('complex tree search', () {
        expect(TreeHelper(complexMap).deepSearch('needle'), ['haystack1']);
      });
      // Find a multiple matching values in a tree.
      test('complex tree multi-match search', () {
        expect(
          TreeHelper(complexMap).deepSearch('needle', multipleMatch: true),
          [
            'haystack1',
            2,
            {'haystacks': 'haystack3'},
            {'haystack4'},
          ],
        );
      });
      // Find a parent of matching values in a tree.
      test('complex tree parent search', () {
        expect(TreeHelper(complexMap).deepSearch('this', returnParent: true), [
          ['this', 'is', 'a', 'haystack'],
        ]);
      });
      // Find a parent of matching values in a tree.
      test('complex tree parent map search', () {
        expect(TreeHelper(complexMap).deepSearch('horse', returnParent: true), [
          {
            'horse': 'stall',
            'needle': {'haystack4'},
            'dog': 'house',
          },
        ]);
      });
      // Find a matching value in a tree with partial search on keys.
      test('complex tree suffix search', () {
        expect(TreeHelper(complexMap).deepSearch('needle', suffixMatch: true), [
          ['thisisahaystack'],
        ]);
      });
      // Find a multiple matching values in a tree with partial search on keys.
      test('complex tree multi-match suffix search', () {
        expect(
          TreeHelper(
            complexMap,
          ).deepSearch('needle', multipleMatch: true, suffixMatch: true),
          [
            ['thisisahaystack'], // list result
            'haystack1', // string result
            2, // int result
            {'haystacks': 'haystack3'}, // Map result
            {'haystack4'}, // Set result
          ],
        );
      });
      // Find a multiple matching values in a tree with partial search on keys.
      test('complex tree multi-match numeric suffix search', () {
        expect(
          TreeHelper(
            complexMap,
          ).deepSearch(123, multipleMatch: true, suffixMatch: true),
          [456, 'haystack456'],
        );
      });
    });

    group('searchForString', () {
      // Find key 'text' can convert the value to a string.
      test('default key search', () {
        expect(
          TreeHelper(complexMap).searchForString(),
          '{exposition: blahblahblah, summary: concise}',
        );
      });
      // Find key 123 can convert the value to a string.
      test('default key search', () {
        expect(TreeHelper(complexMap).searchForString(key: 123), '456');
      });
    });

    group('getGrandChildren', () {
      // Test with a list of lists.
      test('list of lists', () {
        final tree = [
          [1, 2],
          [3, 4],
        ];
        expect(TreeHelper(tree).getGrandChildren(), [1, 2, 3, 4]);
      });

      // Test with a map of lists.
      test('map of lists', () {
        final tree = {
          'a': [1, 2],
          'b': [3, 4],
        };
        expect(tree.getGrandChildren(), [1, 2, 3, 4]);
      });
    });

    group('TreeHelper extensions', () {
      // Test map, list and set extension helper classes.
      test('searchForString map extension', () {
        expect(simpleMap.searchForString(key: 'marco'), 'polo');
      });
      test('searchForString list extension', () {
        expect([simpleMap].searchForString(key: 'marco'), 'polo');
      });
      test('searchForString set extension', () {
        expect({simpleMap}.searchForString(key: 'marco'), 'polo');
      });
      test('deepSearch map extension', () {
        expect(simpleMap.deepSearch('marco'), ['polo']);
      });
      test('deepSearch list extension', () {
        expect([simpleMap].deepSearch('marco'), ['polo']);
      });
      test('deepSearch set extension', () {
        expect({simpleMap}.deepSearch('marco'), ['polo']);
      });
    });
  });
}
