/// Extend [String] to provide convenience functions.
///
extension StringHelper on String {
  /// Remove any 4 digit years from the string
  ///
  /// Substitutes a blank space by default
  ///
  /// ```dart
  /// final cleanText = '2001 a space odyssey'.removeYear();
  /// ```
  String removeYear([String substitution = ' ']) {
    const fourNumbers = r'\b\d\d\d\d\b'; // \d is a digit \b is a word boundary

    return replaceAll(RegExp(fourNumbers), substitution);
  }

  /// Remove any 4 digit years from the string
  ///
  /// Substitutes a blank space by default
  ///
  /// ```dart
  /// final cleanText = '2001: a space odyssey'.removePunctuation();
  /// ```
  String removePunctuation([String substitution = ' ']) {
    const punctuation = r'[\W]'; // \W is not a letter, a number or _

    final temp = replaceAll(RegExp(punctuation), substitution);
    return temp.replaceAll('_', substitution);
  }

  /// Remove any duplicate whitespace from inside the string and remove leading/trairling whitespace
  ///
  /// Substitutes a blank space by default
  ///
  /// ```dart
  /// final cleanText = ' 2001    a space odyssey '.reduceWhitespace();
  /// ```
  String reduceWhitespace([String substitution = ' ']) {
    const whitespace = r'\s\t\v';
    const nonBreakingSpace = '\u{00a0}';
    const lineBreak = r'\r\n';
    const twoBlanks = '[$whitespace$lineBreak$nonBreakingSpace]'
        '[$whitespace$lineBreak$nonBreakingSpace]+';

    final temp = replaceAll(RegExp(twoBlanks), substitution);
    return temp.trim();
  }
}
