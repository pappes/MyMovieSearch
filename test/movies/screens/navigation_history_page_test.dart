import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/screens/navigation_history_page.dart';
import 'package:my_movie_search/persistence/nav_log.dart';
import 'package:my_movie_search/persistence/session_nav_tree.dart';
import 'package:provider/provider.dart';

void main() {
  Widget createWidgetUnderTest(SessionNavTree mockTree) => MaterialApp(
    home: ChangeNotifierProvider<SessionNavTree>.value(
      value: mockTree,
      child: const NavigationHistoryPage(),
    ),
  );

  testWidgets('shows empty state when no history', (WidgetTester tester) async {
    final mockTree = SessionNavTree();

    await tester.pumpWidget(createWidgetUnderTest(mockTree));

    expect(find.text('No navigation history yet.'), findsOneWidget);
  });

  testWidgets('displays navigation roots and children with sticky scroll', (
    WidgetTester tester,
  ) async {
    final mockTree = SessionNavTree()
      ..logPageOpen('Home', NavLog.rootReference)
      ..logPageOpen('Details', 'movie_1')
      ..logPageOpen('Person', 'person_1');

    await tester.pumpWidget(createWidgetUnderTest(mockTree));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Person'), findsOneWidget);

    // Verify references are also present
    expect(find.text(NavLog.rootReference), findsOneWidget);
    expect(find.text('movie_1'), findsOneWidget);
    expect(find.text('person_1'), findsOneWidget);
  });
}
