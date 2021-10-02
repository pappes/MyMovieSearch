import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////
Future<dynamic> nullCallback() async {
  return null;
}

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() async {
  group('Store In Memory', () {
    test('String', () {
      /// Run a series of values through the cache and compare to expected output
      testCache(List<Map> input, Map expectedOutput) {
        var cache = TieredCache();

        input.forEach((listitem) {
          listitem.forEach((key, value) {
            cache.add(key, value);
          });
        });
        expectedOutput.forEach((key, value) {
          expect(cache.isCached(key), true);
          var actualOutput = cache.get(key, callback: nullCallback);
          actualOutput.then((value) {
            expect(value, expectedOutput[key]);
          });

          expect(actualOutput, completes);
        });
      }

      /// Test one key:value pair in and the same key:value pair out
      testCache([
        {'a': 'b'}
      ], {
        'a': 'b'
      });

      /// Test two distinct key:value pairs in and the same key:value pairs out
      testCache([
        {'a': 'b', 'c': 'd'}
      ], {
        'a': 'b',
        'c': 'd'
      });

      /// Test duplicate keys in and single key:value pair out
      testCache([
        {'a': 'b'},
        {'a': 'c'},
        {'a': 'd'}
      ], {
        'a': 'b'
      });
    });
  });
}
