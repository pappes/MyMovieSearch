import 'dart:convert';

/// Extend [List]<[String]> to provide convenience functions.
///
extension ListHelper on List<String> {
  /// Pull a list out of a json value - even if it is not represented as a list
  ///
  /// Convert scalar value to a List with a single value
  /// Convert map to a List (return values, discard keys)
  static List<String> fromJson(String? jsonText) {
    List<String> unique = [];
    if (null == jsonText || jsonText.isEmpty) return unique;
    var contents = json.decode(jsonText);
    unique.combineUnique(contents);
    return unique;
  }

  /// Add values to the current list.
  /// [additions] can be null, scalar, a dynamic list or a map.
  ///
  /// Removes any duplicate values.
  /// Converts map to a List (adds values, discard keys)
  combineUnique(dynamic additions) {
    if (null == additions) return [];
    List<String> itemList = [];
    if (additions is List<String>)
      itemList = additions;
    else if (additions is Iterable)
      for (var addition in additions) itemList.add(addition.toString());
    else if (additions is Map)
      itemList.combineUnique(additions.values);
    else
      itemList = [additions.toString()];

    Set<String> unique = {};
    unique.addAll(this);
    unique.addAll(itemList);
    this.clear();
    this.addAll(unique);
  }
}
