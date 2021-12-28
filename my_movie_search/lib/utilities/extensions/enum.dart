/// String representation of an Enum to Enum representation.
///
T? getEnumValue<T extends Enum>(dynamic stringValue, List<T> enumClass) {
  if (stringValue != null) {
    return enumClass.byName(stringValue.toString());
  }
}
