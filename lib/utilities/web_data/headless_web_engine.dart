import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/platform_android/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/platform_linux/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/platform_other/headless_web_engine.dart';

typedef DataCallback = void Function(String data);
typedef PageLoadCallback = Future<void> Function();

const timeoutDurationFull = Duration(seconds: 15);
const timeoutDurationShort = Duration(seconds: 10);
const timeoutDurationVeryShort = Duration(seconds: 3);
const timeoutDurationMicroSleep = Duration(milliseconds: 50);

/// Platform-agnostic interface for headless web extraction engines.
abstract class HeadlessWebEngine {
  factory HeadlessWebEngine() {
    if (Platform.isAndroid) {
      return HeadlessWebEngineAndroid();
    } else if (Platform.isLinux) {
      return HeadlessWebEngineLinux();
    }
    return HeadlessWebEngineOther();
  }

  /// Starts the engine, loads the [url],
  /// and streams network/intercepted data through [onEngineData].
  ///
  /// [onPageLoaded] is invoked once the page fully loads,
  /// allowing scripts to be evaluated.
  /// [urlInterceptFilter] restricts which network requests are
  /// intercepted vs passed through.
  ///
  /// returns HttpStatus codes:
  /// 102 - processing - waiting for updates (HttpStatus.processing)
  /// 200 - success - page loaded and data extracted (HttpStatus.ok)
  /// 204 - noContent - request suppressed (HttpStatus.noContent)
  /// 400 - badRequest - recieved error (HttpStatus.badRequest)
  /// 510 - notExtended - no status available (HttpStatus.notExtended)
  /// 501 - notImplemented - not implemented (HttpStatus.notImplemented)
  ///
  /// 404 - not found - page not found (HttpStatus.notFound)
  /// 503 - unavailable - service unavailable (HttpStatus.serviceUnavailable)

  Future<int> run({
    required String url,
    required String urlInterceptFilter,
    required DataCallback onEngineData,
    PageLoadCallback? onPageLoaded,
  });

  /// Evaluates Javascript on the currently loaded page.
  Future<dynamic> evaluateJavascript(String script);

  /// Cleans up engine resources.
  Future<void> dispose({Duration optionalDelay = Duration.zero});

  /// Disposes the headless web engine after a timeout period.
  ///
  /// [timeoutDuration] The duration to wait before disposing the engine.
  void resetTimeout([Duration? timeoutDuration]);
}

/// Base functionality shared by all headless web engines.
abstract class HeadlessWebEngineBase implements HeadlessWebEngine {
  final Completer<void> dataLoadedCompleter = Completer<void>();
  int pageLoadCompleteCount = 0;
  int? httpStatusCode;
  String? pageContents;
  Timer? timeoutTimer;

  late DataCallback onEngineData;
  PageLoadCallback? onPageLoaded;
  late String urlProxyFilter;
  String imdbUrl = '';

  /// Returns the html content of the page.
  Future<String?> getPageContent();

  /// Disposes the headless web page.
  Future<void> closePage();

  /// Disposes the headless web engine.
  Future<void> closeEngine();

  @override
  Future<int> run({
    required String url,
    required String urlInterceptFilter,
    required DataCallback onEngineData,
    PageLoadCallback? onPageLoaded,
  }) {
    imdbUrl = url;
    this.onEngineData = onEngineData;
    this.onPageLoaded = onPageLoaded;
    urlProxyFilter = urlInterceptFilter;
    httpStatusCode = HttpStatus.processing;

    return Future<int>.value(httpStatusCode!);
  }

  /// Disposes the headless web engine after a timeout period.
  ///
  /// [timeoutDuration] The duration to wait before disposing the engine.
  @override
  void resetTimeout([Duration? timeoutDuration]) {
    timeoutTimer?.cancel();
    timeoutTimer = Timer(timeoutDuration ?? timeoutDurationFull, dispose);
  }

  /// Disposes the headless web engine and signals that the data is loaded.
  ///
  /// [optionalDelay] optional delay to wait before disposing the engine.
  @override
  @awaitNotRequired
  Future<void> dispose({Duration optionalDelay = Duration.zero}) async {
    timeoutTimer?.cancel();
    await Future<void>.delayed(optionalDelay);
    await closePage();

    if (!dataLoadedCompleter.isCompleted) {
      onEngineData(pageContents ?? 'Unable to get html from HeadlessWebView');
      dataLoadedCompleter.complete();
    }
    // Allow time for any final requests to complete.
    await Future<void>.delayed(timeoutDurationMicroSleep);
  }

  /// Handles the completion of a page load.
  ///
  /// Page load can complete multiple times because code is
  /// interacting with the page after the initial load complete.
  Future<void> pageLoadComplete() async {
    logger.t('Page load complete event for $imdbUrl');
    httpStatusCode ??= HttpStatus.ok;
    if (onPageLoaded == null) {
      dispose();
    } else {
      await onPageLoaded!();
      final html = await getPageContent();
      if (html != null) {
        pageContents = html;
      }
      // Timeout if requests do not complete quickly enough.
      pageLoadCompleteCount++;
      if (pageLoadCompleteCount == 1) {
        logger.t('First page load complete for $imdbUrl');
        resetTimeout(timeoutDurationShort);
      } else {
        logger.t('Subsequent page load complete for $imdbUrl');
        // Sometimes there is a false positive for page load complete.
        // Delay disposal to allow any final requests to complete.
        resetTimeout(timeoutDurationVeryShort);
      }
    }
  }
}
