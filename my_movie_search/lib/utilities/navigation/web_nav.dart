import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:my_movie_search/movies/screens/popup.dart';

void _launchURL(String url, BuildContext context) async {
  try {
    await launch(
      url,
      customTabsOption: CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

void viewWebPage(String url, BuildContext context) {
  if (Platform.isAndroid) {
    _launchURL(
      url,
      context,
    );
  } else {
    showPopup(context, url);
  }
}
