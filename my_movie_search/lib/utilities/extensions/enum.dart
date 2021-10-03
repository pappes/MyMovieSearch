/// String representation of an Enum to Enum representation.
///
T? getEnumValue<T>(dynamic stringValue, List enumClass) {
  if (stringValue != null) {
    final String str = stringValue.toString();
    for (final element in enumClass) {
      if (element.toString() == str) {
        return element as T;
      }
    }
  }
}
