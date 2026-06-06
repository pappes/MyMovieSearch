import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_movie_search/movies/screens/widgets/app_scaffold.dart';
import 'package:my_movie_search/persistence/session_nav_tree.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:provider/provider.dart';

class NavigationHistoryPage extends StatefulWidget {
  const NavigationHistoryPage({super.key});

  static MaterialPage<Object?> goRoute(_, _) => const MaterialPage(
    restorationId: 'NavigationHistoryPage',
    child: NavigationHistoryPage(),
  );

  @override
  State<NavigationHistoryPage> createState() => _NavigationHistoryPageState();
}

class FlatNode {
  FlatNode({required this.node, required this.depth, required this.path});

  final NavTreeNode node;
  final int depth;
  final List<NavTreeNode> path;
}

class _NavigationHistoryPageState extends State<NavigationHistoryPage> {
  late final ScrollController _scrollController;
  List<FlatNode> _flatNodes = [];
  List<NavTreeNode> _lastActiveParents = [];

  int _scrollBottomAttempts = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!mounted || !_scrollController.hasClients) return;

    final maxExtent = _scrollController.position.maxScrollExtent;

    // Stop if we're at the bottom, or if we've tried too many times
    // (prevents infinite layout loops)
    if ((_scrollController.offset - maxExtent).abs() < 1.0 ||
        _scrollBottomAttempts > 3) {
      return;
    }

    _scrollBottomAttempts++;
    _scrollController.jumpTo(maxExtent);

    // Since jumping changes the top index,
    // it might change the dynamic size of the Parents Section.
    // This changes the maxScrollExtent, so we loop until it settles.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Listens to scroll events,
  ///  calculates the top visible row using the 72px itemExtent,
  /// and updates the active parents if they have changed.
  void _onScroll() {
    if (!_scrollController.hasClients || _flatNodes.isEmpty) return;

    final offset = math.max(0, _scrollController.offset);
    final topIndex = (offset / 72.0).floor().clamp(0, _flatNodes.length - 1);

    final topNode = _flatNodes[topIndex];
    final activePath = topNode.path;
    final startIndex = math.max(0, activePath.length - 5);
    final activeParents = activePath.skip(startIndex).toList();

    if (!_parentsEqual(_lastActiveParents, activeParents)) {
      setState(() {
        _lastActiveParents = activeParents;
      });
    }
  }

  bool _parentsEqual(List<NavTreeNode> a, List<NavTreeNode> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Flattens the hierarchical session navigation tree into a 1D list
  /// while preserving depth and parent path information.
  List<FlatNode> _flattenTree(List<NavTreeNode> roots) {
    final list = <FlatNode>[];
    void traverse(List<NavTreeNode> nodes, int depth, List<NavTreeNode> path) {
      for (final node in nodes) {
        list.add(FlatNode(node: node, depth: depth, path: path));
        final childPath = List<NavTreeNode>.from(path)..add(node);
        traverse(node.children, depth + 1, childPath);
      }
    }

    traverse(roots, 0, []);
    return list;
  }

  int _getTopIndex() {
    if (!_scrollController.hasClients) return 0;
    final offset = math.max(0, _scrollController.offset);
    return (offset / 72.0).floor().clamp(0, math.max(0, _flatNodes.length - 1));
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    appBar: AppBar(
      title: const Text('Navigation History'),
      leading: BackButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
      ),
    ),
    body: Consumer<SessionNavTree>(
      builder: (context, navTree, child) {
        if (navTree.roots.isEmpty) {
          return const Center(child: Text('No navigation history yet.'));
        }

        // Rebuild the flat representation of the tree
        _flatNodes = _flattenTree(navTree.roots);

        // Calculate the active parents based on the current scroll position
        final topIndex = _getTopIndex();
        final topNode = _flatNodes.isNotEmpty ? _flatNodes[topIndex] : null;
        final activePath = topNode?.path ?? [];
        final startIndex = math.max(0, activePath.length - 5);
        final activeParents = activePath.skip(startIndex).toList();

        // Update tracking variable quietly
        _lastActiveParents = activeParents;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildParentsSection(context, activeParents, startIndex),
            _buildNonParentsSection(context),
          ],
        );
      },
    ),
  );

  /// Builds the top reserved area displaying the 5 most recent parents
  /// of the currently visible row in the list below.
  Widget _buildParentsSection(
    BuildContext context,
    List<NavTreeNode> parents,
    int startIndex,
  ) {
    if (parents.isEmpty) return const SizedBox.shrink();

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: parents.asMap().entries.map((entry) {
          final depth = startIndex + entry.key;
          return _buildTile(context, entry.value, depth, isHeader: true);
        }).toList(),
      ),
    );
  }

  /// Builds the bottom scrollable area
  ///  containing the full flattened navigation history.
  Widget _buildNonParentsSection(BuildContext context) => Expanded(
    child: ListView.builder(
      controller: _scrollController,
      itemExtent: 72,
      itemCount: _flatNodes.length,
      itemBuilder: (context, index) {
        final flatNode = _flatNodes[index];
        return _buildTile(
          context,
          flatNode.node,
          flatNode.depth,
          isHeader: false,
        );
      },
    ),
  );

  Widget _buildTile(
    BuildContext context,
    NavTreeNode node,
    int depth, {
    required bool isHeader,
  }) {
    final timeFormat = DateFormat.Hms().format(node.timestamp);
    return SizedBox(
      height: 72,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0 * depth),
        child: ListTile(
          onTap: () async {
            await MMSNav(context).canvas.viewFlutterPage(node.route);
          },
          title: Text(
            node.route.routePath.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: isHeader
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
          subtitle: Text(
            node.route.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            timeFormat,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
