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
  final _movie = RestorableMovie();
  final _list = RestorableMovieList();

  @override
  // The restoration bucket id for this page.
  String get restorationId => 'abc';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_movie, '${uniqueId}movie');
    registerForRestoration(_list, '${uniqueId}list');
  }

  @override
  Widget build(BuildContext context) => const Text('');
}

MovieResultDTO fullDTO() {
  final dto2 = MovieResultDTO()..uniqueId = 'dto2';
  final dto3 = MovieResultDTO()..uniqueId = 'dto3';
  final dto4 = MovieResultDTO()..uniqueId = 'dto4';
  return MovieResultDTO()
    ..bestSource = DataSourceType.wiki
    ..uniqueId = 'abc123'
    ..title = 'init testing'
    ..alternateTitle = 'testing init'
    ..charactorName = 'testing dto'
    ..description = 'test dto'
    ..type = MovieContentType.episode
    ..year = 1999
    ..yearRange = '1999-2005'
    ..creditsOrder = 42
    ..userRating = 1.5
    ..userRatingCount = 1500
    ..censorRating = CensorRatingType.family
    ..runTime = const Duration(seconds: 9000)
    ..imageUrl = 'www.microsoft.com'
    ..language = LanguageType.mostlyEnglish
    ..languages = {'a', 'b', 'c'}
    ..genres = {'x', 'y', 'z'}
    ..keywords = {'they', 'them'}
    ..sources = {DataSourceType.wiki: 'abc123'}
    ..related = {
      'Actress': {dto2.uniqueId: dto2, dto3.uniqueId: dto3},
      'Director': {dto4.uniqueId: dto4, dto3.uniqueId: dto3},
    };
}

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('DTOCompare', () {
    // Categorise dto based on popularity from userRatingCount.
    test('userRatingCategory', () {
      void testUserRatingCategory(int input, int expectedOutput) {
        final testInput = MovieResultDTO()..userRatingCount = input;
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
      void testUserContentCategory(MovieContentType input, int expectedOutput) {
        final testInput = MovieResultDTO()..type = input;
        expect(testInput.titleContentCategory(), expectedOutput);
      }

      testUserContentCategory(MovieContentType.custom, 0);
      testUserContentCategory(MovieContentType.episode, 1);
      testUserContentCategory(MovieContentType.short, 2);
      testUserContentCategory(MovieContentType.series, 3);
      testUserContentCategory(MovieContentType.miniseries, 4);
      testUserContentCategory(MovieContentType.movie, 5);
    });
    // Categorise dto based on title type from MovieContentType.
    test('viewedCategory', () {
      void testViewedCategory(String input, int expectedOutput) {
        final testInput = MovieResultDTO()..setReadIndicator(input);
        expect(testInput.viewedCategory(), expectedOutput);
      }

      testViewedCategory(ReadHistory.starred.name, 99);
      testViewedCategory(ReadHistory.custom.name, 0);
      testViewedCategory(ReadHistory.none.name, 0);
      testViewedCategory(ReadHistory.read.name, 0);
      testViewedCategory(ReadHistory.reading.name, 1);
      testViewedCategory('AndNowForSomethingCompletelyDifferent', 0);
      testViewedCategory('', 98);
    });
    // Categorise dto based on popularity from userRating and Year.
    // A rating of 2/5 is better than a rating of less than 2/5.
    // A movie after 2000 is better than a movie before 2000.
    test('popularityCategory', () {
      void testPopularityCategory(MovieResultDTO input, int expectedOutput) =>
          expect(input.popularityCategory(), expectedOutput);

      final testInput = MovieResultDTO()
        // Any movie with a super low rating is probably bad.
        ..userRating = 1.99;
      testPopularityCategory(testInput, 0);
      // A rating of 2 out of 5 is not great but better than nothing.
      testInput.userRating = 2;
      testPopularityCategory(testInput, 1);
      testInput.year = 1999;
      testPopularityCategory(testInput, 1);
      // Movies made before 2000 have a lower relevancy to today.
      testInput.year = 2000;
      testPopularityCategory(testInput, 2);
      testInput
        ..year = 1999
        ..yearRange = '1999';
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
        final testInput = MovieResultDTO()
          ..year = inputYear
          ..yearRange = inputYR;
        final testOther = MovieResultDTO()
          ..year = otherYear
          ..yearRange = otherYR;
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
      void testYearCompare(String inputYR, int expectedOutput) {
        final testInput = MovieResultDTO()..yearRange = inputYR;
        expect(testInput.yearRangeAsNumber(), expectedOutput);
      }

      testYearCompare('0', 0);
      testYearCompare('1999', 1999);
      testYearCompare('2000', 2000);
      testYearCompare('1999-2000', 2000);
      testYearCompare('1999-', 1999);
    });

    // Test dto matcher.
    test('MovieResultDTOMatcher equals', () {
      final dto1 = makeResultDTO('abc');
      final dto2 = makeResultDTO('abc');

      expect(dto1, MovieResultDTOMatcher(dto2));
    });

    // Test matcher error string.
    test('MovieResultDTOMatcher different', () {
      const expectedError = '{uniqueId: is different\n'
          '  Expected: "abc_uniqueId"\n'
          '    Actual: "def"\n'
          '}';
      final dtoExpected = makeResultDTO('abc');
      final dtoActual = makeResultDTO('abc')..uniqueId = 'def';
      final matcher = MovieResultDTOMatcher(dtoExpected);

      final Description mismatchDescription = StringDescription();
      final Map<dynamic, dynamic> matchState = {};
      const bool verbose = false;
      expect(matcher.matches(dtoActual, matchState), false);
      matcher.describeMismatch(
        dtoExpected,
        mismatchDescription,
        matchState,
        verbose,
      );

      expect(mismatchDescription.toString(), expectedError);
    });

    // Test matcher error string.
    test('MovieResultDTOMatcher different verbose ', () {
      const expectedError =
          // ignore: lines_longer_than_80_chars
          'Expected: {uniqueId: abc_uniqueId, bestSource: DataSourceType.wiki, title: abc_title, alternateTitle: abc_alternateTitle, charactorName: abc_charactorName, type: MovieContentType.custom, year: 123, yearRange: abc_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","abc_language1","abc_language2"], genres: ["abc_genre1","abc_genre2"], keywords: ["abc_keyword1","abc_keyword2"], description: abc_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: abc_imageUrl, sources: {DataSourceType.tmdbMovie: abc_alternateTitle, DataSourceType.wiki: abc_uniqueId}, related: {actors: {relabc a_uniqueId: {uniqueId: relabc a_uniqueId, bestSource: DataSourceType.wiki, title: relabc a_title, alternateTitle: relabc a_alternateTitle, charactorName: relabc a_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc a_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc a_language1","relabc a_language2"], genres: ["relabc a_genre1","relabc a_genre2"], keywords: ["relabc a_keyword1","relabc a_keyword2"], description: relabc a_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc a_imageUrl, sources: {DataSourceType.tmdbMovie: relabc a_alternateTitle, DataSourceType.wiki: relabc a_uniqueId}}, relabc b_uniqueId: {uniqueId: relabc b_uniqueId, bestSource: DataSourceType.wiki, title: relabc b_title, alternateTitle: relabc b_alternateTitle, charactorName: relabc b_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc b_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc b_language1","relabc b_language2"], genres: ["relabc b_genre1","relabc b_genre2"], keywords: ["relabc b_keyword1","relabc b_keyword2"], description: relabc b_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc b_imageUrl, sources: {DataSourceType.tmdbMovie: relabc b_alternateTitle, DataSourceType.wiki: relabc b_uniqueId}}, relabc c_uniqueId: {uniqueId: relabc c_uniqueId, bestSource: DataSourceType.wiki, title: relabc c_title, alternateTitle: relabc c_alternateTitle, charactorName: relabc c_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc c_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc c_language1","relabc c_language2"], genres: ["relabc c_genre1","relabc c_genre2"], keywords: ["relabc c_keyword1","relabc c_keyword2"], description: relabc c_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc c_imageUrl, sources: {DataSourceType.tmdbMovie: relabc c_alternateTitle, DataSourceType.wiki: relabc c_uniqueId}}}, suggestions: {relabc 1_uniqueId: {uniqueId: relabc 1_uniqueId, bestSource: DataSourceType.wiki, title: relabc 1_title, alternateTitle: relabc 1_alternateTitle, charactorName: relabc 1_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 1_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 1_language1","relabc 1_language2"], genres: ["relabc 1_genre1","relabc 1_genre2"], keywords: ["relabc 1_keyword1","relabc 1_keyword2"], description: relabc 1_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 1_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 1_alternateTitle, DataSourceType.wiki: relabc 1_uniqueId}}, relabc 2_uniqueId: {uniqueId: relabc 2_uniqueId, bestSource: DataSourceType.wiki, title: relabc 2_title, alternateTitle: relabc 2_alternateTitle, charactorName: relabc 2_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 2_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 2_language1","relabc 2_language2"], genres: ["relabc 2_genre1","relabc 2_genre2"], keywords: ["relabc 2_keyword1","relabc 2_keyword2"], description: relabc 2_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 2_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 2_alternateTitle, DataSourceType.wiki: relabc 2_uniqueId}}, relabc 3_uniqueId: {uniqueId: relabc 3_uniqueId, bestSource: DataSourceType.wiki, title: relabc 3_title, alternateTitle: relabc 3_alternateTitle, charactorName: relabc 3_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 3_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 3_language1","relabc 3_language2"], genres: ["relabc 3_genre1","relabc 3_genre2"], keywords: ["relabc 3_keyword1","relabc 3_keyword2"], description: relabc 3_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 3_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 3_alternateTitle, DataSourceType.wiki: relabc 3_uniqueId}}}}}\n'
          // ignore: lines_longer_than_80_chars
          '  Actual: {uniqueId: def, bestSource: DataSourceType.wiki, title: abc_title, alternateTitle: abc_alternateTitle, charactorName: abc_charactorName, type: MovieContentType.custom, year: 123, yearRange: abc_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","abc_language1","abc_language2"], genres: ["abc_genre1","abc_genre2"], keywords: ["abc_keyword1","abc_keyword2"], description: abc_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: abc_imageUrl, sources: {DataSourceType.tmdbMovie: abc_alternateTitle, DataSourceType.wiki: abc_uniqueId}, related: {actors: {relabc a_uniqueId: {uniqueId: relabc a_uniqueId, bestSource: DataSourceType.wiki, title: relabc a_title, alternateTitle: relabc a_alternateTitle, charactorName: relabc a_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc a_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc a_language1","relabc a_language2"], genres: ["relabc a_genre1","relabc a_genre2"], keywords: ["relabc a_keyword1","relabc a_keyword2"], description: relabc a_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc a_imageUrl, sources: {DataSourceType.tmdbMovie: relabc a_alternateTitle, DataSourceType.wiki: relabc a_uniqueId}}, relabc b_uniqueId: {uniqueId: relabc b_uniqueId, bestSource: DataSourceType.wiki, title: relabc b_title, alternateTitle: relabc b_alternateTitle, charactorName: relabc b_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc b_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc b_language1","relabc b_language2"], genres: ["relabc b_genre1","relabc b_genre2"], keywords: ["relabc b_keyword1","relabc b_keyword2"], description: relabc b_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc b_imageUrl, sources: {DataSourceType.tmdbMovie: relabc b_alternateTitle, DataSourceType.wiki: relabc b_uniqueId}}, relabc c_uniqueId: {uniqueId: relabc c_uniqueId, bestSource: DataSourceType.wiki, title: relabc c_title, alternateTitle: relabc c_alternateTitle, charactorName: relabc c_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc c_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc c_language1","relabc c_language2"], genres: ["relabc c_genre1","relabc c_genre2"], keywords: ["relabc c_keyword1","relabc c_keyword2"], description: relabc c_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc c_imageUrl, sources: {DataSourceType.tmdbMovie: relabc c_alternateTitle, DataSourceType.wiki: relabc c_uniqueId}}}, suggestions: {relabc 1_uniqueId: {uniqueId: relabc 1_uniqueId, bestSource: DataSourceType.wiki, title: relabc 1_title, alternateTitle: relabc 1_alternateTitle, charactorName: relabc 1_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 1_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 1_language1","relabc 1_language2"], genres: ["relabc 1_genre1","relabc 1_genre2"], keywords: ["relabc 1_keyword1","relabc 1_keyword2"], description: relabc 1_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 1_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 1_alternateTitle, DataSourceType.wiki: relabc 1_uniqueId}}, relabc 2_uniqueId: {uniqueId: relabc 2_uniqueId, bestSource: DataSourceType.wiki, title: relabc 2_title, alternateTitle: relabc 2_alternateTitle, charactorName: relabc 2_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 2_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 2_language1","relabc 2_language2"], genres: ["relabc 2_genre1","relabc 2_genre2"], keywords: ["relabc 2_keyword1","relabc 2_keyword2"], description: relabc 2_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 2_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 2_alternateTitle, DataSourceType.wiki: relabc 2_uniqueId}}, relabc 3_uniqueId: {uniqueId: relabc 3_uniqueId, bestSource: DataSourceType.wiki, title: relabc 3_title, alternateTitle: relabc 3_alternateTitle, charactorName: relabc 3_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 3_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 3_language1","relabc 3_language2"], genres: ["relabc 3_genre1","relabc 3_genre2"], keywords: ["relabc 3_keyword1","relabc 3_keyword2"], description: relabc 3_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 3_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 3_alternateTitle, DataSourceType.wiki: relabc 3_uniqueId}}}}}\n'
          '{uniqueId: is different\n'
          '  Expected: "abc_uniqueId"\n'
          '    Actual: "def"\n'
          '}';
      final dto1 = makeResultDTO('abc');
      final dto2 = makeResultDTO('abc')..uniqueId = 'def';
      final matcher = MovieResultDTOMatcher(dto1);

      final Description mismatchDescription = StringDescription();
      final Map<dynamic, dynamic> matchState = {};
      const bool verbose = true;
      matcher
        ..matches(dto2, matchState)
        ..describeMismatch(dto1, mismatchDescription, matchState, verbose);

      expect(mismatchDescription.toString(), expectedError);
    });

    // Test list matcher.
    test('MovieResultDTOListMatcher equals', () {
      final list1 = <MovieResultDTO>[
        makeResultDTO('abc'),
        makeResultDTO('def'),
      ];
      final list2 = <MovieResultDTO>[
        makeResultDTO('abc'),
        makeResultDTO('def'),
      ];

      expect(list1, MovieResultDTOListMatcher(list2));
    });

    // Test list matcher error string.
    test('MovieResultDTOListMatcher different', () {
      const expectedError = '{instance def_uniqueId -> uniqueId: is different\n'
          '  Expected: "def_uniqueId"\n'
          '    Actual: "xyz"\n'
          '}';
      final expectedDTOList = <MovieResultDTO>[
        makeResultDTO('abc'),
        makeResultDTO('def'),
      ];
      final actualDTOList = <MovieResultDTO>[
        makeResultDTO('abc'),
        makeResultDTO('def'),
      ];
      actualDTOList.last.uniqueId = 'xyz';

      final matcher = MovieResultDTOListMatcher(expectedDTOList);

      final Description mismatchDescription = StringDescription();
      final Map<dynamic, dynamic> matchState = {};
      const bool verbose = false;
      matcher
        ..matches(actualDTOList, matchState)
        ..describeMismatch(
          expectedDTOList,
          mismatchDescription,
          matchState,
          verbose,
        );

      expect(mismatchDescription.toString(), expectedError);
    });

    // Test list matcher error string.
    test('MovieResultDTOListMatcher different verbose', () {
      const expectedError = 'Expected: List<MovieResultDTO>(2)[\n'
          // ignore: lines_longer_than_80_chars
          '{uniqueId: abc_uniqueId, bestSource: DataSourceType.wiki, title: abc_title, alternateTitle: abc_alternateTitle, charactorName: abc_charactorName, type: MovieContentType.custom, year: 123, yearRange: abc_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","abc_language1","abc_language2"], genres: ["abc_genre1","abc_genre2"], keywords: ["abc_keyword1","abc_keyword2"], description: abc_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: abc_imageUrl, sources: {DataSourceType.tmdbMovie: abc_alternateTitle, DataSourceType.wiki: abc_uniqueId}, related: {actors: {relabc a_uniqueId: {uniqueId: relabc a_uniqueId, bestSource: DataSourceType.wiki, title: relabc a_title, alternateTitle: relabc a_alternateTitle, charactorName: relabc a_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc a_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc a_language1","relabc a_language2"], genres: ["relabc a_genre1","relabc a_genre2"], keywords: ["relabc a_keyword1","relabc a_keyword2"], description: relabc a_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc a_imageUrl, sources: {DataSourceType.tmdbMovie: relabc a_alternateTitle, DataSourceType.wiki: relabc a_uniqueId}}, relabc b_uniqueId: {uniqueId: relabc b_uniqueId, bestSource: DataSourceType.wiki, title: relabc b_title, alternateTitle: relabc b_alternateTitle, charactorName: relabc b_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc b_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc b_language1","relabc b_language2"], genres: ["relabc b_genre1","relabc b_genre2"], keywords: ["relabc b_keyword1","relabc b_keyword2"], description: relabc b_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc b_imageUrl, sources: {DataSourceType.tmdbMovie: relabc b_alternateTitle, DataSourceType.wiki: relabc b_uniqueId}}, relabc c_uniqueId: {uniqueId: relabc c_uniqueId, bestSource: DataSourceType.wiki, title: relabc c_title, alternateTitle: relabc c_alternateTitle, charactorName: relabc c_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc c_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc c_language1","relabc c_language2"], genres: ["relabc c_genre1","relabc c_genre2"], keywords: ["relabc c_keyword1","relabc c_keyword2"], description: relabc c_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc c_imageUrl, sources: {DataSourceType.tmdbMovie: relabc c_alternateTitle, DataSourceType.wiki: relabc c_uniqueId}}}, suggestions: {relabc 1_uniqueId: {uniqueId: relabc 1_uniqueId, bestSource: DataSourceType.wiki, title: relabc 1_title, alternateTitle: relabc 1_alternateTitle, charactorName: relabc 1_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 1_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 1_language1","relabc 1_language2"], genres: ["relabc 1_genre1","relabc 1_genre2"], keywords: ["relabc 1_keyword1","relabc 1_keyword2"], description: relabc 1_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 1_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 1_alternateTitle, DataSourceType.wiki: relabc 1_uniqueId}}, relabc 2_uniqueId: {uniqueId: relabc 2_uniqueId, bestSource: DataSourceType.wiki, title: relabc 2_title, alternateTitle: relabc 2_alternateTitle, charactorName: relabc 2_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 2_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 2_language1","relabc 2_language2"], genres: ["relabc 2_genre1","relabc 2_genre2"], keywords: ["relabc 2_keyword1","relabc 2_keyword2"], description: relabc 2_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 2_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 2_alternateTitle, DataSourceType.wiki: relabc 2_uniqueId}}, relabc 3_uniqueId: {uniqueId: relabc 3_uniqueId, bestSource: DataSourceType.wiki, title: relabc 3_title, alternateTitle: relabc 3_alternateTitle, charactorName: relabc 3_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 3_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 3_language1","relabc 3_language2"], genres: ["relabc 3_genre1","relabc 3_genre2"], keywords: ["relabc 3_keyword1","relabc 3_keyword2"], description: relabc 3_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 3_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 3_alternateTitle, DataSourceType.wiki: relabc 3_uniqueId}}}}},\n'
          // ignore: lines_longer_than_80_chars
          '{uniqueId: def_uniqueId, bestSource: DataSourceType.wiki, title: def_title, alternateTitle: def_alternateTitle, charactorName: def_charactorName, type: MovieContentType.custom, year: 123, yearRange: def_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","def_language1","def_language2"], genres: ["def_genre1","def_genre2"], keywords: ["def_keyword1","def_keyword2"], description: def_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: def_imageUrl, sources: {DataSourceType.tmdbMovie: def_alternateTitle, DataSourceType.wiki: def_uniqueId}, related: {actors: {reldef a_uniqueId: {uniqueId: reldef a_uniqueId, bestSource: DataSourceType.wiki, title: reldef a_title, alternateTitle: reldef a_alternateTitle, charactorName: reldef a_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef a_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef a_language1","reldef a_language2"], genres: ["reldef a_genre1","reldef a_genre2"], keywords: ["reldef a_keyword1","reldef a_keyword2"], description: reldef a_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef a_imageUrl, sources: {DataSourceType.tmdbMovie: reldef a_alternateTitle, DataSourceType.wiki: reldef a_uniqueId}}, reldef b_uniqueId: {uniqueId: reldef b_uniqueId, bestSource: DataSourceType.wiki, title: reldef b_title, alternateTitle: reldef b_alternateTitle, charactorName: reldef b_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef b_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef b_language1","reldef b_language2"], genres: ["reldef b_genre1","reldef b_genre2"], keywords: ["reldef b_keyword1","reldef b_keyword2"], description: reldef b_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef b_imageUrl, sources: {DataSourceType.tmdbMovie: reldef b_alternateTitle, DataSourceType.wiki: reldef b_uniqueId}}, reldef c_uniqueId: {uniqueId: reldef c_uniqueId, bestSource: DataSourceType.wiki, title: reldef c_title, alternateTitle: reldef c_alternateTitle, charactorName: reldef c_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef c_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef c_language1","reldef c_language2"], genres: ["reldef c_genre1","reldef c_genre2"], keywords: ["reldef c_keyword1","reldef c_keyword2"], description: reldef c_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef c_imageUrl, sources: {DataSourceType.tmdbMovie: reldef c_alternateTitle, DataSourceType.wiki: reldef c_uniqueId}}}, suggestions: {reldef 1_uniqueId: {uniqueId: reldef 1_uniqueId, bestSource: DataSourceType.wiki, title: reldef 1_title, alternateTitle: reldef 1_alternateTitle, charactorName: reldef 1_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef 1_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef 1_language1","reldef 1_language2"], genres: ["reldef 1_genre1","reldef 1_genre2"], keywords: ["reldef 1_keyword1","reldef 1_keyword2"], description: reldef 1_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef 1_imageUrl, sources: {DataSourceType.tmdbMovie: reldef 1_alternateTitle, DataSourceType.wiki: reldef 1_uniqueId}}, reldef 2_uniqueId: {uniqueId: reldef 2_uniqueId, bestSource: DataSourceType.wiki, title: reldef 2_title, alternateTitle: reldef 2_alternateTitle, charactorName: reldef 2_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef 2_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef 2_language1","reldef 2_language2"], genres: ["reldef 2_genre1","reldef 2_genre2"], keywords: ["reldef 2_keyword1","reldef 2_keyword2"], description: reldef 2_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef 2_imageUrl, sources: {DataSourceType.tmdbMovie: reldef 2_alternateTitle, DataSourceType.wiki: reldef 2_uniqueId}}, reldef 3_uniqueId: {uniqueId: reldef 3_uniqueId, bestSource: DataSourceType.wiki, title: reldef 3_title, alternateTitle: reldef 3_alternateTitle, charactorName: reldef 3_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef 3_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef 3_language1","reldef 3_language2"], genres: ["reldef 3_genre1","reldef 3_genre2"], keywords: ["reldef 3_keyword1","reldef 3_keyword2"], description: reldef 3_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef 3_imageUrl, sources: {DataSourceType.tmdbMovie: reldef 3_alternateTitle, DataSourceType.wiki: reldef 3_uniqueId}}}}}\n'
          ']\n'
          '  Actual: List<MovieResultDTO>(2)[\n'
          // ignore: lines_longer_than_80_chars
          '{uniqueId: abc_uniqueId, bestSource: DataSourceType.wiki, title: abc_title, alternateTitle: abc_alternateTitle, charactorName: abc_charactorName, type: MovieContentType.custom, year: 123, yearRange: abc_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","abc_language1","abc_language2"], genres: ["abc_genre1","abc_genre2"], keywords: ["abc_keyword1","abc_keyword2"], description: abc_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: abc_imageUrl, sources: {DataSourceType.tmdbMovie: abc_alternateTitle, DataSourceType.wiki: abc_uniqueId}, related: {actors: {relabc a_uniqueId: {uniqueId: relabc a_uniqueId, bestSource: DataSourceType.wiki, title: relabc a_title, alternateTitle: relabc a_alternateTitle, charactorName: relabc a_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc a_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc a_language1","relabc a_language2"], genres: ["relabc a_genre1","relabc a_genre2"], keywords: ["relabc a_keyword1","relabc a_keyword2"], description: relabc a_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc a_imageUrl, sources: {DataSourceType.tmdbMovie: relabc a_alternateTitle, DataSourceType.wiki: relabc a_uniqueId}}, relabc b_uniqueId: {uniqueId: relabc b_uniqueId, bestSource: DataSourceType.wiki, title: relabc b_title, alternateTitle: relabc b_alternateTitle, charactorName: relabc b_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc b_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc b_language1","relabc b_language2"], genres: ["relabc b_genre1","relabc b_genre2"], keywords: ["relabc b_keyword1","relabc b_keyword2"], description: relabc b_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc b_imageUrl, sources: {DataSourceType.tmdbMovie: relabc b_alternateTitle, DataSourceType.wiki: relabc b_uniqueId}}, relabc c_uniqueId: {uniqueId: relabc c_uniqueId, bestSource: DataSourceType.wiki, title: relabc c_title, alternateTitle: relabc c_alternateTitle, charactorName: relabc c_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc c_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc c_language1","relabc c_language2"], genres: ["relabc c_genre1","relabc c_genre2"], keywords: ["relabc c_keyword1","relabc c_keyword2"], description: relabc c_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc c_imageUrl, sources: {DataSourceType.tmdbMovie: relabc c_alternateTitle, DataSourceType.wiki: relabc c_uniqueId}}}, suggestions: {relabc 1_uniqueId: {uniqueId: relabc 1_uniqueId, bestSource: DataSourceType.wiki, title: relabc 1_title, alternateTitle: relabc 1_alternateTitle, charactorName: relabc 1_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 1_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 1_language1","relabc 1_language2"], genres: ["relabc 1_genre1","relabc 1_genre2"], keywords: ["relabc 1_keyword1","relabc 1_keyword2"], description: relabc 1_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 1_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 1_alternateTitle, DataSourceType.wiki: relabc 1_uniqueId}}, relabc 2_uniqueId: {uniqueId: relabc 2_uniqueId, bestSource: DataSourceType.wiki, title: relabc 2_title, alternateTitle: relabc 2_alternateTitle, charactorName: relabc 2_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 2_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 2_language1","relabc 2_language2"], genres: ["relabc 2_genre1","relabc 2_genre2"], keywords: ["relabc 2_keyword1","relabc 2_keyword2"], description: relabc 2_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 2_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 2_alternateTitle, DataSourceType.wiki: relabc 2_uniqueId}}, relabc 3_uniqueId: {uniqueId: relabc 3_uniqueId, bestSource: DataSourceType.wiki, title: relabc 3_title, alternateTitle: relabc 3_alternateTitle, charactorName: relabc 3_charactorName, type: MovieContentType.custom, year: 123, yearRange: relabc 3_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","relabc 3_language1","relabc 3_language2"], genres: ["relabc 3_genre1","relabc 3_genre2"], keywords: ["relabc 3_keyword1","relabc 3_keyword2"], description: relabc 3_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: relabc 3_imageUrl, sources: {DataSourceType.tmdbMovie: relabc 3_alternateTitle, DataSourceType.wiki: relabc 3_uniqueId}}}}},\n'
          // ignore: lines_longer_than_80_chars
          '{uniqueId: xyz, bestSource: DataSourceType.wiki, title: def_title, alternateTitle: def_alternateTitle, charactorName: def_charactorName, type: MovieContentType.custom, year: 123, yearRange: def_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","def_language1","def_language2"], genres: ["def_genre1","def_genre2"], keywords: ["def_keyword1","def_keyword2"], description: def_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: def_imageUrl, sources: {DataSourceType.tmdbMovie: def_alternateTitle, DataSourceType.wiki: def_uniqueId}, related: {actors: {reldef a_uniqueId: {uniqueId: reldef a_uniqueId, bestSource: DataSourceType.wiki, title: reldef a_title, alternateTitle: reldef a_alternateTitle, charactorName: reldef a_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef a_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef a_language1","reldef a_language2"], genres: ["reldef a_genre1","reldef a_genre2"], keywords: ["reldef a_keyword1","reldef a_keyword2"], description: reldef a_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef a_imageUrl, sources: {DataSourceType.tmdbMovie: reldef a_alternateTitle, DataSourceType.wiki: reldef a_uniqueId}}, reldef b_uniqueId: {uniqueId: reldef b_uniqueId, bestSource: DataSourceType.wiki, title: reldef b_title, alternateTitle: reldef b_alternateTitle, charactorName: reldef b_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef b_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef b_language1","reldef b_language2"], genres: ["reldef b_genre1","reldef b_genre2"], keywords: ["reldef b_keyword1","reldef b_keyword2"], description: reldef b_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef b_imageUrl, sources: {DataSourceType.tmdbMovie: reldef b_alternateTitle, DataSourceType.wiki: reldef b_uniqueId}}, reldef c_uniqueId: {uniqueId: reldef c_uniqueId, bestSource: DataSourceType.wiki, title: reldef c_title, alternateTitle: reldef c_alternateTitle, charactorName: reldef c_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef c_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef c_language1","reldef c_language2"], genres: ["reldef c_genre1","reldef c_genre2"], keywords: ["reldef c_keyword1","reldef c_keyword2"], description: reldef c_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef c_imageUrl, sources: {DataSourceType.tmdbMovie: reldef c_alternateTitle, DataSourceType.wiki: reldef c_uniqueId}}}, suggestions: {reldef 1_uniqueId: {uniqueId: reldef 1_uniqueId, bestSource: DataSourceType.wiki, title: reldef 1_title, alternateTitle: reldef 1_alternateTitle, charactorName: reldef 1_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef 1_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef 1_language1","reldef 1_language2"], genres: ["reldef 1_genre1","reldef 1_genre2"], keywords: ["reldef 1_keyword1","reldef 1_keyword2"], description: reldef 1_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef 1_imageUrl, sources: {DataSourceType.tmdbMovie: reldef 1_alternateTitle, DataSourceType.wiki: reldef 1_uniqueId}}, reldef 2_uniqueId: {uniqueId: reldef 2_uniqueId, bestSource: DataSourceType.wiki, title: reldef 2_title, alternateTitle: reldef 2_alternateTitle, charactorName: reldef 2_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef 2_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef 2_language1","reldef 2_language2"], genres: ["reldef 2_genre1","reldef 2_genre2"], keywords: ["reldef 2_keyword1","reldef 2_keyword2"], description: reldef 2_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef 2_imageUrl, sources: {DataSourceType.tmdbMovie: reldef 2_alternateTitle, DataSourceType.wiki: reldef 2_uniqueId}}, reldef 3_uniqueId: {uniqueId: reldef 3_uniqueId, bestSource: DataSourceType.wiki, title: reldef 3_title, alternateTitle: reldef 3_alternateTitle, charactorName: reldef 3_charactorName, type: MovieContentType.custom, year: 123, yearRange: reldef 3_yearRange, runTime: 3723, language: LanguageType.mostlyEnglish, creditsOrder: 42, languages: ["English","reldef 3_language1","reldef 3_language2"], genres: ["reldef 3_genre1","reldef 3_genre2"], keywords: ["reldef 3_keyword1","reldef 3_keyword2"], description: reldef 3_description, userRating: 456.0, userRatingCount: 789, censorRating: CensorRatingType.family, imageUrl: reldef 3_imageUrl, sources: {DataSourceType.tmdbMovie: reldef 3_alternateTitle, DataSourceType.wiki: reldef 3_uniqueId}}}}}\n'
          ']\n'
          '{instance def_uniqueId -> uniqueId: is different\n'
          '  Expected: "def_uniqueId"\n'
          '    Actual: "xyz"\n'
          '}';
      final expectedDTOList = <MovieResultDTO>[
        makeResultDTO('abc'),
        makeResultDTO('def'),
      ];
      final actualDTOList = <MovieResultDTO>[
        makeResultDTO('abc'),
        makeResultDTO('def'),
      ];
      actualDTOList.last.uniqueId = 'xyz';

      final matcher = MovieResultDTOListMatcher(expectedDTOList);

      final Description mismatchDescription = StringDescription();
      final Map<dynamic, dynamic> matchState = {};
      const bool verbose = true;
      matcher
        ..matches(actualDTOList, matchState)
        ..describeMismatch(
          expectedDTOList,
          mismatchDescription,
          matchState,
          verbose,
        );

      expect(mismatchDescription.toString(), expectedError);
    });
  });

  group('LanguageType', () {
    // Check that language list is categorised corectly.
    test('empty_DTO', () {
      final dto = MovieResultDTO();
      expect(dto.getLanguageType(), LanguageType.none);
    });
    test('supply list to helper, get language from helper', () {
      final dto = MovieResultDTO();
      expect(dto.getLanguageType({'English'}), LanguageType.allEnglish);
      expect(dto.languages, {'English'});
    });
    test('supply list to dto, get language from helper', () {
      final dto = MovieResultDTO()..languages = {'English'};
      expect(dto.getLanguageType(), LanguageType.allEnglish);
    });
    test('supply list to dto, get language from dto', () {
      final dto = MovieResultDTO()
        ..languages = {'English'}
        ..getLanguageType();
      expect(dto.language, LanguageType.allEnglish);
    });
    test('supply list to helper, get language from dto', () {
      final dto = MovieResultDTO()..getLanguageType({'English'});
      expect(dto.language, LanguageType.allEnglish);
      expect(dto.languages, {'English'});
    });
    test('All English', () {
      final dto = MovieResultDTO();
      expect(
        dto.getLanguageType(['English', 'en', 'Englasias']),
        LanguageType.allEnglish,
      );
    });
    test('Foreign', () {
      final dto = MovieResultDTO();
      expect(
        dto.getLanguageType(['Not English', 'French', 'el-Englasias']),
        LanguageType.foreign,
      );
    });
    test('mostlyEnglish', () {
      final dto = MovieResultDTO();
      expect(
        dto.getLanguageType(['English', 'French', 'el-Englasias']),
        LanguageType.mostlyEnglish,
      );
    });
    test('someEnglish', () {
      final dto = MovieResultDTO();
      expect(
        dto.getLanguageType(['French', 'Englasias']),
        LanguageType.someEnglish,
      );
    });
  });

  group('MovieResultDTOinit', () {
    // Convert a dto to a map.
    test('empty_DTO', () {
      final dto = MovieResultDTO()
        ..type = MovieContentType.none
        ..setSource();
      final initialisedDTO = MovieResultDTO().init();
      expect(dto, MovieResultDTOMatcher(initialisedDTO));
    });
    test('full_DTO_json', () {
      final dto = fullDTO();

      final initialisedDTO = MovieResultDTO().init(
        bestSource: dto.bestSource,
        uniqueId: dto.uniqueId,
        title: dto.title,
        alternateTitle: dto.alternateTitle,
        charactorName: dto.charactorName,
        description: dto.description,
        type: dto.type.toString(),
        year: dto.year.toString(),
        yearRange: dto.yearRange,
        creditsOrder: dto.creditsOrder.toString(),
        userRating: dto.userRating.toString(),
        userRatingCount: dto.userRatingCount.toString(),
        censorRating: dto.censorRating.toString(),
        runTime: '9000',
        imageUrl: dto.imageUrl,
        language: dto.language.toString(),
        languages: json.encode(dto.languages.toList()),
        genres: json.encode(dto.genres.toList()),
        keywords: json.encode(dto.keywords.toList()),
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

      final map = dto.toMap();

      testToMovieResultDTO(dto, map);
    });

    // Convert a list of dtos to a JSON
    //and then convert the JSON back to a list.
    test('multiple_DTO', () {
      final list = <MovieResultDTO>[
        makeResultDTO('abc'),
        makeResultDTO('def'),
        makeResultDTO('ghi'),
      ];
      final encoded = list.encodeList();

      final decoded = ListDTOConversion.decodeList(encoded);

      expect(list[0], MovieResultDTOMatcher(decoded[0]));
      expect(list[1], MovieResultDTOMatcher(decoded[1]));
      expect(list[2], MovieResultDTOMatcher(decoded[2]));
    });
    // Convert a restorable dto to JSON
    //and then convert the JSON to a restorable dto.
    test('RestorableMovie', () {
      final movie = makeResultDTO('abcd');
      final rtp = RestorationTestParent(movie.uniqueId)
        ..restoreState(null, true);

      final encoded = rtp._movie.dtoToPrimitives(movie);
      rtp._movie.initWithValue(rtp._movie.fromPrimitives(encoded));
      final encoded2 = rtp._movie.toPrimitives();

      expect(movie, MovieResultDTOMatcher(rtp._movie.value));
      expect(encoded, encoded2);
    });
    // Convert a restorable dto list to JSON
    //and then convert the JSON to a restorable dto list.
    test('RestorableMovieList', () {
      final list = <MovieResultDTO>[
        makeResultDTO('abc'),
        makeResultDTO('def'),
        makeResultDTO('ghi'),
      ];
      final rtp = RestorationTestParent(list[1].uniqueId)
        ..restoreState(null, true);

      final encoded = rtp._list.listToPrimitives(list);
      rtp._list.initWithValue(rtp._list.fromPrimitives(encoded));
      final encoded2 = rtp._list.toPrimitives();

      expect(list, MovieResultDTOListMatcher(rtp._list.value));
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

      final map = dto.toMap();

      testToMovieResultDTO(dto, map);
    });

    // Convert a list of dtos to a JSON
    //and then convert the JSON back to a list.
    test('multiple_DTO', () {
      final list = <MovieResultDTO>[
        makeResultDTO('abc'),
        makeResultDTO('def'),
        makeResultDTO('ghi'),
      ];
      final encoded = list.toJson();

      final decoded = encoded.jsonToList();

      expect(list[0], MovieResultDTOMatcher(decoded[0]));
      expect(list[1], MovieResultDTOMatcher(decoded[1]));
      expect(list[2], MovieResultDTOMatcher(decoded[2]));
    });
  });

  void testContent(
    MovieContentType? type,
    String suffix,
    int? duration,
    String id,
  ) {
    expect(
      MovieResultDTOHelpers.getMovieContentType(suffix, duration, id),
      type,
      reason: 'unexpected value returned from getImdbMovieContentType',
    );
  }

  group('findImdbMovieContentTypeFromTitle movie', () {
    test(
      'normal movie',
      () => testContent(null, '', null, '1234'),
    );
    test(
      'normal imdb movie',
      () => testContent(MovieContentType.title, '', null, 'tt1234'),
    );
    test(
      'unknown movie',
      () => testContent(MovieContentType.title, 'info', null, 'tt1234'),
    );
    test(
      'concise movie',
      () => testContent(MovieContentType.movie, 'movie', null, 'tt1234'),
    );
    test(
      'verbose movie',
      () => testContent(MovieContentType.movie, '(funMovie!)', null, 'tt1234'),
    );
    test(
      'video',
      () => testContent(MovieContentType.movie, 'vhs video', null, 'tt1234'),
    );
    test(
      'feature',
      () => testContent(MovieContentType.movie, 'feature film', null, 'tt1234'),
    );
  });

  group('findImdbMovieContentTypeFromTitle misc', () {
    test('empty string', () => testContent(null, '', null, ''));
    test(
      '30 mins title',
      () => testContent(MovieContentType.short, 'info', 30, ''),
    );
    test(
      'short title',
      () => testContent(MovieContentType.short, 'short', null, ''),
    );
    test(
      'normal person',
      () => testContent(MovieContentType.person, 'info', null, 'nm1234'),
    );
    test(
      'year range hyphen',
      () => testContent(MovieContentType.series, '(2020-2022)', null, 'tt1234'),
    );
    test(
      'year range dash',
      () => testContent(MovieContentType.series, '(2020–2022)', null, 'tt1234'),
    );
  });

  group('findImdbMovieContentTypeFromTitle not a movie ie game', () {
    test(
      'error',
      () => testContent(MovieContentType.none, 'info', null, '-1'),
    );
    test(
      'error',
      () => testContent(MovieContentType.error, 'info', null, '-2'),
    );
    test(
      'game',
      () => testContent(MovieContentType.custom, 'game', null, 'tt1234'),
    );
    test(
      'creativeWork',
      () =>
          testContent(MovieContentType.custom, 'creativeWork', null, 'tt1234'),
    );
  });

  group('findImdbMovieContentTypeFromTitle episodic', () {
    test(
      'miniseries',
      () => testContent(
        MovieContentType.miniseries,
        'mini series',
        null,
        'tt1234',
      ),
    );
    test(
      'series episode',
      () => testContent(MovieContentType.episode, 'episode', null, 'tt1234'),
    );
    test(
      'tv series',
      () => testContent(MovieContentType.series, 'series', null, 'tt1234'),
    );
    test(
      'tv series special',
      () => testContent(MovieContentType.series, 'special', null, 'tt1234'),
    );
  });

  group('read indicator', () {
    test('set and get', () {
      final dto = MovieResultDTO();
      const expectedValue = 'testing';
      dto.setReadIndicator(expectedValue);
      final actualValue = dto.getReadIndicator();
      expect(actualValue, expectedValue);
    });
  });

  group('merge', () {
    // Check that merge combines 2 DTOs corectly.
    test('empty_DTO', () {
      final dto1 = MovieResultDTO();
      final dto2 = MovieResultDTO();
      dto1.merge(dto2);
      expect(dto1.title, '');
      expect(dto1.description, '');
    });
    test('some details', () {
      final dto1related = MovieResultDTO().init(title: 'related dto 1');
      final dto2related = MovieResultDTO().init(title: 'related dto 2');
      final dto1 = MovieResultDTO().init(
        title: 'merge into me',
        related: {
          'suggestions': {'123': dto1related},
        },
      );
      final dto2 = MovieResultDTO().init(
        description: 'merge me',
        related: {
          'suggestions': {'456': dto2related},
        },
      );

      dto1.merge(dto2);

      expect(dto1.title, 'merge into me');
      expect(dto1.description, 'merge me');
      expect(dto1.related.length, 1);
      expect(dto1.related.keys.first, 'suggestions');
      expect(dto1.related.values.first.values.first.title, 'related dto 1');
      expect(dto1.related.values.first.values.last.title, 'related dto 2');
    });
    test('exclude related', () {
      final dto1 = MovieResultDTO();
      final dto2 = MovieResultDTO();
      final dto3 = MovieResultDTO();
      dto1.title = 'merge into me';
      dto2.description = 'merge me';
      dto3.title = 'related dto';
      dto2.related = {
        'suggestions': {dto3.uniqueId: dto3},
      };
      dto1.merge(dto2, excludeRelated: true);
      expect(dto1.title, 'merge into me');
      expect(dto1.description, 'merge me');
      expect(dto1.related.length, 0);
    });

    group('full DTO', () {
      final betterValues = makeResultDTO('abc')
        ..setSource(newSource: DataSourceType.omdb)
        ..sources[DataSourceType.imdb] = 'good data'
        ..languages = {'English', 'French', 'Italian'}
        ..userRating = 0
        ..userRatingCount = 0
        ..getLanguageType();
      final otherValues = MovieResultDTO()
        ..sources[DataSourceType.imdb] = 'good data'
        ..setSource(newSource: DataSourceType.wiki)
        ..languages = {'French', 'English'}
        ..userRating = 0
        ..userRatingCount = 0
        ..getLanguageType();

      test('no merge required', () {
        final expected = betterValues.clone();
        expected.sources.addAll(otherValues.sources);

        final output = betterValues.clone()..merge(otherValues);

        expect(output, MovieResultDTOMatcher(expected));
      });

      test('merge required', () {
        final expected = betterValues.clone()
          ..uniqueId = otherValues.uniqueId
          ..sources.addAll(otherValues.sources)
          ..bestSource = otherValues.bestSource
          ..languages = otherValues.languages
          ..languages.addAll(betterValues.languages)
          ..getLanguageType();

        final output = otherValues.clone()..merge(betterValues);

        expect(output, MovieResultDTOMatcher(expected));
      });

      test('truncated description', () {
        const shortDescription = 'Short but sweet.  '
            'More than 100 chars long '
            'but does not end in . . . unlike the other string.  '
            'This string should win.';
        const longDescription = 'Longer description text.  '
            'More than 100 chars long '
            'and does end in . . . unlike the other string. '
            ' This string should lose...';
        final worseDescription = betterValues.clone()
          ..description = longDescription;
        final betterDescription = otherValues.clone()
          ..description = shortDescription;
        final expected = betterValues.clone()
          ..description = shortDescription
          ..sources.addAll(betterDescription.sources)
          ..bestSource = worseDescription.bestSource;

        final output = worseDescription.clone()..merge(betterDescription);

        expect(output, MovieResultDTOMatcher(expected));
      });
    });
  });
}
