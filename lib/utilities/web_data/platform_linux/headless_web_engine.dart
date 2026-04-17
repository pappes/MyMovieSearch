import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/headless_web_interceptor.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:puppeteer/puppeteer.dart';

/// This function type abstracts the creation of the HttpClient,
/// making it mockable.
typedef HttpClientFactory = HttpClient Function();

/// Headless web engine for Linux platforms.
///
/// This class implements the [HeadlessWebEngine] interface for Linux platforms.
class HeadlessWebEngineLinux extends HeadlessWebEngineBase {
  HeadlessWebEngineLinux({HttpClientFactory httpClientFactory = HttpClient.new})
    : _httpClientFactory = httpClientFactory;

  final HttpClientFactory _httpClientFactory;
  final HeadlessWebInterceptor _interceptor = HeadlessWebInterceptor();

  static Timer? browserTimeoutTimer;
  static Browser? _browser;
  Page? _page;

  /// Returns the html content of the page.
  @override
  Future<String?> getPageContent() async => _page?.content;

  /// Perform actions when page load is stopped.
  Future<void> _loadStopped(_) => pageLoadComplete();

  /// Initialize the headless web engine for the given URL.
  ///
  /// [url] The URL to navigate to.
  /// [urlInterceptFilter] The URL intercept filter.
  /// [onEngineData] The callback to invoke when data is intercepted.
  /// [onPageLoaded] The callback to invoke when the page is loaded.
  ///
  /// Returns the HTTP status code of the response.
  @override
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

    _browser ??= await puppeteer.launch(
      headless: false,
      executablePath: '/usr/bin/google-chrome',
    );
    _page = await _browser!.newPage();
    _page!.onLoad.listen(_loadStopped);

    await _page!.setRequestInterception(true);
    _page!.onRequest.listen(_handleRequest);

    resetTimeout();
    resetBrowserTimeout();
    final response = await _page!.goto(url, wait: Until.networkAlmostIdle);
    if (onPageLoaded != null) {
      await onPageLoaded();
    }

    await dataLoadedCompleter.future;
    httpStatusCode = response.status;
    await dispose();
    return httpStatusCode!;
  }

  /// Transmit request to the interceptor for processing.
  ///
  /// [request] The request to process.
  /// Resets the timeout to a very short duration to allow for
  /// additional requests to complete before the timeout is reached.
  Future<void> _handleRequest(Request request) async {
    resetTimeout(timeoutDurationVeryShort);
    resetBrowserTimeout(timeoutDurationVeryShort);

    try {
      final interceptionResponse = await _interceptor.shouldProxyUrl(
        Uri.parse(request.url),
        request.method,
        _createHttpRequest,
        request.headers,
        urlProxyFilter,
      );

      // Decide what to do with the request based on the interception decision.
      switch (interceptionResponse.decision.action) {
        case InterceptionAction.syntheticResponse:
          final response = _processSyntheticResponse(
            interceptionResponse.decision,
          );
          await request.respond(
            status: response.statusCode,
            contentType: response.contentType,
            body: response.body,
          );
        case InterceptionAction.delegateRequest:
          await request.continueRequest();
        case InterceptionAction.executeRequest:
          final response = await _processExecuteRequest(
            interceptionResponse.httpResponse,
          );
          if (response == null) {
            await request.continueRequest();
          } else {
            await request.respond(
              status: response.statusCode,
              contentType: response.contentType,
              headers: response.headers,
              body: response.body,
            );
          }
      }
    } catch (e) {
      // If an error occurs, continue the request.
      logger.e('Error intercepting request for ${request.url}: $e');
      await request.continueRequest();
    }
  }

  /// Creates an HTTP request for the given URI and method.
  ///
  /// [uri] The URI to create the request for.
  /// [method] The HTTP method to use for the request.
  ///
  /// Returns the HTTP request.
  Future<HttpClientRequest> _createHttpRequest(Uri uri, String method) =>
      _httpClientFactory().openUrl(method, uri);

  /// Creates a synthetic response for the given request and decision.
  ///
  /// [decision] The interception decision.
  SyntheticResponse _processSyntheticResponse(InterceptionDecision decision) =>
      SyntheticResponse(
        statusCode: decision.statusCode ?? 200,
        contentType: decision.contentType ?? 'text/html',
        body: decision.body?.toString() ?? '',
      );

  /// Coordinates the processing of an execute request using the HTTP response.
  ///
  /// [httpResponse] The HTTP response to process.
  Future<SyntheticResponse?> _processExecuteRequest(
    HttpClientResponse? httpResponse,
  ) async {
    if (httpResponse == null) {
      return null;
    }

    final bodyBytes = await _readResponseBody(httpResponse);
    final responseString = String.fromCharCodes(bodyBytes);
    final responseHeaders = _extractResponseHeaders(httpResponse);
    final contentType = httpResponse.headers.contentType?.mimeType;

    _notifyCallerOfNewData(contentType, responseString);

    return SyntheticResponse(
      statusCode: httpResponse.statusCode,
      contentType: contentType ?? 'text/html',
      headers: responseHeaders,
      body: responseString,
    );
  }

  /// Reads A http response body into a list of bytes.
  ///
  /// [httpResponse] The HTTP response to read the body from.
  ///
  /// Returns the response body as a list of bytes.
  Future<Uint8List> _readResponseBody(HttpClientResponse httpResponse) async {
    final builder = BytesBuilder();
    await httpResponse.forEach(builder.add);
    return builder.toBytes();
  }

  /// Extracts http response headers into a map.
  ///
  /// [httpResponse] The HTTP response to extract the headers from.
  ///
  /// Returns the response headers as a map of strings.
  /// Multiple header values are joined with a comma and space.
  Map<String, String> _extractResponseHeaders(HttpClientResponse httpResponse) {
    final responseHeaders = <String, String>{};
    httpResponse.headers.forEach((name, values) {
      responseHeaders[name] = values.join(', ');
    });
    return responseHeaders;
  }

  /// Notifies the caller of new data if the content type is JSON or HTML.
  ///
  /// [contentType] The content type of the response.
  /// [body] The response body as a string.
  void _notifyCallerOfNewData(String? contentType, String body) {
    if (contentType == 'application/json' || contentType == 'text/html') {
      logger.t('_handleRequest intercepted body: ${body.truncate()}');
      onEngineData(body);
    }
  }

  /// Evaluates a JavaScript script in the headless web page.
  ///
  /// [script] The JavaScript script to evaluate.
  ///
  /// Returns the result of the script evaluation.
  @override
  Future<dynamic> evaluateJavascript(String script) async {
    logger.t('evaluateJavascript: $script');
    try {
      final result = await _page?.evaluate<dynamic>(script);

      logger.t('evaluateJavascript result: ${result.toString().truncate(100)}');
      resetTimeout(timeoutDurationVeryShort);
      return result;
    } catch (e) {
      logger.e('evaluateJavascript error: $e');
      return null;
    }
  }

  /// Disposes the headless web page
  @override
  Future<void> closePage() {
    final webView = _page;
    if (webView != null) {
      _page = null;
      return webView.close();
    }
    return Future.value();
  }

  @override
  Future<void> closeEngine() async {
    logger.t('closeEngine');
    await closePage();
    await closeBroswer();
  }

  static Future<void> closeBroswer() async {
    final browser = _browser;
    if (browser != null) {
      _browser = null;
      await browser.close();
    }
  }

  /// Disposes the headless web engine after a timeout period.
  ///
  /// [timeoutDuration] The duration to wait before disposing the engine.
  static void resetBrowserTimeout([Duration? timeoutDuration]) {
    browserTimeoutTimer?.cancel();
    browserTimeoutTimer = Timer(
      timeoutDuration ?? timeoutDurationFull,
      closeBroswer,
    );
  }
}
