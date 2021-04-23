import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/data_model/movie_result_dto.dart';

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
/*
class MovieResultDTOMatcher extends Matcher {
  MovieResultDTO expected;
  MovieResultDTO _actual;

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
        .add("has actual emitted MovieResultDTO = ${_actual.toMap()}");
  }

  @override
  bool matches(actual, Map matchState) {
    _actual = actual;
    matchState['actual'] =
        _actual is MovieResultDTO ? _actual : MovieResultDTO().toUnknown();
    return _actual.matches(expected);
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
}*/

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('DTOCompare', () {
    test('userRatingCategory', () {
      testUserRatingCategory(input, expectedOutput) {
        var testInput = MovieResultDTO();
        testInput.userRatingCount = input;
        expect(testInput.userRatingCategory(), expectedOutput);
      }

      testUserRatingCategory(0, 0);
      testUserRatingCategory(1, 1);
      testUserRatingCategory(99, 1);
      testUserRatingCategory(100, 2);
      testUserRatingCategory(9999, 2);
      testUserRatingCategory(10000, 3);
    });
    test('userContentCategory', () {
      testUserContentCategory(input, expectedOutput) {
        var testInput = MovieResultDTO();
        testInput.type = input;
        expect(testInput.userContentCategory(), expectedOutput);
      }

      testUserContentCategory(MovieContentType.custom, 0);
      testUserContentCategory(MovieContentType.episode, 1);
      testUserContentCategory(MovieContentType.short, 2);
      testUserContentCategory(MovieContentType.series, 3);
      testUserContentCategory(MovieContentType.miniseries, 4);
      testUserContentCategory(MovieContentType.movie, 5);
    });
    test('popularityCategory', () {
      testPopularityCategory(MovieResultDTO input, expectedOutput) {
        expect(input.popularityCategory(), expectedOutput);
      }

      var testInput = MovieResultDTO();
      testInput = MovieResultDTO();
      // Any movie with a super low rating is probably bad.
      testInput.userRating = 1.99;
      testPopularityCategory(testInput, 0);
      // A rating of 2 out of 5 is not great but better than nothing.
      testInput.userRating = 2;
      testPopularityCategory(testInput, 1);
      testInput.year = 1999;
      testPopularityCategory(testInput, 1);
      // Movies made before 2000 have a lower relevancy to today.
      testInput.year = 2000;
      testPopularityCategory(testInput, 2);
      testInput.year = 1999;
      testInput.yearRange = '1999';
      testPopularityCategory(testInput, 1);
      // TVSeries started before 2000 have a lower relevancy to today.
      testInput.yearRange = '2000';
      testPopularityCategory(testInput, 2);
    });
    test('yearCompare', () {
      testYearCompare(
        int inputYear,
        String inputYR,
        int otherYear,
        String otherYR,
        int expectedOutput,
      ) {
        var testInput = MovieResultDTO();
        testInput.year = inputYear;
        testInput.yearRange = inputYR;
        var testOther = MovieResultDTO();
        testOther.year = otherYear;
        testOther.yearRange = otherYR;
        expect(testInput.yearCompare(testOther), expectedOutput);
      }

      // Years that should be considered the same.
      testYearCompare(0, "", 0, "", 0);
      testYearCompare(2000, "", 2000, "", 0);
      testYearCompare(0, "1980-2000", 0, "1999-2000", 0);
      testYearCompare(2000, "2000", 2000, "2000", 0);

      // Year on left should be considered higher than year on right.
      testYearCompare(2000, "", 1999, "", 1);
      testYearCompare(0, "1980-2000", 0, "1998-1999", 1);
      testYearCompare(2000, "1990-1995", 1997, "1998-1999", 1);
      testYearCompare(1990, "1980-2000", 1997, "1998-1999", 1);

      // Year on left should be considered lower than year on right.
      testYearCompare(1999, "", 2000, "", -1);
      testYearCompare(0, "1998-1999", 0, "1980-2000", -1);
      testYearCompare(1997, "1998-1999", 2000, "1990-1995", -1);
      testYearCompare(1997, "1998-1999", 1990, "1980-2000", -1);

      MovieResultDTO tmpYear = MovieResultDTO();
      expect(tmpYear.yearCompare(null), 0);
      tmpYear.year = 2000;
      expect(tmpYear.yearCompare(null), 1);
    });
    test('yearRangeAsNumber', () {
      testYearCompare(inputYR, expectedOutput) {
        var testInput = MovieResultDTO();
        testInput.yearRange = inputYR;
        expect(testInput.yearRangeAsNumber(), expectedOutput);
      }

      testYearCompare("0", 0);
      testYearCompare("1999", 1999);
      testYearCompare("2000", 2000);
      testYearCompare("1999-2000", 2000);
    });
  });
}
