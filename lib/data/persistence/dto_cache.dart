import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_transformation.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/app_logger.dart';

/// Stores MovieResultDTO objects in a tiered cache.
class DtoCache {
  /// Constructor allows injecting a custom or mock [TieredCache] for testing.
  DtoCache({TieredCache<MovieResultDTO>? cache})
    : _globalDtoCache = cache ?? TieredCache<MovieResultDTO>();

  factory DtoCache.singleton() => _singleton;

  static final DtoCache _singleton = DtoCache();

  final TieredCache<MovieResultDTO> _globalDtoCache;

  Map<Object, MovieResultDTO> dumpCache() {
    final cache = _globalDtoCache.memoryCache;
    for (final record in cache.entries) {
      AppLogger.instance.info('${record.key} - ${record.value.title}');
    }
    return cache;
  }

  /// Retrieve data from the memory cache synchronously if available.
  MovieResultDTO? fetchSynchronously(String uniqueId) {
    try {
      return _globalDtoCache.get(uniqueId);
    } catch (e) {
      return null;
    }
  }

  /// Retrieve data from the cache.
  ///
  Future<MovieResultDTO> fetch(MovieResultDTO newValue) =>
      // Use Future.sync to allow code to run synchronously and ensure
      // that exceptions are propagated as Future errors.
      Future.sync(() => merge(newValue));

  /// Remove [newValue] from the cache.
  void remove(MovieResultDTO newValue) =>
      _globalDtoCache.remove(_key(newValue));

  /// Store information from [newValue] into a cache and
  /// merge with any existing record.
  /// Returned value contains a a combination of existing data and new data.
  ///
  @awaitNotRequired
  Future<MovieResultDTO> merge(MovieResultDTO newValue) async {
    final key = _key(newValue);
    if (await _globalDtoCache.isCached(key)) {
      return _globalDtoCache.get(key)..merge(newValue);
    }
    _globalDtoCache.add(key, newValue);
    return newValue;
  }

  /// Update cache to merge in movies from [newDtos] and
  /// return the same records with updated values.
  Future<MovieCollection> mergeCollection(MovieCollection newDtos) async {
    Future<MovieCollection> mergeUnawaited(
      String key,
      MovieResultDTO newValue,
    ) async {
      await merge(newValue);
      return {key: newValue};
    }

    final MovieCollection merged = {};
    final futures = <Future<MovieCollection>>[];
    for (final dto in newDtos.entries) {
      futures.add(mergeUnawaited(dto.key, dto.value));
    }
    await Future.wait(futures).then((results) {
      results.forEach(merged.addAll);
    });
    return merged;
  }

  /// Remove all items from the cache.
  ///
  Future<void> clear() => _globalDtoCache.clear();

  static String _key(MovieResultDTO dto) => dto.uniqueId;
}
