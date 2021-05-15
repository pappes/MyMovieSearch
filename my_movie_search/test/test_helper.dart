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
    return description
        .add('has expected MovieResultDTO content = ${expected.toMap()}');
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map<dynamic, dynamic> matchState, bool verbose) {
    return mismatchDescription
        .add('has actual emitted MovieResultDTO = ${_actual!.toMap()}');
  }

  @override
  bool matches(actual, Map matchState) {
    _actual = actual;
    matchState['actual'] =
        _actual is MovieResultDTO ? _actual : MovieResultDTO().toUnknown();
    return _actual!.matches(expected);
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
    Iterable<Map<dynamic, dynamic>> records) async* {
  for (Map record in records) {
    yield record.toMovieResultDTO();
  }
}
