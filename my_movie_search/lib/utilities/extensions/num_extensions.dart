/// Extend [double] to provide convenience functions.
///
extension DoubleHelper on double {
  /// Convert an [formattedText] to decimal representation ignoring thousand seperators
  ///
  /// Allows substitution of null values and zero values
  static double? fromText(
    dynamic formattedText, {
    double? nullValueSubstitute,
    double? zeroValueSubstitute: 0,
  }) {
    double? count;
    if (formattedText != null) {
      var text = formattedText.toString().replaceAll(',', '');
      count = double.tryParse(text);
    }
    if (count == 0) return zeroValueSubstitute;
    return count ?? nullValueSubstitute;
  }
}

/// Extend [int] to provide convenience functions.
///
extension IntHelper on int {
  /// Convert an [formattedText] to int representation ignoring thousand seperators
  ///
  /// Allows substitution of null values and zero values
  static int? fromText(
    dynamic formattedText, {
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

/// Extract last numeric year value from a text date representation.
///
/// Supports [yeartext] values in the format 'YYYY', 'yyyy-YYYY' and 'YYYY-'
/// e.g. '2005-2009' will return 2009
int? getYear(String? yeartext) {
  if (null != yeartext) {
    if (4 == yeartext.length) {
      // 1995
      return DateTime.tryParse('${yeartext}-01-01')?.year;
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
