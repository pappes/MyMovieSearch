import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebCustomTabsPage extends StatefulWidget {
  WebCustomTabsPage({required String url}) : _url = url;

  String _url;
  @override
  _WebCustomTabsPageState createState() => _WebCustomTabsPageState();
}

class _WebCustomTabsPageState extends State<WebCustomTabsPage> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget._url,
    );
  }
}
