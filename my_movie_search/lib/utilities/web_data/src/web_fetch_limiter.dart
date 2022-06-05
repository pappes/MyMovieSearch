library web_fetch;

const _defaultSearchResultsLimit = 100;

/// Constrain the number of records that can be fetched from the web.
class WebFetchLimiter {
  final int? _classLimit;
  int? _instanceLimit;
  int currentUsage = 0;

  bool get limitExceeded => false;

  int get limit => _instanceLimit ?? _classLimit ?? double.maxFinite.toInt();
  set limit(int? newLimit) => _instanceLimit = newLimit;

  WebFetchLimiter([this._classLimit = _defaultSearchResultsLimit]);

  int consume([int quantity = 1]) {
    currentUsage += quantity;
    if (limit >= currentUsage) return quantity;
    final excess = currentUsage - limit;
    return quantity - excess;
  }

  void reset() {
    currentUsage = 0;
  }
}
