import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';

/// Extend datatype "dynamic" to provide convenience functions.
///
extension DynamicHelper on dynamic {
  /// Convert datatype of a value to a non nullablle String
  ///
  /// Sets the value to empty string if it is not currently a string
  ///
  /// Static verison of the function supplied
  /// for calling from other static functions e.g.
  /// x = DynamicHelper.dynamicToString_(y);
  ///
  /// Non-static verison of the function supplied
  /// for simpler call syntax e.g.
  /// x = dynamicToString(y);
  ///
  String dynamicToString(dynamic val) => DynamicHelper.dynamicToString_(val);
  static String dynamicToString_(dynamic val) {
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
  /// Static verison of the function supplied
  /// for calling from other static functions e.g.
  /// x = DynamicHelper.dynamicToStringList_(y);
  ///
  /// Non-static verison of the function supplied
  /// for simpler call syntax e.g.
  /// x = dynamicToStringList(y);
  ///
  List<String> dynamicToStringList(dynamic val) => dynamicToStringList_(val);
  static List<String> dynamicToStringList_(dynamic val) {
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
  /// Static verison of the function supplied
  /// for calling from other static functions e.g.
  /// x = DynamicHelper.dynamicToInt_(y);
  ///
  /// Non-static verison of the function supplied
  /// for simpler call syntax e.g.
  /// x = dynamicToInt(y);
  ///
  int dynamicToInt(dynamic val) => dynamicToInt_(val);
  static int dynamicToInt_(dynamic val) {
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
  /// Static verison of the function supplied
  /// for calling from other static functions e.g.
  /// x = DynamicHelper.dynamicToDouble_(y);
  ///
  /// Non-static verison of the function supplied
  /// for simpler call syntax e.g.
  /// x = dynamicToDouble(y);
  ///
  double dynamicToDouble(dynamic val) => dynamicToDouble_(val);
  static double dynamicToDouble_(dynamic val) {
    if (val is double) return val;
    if (val is String) return double.tryParse(val) ?? 0;
    if (val == null) return 0;
    return double.tryParse(val.toString()) ?? 0;
  }
}
