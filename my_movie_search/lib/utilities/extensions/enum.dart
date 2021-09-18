/// String representation of an Enum to Enum representation.
///
dynamic getEnumValue(dynamic stringValue, List enumClass) {
  if (stringValue != null) {
    String str = stringValue.toString();
    for (var element in enumClass) {
      if (element.toString() == str) {
        return element;
      }
    }
  }
}
