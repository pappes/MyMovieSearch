import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_linux/path_provider_linux.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() {
  group(
    'Store In Memory',
    () {
      setUp(() async {
        PathProviderPlatform.instance = PathProviderLinux();
      });
      test(
        'String',
        () async {
          /// Run a series of values through the cache
          /// and compare to expected output.
          Future<void> testCache(
            List<Map<String, String>> input,
            Map<String, String> expectedOutput,
          ) async {
            final cache = TieredCache<String>();

            void addMapContentsToCache(Map<String, String> listItem) =>
                listItem.forEach(cache.add);

            input.forEach(addMapContentsToCache);
            for (final keyValuePair in expectedOutput.entries) {
              final keyIsCached = await cache.isCached(keyValuePair.key);
              expect(keyIsCached, true);
              final actualOutput = cache.get(keyValuePair.key);
              expect(actualOutput, expectedOutput[keyValuePair.key]);
            }
          }

          /// Test one key:value pair in and the same key:value pair out.
          await testCache(
            [
              {'a': 'b'},
            ],
            {'a': 'b'},
          );

          /// Test two distinct key:value pairs in
          ///  and the same key:value pairs out.
          await testCache(
            [
              {'a': 'b', 'c': 'd'},
            ],
            {'a': 'b', 'c': 'd'},
          );

          /// Test duplicate keys in and single key:value pair out
          await testCache(
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
