import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:puppeteer/puppeteer.dart';

const _timeoutDurationFull = Duration(seconds: 15);
const _timeoutDurationShort = Duration(seconds: 10);
const _timeoutDurationVeryShort = Duration(seconds: 3);
const _timeoutDurationMicroSleep = Duration(milliseconds: 50);

/// Headless web engine for Linux platforms.
///
/// This class implements the [HeadlessWebEngine] interface for Linux platforms.
class HeadlessWebEngineLinux implements HeadlessWebEngine {
  static Browser? browser;
  Page? _page;

  final Completer<void> _dataLoadedCompleter = Completer<void>();
  int pageLoadCompleteCount = 0;
  int? httpStatusCode;
  String? pageContents;
  Timer? _timeoutTimer;

  late DataCallback _onEngineData;
  PageLoadCallback? _onPageLoaded;
  late String _urlProxyFilter;
  String _imdbUrl = '';

  @override
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
    httpStatusCode = HttpStatus.notExtended;

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
    await _dataLoadedCompleter.future;
    httpStatusCode = response.status;
    await dispose();
    return httpStatusCode!;
  }

  @override
  Future<dynamic> evaluateJavascript(String script) async => null;

  /// Disposes the headless web engine after a timeout period.
  ///
  /// [timeoutDuration] The duration to wait before disposing the engine.
  void resetTimeout([Duration timeoutDuration = _timeoutDurationFull]) {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(timeoutDuration, () {
      if (_page != null) {
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
    final webView = _page;
    if (webView != null) {
      _page = null;
      await webView.close();
    }

    if (!_dataLoadedCompleter.isCompleted) {
      _onEngineData(pageContents ?? 'Unable to get html from HeadlessWebView');
      _dataLoadedCompleter.complete();
    }
    // Allow time for any final requests to complete.
    await Future<void>.delayed(_timeoutDurationMicroSleep);
  }

  Future<void> _loadStopped(_) async {
    logger.t('Page load complete for $_imdbUrl');
    httpStatusCode ??= HttpStatus.ok;
    if (_onPageLoaded == null || _page == null) {
      dispose();
    } else {
      await _onPageLoaded!();
      final html = await _page!.content;
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
}
