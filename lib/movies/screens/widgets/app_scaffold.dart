import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/screens/widgets/snack_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBar,
    endDrawer: getDrawer(context),
    drawerEnableOpenDragGesture: false,
    body: body,
    floatingActionButton: floatingActionButton,
  );
}
