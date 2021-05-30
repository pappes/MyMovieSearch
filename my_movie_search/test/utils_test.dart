import 'package:flutter_test/flutter_test.dart';

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
}
