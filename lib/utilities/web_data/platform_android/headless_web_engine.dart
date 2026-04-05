import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:meta/meta.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';

import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/http_method.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

const _timeoutDurationFull = Duration(seconds: 15);
const _timeoutDurationShort = Duration(seconds: 10);
const _timeoutDurationVeryShort = Duration(seconds: 3);
const _timeoutDurationMicroSleep = Duration(milliseconds: 50);

/// This function type abstracts the creation of the HttpClient,
/// making it mockable.
typedef HttpClientFactory = HttpClient Function();

/// This function type defines the interceptor for WebView resource requests.
typedef WebResourceInterceptor =
    Future<WebResourceResponse?> Function(
      InAppWebViewController,
      WebResourceRequest,
    )?;

/// This function type abstracts the running of the WebView, making it mockable.
typedef WebViewFactory =
    HeadlessInAppWebView Function({
      required String initialUrl,
      required WebResourceInterceptor proxySelector,
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
  required WebResourceInterceptor proxySelector,
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

/// Defines the three possible outcomes of an interception request,
enum InterceptionAction { delegateRequest, syntheticResponse, executeRequest }

/// Represents the interception decision made by the orchestration layer.
class InterceptionDecision {
  InterceptionDecision.delegateRequest()
    : action = InterceptionAction.delegateRequest,
      statusCode = null,
      contentType = null,
      body = null;
  InterceptionDecision.executeRequest()
    : action = InterceptionAction.executeRequest,
      statusCode = null,
      contentType = null,
      body = null;
  InterceptionDecision.syntheticResponse({
    required this.statusCode,
    required this.contentType,
    required this.body,
  }) : action = InterceptionAction.syntheticResponse;

  final InterceptionAction action;
  final int? statusCode;
  final String? contentType;
  final Uint8List? body;
}

/// Implementation of [HeadlessWebEngine] for Android using [InAppWebView].
class HeadlessWebEngineAndroid implements HeadlessWebEngine {
  HeadlessWebEngineAndroid({
    HttpClientFactory httpClientFactory = HttpClient.new,
    WebViewFactory webViewRunner = defaultWebView,
  }) : _httpClientFactory = httpClientFactory,
       _webViewRunner = webViewRunner;

  final HttpClientFactory _httpClientFactory;
  final WebViewFactory _webViewRunner;
  HeadlessInAppWebView? _headlessWebView;

  final Completer<void> _dataLoadedCompleter = Completer<void>();
  int pageLoadCompleteCount = 0;
  int? httpStatusCode;
  String? pageContents;
  Timer? _timeoutTimer;

  late DataCallback _onEngineData;
  PageLoadCallback? _onPageLoaded;
  late String _urlProxyFilter;
  String _imdbUrl = '';

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
    _imdbUrl = url;
    _onEngineData = onEngineData;
    _onPageLoaded = onPageLoaded;
    _urlProxyFilter = urlInterceptFilter;

    _headlessWebView = _webViewRunner(
      initialUrl: url,
      proxySelector: _webViewProxySelector,
      onLoadStop: _loadStopped,
      onReceivedError: _onReceivedError,
    );
    resetTimeout();

    await _headlessWebView!.run();
    await _dataLoadedCompleter.future;
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

  /// Disposes the headless web engine after a timeout period.
  ///
  /// [timeoutDuration] The duration to wait before disposing the engine.
  void resetTimeout([Duration timeoutDuration = _timeoutDurationFull]) {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(timeoutDuration, () {
      if (_headlessWebView != null && _headlessWebView!.isRunning()) {
        logger.i(
          'Disposing InAppWebViewController due to timeout for $_imdbUrl',
        );
        dispose();
      }
    });
  }

  /// Disposes the headless web engine and signals that the data is loaded.
  ///
  /// [optionalDelay] optional delay to wait before disposing the engine.
  @override
  @awaitNotRequired
  Future<void> dispose({Duration optionalDelay = Duration.zero}) async {
    _timeoutTimer?.cancel();
    await Future<void>.delayed(optionalDelay);
    final webView = _headlessWebView;
    if (webView != null) {
      _headlessWebView = null;
      await webView.dispose();
    }
    if (!_dataLoadedCompleter.isCompleted) {
      _onEngineData(pageContents ?? 'Unable to get html from HeadlessWebView');
      _dataLoadedCompleter.complete();
    }
    // Allow time for any final requests to complete.
    await Future<void>.delayed(_timeoutDurationMicroSleep);
  }

  /// Handles the completion of a page load.
  ///
  /// Page load can complete multiple times because code is
  /// interacting with the page after the initial load complete.
  // void return signature required
  // so that it can be used as a callback for the WebView.
  // ignore: avoid_void_async
  void _loadStopped(InAppWebViewController controller, WebUri? url) async {
    logger.t('Page load complete for $_imdbUrl');
    httpStatusCode ??= HttpStatus.ok;
    if (_onPageLoaded == null || _headlessWebView == null) {
      dispose();
    } else {
      await _onPageLoaded!();
      final html = await controller.getHtml();
      if (html != null) {
        pageContents = html;
      }
      // Timeout if requests do not complete quickly enough.
      pageLoadCompleteCount++;
      if (pageLoadCompleteCount == 1) {
        logger.t('Page load complete');
        resetTimeout(_timeoutDurationShort);
      } else {
        logger.t('Page load fully complete');
        // Sometimes there is a false positive for page load complete.
        // Delay disposal to allow any final requests to complete.
        resetTimeout(_timeoutDurationVeryShort);
      }
    }
  }

  /// Exposes the private proxy selector for testing purposes.
  Future<WebResourceResponse?> executeProxySelectorForTest(
    InAppWebViewController controller,
    WebResourceRequest request,
  ) => _webViewProxySelector(controller, request);

  /// Handles the interception of specific URL requests (e.g., /api/)
  /// and proxies them through a Dart HttpClient to allow for manipulation
  /// or inspection, returning the result to the WebView.
  ///
  /// This method is private as it is intended only to be called by the WebView.
  //  @implements WebResourceInterceptor
  Future<WebResourceResponse?> _webViewProxySelector(
    InAppWebViewController controller,
    WebResourceRequest request,
  ) async {
    final decision = getInterceptionDecision(
      request.url.toString(),
      request.method,
      acceptHeader: request.headers?['accept'],
    );
    // print('Interception decision: ${decision.action} for ${request.url}');

    switch (decision.action) {
      case InterceptionAction.syntheticResponse:
        return WebResourceResponse(
          statusCode: decision.statusCode,
          contentType: decision.contentType,
          data: decision.body,
        );
      case InterceptionAction.delegateRequest:
        return null;
      case InterceptionAction.executeRequest:
        final response = await _executeProxyRequest(request);
        return transferResponseData(request, response);
    }
  }

  /// Determines the interception decision for a given request.
  InterceptionDecision getInterceptionDecision(
    String url,
    String? method, {
    String? acceptHeader,
  }) {
    if (_discardImageRequests(url, acceptHeader) || _discardAdRequests(url)) {
      // Decision: Block the request with a synthetic 404.
      return InterceptionDecision.syntheticResponse(
        statusCode: HttpStatus.noContent,
        contentType: 'text/plain',
        body: Uint8List(0),
      );
    }
    if (_shouldPassthroughRequest(url, method)) {
      // Decision: Let the WebView handle it.
      return InterceptionDecision.delegateRequest();
    }
    // Decision: Proxy the request over Dart network.
    return InterceptionDecision.executeRequest();
  }

  static const _blackListedEndPoints = [
    'amazon.com/images',
    'unagi-na.amazon.com',
    'unagi.amazon.com',
    'https://app.link',
    'fls-na.amazon.com',
    'cdn.prod.metrics',
    'api/_ajax/metrics',
    'm.media-amazon.com/images',
    'googletagservices.com',
    'cloudfront.net/jwplayer',
    'c.amazon-adsystem.com/',
    'ww.imdb.com/_json/getads',
    'launchpad-wrapper.privacymanager.io',
    'secure.cdn.fastclick.net',
    'tags.crwdcntrl.net',
    'cdn-ima.33across.com',
    'cdn.hadronid.net',
    'lexicon.33across.com',
    'sb.scorecardresearch.com',
    'doubleclick.net',
    'adsystem',
    'adtraffic',
    'yahoo.com',
  ];

  /// Determines if a request targets an ad server and should be blocked.
  bool _discardAdRequests(String url) {
    for (final endpoint in _blackListedEndPoints) {
      if (url.contains(endpoint)) return true;
    }
    return false;
  }

  /// Determines if a request targets a static image and should be blocked.
  bool _discardImageRequests(String url, String? acceptHeader) {
    const blockedExtensions = ['.png', '.gif', '.jpg', '.jpeg'];
    return blockedExtensions.any((ext) => url.endsWith(ext)) ||
        (acceptHeader != null && acceptHeader.contains('image/'));
  }

  /// Determines if a request should be executed by the WebView without
  /// Dart interception.
  /// Returns `true` to skip interception (return null from _handleIntercept).
  bool _shouldPassthroughRequest(String url, String? method) {
    // Pass through scripts, styles, and fonts
    const passedExtensions = ['.js', '.css', '.woff2'];

    if (passedExtensions.any((ext) => url.endsWith(ext))) {
      return true;
    }
    // Pass through non-API URLs
    if (_urlProxyFilter.isEmpty || !url.contains(_urlProxyFilter)) {
      return true;
    }
    // Pass through non-GET requests
    if (method != HttpMethod.get.value) {
      return true;
    }
    return false; // Intercept all other requests.
  }

  /// Executes the proxy request using the injected HttpClient factory.
  /// This helper encapsulates the networking aspect of the interception flow.
  Future<HttpClientResponse> _executeProxyRequest(
    WebResourceRequest request,
  ) async {
    final client = _httpClientFactory();
    final uri = request.url.uriValue;
    final dartRequest = await client.openUrl(
      request.method ?? HttpMethod.get.value,
      uri,
    );
    transferRequestData(request, dartRequest);
    return dartRequest.close();
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
      _onEngineData(String.fromCharCodes(bodyBytes));
    }

    return WebResourceResponse(
      contentType: contentType ?? 'application/json',
      contentEncoding: response.headers.contentType?.charset ?? 'utf-8',
      statusCode: response.statusCode,
      headers: responseHeaders,
      data: bodyBytes,
    );
  }

  /// Transfers request data from a [WebResourceRequest]
  /// to a [HttpClientRequest].
  ///
  /// [request] The web resource request to transfer data from.
  /// [dartRequest] The HTTP client request to transfer data to.
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

  /// Handles errors received during page loading.

  void _onReceivedError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  ) {
    logger.e(
      'Error loading headless page: ${error.description.characters.take(100)}'
      'for ${request.url}',
    );
    if (httpStatusCode == null || httpStatusCode == HttpStatus.ok) {
      httpStatusCode = HttpStatus.badRequest;
    }
  }
}
