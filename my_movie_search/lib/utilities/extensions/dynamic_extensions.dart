import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';

/// Extend datatype "dynamic" to provide convenience functions.
///
extension DynamicHelper on dynamic {
  /// Filter out non string values
  ///
  /// Sets the value to empty string if it is not currently a string
  ///
  /// Static version of the function supplied for calling from other static functions
  /// ```dart
  /// x = DynamicHelper.dynamicToString(y);
  /// ```
  ///
  /// Non-static version of the function supplied
  /// for simpler call syntax
  /// ```dart
  /// x = dynamicToString(y);
  /// ```
  ///
  String dynamicToString(dynamic val) => DynamicHelper.toString_(val);
  static String toString_(dynamic val) {
    if (val is String) {
      return val;
    }
    return '';
  }

  /// Filter out values that are not lists of strings
  ///
  /// Sets the value to empty list if it is not currently
  /// *   a [List]<[String]>
  /// *   a json encoded [List]<[String]>
  ///
  /// Static version of the function supplied for calling from other static functions
  /// ```dart
  /// x = DynamicHelper.dynamicToStringList_(y);
  /// ```
  ///
  /// Non-static version of the function supplied for simpler call syntax
  /// ```dart
  /// x = dynamicToStringList(y);
  /// ```
  ///
  List<String> dynamicToStringList(dynamic val) => toStringList_(val);
  static List<String> toStringList_(dynamic val) {
    if (val is String) return StringIterableHelper.fromJson(val).toList();
    if (val is List<String>) return val;
    final result = <String>[];
    if (val is List) {
      for (final item in val) {
        result.add(item.toString());
      }
    }
    return result;
  }

  /// Filter out values that are not Iterable strings
  ///
  /// Sets the value to empty set if it is not currently
  /// *   a [Iterable]<[String]>
  /// *   a json encoded [Iterable]<[String]>
  ///
  /// Static version of the function supplied for calling from other static functions
  /// ```dart
  /// x = DynamicHelper.dynamicToStringSet_(y);
  /// ```
  ///
  /// Non-static version of the function supplied for simpler call syntax
  /// ```dart
  /// x = dynamicToStringSet(y);
  /// ```
  ///
  Set<String> dynamicToStringSet(dynamic val) => toStringSet_(val);
  static Set<String> toStringSet_(dynamic val) {
    if (val is String) return StringIterableHelper.fromJson(val);
    if (val is Set<String>) return val;
    if (val is List<String>) return val.toSet();
    final result = <String>{};
    if (val is Iterable) {
      for (final item in val) {
        result.add(item.toString());
      }
    }
    return result;
  }

  /// filter out values that are not [int]
  ///
  /// Sets the value to 0 if it is not currently
  /// *   a number
  /// *   a string representation of a number
  ///
  /// Static version of the function supplied for calling from other static functions
  /// ```dart
  /// x = DynamicHelper.dynamicToInt_(y);
  /// ```
  ///
  /// Non-static version of the function supplied for simpler call syntax
  /// ```dart
  /// x = dynamicToInt(y);
  /// ```
  ///
  int dynamicToInt(dynamic val) => toInt_(val);
  static int toInt_(dynamic val) {
    if (val is int) return val;
    if (val is String) return int.tryParse(val) ?? 0;
    if (val == null) return 0;
    return int.tryParse(val.toString()) ?? 0;
  }

  /// Filter out values that are not [double]
  ///
  /// Sets the value to 0 if it is not currently
  /// *   a number
  /// *   a string representation of a number
  ///
  /// Static version of the function supplied for calling from other static functions
  /// ```dart
  /// x = DynamicHelper.dynamicToDouble_(y);
  /// ```
  ///
  /// Non-static version of the function supplied for simpler call syntax
  /// ```dart
  /// x = dynamicToDouble(y);
  /// ```
  ///
  double dynamicToDouble(dynamic val) => toDouble_(val);
  static double toDouble_(dynamic val) {
    if (val is double) return val;
    if (val is String) return double.tryParse(val) ?? 0;
    if (val == null) return 0;
    return double.tryParse(val.toString()) ?? 0;
  }
}
