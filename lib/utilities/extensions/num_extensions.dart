/// Extend [double] to provide convenience functions.
///
extension DoubleHelper on double {
  /// Convert a [formattedText] to decimal representation
  /// ignoring thousand seperators
  ///
  /// Allows substitution of null values and zero values
  ///
  /// ```dart
  /// final number = DoubleHelper.fromText('9,999.99');
  /// ```
  static double? fromText(
    dynamic formattedText, {
    double? nullValueSubstitute,
    double? zeroValueSubstitute = 0,
  }) {
    double? count;
    if (formattedText != null) {
      final text = formattedText.toString().replaceAll(',', '');
      count = double.tryParse(text);
    }
    if (count == 0) return zeroValueSubstitute;
    return count ?? nullValueSubstitute;
  }

  /// Compare [actual] and [expected] to see if they are close enough.
  ///
  /// [tolerance] is the percentage varianace allowed
  ///
  /// ```dart
  ///if (DoubleHelper.fuzzyMatch(123.7, 124.2)) ...
  /// ```
  static bool fuzzyMatch<T extends num>(
    T actual,
    T expected, {
    int tolerance = 80,
  }) {
    if (actual != expected) {
      final expectedDouble = fromText(expected.toString()) ?? 0.0;
      final actualDouble = fromText(actual.toString()) ?? 0.0;
      final percent = tolerance / 100;
      // Avoid divide by zero! Zero is never in percentage range!
      if (0.0 == expectedDouble) return false;
      if (actualDouble / expectedDouble < percent) return false;
      if (expectedDouble / actualDouble < percent) return false;
    }
    return true;
  }
}

/// Extend [int] to provide convenience functions.
///
extension IntHelper on int {
  /// Convert a [formattedText] to int representation
  /// ignoring thousand seperators
  ///
  /// Allows substitution of null values and zero values
  ///
  /// ```dart
  /// final number = IntHelper.fromText('9,999');
  /// ```
  static int? fromText(
    dynamic formattedText, {
    int? nullValueSubstitute,
    int? zeroValueSubstitute = 0,
  }) {
    final number = DoubleHelper.fromText(
      formattedText,
      zeroValueSubstitute: zeroValueSubstitute?.toDouble(),
      nullValueSubstitute: nullValueSubstitute?.toDouble(),
    );
    if (number == null) return null;
    return number.round();
  }
}
