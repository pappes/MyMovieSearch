import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/screens/navigation_history_page.dart';
import 'package:my_movie_search/persistence/nav_log.dart';
import 'package:my_movie_search/persistence/session_nav_tree.dart';
import 'package:my_movie_search/utilities/navigation/route_info.dart';
import 'package:provider/provider.dart';

void main() {
  RouteInfo createRoute(
    ScreenRoute path,
    String reference,
    String description,
  ) => RouteInfo(path, {}, reference, description);

  Widget createWidgetUnderTest(SessionNavTree mockTree) => MaterialApp(
    home: ChangeNotifierProvider<SessionNavTree>.value(
      value: mockTree,
      child: const NavigationHistoryPage(),
    ),
  );

  testWidgets('shows empty state when no history', (tester) async {
    final mockTree = SessionNavTree();

    await tester.pumpWidget(createWidgetUnderTest(mockTree));

    expect(find.text('No navigation history yet.'), findsOneWidget);
  });

  testWidgets('displays navigation roots and children', (tester) async {
    final mockTree = SessionNavTree()
      ..logPageOpen(
        createRoute(ScreenRoute.search, NavLog.rootReference, 'dummy home'),
      )
      ..logPageOpen(
        createRoute(ScreenRoute.moviedetails, 'movie_1', 'dummy details'),
      )
      ..logPageOpen(
        createRoute(ScreenRoute.persondetails, 'person_1', 'dummy person'),
      );

    await tester.pumpWidget(createWidgetUnderTest(mockTree));
    await tester.pumpAndSettle();

    expect(find.text('ScreenRoute.search'), findsOneWidget);
    expect(find.text('ScreenRoute.moviedetails'), findsOneWidget);
    expect(find.text('ScreenRoute.persondetails'), findsOneWidget);

    // Verify references are also present
    expect(find.text('dummy home'), findsOneWidget);
    expect(find.text('dummy details'), findsOneWidget);
    expect(find.text('dummy person'), findsOneWidget);
  });

  testWidgets('limits split-screen top area to 5 most recent parents', (
    tester,
  ) async {
    final mockTree = SessionNavTree();
    // Create an 8-level deep tree (0 to 7)
    for (var i = 0; i < 8; i++) {
      mockTree.logPageOpen(
        createRoute(ScreenRoute.search, 'ref_$i', 'dummy level $i'),
      );
    }

    await tester.pumpWidget(createWidgetUnderTest(mockTree));

    // Auto-scroll runs on post frame
    await tester.pumpAndSettle();

    final boldTextFinder = find.byWidgetPredicate(
      (widget) => widget is Text && widget.style?.fontWeight == FontWeight.bold,
    );

    final boldWidgets = tester.widgetList<Text>(boldTextFinder).toList();
    expect(boldWidgets.length, lessThanOrEqualTo(5));

    if (boldWidgets.length == 5) {
      // Actually all node titles will be 'ScreenRoute.search'
      expect(boldWidgets[0].data, 'ScreenRoute.search');
    }
  });

  testWidgets('auto-scrolls to the bottom on open', (tester) async {
    final mockTree = SessionNavTree();
    // Create a very deep tree to ensure it's scrollable
    for (var i = 0; i < 20; i++) {
      mockTree.logPageOpen(
        createRoute(ScreenRoute.search, 'ref_$i', 'dummy level $i'),
      );
    }

    await tester.pumpWidget(createWidgetUnderTest(mockTree));

    // Pump to trigger the post-frame callback
    await tester.pump();

    // Check that we are scrolled down
    final ScrollableState scrollable = tester.state<ScrollableState>(
      find.byType(Scrollable),
    );
    expect(scrollable.position.pixels, greaterThan(0));

    await tester.pumpAndSettle();
  });
}
