import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/screens/popup.dart';
import 'package:my_movie_search/utilities/navigation/app_context.dart';

/// A concrete implementation of the app context interfaces that uses
/// the go_router extension method on BuildContext and other Flutter services.
class FlutterAppContext 
    implements AppNavigator, AppTheme, AppDialogs, AppFocus {
  FlutterAppContext(this.context);
  final BuildContext context;

  @override
  Future<T?> pushNamed<T extends Object?>(String name, {Object? extra}) =>
      context.mounted
          ? context.pushNamed(name, extra: extra)
          : Future.value(null);
  @override
  void pushReplacementNamed<T extends Object?>(String name, {Object? extra}) =>
      context.mounted
          ? context.pushReplacementNamed(name, extra: extra)
          : null;
  @override
  bool pop<T extends Object?>([T? result]) {
    if (context.mounted && context.canPop()) {
      context.pop(result);
      return true;
    }
    return false;
  }

  @override
  Color? getPrimaryColor() =>
      context.mounted ? Theme.of(context).primaryColor : null;

  @override
  Future<Object?> popup(
    String dialogText,
    String title,
  ) =>
      context.mounted ? 
         showPopup(context, dialogText, title) : 
         Future.value(null);

  @override
  FocusNode? primaryFocus() => FocusManager.instance.primaryFocus;
}

/// A concrete implementation of the CustomTabsLauncher that uses the
/// flutter_custom_tabs package.
class FlutterCustomTabsLauncher implements CustomTabsLauncher {
  @override
  Future<void> launch(String url, {
    tabs.CustomTabsOptions? customTabsOptions}
  ) async => tabs.launchUrl(
      Uri.parse(url),
      customTabsOptions: customTabsOptions
      );
}
