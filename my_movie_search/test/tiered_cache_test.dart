import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_linux/path_provider_linux.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'test_helper.dart';

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
      test(
        'inseert and fetch dto',
        () async {
          final cache = TieredCache<MovieResultDTO>();
          final dto = MovieResultDTO().init(
            uniqueId: 'test123',
            title: 'myDto',
          );
          cache.add(dto.uniqueId, dto);
          final isCached = await cache.isCached(dto.uniqueId);
          expect(isCached, true);

          expect(cache.get(dto.uniqueId), MovieResultDTOMatcher(dto));
        },
      );
      test(
        'encode and decode dto',
        () async {
          final cache = TieredCache<MovieResultDTO>();
          final dto = MovieResultDTO().init(
            uniqueId: 'test123',
            title: 'myDto decoded',
          );
          cache
            ..add(dto.uniqueId, dto)
            ..clearMemoryOnly();
          // Fetch from disk and decode.
          final isCached = await cache.isCached(dto.uniqueId);
          expect(isCached, true);

          expect(cache.get(dto.uniqueId), MovieResultDTOMatcher(dto));
        },
      );
    },
  );
}
