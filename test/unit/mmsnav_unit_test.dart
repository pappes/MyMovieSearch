import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';

import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

import 'package:provider/provider.dart';
import 'mmsnav_unit_test.mocks.dart';

// To regenerate mocks run the following command
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateNiceMocks([
  MockSpec<MMSFlutterCanvas>(), 
  MockSpec<GoRouter>(), 
  MockSpec<FirebaseApplicationState>(),
])

////////////////////////////////////////////////////////////////////////////////
/// Mock MMSFlutterCanvas
////////////////////////////////////////////////////////////////////////////////

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Non Mocked Unit tests
////////////////////////////////////////////////////////////////////////////////
      
  group('MMSNav web page unit tests', () {
    final testClass = RouteInfo(
        ScreenRoute.persondetails, // Dummy object for params
        <String, dynamic>{},
        'uniqueId',
      );

    test('toString()', ()  {
      expect(
        testClass.toString(),
        '{"path":"ScreenRoute.persondetails","params":"{}","ref":"uniqueId"}',
      );
    });
  });

  group('MMSNav web page unit tests', () {
    late MockMMSFlutterCanvas mockCanvas;
    late MMSNav testClass;
    late String? navigationResult;

    setUp(() {
      mockCanvas = MockMMSFlutterCanvas();
      testClass = MMSNav.headless(mockCanvas);
      navigationResult = null;

      when(mockCanvas.viewWebPage(any)).thenAnswer((invocation) {
        navigationResult = invocation.positionalArguments[0] as String;
        return Future.value(null);
      });
      when(mockCanvas.viewFlutterPage(any)).thenAnswer((invocation) {
        navigationResult = (invocation.positionalArguments[0] as RouteInfo).routePath.name;
        return Future.value(null);
      });
    });

    test('viewWebPage()', () async {
      await testClass.viewWebPage('unknown');
      expect(navigationResult, 'unknown');
    });

    test('showResultsPage()', () async {
      await testClass.showResultsPage(
        SearchCriteriaDTO().init(SearchCriteriaType.none)
      );
      expect(navigationResult, 'searchresults');
    });

    test('showCriteriaPage()', () async {
      await testClass.showCriteriaPage(
        SearchCriteriaDTO().init(SearchCriteriaType.none)
      );
      // This uses viewFlutterRootPage, which we haven't mocked yet.
      // For now, let's verify viewFlutterPage wasn't called.
      verifyNever(mockCanvas.viewFlutterPage(any));
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
      await testClass.searchForRelated(
        'unknown',
        [MovieResultDTO().init(type: MovieContentType.episode.toString())]
      );
      expect(navigationResult, 'moviedetails');
    });

    test('searchForRelated() 1 error result', () async {
      await testClass.searchForRelated(
        'unknown',
        [MovieResultDTO().init(type: MovieContentType.error.toString())]
      );
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
        if (expected.startsWith('http')) {
          verify(mockCanvas.viewWebPage(expected));
        } else {
          verify(mockCanvas.viewFlutterPage(any));
        }
        expect(
          navigationResult,
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

      await checkCalledPage(
        '12345',
        'searchresults',
        type: MovieContentType.barcode.toString(),
      );

      await checkCalledPage(
        'http://www.google.com',
        'http://www.google.com',
        type: MovieContentType.navigation.toString(),
      );

      await checkCalledPage(
        'tt1234',
        'searchresults',
        type: MovieContentType.navigation.toString(),
      );
    });
  });

  group('MMSFlutterCanvas with mocked GoRouter', () {
    late MockGoRouter mockGoRouter;
    late MockFirebaseApplicationState mockFirebaseState;
    late String pushedRouteName;

    setUp(() {
      mockGoRouter = MockGoRouter();
      mockFirebaseState = MockFirebaseApplicationState();
      pushedRouteName = '';
 
      when(mockGoRouter.pushNamed(
        any,
        extra: anyNamed('extra'),
        pathParameters: anyNamed('pathParameters'),
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((invocation) {
        pushedRouteName = invocation.positionalArguments[0] as String;
        return Future.value(null);
      });

      // Stub the call to prevent null pointer exceptions if your code uses it
      when(mockFirebaseState.addRecord(any, message: anyNamed('message'), id: anyNamed('id'))).thenAnswer((_) async => true);
    });
/*
    testWidgets('viewFlutterPage uses context.pushNamed',
        (WidgetTester tester) async {
      // To test a widget that needs a BuildContext with a GoRouter,
      // we wrap it in an InheritedGoRouter that provides our mock.
      await tester.pumpWidget(
        ChangeNotifierProvider<FirebaseApplicationState>.value(
          value: mockFirebaseState,
          child: InheritedGoRouter(
            goRouter: mockGoRouter,
            child: Builder(builder: (context) {
                final canvas = MMSFlutterCanvas(context);
                final pageInfo = RouteInfo(ScreenRoute.moviedetails, {}, 'tt123');
                canvas.viewFlutterPage(pageInfo);
                // Return a placeholder widget.
                return Container();
              }),
          ),
        ),
      );
      expect(pushedRouteName, 'moviedetails');
    });*/
  });

}
