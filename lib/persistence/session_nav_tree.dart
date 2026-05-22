import 'package:flutter/material.dart';
import 'package:my_movie_search/persistence/nav_log.dart';
import 'package:my_movie_search/utilities/navigation/route_info.dart';

class NavTreeNode {
  NavTreeNode({required this.route, required this.timestamp});

  final RouteInfo route;
  final DateTime timestamp;
  final List<NavTreeNode> children = [];
}

class SessionNavTree extends ChangeNotifier {
  final List<NavTreeNode> roots = [];
  final List<NavTreeNode> _activeStack = [];

  void logPageOpen(RouteInfo route) {
    final node = NavTreeNode(route: route, timestamp: DateTime.now());

    if (isRoot(route.reference, _activeStack)) {
      roots.add(node);
      _activeStack
        ..clear()
        ..add(node);
    } else {
      _activeStack.last.children.add(node);
      _activeStack.add(node);
    }
    notifyListeners();
  }

  void logPageClose(RouteInfo route) {
    if (_activeStack.isNotEmpty) {
      final last = _activeStack.last;
      // Only pop if the closing page matches the active top of stack.
      // This protects against async pops happening after a new root is pushed.
      if (last.route.routePath.name == route.routePath.name &&
          last.route.reference == route.reference) {
        _activeStack.removeLast();
        notifyListeners();
      }
    }
  }

  bool isRoot(String reference, List<NavTreeNode> activeStack) =>
      reference == NavLog.rootReference || activeStack.isEmpty;
}
