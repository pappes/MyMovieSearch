import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/database_helpers.dart';

/// Store items for faster access.
///
/// Combines in memory cache with on device and web stored cache
/// to balance access speed with memory usage.
///
class TieredCache<T> {
  Map<dynamic, T> memoryCache = {};

  /// Put a data item into the cache if it is not already there.
  /// If it is a list and already present, merge the lists.
  ///
  void add(dynamic key, T? item) {
    if (null != item) {
      final existing = memoryCache[key];
      if (null != existing && existing is List && item is List) {
        existing.addAll(item);
      } else {
        memoryCache[key] = item;
      }
      final json = jsonEncode(item);
      unawaited(
        DatabaseHelper.instance.insert(
          MovieModel(uniqueId: key.toString(), dtoJson: json),
        ),
      );
    }
  }

  /// Remove an item from the cache.
  ///
  void remove(dynamic key) {
    memoryCache.remove(key);
    unawaited(
      DatabaseHelper.instance.delete(
        MovieModel(uniqueId: key.toString(), dtoJson: ''),
      ),
    );
  }

  /// Remove all items from the cache.
  ///
  @visibleForTesting
  void clearMemoryOnly() {
    memoryCache.clear();
  }

  /// Remove all items from the cache.
  ///
  Future<void> clear() async {
    memoryCache.clear();

    // Delete all records from the database.
    final records = await DatabaseHelper.instance.queryAllMovies();
    for (final record in records) {
      if (record.containsKey('uniqueId')) {
        final key = record['uniqueId'].toString();
        await DatabaseHelper.instance.delete(
          MovieModel(uniqueId: key, dtoJson: ''),
        );
      }
    }
  }

  /// Check the cache to see if the item is present.
  ///
  Future<bool> isCached(dynamic key) async {
    if (memoryCache.containsKey(key)) return true;
    // Attempt to fetch from db cache.
    final record = await DatabaseHelper.instance.queryMovieUniqueId(
      key.toString(),
    );
    if (record != null) {
      T? result = _decodeDto(record.dtoJson);
      if (result == null) {
        final decoded = jsonDecode(record.dtoJson);
        if (decoded is T) result = decoded;
      }
      if (result != null) {
        add(key, result);
        return true;
      }
    }

    return false;
  }

  T? _decodeDto(String jsonText) {
    if (<T>[] is List<MovieResultDTO>) {
      final result = MovieResultDTO().fromJson(jsonText);
      if (result != MovieResultDTO()) {
        return result as T;
      }
    } else if (<T>[] is List<List>) {
      final decoded = jsonDecode(jsonText);
      if (decoded is Iterable) {
        final dtos = ListDTOConversion.decodeList(decoded);
        if (dtos.isNotEmpty && dtos.first != MovieResultDTO()) {
          return dtos as T;
        }
      }
    }
    return null;
  }

  /// Check the cache to see how many items are present.
  ///
  int cachedSize() => memoryCache.length;

  /// Get data from the cache.
  ///
  /// The caller must validate the data in is the cache before calling get.
  ///
  /// Throws an error if there is no match in the cache.
  T get(dynamic key) {
    if (memoryCache.containsKey(key)) return memoryCache[key]!;
    throw CacheMissError('Requested key $key not found in the cache');
  }

  /// Put a data item as a list into into the cache.
  ///
  void addToCacheList(dynamic key, dynamic item) {
    if (null == item || [item] is! T) return;

    if (memoryCache.containsKey(key)) {
      // Get existing search result from cache.
      final newList = get(key) as List..add(item);
      memoryCache[key] = newList as T;
    } else {
      memoryCache[key] = [item] as T;
    }
    unawaited(
      DatabaseHelper.instance.insert(
        MovieModel(uniqueId: key.toString(), dtoJson: jsonEncode(item)),
      ),
    );
  }
}

/// Exception used in myConvertTreeToOutputType.
class CacheMissError implements Error {
  CacheMissError(this._cause);

  String _cause;
  StackTrace stack = StackTrace.current;
  @override
  StackTrace? get stackTrace => stack;

  @override
  String toString() => _cause;
}
