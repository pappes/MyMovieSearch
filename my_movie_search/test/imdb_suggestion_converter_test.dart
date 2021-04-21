import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'transformer_test_data.dart';
import 'package:my_movie_search/search_providers/jsonp_transformer.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/converters/search_imdb_suggestion_converter.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////

/*Stream<String> emitString(String str) async* {
  yield str;
}*/

/* TODO: test executeQuery()
class QueryIMDBSuggestions_temp {
  static executeQuery(
    StreamController<MovieResultDTO> sc,
    SearchCriteriaDTO criteria,
  ) async {
    emitImdbJsonSample()
        .transform(json.decoder)
        .transform(json.decoder)
        .expand((element) =>
            element) // expand the JSON collection and emit the single results record into a new stream
        .pipe(sc);
  }
}
*/

class MovieResultDTOMatcher extends Matcher {
  MovieResultDTO expected;
  MovieResultDTO? _actual;

  MovieResultDTOMatcher(this.expected);

  @override
  Description describe(Description description) {
    return description
        .add("has expected MovieResultDTO content = ${expected.toMap()}");
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map<dynamic, dynamic> matchState, bool verbose) {
    return mismatchDescription
        .add("has actual emitted MovieResultDTO = ${_actual!.toMap()}");
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

Stream<List<int>> emitConsolidatedByteStream(String str) async* {
  List<int> lst = [];

  for (var rune in str.runes.toList()) {
    lst.add(rune);
  }
  yield lst;
}

////////////////////////////////////////////////////////////////////////////////
/// Conceptual testing
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('stream basics', () {
    test('simple Bytesteam test', () {
      String testInput = 'B(a)';
      List<List<int>> expectedOutput = [
        [66],
        [40],
        [97],
        [41]
      ];
      var stream = emitByteStream(testInput);

      int runeCount = 0;
      var expectFn = expectAsync1<void, List<int>>((output) {
        expect(output, expectedOutput[runeCount]);
        runeCount++;
      }, count: testInput.length);
      stream.listen(expectFn, onDone: () {
        expect(runeCount, testInput.length);
        print('stream done, all $runeCount elements consumed');
      });
    });

    test('UTF8 test', () {
      String testInput = '$imdbJsonPFunction(a)';
      var stream = emitByteStream(testInput).transform(utf8.decoder);

      int runeCount = 0;
      var expectFn = expectAsync1<void, String>((output) {
        expect(output, testInput.substring(runeCount++, runeCount));
      }, count: testInput.length);
      stream.listen(expectFn);
    });

    test('json test', () {
      String testInput = imdbJsonSampleOuter;
      var stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(json.decoder);

      var expectFn = expectAsync1<void, Object?>((output) {
        Map decodedOutput = output as Map<dynamic, dynamic>;
        expect(decodedOutput[imdbCustomKeyName], imdbCustomKeyVal);
      }, count: 1);
      stream.listen(expectFn);
    });

    test('outer map test', () {
      String testInput = imdbJsonSampleOuter;
      var stream = emitConsolidatedByteStream(testInput)
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((outerMap) => (outerMap as Map)[imdbCustomKeyName]);

      var expectFn = expectAsync1<void, Object?>((output) {
        expect(output, imdbCustomKeyVal);
      }, count: 1);
      stream.listen(expectFn);
    });

    test('jsonp transformer test', () {
      String testInput = imdbJsonPSampleFull;
      var stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder())
          .transform(json.decoder);

      var expectFn = expectAsync1<void, Object?>((output) {
        Map decodedOutput = output as Map<dynamic, dynamic>;
        expect(decodedOutput[imdbCustomKeyName], imdbCustomKeyVal);
      }, count: 1);
      stream.listen(expectFn);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestion', () {
    test('extractor', () async {
      String testInput = imdbJsonPSampleFull;
      Stream<MovieResultDTO> stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder())
          .transform(json.decoder)
          .map(
              (outerMap) => (outerMap as Map)[outer_element_results_collection])
          .expand((element) =>
              element) // Emit each element from the list as a seperate stream event
          .map((event) => ImdbSuggestionConverter.dtoFromMap(event));

      var expectedDTO = await expectedDTOList;
      int dtoCount = 0;
      var expectFn = expectAsync1<void, MovieResultDTO>((output) {
        var expectedValue = expectedDTO[dtoCount++];
        var isExpectedValue = MovieResultDTOMatcher(expectedValue);
        expect(output, isExpectedValue);
      }, count: expectedDTO.length, max: expectedDTO.length);
      stream.listen(expectFn);
    });
    test('transformer', () async {
      String testInput = imdbJsonPSampleFull;
      Stream<MovieResultDTO> stream = emitByteStream(testInput)
          .transform(utf8.decoder)
          .transform(JsonPDecoder())
          .transform(json.decoder)
          .map(
              (outerMap) => (outerMap as Map)[outer_element_results_collection])
          .expand((element) =>
              element) // Emit each element from the list as a seperate stream event
          .map((event) => ImdbSuggestionConverter.dtoFromMap(event));

      var expectedDTO = await expectedDTOList;
      int dtoCount = 0;
      var expectFn = expectAsync1<void, MovieResultDTO>((output) {
        var expectedValue = expectedDTO[dtoCount++];
        var isExpectedValue = MovieResultDTOMatcher(expectedValue);
        expect(output, isExpectedValue);
      }, count: expectedDTO.length, max: expectedDTO.length);
      stream.listen(expectFn);
    });
  });
}
