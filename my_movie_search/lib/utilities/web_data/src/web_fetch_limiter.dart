/// This library provides a framework for fetching different types of web data
/// in a concsistent manner.
library web_fetch;

import 'package:flutter/material.dart';

const _defaultSearchResultsLimit = 100;

/// Constrain the number of records that can be fetched from the web.
class WebFetchLimiter {
  WebFetchLimiter([this._classLimit = _defaultSearchResultsLimit]);

  final int? _classLimit;
  int? _instanceLimit;
  int currentUsage = 0;

  bool get limitExceeded => false;

  int get limit => _instanceLimit ?? _classLimit ?? double.maxFinite.toInt();
  set limit(int? newLimit) => _instanceLimit = newLimit;

  @mustCallSuper
  int consume([int quantity = 1]) {
    currentUsage += quantity;
    if (limit >= currentUsage) return quantity;
    final excess = currentUsage - limit;
    currentUsage = limit;
    return quantity - excess;
  }

  @mustCallSuper
  void reset() => currentUsage = 0;
}
