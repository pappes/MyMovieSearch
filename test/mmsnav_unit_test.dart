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
    // ignore: discarded_futures
    when(mockCanvas.viewWebPage(any)).thenAnswer((invocation) {
      final url = invocation.positionalArguments[0] as String;
      result = url;
      return Future.value(null);
    });
    // ignore: discarded_futures
    when(mockCanvas.viewFlutterPage(any)).thenAnswer((invocation) {
      final page = invocation.positionalArguments[0] as RouteInfo;
      result = page.routePath.name;
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

    test('viewWebPage()', () async {
      await testClass.viewWebPage('unknown');
      expect(testCanvas.result, 'unknown');
    });

    test('searchForRelated()', () async {
      await testClass.searchForRelated('unknown', []);
      expect(
        testCanvas.result,
        'searchresults',
      );
    });

    test('getMoviesForKeyword()', () async {
      await testClass.showMoviesForKeyword('unknown');
      expect(
        testCanvas.result,
        'searchresults',
      );
    });

    test('getDownloads()', () async {
      await testClass.showDownloads('unknown', MovieResultDTO());
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
        final actual = movie.getDetailsPage();
        final param = actual.params as Map;

        expect(
          actual.routePath.name,
          route,
          reason: 'criteria: id=$id , route = $route, type=$type',
        );
        expect(
          param['dtoId'],
          id,
          reason: 'criteria: id=$id , route = $route, type=$type',
        );
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

    test('resultDrillDown()', () async {
      Future<void> checkCalledPage(
        String id,
        String expected, {
        String? type,
      }) async {
        final movie = MovieResultDTO().init(
          uniqueId: id,
          type: type,
          imageUrl: 'http://something.com',
        );
        await testClass.resultDrillDown(movie);
        expect(
          testCanvas.result,
          expected,
          reason: 'criteria: id=$id type=$type',
        );
      }

      await checkCalledPage('${imdbTitlePrefix}12345', 'moviedetails');
      await checkCalledPage('${imdbPersonPrefix}12345', 'persondetails');
      await checkCalledPage('12345', 'errordetails');

      await checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.movie.toString(),
      );

      await checkCalledPage(
        '12345',
        'persondetails',
        type: MovieContentType.person.toString(),
      );

      await checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.custom.toString(),
      );

      await checkCalledPage(
        '12345',
        'http://something.com',
        type: MovieContentType.download.toString(),
      );

      await checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.episode.toString(),
      );

      await checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.error.toString(),
      );

      await checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.information.toString(),
      );

      await checkCalledPage(
        '12345',
        'searchresults',
        type: MovieContentType.keyword.toString(),
      );

      await checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.miniseries.toString(),
      );

      await checkCalledPage(
        '12345',
        'searchresults',
        type: MovieContentType.navigation.toString(),
      );

      await checkCalledPage(
        '12345',
        'errordetails',
        type: MovieContentType.none.toString(),
      );

      await checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.series.toString(),
      );

      await checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.short.toString(),
      );

      await checkCalledPage(
        '12345',
        'moviedetails',
        type: MovieContentType.title.toString(),
      );
    });
  });
}
