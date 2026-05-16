import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_movie_search/movies/screens/widgets/app_scaffold.dart';
import 'package:my_movie_search/persistence/session_nav_tree.dart';
import 'package:provider/provider.dart';

class NavigationHistoryPage extends StatelessWidget {
  const NavigationHistoryPage({super.key});

  static MaterialPage<dynamic> goRoute(_, _) => const MaterialPage(
    restorationId: 'NavigationHistoryPage',
    child: NavigationHistoryPage(),
  );

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

        // We reverse the roots to show most recent at the top
        return CustomScrollView(
          slivers: navTree.roots.reversed
              .map((root) => _buildNode(context, root, 0))
              .toList(),
        );
      },
    ),
  );

  Widget _buildNode(BuildContext context, NavTreeNode node, int depth) {
    if (node.children.isEmpty) {
      return SliverToBoxAdapter(child: _buildTile(context, node, depth));
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeaderDelegate(
            minHeight: 64.0,
            maxHeight: 64.0,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              elevation: depth == 0 ? 2 : 1,
              child: _buildTile(context, node, depth),
            ),
          ),
        ),
        // Reverse children to show most recent child at top
        ...node.children.reversed.map(
          (child) => _buildNode(context, child, depth + 1),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, NavTreeNode node, int depth) {
    final timeFormat = DateFormat.Hms().format(node.timestamp);
    return Padding(
      padding: EdgeInsets.only(left: 16.0 * depth),
      child: ListTile(
        title: Text(node.destination),
        subtitle: Text(node.description),
        trailing: Text(
          timeFormat,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) =>
      maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
}
