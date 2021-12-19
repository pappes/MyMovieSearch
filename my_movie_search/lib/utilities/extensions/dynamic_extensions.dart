import 'dart:convert';

import 'collection_extensions.dart';

/// Extend datatype "dynamic" to provide convenience functions.
///
extension DynamicHelper on dynamic {
  /// Convert datatype of a value to a non nullablle String
  ///
  /// Sets the value to empty string if it is not currently a string
  ///
  String dynamicToString(dynamic val) {
    if (val is String) {
      return val;
    }
    return '';
  }

  /// Convert datatype of a value to a non nullablle List<String>
  ///
  /// Sets the value to empty list if it is not currently
  ///     a List<String>
  ///     a json encoded List<String>
  ///
  List<String> dynamicToStringList(dynamic val) {
    if (val is String) return ListHelper.fromJson(val);
    if (val is List<String>) return val;
    return [];
  }

  /// Convert datatype of a value to a non nullablle int
  ///
  /// Sets the value to 0 if it is not currently
  ///     a number
  ///     a a string representation of a number
  ///
  int dynamicToInt(dynamic val) {
    if (val is int) return val;
    if (val is String) return int.tryParse(val) ?? 0;
    if (val == null) return 0;
    return int.tryParse(val.toString()) ?? 0;
  }

  /// Convert datatype of a value to a non nullablle double
  ///
  /// Sets the value to 0 if it is not currently
  ///     a number
  ///     a a string representation of a number
  ///
  double dynamicToDouble(dynamic val) {
    if (val is double) return val;
    if (val is String) return double.tryParse(val) ?? 0;
    if (val == null) return 0;
    return double.tryParse(val.toString()) ?? 0;
  }
}
