/// Store items for faster access.
///
/// Combines in memory cache with on device and web stored cache
/// to balance access speed with memory usage.
///
class TieredCache<T> {
  Map memoryCache = {};

  /// Put a data item into the cache if it is not already there.
  ///
  Future<void> add(dynamic key, dynamic item) async {
    if (null == item || item is! T || memoryCache.containsKey(key)) return;
    memoryCache[key] = item;
    //TODO: queue for adding to disk and cloud caches
  }

  /// Remove all items from the cache.
  ///
  void clear() {
    memoryCache.clear();
    //TODO: flush disk and cloud caches
  }

  /// Check the cache to see if the item is present.
  ///
  Future<bool> isCached(dynamic key) async {
    if (memoryCache.containsKey(key)) return true;
    //TODO: check disk and cloud caches
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
  Future<T> get(dynamic key, {Future<T> Function()? callback}) async {
    try {
      return _getSynchronously(key);
    } catch (_) {
      assert(null != callback);
      return callback!();
    }
  }

  T _getSynchronously(dynamic key) {
    final val = memoryCache[key];
    if (val is T) {
      return val;
    }
    throw 'key not found';
  }

  /// Put a data item as a list into into the cache.
  ///
  Future<void> addToCacheList(dynamic key, dynamic item) async {
    if (null == item || [item] is! T) return;

    if (memoryCache.containsKey(key)) {
      // Get existing search result from cache.
      final newList = _getSynchronously(key) as List;
      newList.add(item);
      memoryCache[key] = newList as T;
    } else {
      memoryCache[key] = [item] as T;
    }
    return;
    //TODO: queue for adding to disk and cloud caches
  }
}
