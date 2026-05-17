import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/persistence/nav_log.dart';
import 'package:my_movie_search/persistence/session_nav_tree.dart';
import 'package:my_movie_search/utilities/navigation/route_info.dart';

void main() {
  RouteInfo createRoute(ScreenRoute path, String reference, String description) {
    return RouteInfo(path, {}, reference, description);
  }

  group('SessionNavTree', () {
    late SessionNavTree navTree;

    setUp(() {
      navTree = SessionNavTree();
    });

    test('Initial state is empty', () {
      expect(navTree.roots, isEmpty);
    });

    test('logPageOpen with root adds a new root', () {
      navTree.logPageOpen(createRoute(ScreenRoute.search, NavLog.rootReference, 'dummy home'));
      expect(navTree.roots, hasLength(1));
      expect(navTree.roots.first.route.routePath, ScreenRoute.search);
      expect(navTree.roots.first.route.reference, NavLog.rootReference);
      expect(navTree.roots.first.children, isEmpty);
    });

    test('logPageOpen without root creates child of active node', () {
      navTree
        ..logPageOpen(createRoute(ScreenRoute.search, NavLog.rootReference, 'dummy home'))
        ..logPageOpen(createRoute(ScreenRoute.moviedetails, 'item_1', 'dummy details'));

      expect(navTree.roots, hasLength(1));
      expect(navTree.roots.first.children, hasLength(1));
      expect(navTree.roots.first.children.first.route.routePath, ScreenRoute.moviedetails);
      expect(navTree.roots.first.children.first.route.reference, 'item_1');
    });

    test('logPageClose removes active node correctly', () {
      navTree
        ..logPageOpen(createRoute(ScreenRoute.search, NavLog.rootReference, 'dummy home'))
        ..logPageOpen(createRoute(ScreenRoute.moviedetails, 'item_1', 'dummy details'))
        ..logPageClose(createRoute(ScreenRoute.moviedetails, 'item_1', ''))
        ..logPageOpen(createRoute(ScreenRoute.persondetails, 'item_2', 'dummy details 2'));

      // The new page should be a child of 'home', not 'details'.
      expect(navTree.roots.first.children, hasLength(2));
      expect(navTree.roots.first.children.last.route.routePath, ScreenRoute.persondetails);
    });

    test('logPageClose ignores mismatched pop', () {
      navTree
        ..logPageOpen(createRoute(ScreenRoute.search, NavLog.rootReference, 'dummy home'))
        ..logPageOpen(createRoute(ScreenRoute.moviedetails, 'item_1', 'dummy details'))
        // Mismatched pop
        ..logPageClose(createRoute(ScreenRoute.errordetails, 'item_x', ''))
        ..logPageOpen(createRoute(ScreenRoute.persondetails, 'item_2', 'dummy details 2'));

      // It should still be a child of 'details' because pop failed
      expect(navTree.roots.first.children.first.children, hasLength(1));
      expect(
        navTree.roots.first.children.first.children.first.route.routePath,
        ScreenRoute.persondetails,
      );
    });

    test('new root clears active stack', () {
      navTree
        ..logPageOpen(createRoute(ScreenRoute.search, NavLog.rootReference, 'dummy home'))
        ..logPageOpen(createRoute(ScreenRoute.moviedetails, 'item_1', 'dummy details'))
        // New root
        ..logPageOpen(createRoute(ScreenRoute.about, NavLog.rootReference, 'dummy settings'));

      expect(navTree.roots, hasLength(2));

      navTree.logPageOpen(createRoute(ScreenRoute.changelog, 'item_2', 'dummy settings detail'));

      expect(navTree.roots.last.children, hasLength(1));
      expect(navTree.roots.last.children.first.route.routePath, ScreenRoute.changelog);
    });
  });
}
