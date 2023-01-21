/// Store items for faster access.
///
/// Combines in memory cache with on device and web stored cache
/// to balance access speed with memory usage.
///
class TieredCache<T> {
  Map memoryCache = {};

  /// Put a data item into the cache if it is not already there.
  /// If it is a list and already present, merge the lists.
  ///
  void add(dynamic key, dynamic item) {
    if (null != item && item is T) {
      final existing = memoryCache[key];
      if (null != existing && existing is List && item is List) {
        existing.addAll(item);
      } else {
        memoryCache[key] = item;
      }
    }
  }

  /// Remove an item from the cache.
  ///
  void remove(dynamic key) {
    memoryCache.remove(key);
  }

  /// Remove all items from the cache.
  ///
  void clear() {
    memoryCache.clear();
  }

  /// Check the cache to see if the item is present.
  ///
  bool isCached(dynamic key) {
    if (memoryCache.containsKey(key)) return true;
    return false;
  }

  /// Check the cache to see how many items are present.
  ///
  int cachedSize() {
    return memoryCache.length;
  }

  /// Get data from the cache.
  ///
  /// If data is not in any cache, executes [callback] to construct the value.
  T get(dynamic key) {
    final val = memoryCache[key];
    if (val is T) {
      return val;
    }
    throw 'key not found';
  }

  /// Put a data item as a list into into the cache.
  ///
  void addToCacheList(dynamic key, dynamic item) {
    if (null == item || [item] is! T) return;

    if (memoryCache.containsKey(key)) {
      // Get existing search result from cache.
      final newList = get(key) as List;
      newList.add(item);
      memoryCache[key] = newList as T;
    } else {
      memoryCache[key] = [item] as T;
    }
    return;
  }
}
