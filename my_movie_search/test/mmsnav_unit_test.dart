import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

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
  TestMMSFlutterCanvas() {
    // Use Mockito to return a string describing the parameters.
    when(mockCanvas.viewWebPage(any)).thenAnswer((invocation) {
      final url = invocation.positionalArguments[0] as String;
      result = url;
    });
    // ignore: discarded_futures
    when(mockCanvas.viewFlutterPage(any)).thenAnswer((invocation) {
      final page = invocation.positionalArguments[0] as RouteInfo;
      result = page.routePath;
      return Future.value(null);
    });
  }

  String? result;
  final mockCanvas = MockMMSFlutterCanvas();
}

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
      expect(
        testCanvas.result,
        'searchresults',
      );
    });

    test('getMoviesForKeyword()', () {
      testClass.getMoviesForKeyword('unknown');
      expect(
        testCanvas.result,
        'searchresults',
      );
    });

    test('getDownloads()', () {
      testClass.getDownloads('unknown', MovieResultDTO());
      expect(
        testCanvas.result,
        'searchresults',
      );
    });

    test('getMoreKeywords()', () {
      testClass.getMoviesForKeyword('unknown');
      expect(
        testCanvas.result,
        'searchresults',
      );
    });

    test('getDetailsPage()', () {
      void checkCalledPage(
        String id,
        String route, {
        String? type,
      }) {
        final movie = MovieResultDTO().init(uniqueId: id, type: type);
        final actual = testClass.getDetailsPage(movie);
        final dto = actual.params as MovieResultDTO;

        expect(
          actual.routePath,
          route,
          reason: 'criteria: id=$id , route = $route, type=$type',
        );
        expect(
          dto.uniqueId,
          id,
          reason: 'criteria: id=$id , route = $route, type=$type',
        );
        if (type != null) {
          expect(
            dto.type.toString(),
            type,
            reason: 'criteria: id=$id , route = $route, type=$type',
          );
        }
        //expect(actual.reference, ref, reason: 'criteria: id=$id type=$type');
      }

      checkCalledPage('${imdbTitlePrefix}12345', 'moviedetails');
      checkCalledPage('${imdbPersonPrefix}12345', 'persondetails');
      checkCalledPage('12345', 'errordetails');

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.movie.toString(),
      );

      checkCalledPage(
        '12345',
        'persondetails',
        type: MovieContentType.person.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.custom.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.download.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.episode.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.error.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.information.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.keyword.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.miniseries.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.navigation.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.none.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.series.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.short.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
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
        expect(
          testCanvas.result,
          expected,
          reason: 'criteria: id=$id type=$type',
        );
      }

      checkCalledPage('${imdbTitlePrefix}12345', 'moviedetails');
      checkCalledPage('${imdbPersonPrefix}12345', 'persondetails');
      checkCalledPage('12345', 'errordetails');

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.movie.toString(),
      );

      checkCalledPage(
        '12345',
        'persondetails',
        type: MovieContentType.person.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.custom.toString(),
      );

      checkCalledPage(
        '12345',
        'http://something.com',
        type: MovieContentType.download.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.episode.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.error.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.information.toString(),
      );

      checkCalledPage(
        '12345',
        'searchresults',
        type: MovieContentType.keyword.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.miniseries.toString(),
      );

      checkCalledPage(
        '12345',
        'searchresults',
        type: MovieContentType.navigation.toString(),
      );

      checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.none.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.series.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.short.toString(),
      );

      checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.title.toString(),
      );
    });
  });
}
