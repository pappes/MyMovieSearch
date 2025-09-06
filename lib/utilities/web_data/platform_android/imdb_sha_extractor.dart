import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/imdb_sha_extractor.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageShaExtractorAndroid extends IMDBShaExtractor {
  WebPageShaExtractorAndroid.internal(super.imdbShaMap, super.imdbSource)
    : super.internal();

  final _imdbPerson = WebViewController();

  // Load the data from IMDB and capture the sha used.
  @override
  Future<void> updateSha() async {
    final imdbAddress = getImdbAddress();
    if (imdbAddress != null) {
      await _initWebView(imdbAddress);
      _clickOnElement(imdbSource);
    }
  }

  // Click on the "See all" button or "Previous" accordion to load the sha.
  // This is needed because the sha is not available until the list is expanded.
  void _clickOnElement(ImdbJsonSource source) {
    final element = _getPageElementSelector(source);
    if (element != null) {
      final js = 'document.querySelector("$element").click();';
      unawaited(_imdbPerson.runJavaScript(js));
    }
  }

  // Get the CSS selector for the page element to click on.
  String? _getPageElementSelector(ImdbJsonSource source) => switch (source) {
    ImdbJsonSource.actor => '#actor-previous-projects',
    ImdbJsonSource.actress =>
      '#accordion-item-actress-previous-projects > div > div > span > button',
    ImdbJsonSource.director => '#director-previous-projects',
    ImdbJsonSource.producer => '#producer-previous-projects',
    ImdbJsonSource.writer =>
      '#accordion-item-writer-previous-projects > div > div > span > button',
  };

  // Initialize the web view with the given [webAddress].
  Future<void> _initWebView(Uri webAddress) async {
    final delegate = NavigationDelegate(
      onNavigationRequest: _interceptWebRequest,
    );
    await _imdbPerson.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _imdbPerson.setNavigationDelegate(delegate);
    return _imdbPerson.loadRequest(webAddress);
  }

  // Intercept the web request to extract the sha.
  NavigationDecision _interceptWebRequest(NavigationRequest request) {
    // Intercept the web request to extract the sha.
    debugPrint('Observing resource request to: ${request.url}');
    final newSha = extractShaFromWebText(request.url);
    setShaValue(newSha);
    return NavigationDecision.navigate; // Allow the request to proceed.
  }
}
