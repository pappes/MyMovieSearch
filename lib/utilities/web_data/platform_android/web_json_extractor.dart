import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_json_extractor.dart';

const _timeoutDuration = Duration(seconds: 20);

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
    });

/// Default implementation of the WebView using HeadlessInAppWebView.
HeadlessInAppWebView defaultWebView({
  required String initialUrl,
  required WebResourceInterceptor proxySelector,
  required void Function(InAppWebViewController, WebUri?) onLoadStop,
}) => HeadlessInAppWebView(
  initialUrlRequest: URLRequest(
    url: WebUri(initialUrl),
    cachePolicy:
        URLRequestCachePolicy.RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA,
  ),
  shouldInterceptRequest: proxySelector,
  onLoadStop: onLoadStop,
);

/// Android-specific implementation of the WebJsonExtractor.
class WebJsonExtractorAndroid extends WebJsonExtractor {
  WebJsonExtractorAndroid.internal(
    super.imdbUrl,
    super.jsonCallback,
    super.imdbApi, {
    HttpClientFactory httpClientFactory = HttpClient.new,
    WebViewFactory webViewRunner = defaultWebView,
  }) : _httpClientFactory = httpClientFactory,
       _webViewRunner = webViewRunner,
       super.internal() {
    // ignore: discarded_futures
    _observeWebView(imdbUrl);
  }

  final HttpClientFactory _httpClientFactory; // Injected dependency
  final WebViewFactory _webViewRunner;
  HeadlessInAppWebView? _headlessWebView;
  bool _filtersCleared = false;
  final Completer<void> _dataLoadedCompleter = Completer<void>();

  /// Initialize the web view with the given [webAddress].
  Future<void>? _observeWebView(String webAddress) {
    _headlessWebView = _webViewRunner(
      initialUrl: webAddress,
      proxySelector: _webViewProxySelector,
      onLoadStop: _loadStopped,
    );
    unawaited(_timeout());

    return _headlessWebView!.run();
  }

  /// Handles the timeout for the web view operation.
  Future<void> _timeout() async {
    Future.delayed(_timeoutDuration, () {
      if (_headlessWebView != null && _headlessWebView!.isRunning()) {
        logger.i(
          'Disposing InAppWebViewController due to timeout for $imdbUrl',
        );
        unawaited(dispose());
      }
    });
  }

  @override
  /// Waits for the data loading to complete.
  Future<void> waitForCompletion() async =>
      _dataLoadedCompleter.future.then((_) => super.waitForCompletion());

  /// Disposes the web view after an optional [delay].
  Future<void> dispose({Duration delay = Duration.zero}) async {
    await Future<void>.delayed(delay);
    if (_headlessWebView != null) {
      unawaited(_headlessWebView?.dispose());
      _headlessWebView = null;
      _dataLoadedCompleter.complete();
    }
  }

  /// Called when the web view finishes loading a page.
  void _loadStopped(InAppWebViewController controller, WebUri? url) {
    logger.t('Page load complete for $imdbUrl');
    unawaited(_clickAllFilterOptions(controller));
  }

  /// Clicks all filter options on the page to expand data.
  Future<void> _clickAllFilterOptions(InAppWebViewController controller) async {
    if (_filtersCleared) {
      // Delay disposal to allow any final requests to complete.
      return dispose(delay: const Duration(seconds: 4));
    }

    try {
      _filtersCleared = true;
      // logger.t(
      //   await controller.evaluateJavascript(
      //     source: "document.querySelectorAll('.ipc-chip--active')",
      //   ),
      // );
      // await Future<void>.delayed(const Duration(seconds: 2));
      await controller.evaluateJavascript(source: getClickOnFilter());
      logger.t('Clicked on all filter options to expand data for $imdbUrl');
      //await Future<void>.delayed(const Duration(seconds: 2));
      // logger.t(
      //   await controller.evaluateJavascript(
      //     source: "document.querySelectorAll('.ipc-chip--active')",
      //   ),
      // );
      await dispose(delay: const Duration(seconds: 10));
    } catch (e) {
      logger.e('Error clicking filter options: $e for $imdbUrl');
      await dispose();
    }
  }

  /// Exposes the private proxy selector for testing purposes.
  Future<WebResourceResponse?> executeProxySelectorForTest(
    InAppWebViewController controller,
    WebResourceRequest request,
  ) async => _webViewProxySelector(controller, request);

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
    //print('Interception decision: ${decision.action} for ${request.url}');

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
        return transferResponseData(request, response);
    }
  }

  /// Executes the proxy request using the injected HttpClient factory.
  /// This helper encapsulates the networking aspect of the interception flow.
  Future<HttpClientResponse> _executeProxyRequest(
    WebResourceRequest request,
  ) async {
    // logger.i('Proxying request: ${request.url}');
    final client = _httpClientFactory();
    final uri = request.url.uriValue;
    final dartRequest = await client.openUrl(request.method ?? 'GET', uri);

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
    final responseHeaders = <String, String>{};
    response.headers.forEach((name, values) {
      responseHeaders[name] = values.join(', ');
    });
    final contentType = response.headers.contentType?.mimeType;
    if (contentType == 'application/json') {
      _filtersCleared = true;
      consumeJsonData(String.fromCharCodes(bodyBytes));
    }

    return WebResourceResponse(
      contentType: contentType ?? 'application/json',
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
