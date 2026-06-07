/// Extend [Iterable] and [Map] to provide tree convenience functions.
///
extension TreeListHelper on Iterable<Object?> {
  /// Recursively traverse a tree to pull a specific value out.
  /// {@macro deepSearch}
  List<Object?>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
    bool stopAtTopLevel = true,
    bool returnParent = false,
  }) => TreeHelper(this).deepSearch(
    tag,
    suffixMatch: suffixMatch,
    multipleMatch: multipleMatch,
    stopAtTopLevel: stopAtTopLevel,
    returnParent: returnParent,
  );

  /// {@macro getGrandChildren}
  List<Object?> getGrandChildren() => TreeHelper(this).getGrandChildren();

  /// {@macro searchForString}
  String? searchForString({Object key = 'text'}) =>
      TreeHelper(this).searchForString(key: key);
}

extension TreeMapHelper on Map<Object?, Object?> {
  List<Object?>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
    bool returnParent = false,
  }) => TreeHelper(this).deepSearch(
    tag,
    suffixMatch: suffixMatch,
    multipleMatch: multipleMatch,
    returnParent: returnParent,
  );

  /// {@macro getGrandChildren}
  List<Object?> getGrandChildren() => values.getGrandChildren();

  /// {@macro searchForString}
  String? searchForString({Object key = 'text'}) =>
      TreeHelper(this).searchForString(key: key);
}

extension TreeSetHelper on Set<Object?> {
  /// {@macro deepSearch}
  List<Object?>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
    bool returnParent = false,
  }) => TreeHelper(this).deepSearch(
    tag,
    suffixMatch: suffixMatch,
    multipleMatch: multipleMatch,
    returnParent: returnParent,
  );

  /// {@macro getGrandChildren}
  List<Object?> getGrandChildren() => toList().getGrandChildren();

  /// {@macro searchForString}
  String? searchForString({Object key = 'text'}) =>
      TreeHelper(this).searchForString(key: key);
}

class TreeHelper {
  // Constructor to save tree for later use.
  TreeHelper(this.tree) {
    if (tree is Iterable) {
      asIterable = tree! as Iterable;
    } else if (tree is Map) {
      asMap = tree! as Map;
      asIterable = asMap!.entries;
    }
  }

  final Object? tree;
  Iterable<Object?>? asIterable;
  Map<Object?, Object?>? asMap;

  /// Recursively traverse a tree to pull a specific value out.
  ///
  /// {@template deepSearch}
  /// Parameters:
  /// * [tag] the key to search for.
  /// * [suffixMatch] match on the end of the key.
  /// * [multipleMatch] return all matches.
  /// * [stopAtTopLevel] do not search inside result for more matches.
  /// * [returnParent] identify the tree level above the matched node.
  /// {@endtemplate}
  List<Object?>? deepSearch(
    Object tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
    bool stopAtTopLevel = true,
    bool returnParent = false,
    Object? parent,
    Object? grandparent,
  }) {
    if (null == tree) return null;
    final matches = <Object?>[]; // Allow mutiple results on suffix search.
    for (final entry in asIterable ?? []) {
      final key = entry is MapEntry ? entry.key : entry;
      final value = entry is MapEntry ? entry.value : entry;

      if (key == tag) {
        // Simple match.
        matches.add(_valueToReturn(value, parent, grandparent, returnParent));
        if (!multipleMatch) return matches;
        if (stopAtTopLevel) continue;
      } else if (suffixMatch && key.toString().endsWith(tag.toString())) {
        // Suffix match.
        matches.add(_valueToReturn(value, parent, grandparent, returnParent));
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
          returnParent: returnParent,
          parent: value,
          grandparent: parent,
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

  /// determine which value to return
  /// * child if returnParent is false
  /// * grandparent if parent is part of a Map
  /// * parent if not part of a Map
  /// fall back to child if parent is null
  Object? _valueToReturn(
    Object? child,
    Object? parent,
    Object? grandparent,
    bool returnParent,
  ) {
    if (!returnParent) {
      return child;
    } else if (parent is MapEntry) {
      // need to return the full map, not just the current entry of the map
      return grandparent ?? parent;
    } else {
      return parent ?? child;
    }
  }

  /// {@template getGrandChildren}
  /// Collapse one level of the tree.
  /// {@endtemplate}
  List<Object?> getGrandChildren() {
    final List<Object?> grandChildren = [];
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
  /// It finds the first occurrence of the [key]
  /// and returns the associated value.
  /// {@endtemplate}
  String? searchForString({Object key = 'text'}) {
    final results = deepSearch(key);
    if (null != results && results.isNotEmpty && null != results.first) {
      return results.first!.toString();
    }
    return null;
  }
}
