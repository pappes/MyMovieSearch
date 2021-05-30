extension DoubleHelper on double {
  /// Convert an object to decimal representation ignoring thousand seperators
  ///
  /// Allows substitution of null values and zero values
  static double? fromText(
    Object? formattedText, {
    double? nullValueSubstitute,
    double? zeroValueSubstitute: 0,
  }) {
    double? count;
    if (formattedText != null) {
      var text = formattedText.toString().replaceAll(',', '');
      try {
        count = double.parse(text);
      } on FormatException catch (e) {
        // Process as null if no valid number parsed.
      }
    }
    if (count == null) return nullValueSubstitute;
    if (count == 0 || zeroValueSubstitute == null) return zeroValueSubstitute;
    return count;
  }
}

extension IntHelper on int {
  /// Convert an object to int representation ignoring thousand seperators
  ///
  /// Allows substitution of null values and zero values
  static int? fromText(
    Object? formattedText, {
    int? nullValueSubstitute,
    int? zeroValueSubstitute: 0,
  }) {
    var number = DoubleHelper.fromText(
      formattedText,
      zeroValueSubstitute: zeroValueSubstitute?.toDouble(),
      nullValueSubstitute: nullValueSubstitute?.toDouble(),
    );
    if (number == null) return null;
    return number.round();
  }
}
