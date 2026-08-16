import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_search/data/persistence/dto_cache.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_transformation.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';

import '../test_helper.dart';
@GenerateNiceMocks([MockSpec<TieredCache<MovieResultDTO>>()])
import 'dto_cache_test.mocks.dart';

void main() {
  late MockTieredCache mockCache;
  late DtoCache dtoCache;
  late MovieResultDTO dto1;
  late MovieResultDTO dto2;

  setUp(() {
    mockCache = MockTieredCache();
    dtoCache = DtoCache(cache: mockCache);

    dto1 = MovieResultDTO()..init(uniqueId: 'movie_1', title: 'Inception');
    dto2 = MovieResultDTO()..init(uniqueId: 'movie_2', title: 'Interstellar');
  });

  group('DtoCache Specification', () {
    group('dumpCache', () {
      test(
        'returns a map of all records currently stored in the memory cache',
        () {
          // Arrange & Act
          final result = dtoCache.dumpCache();

          // Assert
          expect(result, isA<Map<Object, MovieResultDTO>>());
        },
      );
      test(
        'returns all cached entries stored in the global memory cache',
        () async {
          // Arrange
          final cache = DtoCache();
          await cache.clear();
          await cache.merge(dto1);

          try {
            // Act
            final result = cache.dumpCache();

            // Assert
            expect(
              result.length,
              equals(1),
              reason: 'collection length does not match',
            );
            expect(result['movie_1'], MovieResultDTOMatcher(dto1));
          } finally {
            // Cleanup global singleton state for test isolation
            cache.remove(dto1);
          }
        },
      );
      test('returns all cached entries stored in the memory cache', () {
        // Arrange
        final expectedMap = <Object, MovieResultDTO>{'movie_1': dto1};
        when(mockCache.memoryCache).thenReturn(expectedMap);

        // Act
        final result = dtoCache.dumpCache();

        // Assert
        expect(
          result.length,
          equals(1),
          reason: 'collection length does not match',
        );
        expect(result['movie_1'], MovieResultDTOMatcher(dto1));
      });
    });
  });

  group('fetchSynchronously', () {
    test(
      'returns the cached movie DTO when the requested unique ID exists',
      () {
        // Arrange
        when(mockCache.get('movie_1')).thenReturn(dto1);

        // Act
        final result = dtoCache.fetchSynchronously('movie_1');

        // Assert
        expect(result, MovieResultDTOMatcher(dto1));
      },
    );

    test(
      'returns null gracefully when accessing the cache throws an error',
      () {
        // Arrange
        when(
          mockCache.get('movie_1'),
        ).thenThrow(StateError('Disk read failure'));

        // Act
        final result = dtoCache.fetchSynchronously('movie_1');

        // Assert
        expect(result, isNull);
      },
    );
  });

  group('remove', () {
    test('evicts the cached movie matching the provided DTO unique ID', () {
      // Arrange
      final targetDto = dto1;

      // Act
      dtoCache.remove(targetDto);

      // Assert
      verify(mockCache.remove('movie_1')).called(1);
    });
  });

  group('merge', () {
    test(
      'stores and returns the new movie DTO when no previous entry is cached',
      () async {
        // Arrange
        when(mockCache.isCached('movie_1')).thenAnswer((_) async => false);

        // Act
        final result = await dtoCache.merge(dto1);

        // Assert
        expect(result, MovieResultDTOMatcher(dto1));
      },
    );

    test(
      'merges incoming data with the cached record when key already exists',
      () async {
        // Arrange
        final existingCachedDto = MovieResultDTO()
          ..init(uniqueId: 'movie_1', title: 'Inception (Original)');
        when(mockCache.isCached('movie_1')).thenAnswer((_) async => true);
        when(mockCache.get('movie_1')).thenReturn(existingCachedDto);

        // Act
        final result = await dtoCache.merge(dto1);

        // Assert
        expect(result, MovieResultDTOMatcher(existingCachedDto));
      },
    );
  });

  group('fetch', () {
    test(
      'asynchronously retrieves and merges the requested movie record',
      () async {
        // Arrange
        when(mockCache.isCached('movie_1')).thenAnswer((_) async => false);

        // Act
        final result = await dtoCache.fetch(dto1);

        // Assert
        expect(result, MovieResultDTOMatcher(dto1));
      },
    );
  });

  group('mergeCollection', () {
    test(
      'returns an empty collection without processing if given an empty map',
      () async {
        // Arrange
        final MovieCollection emptyCollection = {};

        // Act
        final result = await dtoCache.mergeCollection(emptyCollection);

        // Assert
        expect(result, isEmpty);
      },
    );

    test(
      'merges a single-item collection and returns the updated map entry',
      () async {
        // Arrange
        final inputCollection = {'key1': dto1};
        when(mockCache.isCached('movie_1')).thenAnswer((_) async => false);

        // Act
        final result = await dtoCache.mergeCollection(inputCollection);

        // Assert
        expect(
          result.length,
          equals(1),
          reason: 'collection should have 1 entry',
        );
        expect(result['key1'], MovieResultDTOMatcher(dto1));
      },
    );

    test(
      'merges all movies in a collection and preserves key mappings',
      () async {
        // Arrange
        final inputCollection = {'key1': dto1, 'key2': dto2};
        when(mockCache.isCached('movie_1')).thenAnswer((_) async => false);
        when(mockCache.isCached('movie_2')).thenAnswer((_) async => false);

        // Act
        final result = await dtoCache.mergeCollection(inputCollection);

        // Assert
        expect(
          result.length,
          equals(2),
          reason: 'collection should have 2 entries',
        );
        expect(result['key1'], MovieResultDTOMatcher(dto1));
        expect(result['key2'], MovieResultDTOMatcher(dto2));
        expect(result.values.toList(), MovieResultDTOListMatcher([dto1, dto2]));
      },
    );
  });

  group('clear', () {
    test(
      'returns a map of all records currently stored in the memory cache',
      () async {
        // Arrange & Act
        await dtoCache.clear();

        // Assert
        verify(mockCache.clear()).called(1);
      },
    );
  });
}
