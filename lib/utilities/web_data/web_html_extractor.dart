import 'dart:async';
import 'dart:convert';

import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/web_headless_extractor.dart';
import 'package:universal_io/io.dart';

/// Simplified interface for extracting html data from a web page.
///
/// Hides the underlying callback mechanism.
class WebHtmlSychroniser {
  WebHtmlSychroniser(this.webPageUrl) {
    base = WebHtmlExtractor();
  }

  final String webPageUrl;
  late WebHtmlExtractor base;
  List<String> htmlResults = [];

  void _htmlCallback(String html) {
    htmlResults.add(html);
  }

  /// Consolidate all html results into a single list.
  ///
  /// If no results are found, add a single entry with the string
  /// 'no dynamic html results'.
  Future<List<String>> getHtml() async {
    await base.execute(webPageUrl, _htmlCallback);
    if (htmlResults.isEmpty) {
      htmlResults.add('no dynamic html results');
    }
    return htmlResults;
  }
}

/// Extracts the HTML body from a web page.
class WebHtmlExtractor extends WebHeadlessExtractor {
  WebHtmlExtractor({super.webEngine}) {
    webEngine ??= HeadlessWebEngine();
  }

  int pagesLoaded = 0;

  /// Executes the extraction process.
  @override
  Future<int> execute(
    String url,
    DataCallback onData, {
    String apiAcceptFilter = '',
  }) => webEngine!.run(
    url: url,
    urlInterceptFilter: apiAcceptFilter,
    onEngineData: (data) => processRawData(data, onData),
    onPageLoaded: () => _noop(onData),
  );

  /// Empty callback for onPageLoaded to encourage the webview
  /// to wait for more data to load.
  Future<void> _noop(DataCallback onData) async {}

  /// Processes the raw data extracted from the web page.
  @override
  void processRawData(String data, DataCallback onData) {
    // Basic validation to ensure it's HTML
    if (data.trim().startsWith(startHtml) && data.contains(endHtml)) {
      pagesLoaded++;
      if (pagesLoaded == 1) {
        logger.t(
          'processRawData: HTML fragment ${data.length} '
          'sample: ${data.truncate()}',
        );
        onData(data);
      }
    }
  }
}

/// A wrapper class around `WebHtmlExtractor` that simulates an `HttpClient`.
///
/// This is used to drive a headless browser on android
/// to load the full website, including running any javascript
/// to extract HTML from a web page.
///
/// Note: only methods used by `WebFetchBase` are implemented.
///
/// Does not implement autoUncompress, connectionTimeout, idleTimeout,
/// maxConnectionsPerHost, userAgent, addCredentials, addProxyCredentials,
/// authenticate, authenticateProxy, badCertificateCallback, connectionFactory,
/// delete, deleteUrl, findProxy, get, getUrl, head, headUrl, keyLog, patch,
/// patchUrl, post, postUrl, put, putUrl.

class HeadlessHttpClient implements HttpClient {
  @override
  void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) => Future.value(HeadlessHttpClientRequest('http://$host:$port$path'));

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      Future.value(HeadlessHttpClientRequest(url.toString()));

  // throw exception for all unimplimented methods.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A wrapper class around `WebHtmlExtractor` that simulates an `HttpClient`.
///
/// It returns an HTML response as a `Stream<String>`. This is designed
/// to be a drop-in replacement for `myFetchWebText` implementations
/// in classes that extend `WebFetchBase`.
///
/// Note: only methods used by `WebFetchBase` are implemented.
///
/// Does not implement bufferOutput, contentLength, followRedirects,
/// maxRedirects, persistentConnection, encoding, abort, add, addError,
/// addStream, connectionInfo, cookies, done, flush, headers, method, uri,
/// write, writeAll, writeBytes, writeCharCode, writeEncodedString,
/// writeIterable, writeln.
class HeadlessHttpClientRequest implements HttpClientRequest {
  HeadlessHttpClientRequest(this.webPageUrl, {this.base}) {
    base ??= WebHtmlExtractor();
  }

  final String webPageUrl;

  WebHtmlExtractor? base;
  int _statusCode = HttpStatus.ok;
  @override
  final headers = HeadlessHttpHeaders();

  /// execute webrequest using headless browser.
  @override
  Future<HttpClientResponse> close() async {
    final rawData = _convertFutureStream(getHtmlStream());
    final response = HeadlessHttpClientResponse.fromBasic(rawData, _statusCode);
    return response;
  }

  /// Fetches the HTML from the given `webPageUrl` and returns it as a Stream.
  Future<Stream<String>> getHtmlStream() async {
    final streamController = StreamController<String>();

    void htmlCallback(String html) {
      if (!streamController.isClosed) {
        streamController.add(html);
      }
    }

    try {
      // According to Gemini using a headless browser to replace a HttpClient
      // "is like taking a limousine to pick up a single grape".
      // Brutal!
      _statusCode = await base!.execute(webPageUrl, htmlCallback);
    } catch (e) {
      if (!streamController.isClosed) {
        streamController.addError(e);
      }
    } finally {
      if (!streamController.isClosed) {
        unawaited(streamController.close());
      }
    }

    return streamController.stream;
  }

  /// Convert a `Future<Stream<String>>` to a `Stream<List<int>>`.
  ///
  /// ```dart
  /// final stream = await getHtmlStream();
  /// final rawData = _convertFutureStream(stream);
  /// ```
  Stream<List<int>> _convertFutureStream(
    Future<Stream<String>> futureStream,
  ) async* {
    final stream = await futureStream;

    // Pipe the stream through a UTF-8 encoder and yield it
    yield* stream.map(utf8.encode);
  }

  // throw exception for all unimplimented methods.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A wrapper class around `Stream<List<int>>`
/// that simulates an `HttpClientResponse`.
///
/// Note: only methods used by `WebFetchBase` are implemented.
///
/// Does not implement cookies, connectionInfo, certificate, compressionState,
/// detachSocket, isRedirect, persistentConnection, reasonPhrase, redirect,
/// redirects.

class HeadlessHttpClientResponse extends StreamView<List<int>>
    implements HttpClientResponse {
  HeadlessHttpClientResponse.fromBasic(this.htmlStream, this.statusCode)
    : super(htmlStream);

  Stream<List<int>> htmlStream;
  @override
  int statusCode;

  // throw exception for all unimplimented methods.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Headless client does not support headers.
class HeadlessHttpHeaders implements HttpHeaders {
  // throw exception for all unimplimented methods.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
