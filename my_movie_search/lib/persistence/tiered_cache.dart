/// Store items for faster access.
///
/// Combines in memeory caache with on device and web stored cache
/// to balance access speed with memeory usage.
///
class TieredCache<T> {
  Map memoryCache = {};

  /// Put a data item into the cache it it is not already there.
  ///
  add(dynamic key, dynamic item) async {
    if (null == item || item is! T || memoryCache.containsKey(key)) return;
    memoryCache[key] = item;
    //TODO: queue for adding to disk and cloud caches
  }

  /// Get data from the cache.
  ///
  /// If data is not in any cache executes [callback] to construct the value.
  Future<T> get(dynamic key, Future<T> Function() callback) async {
    if (memoryCache.containsKey(key) && memoryCache[key] is T) {
      return memoryCache[key];
    }
    return callback();
  }
}
