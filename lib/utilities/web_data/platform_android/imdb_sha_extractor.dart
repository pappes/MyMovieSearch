import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/imdb_sha_extractor.dart';

class WebPageShaExtractorAndroid extends IMDBShaExtractor {
  WebPageShaExtractorAndroid.internal(
    super.imdbShaMap,
    super.imdbUrlMap,
    super.imdbSource,
  ) : super.internal();

  final _waitForSha = Completer<void>();

  // Load the data from IMDB and capture the sha used.
  @override
  Future<void> updateSha() async {
    final imdbAddress = getImdbAddress();
    if (imdbAddress != null) {
      print('Loading IMDB page $imdbAddress to extract sha for $imdbSource');
      await _observeWebView(imdbAddress);
    }
  }

  // Click on the "See all" button or "Previous" accordion to load the sha.
  // This is needed because the sha is not available until the list is expanded.
  void _clickOnElement(InAppWebViewController controller, WebUri? url) {
    if (imdbSource == ImdbJsonSource.credits) {
      // For credits, we need to click on the "Costume Department" button.
      unawaited(
        controller.evaluateJavascript(source: getClickOnCostumeDepartment()),
      );
    } else {
      // For other sources, we need to click on the "See all" button.
      unawaited(controller.evaluateJavascript(source: getClickOnSeeAll()));
    }
    print('Clicked on element to expand list for $imdbSource');
  }

  // Check if the sha value has changed and update the map if so.
  void _searchForSha(
    InAppWebViewController controller,
    LoadedResource resource,
  ) {
    final newSha = extractShaFromWebText(resource.url.toString());
    if (resource.url.toString().contains('sha256Hash')) {
      print('Loaded resource: ${resource.url}, extracted sha: $newSha');
      final newSha2 = extractShaFromWebText(resource.url.toString());
    }
    if (setShaValue(newSha)) {
      print('Updated sha for $imdbSource to $newSha');
      // Once we have the SHA, we can stop and dispose.
      if (!_waitForSha.isCompleted) {
        _waitForSha.complete();
      }
    }
  }

  // Initialize the web view with the given [webAddress].
  Future<void> _observeWebView(Uri webAddress) async {
    final headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri.uri(webAddress)),
      // Once the page is loaded, we can click the element.
      onLoadStop: _clickOnElement,
      // Monitor all resources loaded to find the sha.
      onLoadResource: _searchForSha,
    );
    await headlessWebView.run();
    await _waitForSha.future; // Wait until the SHA is found.
    await headlessWebView.dispose();
  }
}
