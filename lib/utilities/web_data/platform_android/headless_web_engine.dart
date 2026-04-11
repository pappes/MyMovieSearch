import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:meta/meta.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';

import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/headless_web_interceptor.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';


/// This function type abstracts the creation of the HttpClient,
/// making it mockable.
typedef HttpClientFactory = HttpClient Function();

/// This function type defines the interceptor for WebView resource requests.
typedef Proxyselector =
    Future<WebResourceResponse?> Function(
      InAppWebViewController,
      WebResourceRequest,
    )?;

/// This function type abstracts the running of the WebView, making it mockable.
typedef WebViewFactory =
    HeadlessInAppWebView Function({
      required String initialUrl,
      required Proxyselector proxySelector,
      required void Function(InAppWebViewController, WebUri?) onLoadStop,
      required void Function(
        InAppWebViewController,
        WebResourceRequest,
        WebResourceError,
      )
      onReceivedError,
    });

/// Default implementation of the WebView using HeadlessInAppWebView.
HeadlessInAppWebView defaultWebView({
  required String initialUrl,
  required Proxyselector proxySelector,
  required void Function(InAppWebViewController, WebUri?) onLoadStop,
  required void Function(
    InAppWebViewController,
    WebResourceRequest,
    WebResourceError,
  )
  onReceivedError,
}) {
  final settings = InAppWebViewSettings(
    // 1. Core JS execution
    // javaScriptEnabled: true,

    // 2. Crucial: AWS WAF stores tokens/state in DOM Storage
    // domStorageEnabled: true,

    // 3. Allows the script to handle its own redirects/reloads
    javaScriptCanOpenWindowsAutomatically: true,

    // 4. Important for Android to handle the challenge correctly
    safeBrowsingEnabled: false,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,

    // 5. User-Agent: Sometimes AWS blocks default WebView agents
    // Try setting a standard mobile browser string if it still fails
    userAgent:
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/146.0.0.0 Safari/537.36',
  );
  return HeadlessInAppWebView(
    initialSettings: settings,
    initialUrlRequest: URLRequest(
      url: WebUri(initialUrl),
      cachePolicy:
          URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA,
    ),
    shouldInterceptRequest: proxySelector,
    onLoadStop: onLoadStop,
    onReceivedError: onReceivedError,
  );
}

/// Implementation of `HeadlessWebEngine` for Android using `InAppWebView`.
class HeadlessWebEngineAndroid extends HeadlessWebEngineBase {
  HeadlessWebEngineAndroid({
    HttpClientFactory httpClientFactory = HttpClient.new,
    WebViewFactory webViewRunner = defaultWebView,
  }) : _httpClientFactory = httpClientFactory,
       _webViewRunner = webViewRunner;

  final HttpClientFactory _httpClientFactory;
  final WebViewFactory _webViewRunner;
  HeadlessInAppWebView? _headlessWebView;
  final HeadlessWebInterceptor _interceptor = HeadlessWebInterceptor();

  /// Runs the headless web engine to extract data from a web page.
  ///
  /// [url] The URL of the web page to extract data from.
  /// [urlInterceptFilter] The filter for choosing JSON data
  ///   to be passed to onEngineData.
  ///   Any resource request url containing this string will be intercepted.
  ///   If empty, no urls will be intercepted.
  /// [onEngineData] A callback function to process the main html page
  ///                and extracted JSON data.
  /// [onPageLoaded] A callback function to process the page complete event.
  ///                This is called multiple times in the case of redirects.
  @override
  @awaitNotRequired
  Future<int> run({
    required String url,
    required String urlInterceptFilter,
    required DataCallback onEngineData,
    PageLoadCallback? onPageLoaded,
  }) async {
    await super.run(
      url: url,
      urlInterceptFilter: urlInterceptFilter,
      onEngineData: onEngineData,
      onPageLoaded: onPageLoaded,
    );

    _headlessWebView = _webViewRunner(
      initialUrl: url,
      proxySelector: webViewProxySelector,
      onLoadStop: _loadStopped,
      onReceivedError: _onReceivedError,
    );
    resetTimeout();

    await _headlessWebView!.run();
    await dataLoadedCompleter.future;
    return httpStatusCode ?? HttpStatus.processing;
  }

  /// Executes a JavaScript script in the headless web engine.
  ///
  /// [script] The JavaScript script to execute.
  @override
  Future<dynamic> evaluateJavascript(String script) async {
    if (_headlessWebView == null || !_headlessWebView!.isRunning()) return null;
    return await _headlessWebView!.webViewController?.evaluateJavascript(
      source: script,
    );
  }

  /// Disposes the headless web page.
  @override
  Future<void> closePage() {
    final webView = _headlessWebView;
    if (webView != null) {
      _headlessWebView = null;
      return webView.dispose();
    }
    return Future.value();
  }

  /// Disposes the headless web engine.
  @override
  Future<void> closeEngine() async {
    await closePage();
  }

  /// Returns the html content of the page.
  @override
  Future<String?> getPageContent() async =>
      _headlessWebView?.webViewController?.getHtml();

  // void return signature required
  // so that it can be used as a callback for the WebView.
  void _loadStopped(_, _) => unawaited(pageLoadComplete());

  /// Handles the interception of specific URL requests (e.g., /api/)
  /// and proxies them through a Dart HttpClient to allow for manipulation
  /// or inspection, returning the result to the WebView.
  Future<WebResourceResponse?> webViewProxySelector(
    InAppWebViewController controller,
    WebResourceRequest request,
  ) async {
    final response = await _interceptor.shouldProxyUrl(
      request.url,
      request.method,
      _getHttpRequest,
      request.headers ?? {},
      urlProxyFilter,
    );
    switch (response.decision.action) {
      case InterceptionAction.syntheticResponse:
        return WebResourceResponse(
          statusCode: response.decision.statusCode,
          contentType: response.decision.contentType,
          data: response.decision.body,
        );
      case InterceptionAction.delegateRequest:
        return null;
      case InterceptionAction.executeRequest:
        return transferResponseData(request, response.httpResponse!);
    }
  }

  /// Executes the proxy request using the injected HttpClient factory.
  /// This helper encapsulates the networking aspect of the interception flow.
  Future<HttpClientRequest> _getHttpRequest(Uri url, String method) {
    final client = _httpClientFactory();
    return client.openUrl(method, url);
  }

  /// Processes the [HttpClientResponse]
  /// into a [WebResourceResponse] for the WebView.
  Future<WebResourceResponse> transferResponseData(
    WebResourceRequest request,
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
    final responseHeaders = response.headers.toMap();

    final contentType = response.headers.contentType?.mimeType;
    if (contentType == 'application/json' || contentType == 'text/html') {
      onEngineData(String.fromCharCodes(bodyBytes));
    }

    return WebResourceResponse(
      contentType: contentType ?? 'application/json',
      contentEncoding: response.headers.contentType?.charset ?? 'utf-8',
      statusCode: response.statusCode,
      headers: responseHeaders,
      data: bodyBytes,
    );
  }

  /// Handles errors received during page loading.
  void _onReceivedError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  ) {
    logger.e(
      'Error loading headless page: ${error.description.truncate(100)}'
      'for ${request.url}',
    );
    if (httpStatusCode == null || httpStatusCode == HttpStatus.ok) {
      httpStatusCode = HttpStatus.badRequest;
    }
  }
}
