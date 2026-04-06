import 'dart:async';
import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:puppeteer/puppeteer.dart';

/// Headless web engine for Linux platforms.
///
/// This class implements the [HeadlessWebEngine] interface for Linux platforms.
class HeadlessWebEngineLinux extends HeadlessWebEngineBase {
  static Browser? browser;
  Page? _page;

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

    browser ??= await puppeteer.launch(
      headless: false,
      executablePath: '/usr/bin/google-chrome',
    );
    _page = await browser!.newPage();

    _page!.onLoad.listen(_loadStopped);
    resetTimeout();
    final response = await _page!.goto(url, wait: Until.networkAlmostIdle);
    if (onPageLoaded != null) {
      await onPageLoaded();
    }
    await dataLoadedCompleter.future;
    httpStatusCode = response.status;
    await dispose();
    return httpStatusCode!;
  }

  @override
  Future<dynamic> evaluateJavascript(String script) async => null;
  // TODO: implement find out why changing the dom causes JS to crash
  // Future<dynamic> evaluateJavascript(String script) async {
  //   logger.t('evaluateJavascript: $script');
  //   final result = await _page?.evaluate<dynamic>(script);

  //   logger.t('evaluateJavascript result: $result');
  //   return result;
  // }

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
    await closePage();
    await browser?.close();
  }

  @override
  Future<void> _loadStopped(_) => pageLoadComplete();

  @override
  Future<String?> getPageContent() async => _page?.content;
}
