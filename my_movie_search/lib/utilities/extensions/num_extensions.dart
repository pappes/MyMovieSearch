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
      count = double.tryParse(text);
    }
    if (count == 0 && zeroValueSubstitute != null) return zeroValueSubstitute;
    return count ?? nullValueSubstitute;
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

int? getYear(String? yeartext) {
  if (null != yeartext) {
    if (4 == yeartext.length) {
      return DateTime.tryParse('${yeartext}-01-01')?.year;
    }
    if (4 < yeartext.length) {
      return DateTime.tryParse(yeartext)?.year;
    }
  }
  return null;
}
