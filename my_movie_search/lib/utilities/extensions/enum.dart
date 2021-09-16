dynamic getEnumValue(dynamic val, List values) {
  if (val != null) {
    String str = val.toString();
    for (var element in values) {
      if (element.toString() == str) {
        return element;
      }
    }
  }
}
