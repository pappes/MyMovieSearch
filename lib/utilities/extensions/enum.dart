/// Convert a String representation of an Enum to an Enum representation.
///
/// ```dart
/// getEnumValue<SpokenLanguage>('English',SpokenLanguage.values);
/// ```
/*T? getEnumValue<T extends Enum>(dynamic stringValue, List<T> enumClass) {
  if (stringValue != null && stringValue != '' && stringValue != 'null') {
    final fullString = stringValue.toString();
    // If passed in value is type.enum then discard the type.
    if (fullString.contains('$T.')) {
      return enumClass.byName(fullString.split('.').last);
    }
    return enumClass.byName(fullString);
  }
  return null;
}*/

extension DescribeEnum on Enum {
  String get excludeNone => ('none' == name) ? '' : name;
}

extension EnumListExtension<T extends Enum> on List<T> {
  /// Convert a String representation of an Enum to an Enum representation.
  ///
  /// Example:
  /// ```dart
  /// SpokenLanguage.values.byFullName('English');
  /// ```
  T? byFullName(dynamic stringValue) {
    if (stringValue != null && stringValue != '' && stringValue != 'null') {
      final fullString = stringValue.toString();
      // If passed in value is type.enum then discard the type.
      if (fullString.contains('$T.')) {
        return byName(fullString.split('.').last);
      }
      return byName(fullString);
    }
    return null;
  }
}
