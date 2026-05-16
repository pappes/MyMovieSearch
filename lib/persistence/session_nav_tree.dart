import 'package:flutter/material.dart';
import 'package:my_movie_search/persistence/nav_log.dart';

class NavTreeNode {
  NavTreeNode({
    required this.destination,
    required this.reference,
    required this.timestamp,
  });

  final String destination;
  final String reference;
  final DateTime timestamp;
  final List<NavTreeNode> children = [];
}

class SessionNavTree extends ChangeNotifier {
  final List<NavTreeNode> roots = [];
  final List<NavTreeNode> _activeStack = [];

  void logPageOpen(String destination, String reference) {
    final node = NavTreeNode(
      destination: destination,
      reference: reference,
      timestamp: DateTime.now(),
    );

    if (isRoot(reference, _activeStack)) {
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

  void logPageClose(String destination, String reference) {
    if (_activeStack.isNotEmpty) {
      final last = _activeStack.last;
      // Only pop if the closing page matches the active top of stack.
      // This protects against async pops happening after a new root is pushed.
      if (last.destination == destination && last.reference == reference) {
        _activeStack.removeLast();
        notifyListeners();
      }
    }
  }

  bool isRoot(String reference, List<NavTreeNode> activeStack) =>
      reference == NavLog.rootReference || activeStack.isEmpty;
}
