import 'dart:async';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:puppeteer/puppeteer.dart';

/// Headless web engine for Linux platforms.
///
/// This class implements the [HeadlessWebEngine] interface for Linux platforms.
class HeadlessWebEngineLinux extends HeadlessWebEngineBase {
  static Timer? browserTimeoutTimer;
  static Browser? _browser;
  Page? _page;

  @override
  Future<String?> getPageContent() async => _page?.content;

  Future<void> _loadStopped(_) => pageLoadComplete();

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
    _page!.onResponse.listen(reponseMonitor);

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

  Future<void> reponseMonitor(Response? response) async {
    if (response == null) return;
    // logger.t('reponseMonitor url: ${response.request.url}');
    resetTimeout(timeoutDurationVeryShort);
    resetBrowserTimeout(timeoutDurationVeryShort);
    if (response.request.url.contains(urlProxyFilter)) {
      try {
        final body = await response.text;
        logger.t('reponseMonitor body: ${body.truncate()}');
        onEngineData(body);
      } catch (e) {
        // listener is frequently called when data is being loaded.
      }
    }
  }

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
