/// Extend [double] to provide convenience functions.
///
extension DoubleHelper on double {
  /// Convert an [formattedText] to decimal representation ignoring thousand seperators
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

  /// Convert an [formattedText] to decimal representation ignoring thousand seperators
  ///
  /// [tolerance] is the percentage varianace allowed
  ///
  /// ```dart
  ///if (DoubleHelper.fuzzyMatch(123.7, 124.2)) ...
  /// ```
  static bool fuzzyMatch<T>(T actual, T expected, {int tolerance = 80}) {
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
  /// Convert an [formattedText] to int representation ignoring thousand seperators
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

/// Extract last numeric year value from a text date representation.
///
/// Supports [yeartext] values in the format 'YYYY', 'yyyy-YYYY' and 'YYYY-'
///
/// ```dart
/// final number = IntHelper.getYear('2005-2009'); // returns 2009
/// ```
int? getYear(String? yeartext) {
  if (null != yeartext) {
    if (4 == yeartext.length) {
      // 1995
      return DateTime.tryParse('$yeartext-01-01')?.year;
    } else if (9 == yeartext.length) {
      // 1995-1999
      return DateTime.tryParse('${yeartext.substring(5)}-01-01')?.year;
    } else if (5 == yeartext.length) {
      // 1995-
      return DateTime.tryParse('${yeartext.substring(0, 4)}-01-01')?.year;
    } else if (4 < yeartext.length) {
      return DateTime.tryParse(yeartext)?.year;
    }
  }
  return null;
}
