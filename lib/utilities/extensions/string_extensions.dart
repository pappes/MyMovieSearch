import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

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

  /// Remove any duplicate whitespace from inside the string
  /// and remove leading/trailing whitespace
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
    const twoBlanks =
        '[$whitespace$lineBreak$nonBreakingSpace]'
        '[$whitespace$lineBreak$nonBreakingSpace]+';

    final temp = replaceAll(RegExp(twoBlanks), substitution);
    return temp.trim();
  }

  /// Extract numeric digits from end of string.
  ///
  /// String can optionally end with a dash
  /// 2020- returns 2020
  /// 2020-- returns 2020
  /// 2020 returns 2020
  /// 2020-2021 returns 2021
  int lastNumber() {
    // one or more numeric digits ([0-9]+)
    // followed by 0 or more dashes ([\-]*)
    final match = RegExp(r'([0-9]+)([\-]*)$').firstMatch(this);
    if (null != match) {
      if (null != match.group(1)) {
        return int.tryParse(match.group(1)!) ?? 0;
      }
    }
    return 0;
  }

  /// Add a colon to the end of the string if it does not already end with one.
  ///
  /// ```dart
  /// final textWithColon = 'Title'.addColonIfNeeded();
  /// ```
  String addColonIfNeeded() {
    // Check if the string is not empty and the last character is not a colon.
    if (!endsWith(':')) {
      return '$this:';
    }
    return this;
  }

  /// Replace the value in the string with a new value
  /// if the new value is not null
  ///
  /// ```dart
  /// final cleanText = '2001'.orBetterYet('2001: a space odyssey');
  String orBetterYet(String? replacement) =>
      (replacement != null) ? replacement : this;
}

/// Extend [String?] to provide convenience functions.
///
extension OptionalStringHelper on String? {
  /// Extract last numeric year value from a text date representation.
  ///
  /// Supports  values in the format 'YYYY', 'yyyy-YYYY' and 'YYYY-'
  ///
  /// ```dart
  /// final number = IntHelper.getYear('2005-2009'); // returns 2009
  /// ```
  int? getYear() {
    if (this != null) {
      const lineBreak = r'[\r\n\v]';
      const greedyAnything = '.*';
      const fourNumbers =
          r'\b\d\d\d\d\b'; // \d is a digit \b is a word boundary
      const lazyAnything = '.*?';

      final filter = RegExp('$greedyAnything($fourNumbers)$lazyAnything');
      final oneLine = this!.replaceAll(RegExp(lineBreak), ' ');
      final match = filter.firstMatch(oneLine);

      // group 0 is the whole string, group 1 is the first ()
      final fourDigits = match?.group(1);
      return IntHelper.fromText(fourDigits);
    }
    return null;
  }
}
