import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////

class MovieResultDTOMatcher extends Matcher {
  MovieResultDTO expected;
  MovieResultDTO? _actual;

  MovieResultDTOMatcher(this.expected);

  @override
  Description describe(Description description) {
    return description.add('has expected MovieResultDTO content = \n'
        '${expected.toPrintableString()}');
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map<dynamic, dynamic> matchState, bool verbose) {
    return mismatchDescription.add('has actual emitted MovieResultDTO = \n'
        '${_actual!.toPrintableString()}');
  }

  @override
  bool matches(actual, Map matchState) {
    _actual = actual;
    matchState['actual'] =
        _actual is MovieResultDTO ? _actual : MovieResultDTO().toUnknown();
    return _actual!.matches(expected);
  }
}

class MovieResultDTOListMatcher extends Matcher {
  List<MovieResultDTO> expected;
  List<MovieResultDTO>? _actual;

  MovieResultDTOListMatcher(this.expected);

  @override
  Description describe(Description description) {
    return description.add('has expected ${expected.toPrintableString()}');
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map<dynamic, dynamic> matchState, bool verbose) {
    return mismatchDescription
        .add('has actual ${_actual!.toPrintableString()}');
  }

  @override
  bool matches(actual, Map matchState) {
    _actual = actual;
    matchState['actual'] = _actual is List<MovieResultDTO>
        ? _actual
        : [MovieResultDTO().toUnknown()];
    if (_actual!.length != expected.length) return false;
    for (var i = 0; i < _actual!.length - 1; i++) {
      if (!_actual![i].matches(expected[i])) {
        return false;
      }
    }
    return true;
  }
}

Stream<List<int>> emitByteStream(String str) async* {
  for (var rune in str.runes.toList()) {
    yield [rune];
  }
}

Stream<String> emitString(String str) async* {
  yield str;
}

Stream<List<int>> emitConsolidatedByteStream(String str) async* {
  List<int> lst = [];

  for (var rune in str.runes.toList()) {
    lst.add(rune);
  }
  yield lst;
}

Stream<MovieResultDTO> streamMovieResultDTOFromJsonMap(
    Iterable<Map<String, String>> records) async* {
  for (Map<String, String> record in records) {
    yield (record).toMovieResultDTO();
  }
}
