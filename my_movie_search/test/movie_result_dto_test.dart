import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////
// Class to assist with Restorable tests
class RestorationTestParent extends State with RestorationMixin {
  RestorationTestParent(this.uniqueId);
  String uniqueId;
  final movie = RestorableMovie();
  final list = RestorableMovieList();

  @override
  // The restoration bucket id for this page.
  String get restorationId => 'abc';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(movie, '${uniqueId}movie');
    registerForRestoration(list, '${uniqueId}list');
  }

  @override
  Widget build(BuildContext context) {
    return const Text('');
  }
}

void clearCopyright(MovieResultDTO dto) {
  dto.description = '';
  dto.imageUrl = '';
  dto.userRating = 0;
  dto.userRatingCount = 0;
  dto.censorRating = CensorRatingType.none;
  dto.languages.clear();
  dto.genres.clear();
  dto.keywords.clear();
  for (final category in dto.related.keys) {
    for (final uniqueId in dto.related[category]!.keys) {
      clearCopyright(dto.related[category]![uniqueId]!);
    }
  }
}

MovieResultDTO fullDTO() {
  final dto = MovieResultDTO();

  dto.source = DataSourceType.wiki;
  dto.uniqueId = 'abc123';
  dto.alternateId = '123abc';
  dto.title = 'init testing';
  dto.alternateTitle = 'testing init';
  dto.alternateTitle2 = 'testing dto';
  dto.description = 'test dto';
  dto.type = MovieContentType.episode;
  dto.year = 1999;
  dto.yearRange = '1999-2005';
  dto.userRating = 1.5;
  dto.userRatingCount = 1500;
  dto.censorRating = CensorRatingType.family;
  dto.runTime = const Duration(seconds: 9000);
  dto.imageUrl = 'www.microsoft.com';
  dto.language = LanguageType.mostlyEnglish;
  dto.languages = ['a', 'b', 'c'];
  dto.genres = ['x', 'y', 'z'];
  dto.keywords = ['they', 'them'];

  final dto2 = MovieResultDTO();
  dto2.uniqueId = 'dto2';
  final dto3 = MovieResultDTO();
  dto3.uniqueId = 'dto3';
  final dto4 = MovieResultDTO();
  dto4.uniqueId = 'dto4';

  dto.related = {
    'Actress': {dto2.uniqueId: dto2, dto3.uniqueId: dto3},
    'Director': {dto4.uniqueId: dto4, dto3.uniqueId: dto3},
  };
  return dto;
}

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('DTOCompare', () {
    // Categorise dto based on popularity from userRatingCount.
    test('userRatingCategory', () {
      void testUserRatingCategory(int input, expectedOutput) {
        final testInput = MovieResultDTO();
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
      void testUserContentCategory(MovieContentType input, expectedOutput) {
        final testInput = MovieResultDTO();
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
      void testPopularityCategory(MovieResultDTO input, expectedOutput) {
        expect(input.popularityCategory(), expectedOutput);
      }

      final testInput = MovieResultDTO();
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
      void testYearCompare(
        int inputYear,
        String inputYR,
        int otherYear,
        String otherYR,
        int expectedOutput,
      ) {
        final testInput = MovieResultDTO();
        testInput.year = inputYear;
        testInput.yearRange = inputYR;
        final testOther = MovieResultDTO();
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

      final tmpYear = MovieResultDTO();
      expect(tmpYear.yearCompare(null), 0);
      tmpYear.year = 2000;
      expect(tmpYear.yearCompare(null), 1);
    });
    // Determine definative year based on text based year range
    test('yearRangeAsNumber', () {
      void testYearCompare(String inputYR, expectedOutput) {
        final testInput = MovieResultDTO();
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

  group('MovieResultDTOinit', () {
    // Convert a dto to a map.
    test('empty_DTO', () {
      final dto = MovieResultDTO();
      final initialisedDTO = MovieResultDTO().init();
      expect(dto, MovieResultDTOMatcher(initialisedDTO));
    });
    test('full_DTO_json', () {
      final dto = fullDTO();

      final initialisedDTO = MovieResultDTO().init(
        source: dto.source,
        uniqueId: dto.uniqueId,
        alternateId: dto.alternateId,
        title: dto.title,
        alternateTitle: dto.alternateTitle,
        alternateTitle2: dto.alternateTitle2,
        description: dto.description,
        type: dto.type.toString(),
        year: dto.year.toString(),
        yearRange: dto.yearRange,
        userRating: dto.userRating.toString(),
        userRatingCount: dto.userRatingCount.toString(),
        censorRating: dto.censorRating.toString(),
        runTime: '9000',
        imageUrl: dto.imageUrl,
        language: dto.language.toString(),
        languages: json.encode(dto.languages),
        genres: json.encode(dto.genres),
        keywords: json.encode(dto.keywords),
        related: dto.related,
      );

      expect(dto, MovieResultDTOMatcher(initialisedDTO));
    });
  });

  group('toMap_toMovieResultDTO_Restorable', () {
    // Compare a dto to a map equivalent of the dto.
    void testToMovieResultDTO(
      MovieResultDTO expected,
      Map<String, dynamic> map,
    ) {
      final actual = map.toMovieResultDTO();

      expect(expected, MovieResultDTOMatcher(actual));
    }

    // Convert a dto to a map.
    test('single_DTO', () {
      final dto = makeResultDTO('abc');

      final map = dto.toMap(excludeCopyrightedData: false);

      testToMovieResultDTO(dto, map);
    });

    // Convert a dto to a map excluding copyrighted content.
    test('no copyright data', () {
      final dto = makeResultDTO('abc');

      final map = dto.toMap();
      clearCopyright(dto);

      testToMovieResultDTO(dto, map);
    });

    // Convert a list of dtos to a JSON and then convert the JSON back to a list.
    test('multiple_DTO', () {
      final list = <MovieResultDTO>[];
      list.add(makeResultDTO('abc'));
      list.add(makeResultDTO('def'));
      list.add(makeResultDTO('ghi'));
      final encoded = list.encodeList();

      final decoded = ListDTOConversion.decodeList(encoded);

      expect(list[0], MovieResultDTOMatcher(decoded[0]));
      expect(list[1], MovieResultDTOMatcher(decoded[1]));
      expect(list[2], MovieResultDTOMatcher(decoded[2]));
    });
    // Convert a restorable dto to JSON and then convert the JSON to a restorable dto.
    test('RestorableMovie', () {
      final movie = makeResultDTO('abcd');
      final rtp = RestorationTestParent(movie.uniqueId);
      rtp.restoreState(null, true);

      final encoded = rtp.movie.dtoToPrimitives(movie);
      rtp.movie.initWithValue(rtp.movie.fromPrimitives(encoded));
      final encoded2 = rtp.movie.toPrimitives();

      expect(movie, MovieResultDTOMatcher(rtp.movie.value));
      expect(encoded, encoded2);
    });
    // Convert a restorable dto list to JSON and then convert the JSON to a restorable dto list.
    test('RestorableMovieList', () {
      final list = <MovieResultDTO>[];
      list.add(makeResultDTO('abc'));
      list.add(makeResultDTO('def'));
      list.add(makeResultDTO('ghi'));
      final rtp = RestorationTestParent(list[1].uniqueId);
      rtp.restoreState(null, true);

      final encoded = rtp.list.listToPrimitives(list);
      rtp.list.initWithValue(rtp.list.fromPrimitives(encoded));
      final encoded2 = rtp.list.toPrimitives();

      expect(list, MovieResultDTOListMatcher(rtp.list.value));
      expect(encoded, encoded2);
    });
  });

  group('toJson_fromJson', () {
    // Compare a dto to a map equivalent of the dto.
    void testToMovieResultDTO(
      MovieResultDTO expected,
      Map<String, dynamic> map,
    ) {
      final json = jsonEncode(map);
      final actual = MovieResultDTO().fromJson(json);

      expect(expected, MovieResultDTOMatcher(actual));
    }

    // Convert a dto to a map.
    test('single_DTO', () {
      final dto = makeResultDTO('abc');

      final map = dto.toMap(excludeCopyrightedData: false);

      testToMovieResultDTO(dto, map);
    });

    // Convert a dto to a map excluding copyrighted content.
    test('no copyright data', () {
      final dto = makeResultDTO('abc');

      final map = dto.toMap();
      clearCopyright(dto);

      testToMovieResultDTO(dto, map);
    });

    // Convert a list of dtos to a JSON and then convert the JSON back to a list.
    test('multiple_DTO', () {
      final list = <MovieResultDTO>[];
      list.add(makeResultDTO('abc'));
      list.add(makeResultDTO('def'));
      list.add(makeResultDTO('ghi'));
      final encoded = list.toJson();

      final decoded = encoded.jsonToList();

      expect(list[0], MovieResultDTOMatcher(decoded[0]));
      expect(list[1], MovieResultDTOMatcher(decoded[1]));
      expect(list[2], MovieResultDTOMatcher(decoded[2]));
    });
  });
}
