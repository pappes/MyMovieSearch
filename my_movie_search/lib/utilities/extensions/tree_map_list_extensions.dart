/// Extend [Iterable] and [Map] to provide tree convenience functions.
///
extension TreeListHelper on Iterable<dynamic> {
  List<dynamic>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) =>
      TreeHelper(this).deepSearch(
        tag,
        suffixMatch: suffixMatch,
        multipleMatch: multipleMatch,
      );

  String? searchForString({Object key = 'text'}) =>
      TreeHelper(this).searchForString(key: key);
}

extension TreeMapHelper on Map<dynamic, dynamic> {
  List<dynamic>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) =>
      TreeHelper(this).deepSearch(
        tag,
        suffixMatch: suffixMatch,
        multipleMatch: multipleMatch,
      );

  String? searchForString({Object key = 'text'}) =>
      TreeHelper(this).searchForString(key: key);
}

extension TreeSetHelper on Set<dynamic> {
  List<dynamic>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) =>
      TreeHelper(this).deepSearch(
        tag,
        suffixMatch: suffixMatch,
        multipleMatch: multipleMatch,
      );

  String? searchForString({Object key = 'text'}) =>
      TreeHelper(this).searchForString(key: key);
}

class TreeHelper {
  final dynamic tree;
  late bool _isMap;
  late bool _isIterable;
  Iterable<dynamic>? asIterable;
  Map<dynamic, dynamic>? asMap;
  // Constructor to save tree for later use.
  TreeHelper(this.tree) {
    _isMap = tree is Map;
    _isIterable = tree is Iterable;
    if (_isIterable) {
      asIterable = tree as Iterable;
    } else if (_isMap) {
      asMap = tree as Map;
      asIterable = asMap!.entries;
    }
  }

  /// Recursively traverse a tree to pull a specific value out.
  List<dynamic>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) {
    if (null == tree) return null;
    final matches = <dynamic>[]; // Allow mutiple results on suffix search.
    for (final entry in asIterable ?? []) {
      final key = entry is MapEntry ? entry.key : '';
      final value = entry is MapEntry ? entry.value : entry;

      if (key == tag) {
        // Simple match.
        matches.add(value);
        if (!multipleMatch) return matches;
      } else if (suffixMatch && key.toString().endsWith(tag.toString())) {
        // Suffix match.
        matches.add(value);
        if (!multipleMatch) return matches;
      } else if (value is Map || value is Iterable) {
        // Recursively search children.
        final result = TreeHelper(value).deepSearch(
          tag,
          suffixMatch: suffixMatch,
          multipleMatch: multipleMatch,
        );
        if (result is List) {
          matches.addAll(result);
          if (!multipleMatch) return matches;
        }
      }
    }

    if (matches.isNotEmpty) {
      // Return mutiple results for suffix search.
      return matches;
    }
    return null;
  }

  /// Validate a [Map] or [List] tree contains a String value identided by [key].
  String? searchForString({Object key = 'text'}) {
    final results = deepSearch(key);
    if (null != results && results.isNotEmpty && null != results.first) {
      return results.first!.toString();
    }
    return null;
  }
}
