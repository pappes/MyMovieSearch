import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////

/// Expectation matcher for test framework to compare DTOs
class MovieResultDTOMatcher extends Matcher {
  MovieResultDTO expected;
  late MovieResultDTO _actual;

  MovieResultDTOMatcher(this.expected);

  @override
  // Tell test framework what content was expected.
  Description describe(Description description) {
    return description.add(
      'has expected MovieResultDTO content = \n${expected.toPrintableString()}',
    );
  }

  @override
  // Tell test framework what difference was found.
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    return mismatchDescription.add(
      'has actual emitted MovieResultDTO = \n${_actual.toPrintableString()}',
    );
  }

  @override
  // Compare expected with actual.
  bool matches(dynamic actual, Map matchState) {
    if (actual is MovieResultDTO) {
      _actual = actual;
    } else {
      _actual = MovieResultDTO().toUnknown();
    }
    matchState['actual'] = _actual;
    return _actual.matches(expected);
  }
}

/// Expectation matcher for test framework to compare DTO lists
class MovieResultDTOListMatcher extends Matcher {
  List<MovieResultDTO> expected;
  late List<MovieResultDTO> _actual;

  MovieResultDTOListMatcher(this.expected);

  @override
  // Tell test framework what content was expected.
  Description describe(Description description) {
    return description.add('has expected ${expected.toPrintableString()}');
  }

  @override
  // Tell test framework what difference was found.
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    return mismatchDescription.add('has actual ${_actual.toPrintableString()}');
  }

  @override
  // Compare expected with actual.
  bool matches(dynamic actual, Map matchState) {
    if (actual is List<MovieResultDTO>) {
      _actual = actual;
    } else {
      _actual = [MovieResultDTO().toUnknown()];
    }
    matchState['actual'] = _actual;
    if (_actual.length != expected.length) return false;
    for (var i = 0; i < _actual.length - 1; i++) {
      if (!_actual[i].matches(expected[i])) {
        return false;
      }
    }
    return true;
  }
}

/// Converts a [str] to a stream.
Stream<String> emitString(String str) async* {
  yield str;
}

/// Converts a [str] to a stream of bytes.
///
/// Emits one byte at a time.
Stream<List<int>> emitByteStream(String str) async* {
  for (final rune in str.runes.toList()) {
    yield [rune];
  }
}

/// Converts [str] to a stream containing a list of bytes.
///
/// Emits all bytes at the same time.
Stream<List<int>> emitConsolidatedByteStream(String str) async* {
  final List<int> lst = [];

  for (final rune in str.runes.toList()) {
    lst.add(rune);
  }
  yield lst;
}

/// Converts [records] to a stream of DTOs.
Stream<MovieResultDTO> streamMovieResultDTOFromJsonMap(
  Iterable<Map<String, String>> records,
) async* {
  for (final Map<String, String> record in records) {
    yield record.toMovieResultDTO();
  }
}

/// Helper function to make a unique dto containing unique values.
MovieResultDTO makeDTO(String sample) {
  final dto = MovieResultDTO();

  dto.source = DataSourceType.wiki;
  dto.uniqueId = '${sample}_uniqueId';
  dto.alternateId = '${sample}_alternateId';
  dto.title = '${sample}_title';
  dto.alternateTitle = '${sample}_alternateTitle';
  dto.description = '${sample}_description';
  dto.type = MovieContentType.custom;
  dto.year = 123;
  dto.yearRange = '${sample}_yearRange';
  dto.userRating = 456;
  dto.userRatingCount = 789;
  dto.censorRating = CensorRatingType.family;
  dto.runTime = const Duration(hours: 1, minutes: 2, seconds: 3);
  dto.imageUrl = '${sample}_imageUrl';
  dto.language = LanguageType.mostlyEnglish;
  dto.languages = ['${sample}_language1', '${sample}_language2'];
  dto.genres = ['${sample}_genre1', '${sample}_genre2'];
  return dto;
}
