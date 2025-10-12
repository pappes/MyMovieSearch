import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/imdb_sha_extractor.dart';

// This function type abstracts the creation of the HttpClient, making it mockable.
typedef HttpClientFactory = HttpClient Function();
typedef WebViewRunner =
    Future<void> Function({
      required Uri initialUrl,
      required Future<WebResourceResponse?> Function(
        InAppWebViewController,
        WebResourceRequest,
      )?
      shouldInterceptRequest,
      required void Function(InAppWebViewController, WebUri?) onLoadStop,
      required void Function(InAppWebViewController, LoadedResource)
      onLoadResource,
    });

Future<void> defaultWebViewRunner({
  required Uri initialUrl,
  required Future<WebResourceResponse?> Function(
    InAppWebViewController,
    WebResourceRequest,
  )?
  shouldInterceptRequest,
  required void Function(InAppWebViewController, WebUri?) onLoadStop,
  required void Function(InAppWebViewController, LoadedResource) onLoadResource,
}) async {
  final headlessWebView = HeadlessInAppWebView(
    initialUrlRequest: URLRequest(url: WebUri.uri(initialUrl)),
    shouldInterceptRequest: shouldInterceptRequest,
    onLoadStop: onLoadStop,
    onLoadResource: onLoadResource,
  );
  await headlessWebView.run();
}

class WebPageShaExtractorAndroid extends IMDBShaExtractor {
  WebPageShaExtractorAndroid.internal(
    super.imdbShaMap,
    super.imdbUrlMap,
    super.imdbSource, {
    HttpClientFactory httpClientFactory = HttpClient.new,
    WebViewRunner webViewRunner = defaultWebViewRunner,
  }) : _httpClientFactory = httpClientFactory,
       _webViewRunner = webViewRunner,
       super.internal();

  final HttpClientFactory _httpClientFactory; // Injected dependency
  final WebViewRunner _webViewRunner;
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
    await _webViewRunner(
      initialUrl: webAddress,
      shouldInterceptRequest: _handleIntercept,
      onLoadStop: _clickOnElement,
      onLoadResource: _searchForSha,
    );

    await _waitForSha.future; // Wait until the SHA is found.
    // Note: Disposing the webview would now need to be handled within the runner
    // or by returning the instance from the runner. For simplicity, this is omitted.
  }

  Future<WebResourceResponse?> executeInterceptFlowForTest(
    InAppWebViewController controller,
    WebResourceRequest request,
  ) async => _handleIntercept(controller, request);

  /// Handles the interception of specific URL requests (e.g., /api/)
  /// and proxies them through a Dart HttpClient to allow for manipulation
  /// or inspection, returning the result to the WebView.
  ///
  /// This method is private as it is intended only to be called by the WebView.
  Future<WebResourceResponse?> _handleIntercept(
    InAppWebViewController controller,
    WebResourceRequest request,
  ) async {
    final decision = getInterceptionDecision(
      request.url.toString(),
      request.method,
    );

    switch (decision.action) {
      case InterceptionAction.syntheticResponse:
        // Translate SyntheticDecision into WebResourceResponse
        return WebResourceResponse(
          statusCode: decision.statusCode,
          contentType: decision.contentType,
          data: decision.body,
        );

      case InterceptionAction.delegateRequest:
        return null;

      case InterceptionAction.executeRequest:
        final HttpClientResponse response = await _executeProxyRequest(request);
        return transferResponseData(response);
    }
  }

  /// Executes the proxy request using the injected HttpClient factory.
  /// This helper encapsulates the networking aspect of the interception flow.
  Future<HttpClientResponse> _executeProxyRequest(
    WebResourceRequest request,
  ) async {
    final client = _httpClientFactory();
    final uri = request.url.uriValue;
    final dartRequest = await client.openUrl(request.method ?? 'GET', uri);

    transferRequestData(request, dartRequest);

    return dartRequest.close();
  }

  /// Processes the [HttpClientResponse]
  /// into a [WebResourceResponse] for the WebView.
  Future<WebResourceResponse> transferResponseData(
    HttpClientResponse response,
  ) async {
    // Read the full response body stream and convert it into a Uint8List.
    final bodyBytes = await response
        .fold<List<int>>(
          <int>[],
          (previous, element) => previous..addAll(element),
        )
        .then(Uint8List.fromList);

    // Replicate all response headers, including 'Set-Cookie'
    final responseHeaders = <String, String>{};
    response.headers.forEach((name, values) {
      responseHeaders[name] = values.join(', ');
    });

    return WebResourceResponse(
      contentType: response.headers.contentType?.mimeType ?? 'application/json',
      contentEncoding: response.headers.contentType?.charset ?? 'utf-8',
      statusCode: response.statusCode,
      headers: responseHeaders,
      data: bodyBytes,
    );
  }

  /// Transfers headers from the [WebResourceRequest] to [HttpClientRequest].
  static void transferRequestData(
    WebResourceRequest request,
    HttpClientRequest dartRequest,
  ) {
    final skipHeaders = [
      'content-length',
      'host',
      'connection',
      'accept-encoding',
    ];

    request.headers?.forEach((name, value) {
      if (!skipHeaders.contains(name.toLowerCase())) {
        dartRequest.headers.set(name, value);
      }
    });
  }
}
