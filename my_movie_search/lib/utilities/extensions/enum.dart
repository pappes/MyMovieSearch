/// Convert a String representation of an Enum to an Enum representation.
///
/// ```dart
/// getEnumValue<SpokenLanguage>('English',SpokenLanguage.values);
/// ```
T? getEnumValue<T extends Enum>(dynamic stringValue, List<T> enumClass) {
  if (stringValue != null && stringValue != '' && stringValue != 'null') {
    final fullString = stringValue.toString();
    // If passed in value is type.enum then discard the type.
    if (fullString.contains('${T.toString()}.')) {
      return enumClass.byName(fullString.split('.').last);
    }
    return enumClass.byName(fullString);
  }
  return null;
}
