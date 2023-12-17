import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() {
  group(
    'Store In Memory',
    () {
      test(
        'String',
        () {
          /// Run a series of values through the cache
          /// and compare to expected output.
          void testCache(
            List<Map<String, String>> input,
            Map<String, String> expectedOutput,
          ) {
            final cache = TieredCache<String>();

            void addMapContentsToCache(Map<String, String> listItem) =>
                listItem.forEach(cache.add);

            input.forEach(addMapContentsToCache);
            for (final keyValuePair in expectedOutput.entries) {
              final keyIsCached = cache.isCached(keyValuePair.key);
              expect(keyIsCached, true);
              final actualOutput = cache.get(keyValuePair.key);
              expect(actualOutput, expectedOutput[keyValuePair.key]);
            }
          }

          /// Test one key:value pair in and the same key:value pair out.
          testCache(
            [
              {'a': 'b'},
            ],
            {'a': 'b'},
          );

          /// Test two distinct key:value pairs in
          ///  and the same key:value pairs out.
          testCache(
            [
              {'a': 'b', 'c': 'd'},
            ],
            {'a': 'b', 'c': 'd'},
          );

          /// Test duplicate keys in and single key:value pair out
          testCache(
            [
              {'a': 'b'},
              {'a': 'c'},
              {'a': 'd'},
            ],
            {'a': 'd'},
          );
        },
      );
    },
  );
}
