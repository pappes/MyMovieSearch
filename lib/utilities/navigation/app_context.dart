import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;

/// An abstraction for navigation to make testing easier.
abstract class AppNavigator {
  Future<T?> pushNamed<T extends Object?>(String name, {Object? extra});
  void pushReplacementNamed<T extends Object?>(String name, {Object? extra});
  bool pop<T extends Object?>([T? result]);
}

/// An abstraction for theme access to make testing easier.
// ignore: one_member_abstracts
abstract class AppTheme {
  Color? getPrimaryColor();
}

/// An abstraction for dialogs to make testing easier.
// ignore: one_member_abstracts
abstract class AppDialogs {
  Future<Object?> popup(String dialogText, String title);
}

/// An abstraction for focus management to make testing easier.
// ignore: one_member_abstracts
abstract class AppFocus {
  FocusNode? primaryFocus();
}

/// An abstraction for launching custom tabs to make testing easier.
// ignore: one_member_abstracts
abstract class CustomTabsLauncher {
  Future<void> launch(String url, {tabs.CustomTabsOptions? customTabsOptions});
}
