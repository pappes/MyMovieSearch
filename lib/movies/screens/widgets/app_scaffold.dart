import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/screens/widgets/snack_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBar,
    endDrawer: getDrawer(context),
    drawerEnableOpenDragGesture: false,
    endDrawerEnableOpenDragGesture: false,
    body: body,
    floatingActionButton: floatingActionButton,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
  );
}
