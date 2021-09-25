import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helper.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////
// Class to assist with Restorable tests
class RestorationTestParent extends State with RestorationMixin {
  RestorationTestParent(this.uniqueId) {}
  String uniqueId;
  var movie = RestorableMovie();
  var list = RestorableMovieList();

  @override
  // The restoration bucket id for this page.
  String get restorationId => 'abc';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(movie, uniqueId + 'movie');
    registerForRestoration(list, uniqueId + 'list');
  }

  Widget build(BuildContext context) {
    return Text('');
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('DTOCompare', () {
    // Categorise dto based on popularity from userRatingCount.
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
    // Categorise dto based on title type from MovieContentType.
    test('userContentCategory', () {
      testUserContentCategory(input, expectedOutput) {
        var testInput = MovieResultDTO();
        testInput.type = input;
        expect(testInput.titleContentCategory(), expectedOutput);
      }

      testUserContentCategory(MovieContentType.custom, 0);
      testUserContentCategory(MovieContentType.episode, 1);
      testUserContentCategory(MovieContentType.short, 2);
      testUserContentCategory(MovieContentType.series, 3);
      testUserContentCategory(MovieContentType.miniseries, 4);
      testUserContentCategory(MovieContentType.movie, 5);
    });
    // Categorise dto based on popularity from userRating and Year.
    // A rating of 2/5 is better than a rating of less than 2/5.
    // A movie after 2000 is better than a movie before 2000.
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
    // Categorise dto based on Year of release.
    // Where a definative year is not know use the last known year.
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
      testYearCompare(0, '', 0, '', 0);
      testYearCompare(2000, '', 2000, '', 0);
      testYearCompare(0, '1980-2000', 0, '1999-2000', 0);
      testYearCompare(2000, '2000', 2000, '2000', 0);
      testYearCompare(2011, '1980-2000', 0, '1999-2011', 0);
      testYearCompare(0, '1980-2011', 2011, '1999-2000', 0);

      // Year on left should be considered higher than year on right.
      testYearCompare(2000, '', 1999, '', 1);
      testYearCompare(0, '1980-2000', 0, '1998-1999', 1);
      testYearCompare(2000, '1990-1995', 1997, '1998-1999', 1);
      testYearCompare(1990, '1980-2000', 1997, '1998-1999', 1);
      testYearCompare(0, '1998-', 0, '1980-', 1);
      testYearCompare(2012, '1980-2000', 0, '1999-2011', 1);
      testYearCompare(0, '1980-2012', 2011, '1999-2000', 1);

      // Year on left should be considered lower than year on right.
      testYearCompare(1999, '', 2000, '', -1);
      testYearCompare(0, '1998-1999', 0, '1980-2000', -1);
      testYearCompare(1997, '1998-1999', 2000, '1990-1995', -1);
      testYearCompare(1997, '1998-1999', 1990, '1980-2000', -1);
      testYearCompare(0, '1980-', 0, '1998-', -1);
      testYearCompare(2011, '1980-2000', 0, '1999-2012', -1);
      testYearCompare(0, '1980-2011', 2012, '1999-2000', -1);

      MovieResultDTO tmpYear = MovieResultDTO();
      expect(tmpYear.yearCompare(null), 0);
      tmpYear.year = 2000;
      expect(tmpYear.yearCompare(null), 1);
    });
    // Determine definative year based on text based year range
    test('yearRangeAsNumber', () {
      testYearCompare(inputYR, expectedOutput) {
        var testInput = MovieResultDTO();
        testInput.yearRange = inputYR;
        expect(testInput.yearRangeAsNumber(), expectedOutput);
      }

      testYearCompare('0', 0);
      testYearCompare('1999', 1999);
      testYearCompare('2000', 2000);
      testYearCompare('1999-2000', 2000);
      testYearCompare('1999-', 1999);
    });
  });

  group('toMap_toMovieResultDTO', () {
    // Compare a dto to a map equivialent of the dto.
    test_toMovieResultDTO(MovieResultDTO expected, Map<String, String> map) {
      print(map.toString());

      var actual = map.toMovieResultDTO();

      expect(expected, MovieResultDTOMatcher(actual));
    }

    // Convert a dto to a map.
    test('single_DTO', () {
      var dto = makeDTO('abc');

      var map = dto.toMap(excludeCopywritedData: false);

      test_toMovieResultDTO(dto, map);
    });

    // Convert a dto to a map excluding copywrited content.
    test('copywrite_DTO', () {
      var dto = makeDTO('abc');

      var map = dto.toMap();
      dto.description = '';
      dto.imageUrl = '';
      dto.userRating = 0;
      dto.censorRating = CensorRatingType.none;

      test_toMovieResultDTO(dto, map);
    });

    // Convert a list of dtos to a JSON and then convert the JSON back to a list.
    test('multiple_DTO', () {
      List<MovieResultDTO> list = [];
      list.add(makeDTO('abc'));
      list.add(makeDTO('def'));
      list.add(makeDTO('ghi'));
      var encoded = list.encodeList();

      List<MovieResultDTO> emptylist = [];
      var decoded = emptylist.decodeList(encoded);

      expect(list[0], MovieResultDTOMatcher(decoded[0]));
      expect(list[1], MovieResultDTOMatcher(decoded[1]));
      expect(list[2], MovieResultDTOMatcher(decoded[2]));
    });
    // Convert a restorable dto to JSON and then convert the JSON to a restorable dto.
    test('RestorableMovie', () {
      var movie = makeDTO('abcd');
      var rtp = RestorationTestParent(movie.uniqueId);
      rtp.restoreState(null, true);

      var encoded = rtp.movie.dtoToPrimitives(movie);
      rtp.movie.initWithValue(rtp.movie.fromPrimitives(encoded));
      var encoded2 = rtp.movie.toPrimitives();

      expect(movie, MovieResultDTOMatcher(rtp.movie.value));
      expect(encoded, encoded2);
    });
    // Convert a restorable dto list to JSON and then convert the JSON to a restorable dto list.
    test('RestorableMovieList', () {
      List<MovieResultDTO> list = [];
      list.add(makeDTO('abc'));
      list.add(makeDTO('def'));
      list.add(makeDTO('ghi'));
      var rtp = RestorationTestParent(list[1].uniqueId);
      rtp.restoreState(null, true);

      var encoded = rtp.list.listToPrimitives(list);
      rtp.list.initWithValue(rtp.list.fromPrimitives(encoded));
      var encoded2 = rtp.list.toPrimitives();

      expect(list, MovieResultDTOListMatcher(rtp.list.value));
      expect(encoded, encoded2);
    });
  });
}
