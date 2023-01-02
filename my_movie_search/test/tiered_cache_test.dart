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
    test('String', () async {
      /// Run a series of values through the cache and compare to expected output
      void testCache(List<Map> input, Map expectedOutput) {
        final cache = TieredCache();

        void addMapContentsToCache(Map listItem) {
          listItem.forEach((key, value) {
            cache.add(key, value);
          });
        }

        input.forEach(addMapContentsToCache);
        for (final keyValuePair in expectedOutput.entries) {
          final keyIsCached = cache.isCached(keyValuePair.key);
          expect(keyIsCached, completion(true));
          final actualOutput = cache.get(
            keyValuePair.key,
            callback: nullCallback,
          );
          expect(actualOutput, completion(expectedOutput[keyValuePair.key]));
        }
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
