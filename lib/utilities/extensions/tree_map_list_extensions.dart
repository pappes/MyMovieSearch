/// Extend [Iterable] and [Map] to provide tree convenience functions.
///
extension TreeListHelper on Iterable<dynamic> {
  /// Recursively traverse a tree to pull a specific value out.
  /// {@macro deepSearch}
  List<dynamic>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
    bool stopAtTopLevel = true,
  }) => TreeHelper(this).deepSearch(
    tag,
    suffixMatch: suffixMatch,
    multipleMatch: multipleMatch,
    stopAtTopLevel: stopAtTopLevel,
  );

  /// {@macro getGrandChildren}
  List<dynamic> getGrandChildren() => TreeHelper(this).getGrandChildren();

  /// {@macro searchForString}
  String? searchForString({Object key = 'text'}) =>
      TreeHelper(this).searchForString(key: key);
}

extension TreeMapHelper on Map<dynamic, dynamic> {
  List<dynamic>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) => TreeHelper(
    this,
  ).deepSearch(tag, suffixMatch: suffixMatch, multipleMatch: multipleMatch);

  /// {@macro getGrandChildren}
  List<dynamic> getGrandChildren() => values.getGrandChildren();

  /// {@macro searchForString}
  String? searchForString({Object key = 'text'}) =>
      TreeHelper(this).searchForString(key: key);
}

extension TreeSetHelper on Set<dynamic> {
  /// {@macro deepSearch}
  List<dynamic>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) => TreeHelper(
    this,
  ).deepSearch(tag, suffixMatch: suffixMatch, multipleMatch: multipleMatch);

  /// {@macro getGrandChildren}
  List<dynamic> getGrandChildren() => toList().getGrandChildren();

  /// {@macro searchForString}
  String? searchForString({Object key = 'text'}) =>
      TreeHelper(this).searchForString(key: key);
}

class TreeHelper {
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

  final dynamic tree;
  late bool _isMap;
  late bool _isIterable;
  Iterable<dynamic>? asIterable;
  Map<dynamic, dynamic>? asMap;

  /// Recursively traverse a tree to pull a specific value out.
  ///
  /// {@template deepSearch}
  /// Parameters:
  /// * [tag] the key to search for.
  /// * [suffixMatch] match on the end of the key.
  /// * [multipleMatch] return all matches.
  /// * [stopAtTopLevel] do not search inside result for more matches.
  /// {@endtemplate}
  List<dynamic>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
    bool stopAtTopLevel = true,
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
        if (stopAtTopLevel) continue;
      } else if (suffixMatch && key.toString().endsWith(tag.toString())) {
        // Suffix match.
        matches.add(value);
        if (!multipleMatch) return matches;
        if (stopAtTopLevel) continue;
      }
      if (value is Map || value is Iterable) {
        // Recursively search children.
        final result = TreeHelper(value).deepSearch(
          tag,
          suffixMatch: suffixMatch,
          multipleMatch: multipleMatch,
          stopAtTopLevel: stopAtTopLevel,
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

  /// {@template getGrandChildren}
  /// Collapse one level of the tree.
  /// {@endtemplate}
  List<dynamic> getGrandChildren() {
    final List<dynamic> grandChildren = [];
    for (final child in asIterable ?? []) {
      if (child is Iterable) {
        grandChildren.addAll(child);
      } else if (child is Map) {
        grandChildren.addAll(child.values);
      }
    }
    return grandChildren;
  }

  /// Search tree for a map containing [key] and return its value as a String.
  ///
  /// {@template searchForString}
  /// It finds the first occurrence of the [key] and returns the associated value.
  /// {@endtemplate}
  String? searchForString({Object key = 'text'}) {
    final results = deepSearch(key);
    if (null != results && results.isNotEmpty && null != results.first) {
      return results.first!.toString();
    }
    return null;
  }
}
