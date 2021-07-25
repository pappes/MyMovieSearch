dynamic getEnumFromString(String? val, List values) {
  for (var element in values) {
    if (element.toString() == val) {
      return element;
    }
  }
}
