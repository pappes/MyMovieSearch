import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

import 'mmsnav_unit_test.mocks.dart';

////////////////////////////////////////////////////////////////////////////////
/// Mock MMSFlutterCanvas
////////////////////////////////////////////////////////////////////////////////

// To regenerate mocks run the following command
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([MMSFlutterCanvas])
class TestMMSFlutterCanvas {
  String? result;

  final mockCanvas = MockMMSFlutterCanvas();

  TestMMSFlutterCanvas() {
    // Use Mockito to return a string describing the parameters.
    when(mockCanvas.viewWebPage(any)).thenAnswer((Invocation inv) {
      result = inv.positionalArguments[0]?.toString();
    });
    when(mockCanvas.viewFlutterPage(any)).thenAnswer((Invocation inv) {
      result = inv.positionalArguments[0]?.toString();
    });
  }

  /*String? viewWebPage(String? url) {
    mockCanvas.viewWebPage(url);
    return result;
  }

  String? viewFlutterPage(Widget? page) {
    mockCanvas.viewFlutterPage(page);
    return result;
  }*/
}

final criteriaDto = SearchCriteriaDTO().fromString('criteria');
void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Non Mocked Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('MMSNav web page unit tests', () {
    final testCanvas = TestMMSFlutterCanvas();
    final testClass = MMSNav.headless(testCanvas.mockCanvas);

    test('viewWebPage()', () {
      testClass.viewWebPage('unknown');
      expect(testCanvas.result, 'unknown');
    });

    test('searchForRelated()', () {
      testClass.searchForRelated('unknown', []);
      expect(testCanvas.result, 'MovieSearchResultsNewPage');
    });

    test('getMoviesForKeyword()', () {
      testClass.getMoviesForKeyword('unknown');
      expect(testCanvas.result, 'MovieSearchResultsNewPage');
    });

    test('getDownloads()', () {
      testClass.getDownloads('unknown', MovieResultDTO());
      expect(testCanvas.result, 'MovieSearchResultsNewPage');
    });

    test('getMoreKeywords()', () {
      testClass.getMoviesForKeyword('unknown');
      expect(testCanvas.result, 'MovieSearchResultsNewPage');
    });

    test('getDetailsPage()', () {
      void checkCalledPage(String id, String expected, {String? type}) {
        final movie = MovieResultDTO().init(uniqueId: id, type: type);
        final actual = testClass.getDetailsPage(movie).toString();
        expect(actual, expected, reason: 'criteria: id=$id type=$type');
      }

      checkCalledPage('${imdbTitlePrefix}12345', 'MovieDetailsPage');
      checkCalledPage('${imdbPersonPrefix}12345', 'PersonDetailsPage');
      checkCalledPage('12345', 'ErrorDetailsPage');

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.movie.toString(),
      );

      checkCalledPage(
        '12345',
        'PersonDetailsPage',
        type: MovieContentType.person.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.custom.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.download.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.episode.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.error.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.information.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.keyword.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.miniseries.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.navigation.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.none.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.series.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.short.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.title.toString(),
      );
    });

    test('resultDrillDown()', () {
      void checkCalledPage(String id, String expected, {String? type}) {
        final movie = MovieResultDTO().init(
          uniqueId: id,
          type: type,
          imageUrl: 'http://something.com',
        );
        testClass.resultDrillDown(movie);
        expect(testCanvas.result, expected,
            reason: 'criteria: id=$id type=$type');
      }

      checkCalledPage('${imdbTitlePrefix}12345', 'MovieDetailsPage');
      checkCalledPage('${imdbPersonPrefix}12345', 'PersonDetailsPage');
      checkCalledPage('12345', 'ErrorDetailsPage');

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.movie.toString(),
      );

      checkCalledPage(
        '12345',
        'PersonDetailsPage',
        type: MovieContentType.person.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.custom.toString(),
      );

      checkCalledPage(
        '12345',
        'http://something.com',
        type: MovieContentType.download.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.episode.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.error.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.information.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieSearchResultsNewPage',
        type: MovieContentType.keyword.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.miniseries.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieSearchResultsNewPage',
        type: MovieContentType.navigation.toString(),
      );

      checkCalledPage(
        '12345',
        'ErrorDetailsPage',
        type: MovieContentType.none.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.series.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.short.toString(),
      );

      checkCalledPage(
        '12345',
        'MovieDetailsPage',
        type: MovieContentType.title.toString(),
      );
    });
  });
}
