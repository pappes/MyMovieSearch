import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/persistence/nav_log.dart';
import 'package:my_movie_search/persistence/session_nav_tree.dart';

void main() {
  group('SessionNavTree', () {
    late SessionNavTree navTree;

    setUp(() {
      navTree = SessionNavTree();
    });

    test('Initial state is empty', () {
      expect(navTree.roots, isEmpty);
    });

    test('logPageOpen with root adds a new root', () {
      navTree.logPageOpen('home', NavLog.rootReference);
      expect(navTree.roots, hasLength(1));
      expect(navTree.roots.first.destination, 'home');
      expect(navTree.roots.first.reference, NavLog.rootReference);
      expect(navTree.roots.first.children, isEmpty);
    });

    test('logPageOpen without root creates child of active node', () {
      navTree
        ..logPageOpen('home', NavLog.rootReference)
        ..logPageOpen('details', 'item_1');

      expect(navTree.roots, hasLength(1));
      expect(navTree.roots.first.children, hasLength(1));
      expect(navTree.roots.first.children.first.destination, 'details');
      expect(navTree.roots.first.children.first.reference, 'item_1');
    });

    test('logPageClose removes active node correctly', () {
      navTree
        ..logPageOpen('home', NavLog.rootReference)
        ..logPageOpen('details', 'item_1')
        ..logPageClose('details', 'item_1')
        ..logPageOpen('details2', 'item_2');

      // The new page should be a child of 'home', not 'details'.
      expect(navTree.roots.first.children, hasLength(2));
      expect(navTree.roots.first.children.last.destination, 'details2');
    });

    test('logPageClose ignores mismatched pop', () {
      navTree
        ..logPageOpen('home', NavLog.rootReference)
        ..logPageOpen('details', 'item_1')
        // Mismatched pop
        ..logPageClose('wrong', 'item_x')
        ..logPageOpen('details2', 'item_2');

      // It should still be a child of 'details' because pop failed
      expect(navTree.roots.first.children.first.children, hasLength(1));
      expect(
        navTree.roots.first.children.first.children.first.destination,
        'details2',
      );
    });

    test('new root clears active stack', () {
      navTree
        ..logPageOpen('home', NavLog.rootReference)
        ..logPageOpen('details', 'item_1')
        // New root
        ..logPageOpen('settings', NavLog.rootReference);

      expect(navTree.roots, hasLength(2));

      navTree.logPageOpen('settings_detail', 'item_2');

      expect(navTree.roots.last.children, hasLength(1));
      expect(navTree.roots.last.children.first.destination, 'settings_detail');
    });
  });
}
