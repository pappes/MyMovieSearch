/// Store items for faster access.
///
/// Combines in memeory caache with on device and web stored cache
/// to balance access speed with memeory usage.
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
  Future<void> clear() async {
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

  /// Check the cache to see if the item is present.
  ///
  int cachedSize() {
    return memoryCache.length;
  }

  /// Get data from the cache.
  ///
  /// If data is not in any cache, executes [callback] to construct the value.
  Future<T> get(dynamic key, {Future<T> Function()? callback}) async {
    final val = memoryCache[key];
    if (val is T) {
      return val;
    }
    assert(null != callback);
    return callback!();
  }
}
