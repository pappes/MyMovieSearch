/// Extend [Duration] to provide convenience functions.
///
extension DurationHelper on Duration {
  /// Format [Duration] as H:MM:SS
  String toFormattedTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(this.inSeconds.remainder(60));
    return '${twoDigits(this.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  /// Convert ISO 8601 [String] e.g. PT1H46M to Dart [Duration]
  Duration fromIso8601(String isoString) {
    //logic adapted from https://dev.to/ashishrawat2911/parse-iso8601-duration-string-to-duration-object-in-dart-flutter-1gc1
    if (!RegExp(r'^(-|\+)?P'
            '(?:([-+]?[0-9,.]*)Y)?'
            '(?:([-+]?[0-9,.]*)M)?'
            '(?:([-+]?[0-9,.]*)W)?'
            '(?:([-+]?[0-9,.]*)D)?'
            '(?:T'
            '(?:([-+]?[0-9,.]*)H)?'
            '(?:([-+]?[0-9,.]*)M)?'
            '(?:([-+]?[0-9,.]*)S)?'
            r')?$')
        .hasMatch(isoString)) {
      throw ArgumentError('String does not follow correct format');
    }

    const daysPerWeek = 7;
    final weeks = _parseTime(isoString, 'W');
    final days = _parseTime(isoString, 'D');
    final hours = _parseTime(isoString, 'H');
    final minutes = _parseTime(isoString, 'M');
    final seconds = _parseTime(isoString, 'S');

    return Duration(
      days: days + (weeks * daysPerWeek),
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  /// Private helper method for extracting a time value from the ISO8601 string.
  int _parseTime(String duration, String timeUnit) {
    final timeMatch = RegExp(r'\d+' + timeUnit).firstMatch(duration);

    if (timeMatch == null) {
      return 0;
    }
    final timeString = timeMatch.group(0)!;
    var numbers = timeString.substring(0, timeString.length - 1);
    return int.tryParse(numbers) ?? 0;
  }
}
