import 'dart:convert';

/// Extend [Iterable] and [Map] to provide tree convenience functions.
///
extension TreeListHelper on Iterable {
  List? deepSearch(
    String tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) {
    return TreeHelper(this).deepSearch(
      tag,
      suffixMatch: suffixMatch,
      multipleMatch: multipleMatch,
    );
  }

  String? searchForString({String key = 'text'}) {
    return TreeHelper(this).searchForString(key: key);
  }
}

extension TreeMapHelper on Map {
  List? deepSearch(
    String tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) {
    return TreeHelper(this).deepSearch(
      tag,
      suffixMatch: suffixMatch,
      multipleMatch: multipleMatch,
    );
  }

  String? searchForString({String key = 'text'}) {
    return TreeHelper(this).searchForString(key: key);
  }
}

class TreeHelper {
  final dynamic tree;
  late bool isMap;
  late bool isIterable;
  Iterable? asIterable;
  Map? asMap;
  // Constructor to save tree for later use.
  TreeHelper(this.tree) {
    isMap = tree is Map;
    isIterable = tree is Iterable;
    if (isIterable) {
      asIterable = tree as Iterable;
    } else if (isMap) {
      asMap = tree as Map;
      asIterable = asMap!.entries;
    }
  }

  /// Recursively traverse a tree to pull a specific value out.
  List? deepSearch(
    String tag, {
    bool suffixMatch = false,
    bool multipleMatch = false,
  }) {
    if (null == tree) return null;
    final matches = []; // Allow mutiple results on suffix search.
    for (final entry in asIterable ?? []) {
      final key = entry is MapEntry ? entry.key : '';
      final value = entry is MapEntry ? entry.value : entry;

      if (key == tag) {
        // Simple match.
        matches.add(value);
        if (!multipleMatch) return matches;
      } else if (suffixMatch && key.toString().endsWith(tag)) {
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
  String? searchForString({String key = 'text'}) {
    final results = deepSearch(key);
    if (null != results && results.isNotEmpty && null != results.first) {
      return results.first!.toString();
    }
    return null;
  }
}
/*
  /// Pull a list out of a json value - even if it is not represented as a list
  ///
  /// Convert scalar value to a List with a single value
  /// Convert map to a List (return values, discard keys)
  ///
  /// '''dart
  /// ListHelper.fromJson('[1,2,3]'); // returns  ['1', '2', '3']
  /// ListHelper.fromJson('[[1,2,3],[4,5,6]]'); // returns  ['[1, 2, 3]', '[4, 5, 6]']
  /// ListHelper.fromJson('{"first":1, "second":2 }'); // returns  ['1', '2']
  /// '''
  static List<String> fromJson(String? jsonText) {
    final unique = <String>[];
    if (null == jsonText || jsonText.isEmpty) return unique;
    final contents = json.decode(jsonText);
    unique.combineUnique(contents);
    return unique;
  }

  /// Add values to the current list.
  /// [additions] can be null, scalar, a dynamic list or a map.
  ///
  /// Removes any duplicate values.
  /// Converts map to a List (adds values, discard keys)
  ///
  /// ```dart
  /// ['a', 'b', 'b'].combineUnique(['b', 'b', 'c']); // returns ['a', 'b', 'c']
  /// ['a', 'b', 'c'].combineUnique({'A': '1', 'B': '2'}); // returns ['a', 'b', 'c', '1', '2']
  /// ```
  void combineUnique(dynamic additions) {
    if (null == additions) return;
    List<String> itemList = [];
    if (additions is List<String>) {
      itemList = additions;
    } else if (additions is Iterable) {
      for (final addition in additions) {
        itemList.add(addition.toString());
      }
    } else if (additions is Map) {
      itemList.combineUnique(additions.values);
    } else {
      itemList = [additions.toString()];
    }

    final Set<String> unique = {};
    unique.addAll(this);
    unique.addAll(itemList);
    clear();
    addAll(unique);
  }
}
*/