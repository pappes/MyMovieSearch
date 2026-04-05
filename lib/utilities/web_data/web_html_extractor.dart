import 'dart:async';
import 'dart:convert';

import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/platform_android/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/platform_linux/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/platform_other/headless_web_engine.dart';
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
    if (webEngine == null) {
      if (Platform.isAndroid) {
        webEngine = HeadlessWebEngineAndroid();
      } else if (Platform.isLinux) {
        webEngine = HeadlessWebEngineLinux();
      } else {
        webEngine = HeadlessWebEngineOther();
      }
    }
  }

  int pagesLoaded = 0;

  /// Executes the extraction process.
  @override
  Future<int> execute(
    String url,
    DataCallback onData, {
    String apiAcceptFilter = '',
  }
  ) => webEngine!.run(
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
          'sample: ${data.substring(0, 1000)}',
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
/// Falls back to a standard `HttpClient` on other platforms.
///
/// Note: only methods used by `WebFetchBase` are implemented.
class HeadlessHttpClient implements HttpClient {
  HeadlessHttpClient() {
    if (!Platform.isAndroid) {
      deligate = HttpClient();
    }
  }

  HttpClient? deligate;

  @override
  void close({bool force = false}) => deligate?.close(force: force);

  @override
  Future<HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) =>
      deligate?.open(method, host, port, path) ??
      Future.value(HeadlessHttpClientRequest('http://$host:$port$path'));

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      deligate?.openUrl(method, url) ??
      Future.value(HeadlessHttpClientRequest(url.toString()));

  /*@override
  bool autoUncompress;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout;

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}

  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {}

  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) {}

  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) {}

  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) {}


  @override
  set connectionFactory(Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) {}

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) {
    throw UnimplementedError();
  }

  @override
  set findProxy(String Function(Uri url)? f) {}

  @override
  Future<HttpClientRequest> get(String host, int port, String path) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> head(String host, int port, String path) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> headUrl(Uri url) {
    throw UnimplementedError();
  }

  @override
  set keyLog(Function(String line)? callback) {}


  @override
  Future<HttpClientRequest> patch(String host, int port, String path) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> post(String host, int port, String path) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> postUrl(Uri url) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> put(String host, int port, String path) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) {
    throw UnimplementedError();
  }*/

  // throw exception for all unimplimented methods.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A wrapper class around `WebHtmlExtractor` that simulates an `HttpClient`.
///
/// It returns an HTML response as a `Stream<String>`. This is designed
/// to be a drop-in replacement for `myFetchWebText` implementations
/// in classes that extend `WebFetchBase`.
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
      _statusCode = await base!.execute(
        webPageUrl,
        htmlCallback,
      );
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

  /*
  @override
  bool bufferOutput = false;

  @override
  int contentLength = -1;

  @override
  bool followRedirects = true;

  @override
  int maxRedirects = 5;

  @override
  bool persistentConnection = false;

  @override
  Encoding encoding = utf8;*/

  /*
  @override
  void abort([Object? exception, StackTrace? stackTrace]) {}

  @override
  void add(List<int> data) {}

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<dynamic> addStream(Stream<List<int>> stream) {}

  @override
  HttpConnectionInfo? get connectionInfo => throw UnimplementedError();

  @override
  List<Cookie> get cookies => throw UnimplementedError();

  @override
  Future<HttpClientResponse> get done => throw UnimplementedError();

  @override
  Future<dynamic> flush() {
    throw UnimplementedError();
  }

  @override
  HttpHeaders get headers => requestHeaders;

  @override
  String get method => throw UnimplementedError();

  @override
  Uri get uri => throw UnimplementedError();

  @override
  void write(Object? object) {}

  @override
  void writeAll(Iterable<dynamic> objects, [String separator = ""]) {}

  @override
  void writeCharCode(int charCode) {}

  @override
  void writeln([Object? object = ""]) {}*/

  // throw exception for all unimplimented methods.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A wrapper class around `Stream<List<int>>`
/// that simulates an `HttpClientResponse`.
class HeadlessHttpClientResponse extends StreamView<List<int>>
    implements HttpClientResponse {
  HeadlessHttpClientResponse.fromBasic(this.htmlStream, this.statusCode)
    : super(htmlStream);

  Stream<List<int>> htmlStream;
  @override
  int statusCode;

  /*
  @override
  List<Cookie> cookies = const [];
  @override
  int contentLength = -1;
  @override
  HttpConnectionInfo? connectionInfo;
  @override
  X509Certificate? certificate;
  @override
  HttpClientResponseCompressionState compressionState =
      HttpClientResponseCompressionState.notCompressed;

  @override
  Future<Socket> detachSocket() { throw UnimplementedError(); }

  @override
  bool get isRedirect => throw UnimplementedError();

  @override
  bool get persistentConnection => throw UnimplementedError();

  @override
  String get reasonPhrase => throw UnimplementedError();

  @override
  Future<HttpClientResponse> redirect([
    String? method,
    Uri? url,
    bool? followLoops,
  ]) { throw UnimplementedError(); }

  @override
  List<RedirectInfo> get redirects => throw UnimplementedError();*/

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
