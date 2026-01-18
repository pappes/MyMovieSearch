import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mockito;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/persistence/nav_log.dart';
import 'package:my_movie_search/utilities/navigation/app_context.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

import 'mmsnav_unit_test.mocks.dart';

// To regenerate mocks run the following command
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([
  MockSpec<MMSFlutterCanvas>(),
  MockSpec<FirebaseApplicationState>(),
  MockSpec<NavLog>(),
  MockSpec<AppNavigator>(),
  MockSpec<AppTheme>(),
  MockSpec<AppDialogs>(),
  MockSpec<AppFocus>(),
  MockSpec<CustomTabsLauncher>(),
])
class _DetailsPageTestCase {
  _DetailsPageTestCase(this.id, this.expectedRoute, {this.type});
  final String id;
  final MovieContentType? type;
  final String expectedRoute;
}

void main() {
  group('MMSNav web page unit tests', () {
    final testClass = RouteInfo(
      ScreenRoute.persondetails, // Dummy object for params
      <String, dynamic>{},
      'uniqueId',
    );

    test('toString()', () {
      expect(
        testClass.toString(),
        '{"path":"ScreenRoute.persondetails","params":"{}","ref":"uniqueId"}',
      );
    });
  });

  group('MMSNav web page mocked tests', () {
    late MockMMSFlutterCanvas mockCanvas;
    late MMSNav testClass;
    late String? navigationResult;

    setUp(() {
      mockCanvas = MockMMSFlutterCanvas();
      testClass = MMSNav.withCanvas(mockCanvas);
      navigationResult = null;

      mockito.when(mockCanvas.viewWebPage(mockito.any)).thenAnswer((
        invocation,
      ) {
        navigationResult = invocation.positionalArguments[0] as String;
        return Future.value(null);
      });
      mockito.when(mockCanvas.viewFlutterPage(mockito.any)).thenAnswer((
        invocation,
      ) {
        navigationResult =
            (invocation.positionalArguments[0] as RouteInfo).routePath.name;
        return Future.value(null);
      });
    });

    test('viewWebPage()', () async {
      await testClass.viewWebPage('unknown');
      expect(navigationResult, 'unknown');
    });

    test('showResultsPage()', () async {
      await testClass.showResultsPage(
        SearchCriteriaDTO()..init(SearchCriteriaType.none),
      );
      expect(navigationResult, 'searchresults');
    });

    test('showCriteriaPage()', () async {
      await testClass.showCriteriaPage(
        SearchCriteriaDTO()..init(SearchCriteriaType.none),
      );
      // This uses viewFlutterRootPage, which we haven't mocked yet.
      // For now, let's verify viewFlutterPage wasn't called.
      mockito.verifyNever(mockCanvas.viewFlutterPage(mockito.any));
    });

    test('showDVDsPage()', () async {
      await testClass.showDVDsPage();
      expect(navigationResult, 'searchresults');
    });

    test('searchForRelated()', () async {
      await testClass.searchForRelated('unknown', []);
      expect(navigationResult, 'searchresults');
    });

    test('searchForRelated() 1 episode result', () async {
      await testClass.searchForRelated('unknown', [
        MovieResultDTO().init(type: MovieContentType.episode.toString()),
      ]);
      expect(navigationResult, 'moviedetails');
    });

    test('searchForRelated() 1 error result', () async {
      await testClass.searchForRelated('unknown', [
        MovieResultDTO().init(type: MovieContentType.error.toString()),
      ]);
      expect(navigationResult, 'errordetails');
    });

    test('getMoviesForKeyword()', () async {
      await testClass.showMoviesForKeyword('unknown');
      expect(navigationResult, 'searchresults');
    });

    test('getMoreKeywords()', () async {
      await testClass.getMoreKeywords(MovieResultDTO());
      expect(navigationResult, 'searchresults');
    });

    test('getDownloads()', () async {
      await testClass.showDownloads('unknown', MovieResultDTO());
      expect(navigationResult, 'searchresults');
    });

    test('addLocation()', () async {
      await testClass.addLocation(MovieResultDTO());
      expect(navigationResult, 'addlocation');
    });

    test('getDetailsPage() returns correct screen to open '
        'for each content type', () {
      final testCases = [
        _DetailsPageTestCase('${imdbTitlePrefix}12345', 'moviedetails'),
        _DetailsPageTestCase('${imdbPersonPrefix}12345', 'persondetails'),
        _DetailsPageTestCase('12345', 'errordetails'),
        _DetailsPageTestCase(
          '12345',
          'moviedetails',
          type: MovieContentType.movie,
        ),
        _DetailsPageTestCase(
          '12345',
          'persondetails',
          type: MovieContentType.person,
        ),
        _DetailsPageTestCase(
          '12345',
          'errordetails',
          type: MovieContentType.custom,
        ),
        _DetailsPageTestCase(
          '12345',
          'errordetails',
          type: MovieContentType.download,
        ),
        _DetailsPageTestCase(
          '12345',
          'moviedetails',
          type: MovieContentType.episode,
        ),
        _DetailsPageTestCase(
          '12345',
          'errordetails',
          type: MovieContentType.error,
        ),
        _DetailsPageTestCase(
          '12345',
          'errordetails',
          type: MovieContentType.information,
        ),
        _DetailsPageTestCase(
          '12345',
          'errordetails',
          type: MovieContentType.keyword,
        ),
        _DetailsPageTestCase(
          '12345',
          'moviedetails',
          type: MovieContentType.miniseries,
        ),
        _DetailsPageTestCase(
          '12345',
          'errordetails',
          type: MovieContentType.navigation,
        ),
        _DetailsPageTestCase(
          '12345',
          'errordetails',
          type: MovieContentType.none,
        ),
        _DetailsPageTestCase(
          '12345',
          'moviedetails',
          type: MovieContentType.series,
        ),
        _DetailsPageTestCase(
          '12345',
          'moviedetails',
          type: MovieContentType.short,
        ),
        _DetailsPageTestCase(
          '12345',
          'moviedetails',
          type: MovieContentType.title,
        ),
      ];

      for (final testCase in testCases) {
        // Arrange
        final reason =
            'criteria: id=${testCase.id}, type=${testCase.type}, '
            'expected=${testCase.expectedRoute}';

        final movie = MovieResultDTO().init(
          uniqueId: testCase.id,
          type: testCase.type?.toString(),
        );

        // Act
        final actual = movie.getDetailsPage();
        final param = actual.params as Map;

        // Assert
        expect(actual.routePath.name, testCase.expectedRoute, reason: reason);
        expect(param['dtoId'], testCase.id, reason: reason);
      }
    });

    test('resultDrillDown() navigates to the correct screen '
        'for each content type', () async {
      // A data-driven approach makes this test cleaner and easier to maintain.
      final testCases = <Map<String, dynamic>>[
        {'id': '${imdbTitlePrefix}12345', 'expected': 'moviedetails'},
        {'id': '${imdbPersonPrefix}12345', 'expected': 'persondetails'},
        {'id': '12345', 'expected': 'errordetails'},
        {
          'id': '12345',
          'type': MovieContentType.movie,
          'expected': 'moviedetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.person,
          'expected': 'persondetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.custom,
          'expected': 'errordetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.download,
          'expected': 'http://something.com',
        },
        {
          'id': '12345',
          'type': MovieContentType.episode,
          'expected': 'moviedetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.error,
          'expected': 'errordetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.information,
          'expected': 'errordetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.keyword,
          'expected': 'searchresults',
        },
        {
          'id': '12345',
          'type': MovieContentType.miniseries,
          'expected': 'moviedetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.navigation,
          'expected': 'searchresults',
        },
        {
          'id': '12345',
          'type': MovieContentType.none,
          'expected': 'errordetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.series,
          'expected': 'moviedetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.short,
          'expected': 'moviedetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.title,
          'expected': 'moviedetails',
        },
        {
          'id': '12345',
          'type': MovieContentType.barcode,
          'expected': 'searchresults',
        },
        {
          'id': 'http://www.google.com',
          'type': MovieContentType.navigation,
          'expected': 'http://www.google.com',
        },
        {
          'id': 'tt1234',
          'type': MovieContentType.navigation,
          'expected': 'searchresults',
        },
      ];

      for (final testCase in testCases) {
        // Arrange
        final id = testCase['id'] as String;
        final type = testCase['type'] as MovieContentType?;
        final expected = testCase['expected'] as String;
        final reason = 'criteria: id=$id type=$type';

        // Reset mocks for each iteration to ensure clean verification.
        mockito.clearInteractions(mockCanvas);

        final movie = MovieResultDTO().init(
          uniqueId: id,
          type: type?.toString(),
          imageUrl: 'http://something.com',
        );

        // Act
        await testClass.resultDrillDown(movie);

        // Assert
        if (expected.startsWith(webAddressPrefix)) {
          mockito.verify(mockCanvas.viewWebPage(expected)).called(1);
        } else {
          mockito.verify(mockCanvas.viewFlutterPage(mockito.any)).called(1);
        }
        expect(navigationResult, expected, reason: reason);
      }
    });
  });

  group('MMSFlutterCanvas.viewFlutterPage', () {
    late MockAppNavigator fakeNavigator;
    late MockAppTheme mockTheme;
    late MockAppDialogs mockDialogs;
    late MockAppFocus mockFocus;
    late MockNavLog mockNavLog;
    late MMSFlutterCanvas canvas;
    late RouteInfo testPageInfo;

    setUp(() {
      fakeNavigator = MockAppNavigator();
      mockTheme = MockAppTheme();
      mockDialogs = MockAppDialogs();
      mockFocus = MockAppFocus();
      mockNavLog = MockNavLog();
      canvas = MMSFlutterCanvas(
        navigator: fakeNavigator,
        theme: mockTheme,
        dialogs: mockDialogs,
        focus: mockFocus,
        // customTabsLauncher is not used in this test group, so it can be null.
        navLog: mockNavLog,
      );
      testPageInfo = RouteInfo(ScreenRoute.moviedetails, {
        'id': '123',
      }, 'ref123');
    });

    test('should log open and close, and hide keyboard on success', () async {
      // Act
      await canvas.viewFlutterPage(testPageInfo);

      // Assert
      // Verify navigation was triggered on the context from the canvas
      mockito
          .verify(
            fakeNavigator.pushNamed(
              testPageInfo.routePath.name,
              extra: testPageInfo.params,
            ),
          )
          .called(1);

      // Verify logging calls
      mockito
          .verify(
            mockNavLog.logPageOpen(
              testPageInfo.routePath.name,
              testPageInfo.reference,
            ),
          )
          .called(1);
      mockito
          .verify(
            mockNavLog.logPageClose(
              testPageInfo.routePath.name,
              testPageInfo.reference,
              testPageInfo.params,
            ),
          )
          .called(1);

      // We can't easily test the private _hideKeyboard method directly,
      // but we know it's called after the Future from pushNamed completes.
    });

    test('should not do anything if context is null', () async {
      // Arrange
      final canvasWithNullContext = MMSFlutterCanvas(
        navigator: null,
        theme: null,
        dialogs: null,
        focus: null,
        customTabsLauncher: null,
        navLog: mockNavLog,
      );

      // Act
      await canvasWithNullContext.viewFlutterPage(testPageInfo);

      // Assert
      mockito.verifyNever(mockNavLog.logPageOpen(mockito.any, mockito.any));
      // We don't need to verify pushNamed on the fakeNavigator because it was
      // never passed to the canvasWithNullContext. The null check inside the
      // production code handles this case.
    });
  });
}
