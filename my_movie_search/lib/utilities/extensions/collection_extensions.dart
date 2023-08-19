import 'dart:convert';

import 'package:flutter/material.dart';

/// Extend [List]<[String]> or [Set]<[String]> to provide convenience functions.
///
extension StringIterableHelper on Iterable<String> {
  /// Pull a list out of a json value - even if it is not represented as a list
  ///
  /// Convert scalar value to a List with a single value
  /// Convert map to a List (return values, discard keys)
  ///
  /// '''dart
  /// StringIterableHelper.fromJson('[1,2,3]'); // returns  ['1', '2', '3']
  /// StringIterableHelper.fromJson('[[1,2,3],[4,5,6]]'); // returns  ['[1, 2, 3]', '[4, 5, 6]']
  /// StringIterableHelper.fromJson('{"first":1, "second":2 }'); // returns  ['1', '2']
  /// '''
  static Set<String> fromJson(String? jsonText) {
    final unique = <String>{};
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
    Set<String> itemSet = toSet();
    if (additions is Iterable<String>) {
      itemSet.addAll(additions);
    } else if (additions is Iterable) {
      for (final addition in additions) {
        itemSet.add(addition.toString());
      }
    } else if (additions is Map) {
      itemSet.combineUnique(additions.values);
    } else {
      itemSet = {additions.toString()};
    }

    if (this is List) {
      final list = this as List;

      final unique = toSet();
      unique.addAll(itemSet);
      list.clear();
      list.addAll(unique);
    }

    if (this is Set) {
      final set = this as Set;
      set.addAll(itemSet);
    }
  }
}

/// Extend [List]<dynamic> to provide convenience functions.
///
extension ListHelper<T> on List<T> {
  /// Ensure value is a list.  Make it a list if it is not.
  List<T> valueAsList(dynamic value) {
    if (value is T) {
      clear();
      add(value);
    }
    if (value is List) {
      clear();
      for (final element in value) {
        add(element as T);
      }
    }
    return this;
  }

  /// Extend [List]<dynamic> to concatenate strings with a seperator
  /// and remove nominated whitespace from the start and end.
  ///
  String trimJoin([String separator = '', String whitespace = ' ']) {
    final joined = join(separator);
    int start = 0;
    int end = 0;
    int current = 0;
    final trimable = whitespace.characters;
    if (joined.isEmpty) return joined;
    for (final char in joined.characters) {
      if (current == start && trimable.contains(char)) start++;
      if (!trimable.contains(char)) end = current + 1;
      current++;
    }
    if (start == joined.length) return '';

    return joined.substring(start, end);
  }
}
