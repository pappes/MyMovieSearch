import 'dart:convert';

/// Extend [List]<[String]> to provide convenience functions.
///
extension ListHelper on List<String> {
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
