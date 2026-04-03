import 'dart:async';

typedef DataCallback = void Function(String data);
typedef PageLoadCallback = Future<void> Function();

/// Platform-agnostic interface for headless web extraction engines.
abstract class HeadlessWebEngine {
  /// Starts the engine, loads the [url], 
  /// and streams network/intercepted data through [onEngineData].
  ///
  /// [onPageLoaded] is invoked once the page fully loads,
  /// allowing scripts to be evaluated.
  /// [apiAcceptFilter] restricts which network requests are
  /// intercepted vs passed through.
  ///
  /// returns HttpStatus codes:
  /// 102 - processing - waiting for updates (HttpStatus.processing)
  /// 200 - success - page loaded and data extracted (HttpStatus.ok)
  /// 204 - noContent - request suppressed (HttpStatus.noContent)
  /// 400 - badRequest - recieved error (HttpStatus.badRequest)
  /// 510 - notExtended - not status avaialble (HttpStatus.notExtended)
  /// 501 - notImplemented - not implemented (HttpStatus.notImplemented)
  ///
  /// 404 - not found - page not found (HttpStatus.notFound)
  /// 503 - service unavailable - service unavailable (HttpStatus.serviceUnavailable)
  
  Future<int> run({
    required String url,
    required String apiAcceptFilter,
    required DataCallback onEngineData,
    PageLoadCallback? onPageLoaded,
  });

  /// Evaluates Javascript on the currently loaded page.
  Future<dynamic> evaluateJavascript(String script);

  /// Cleans up engine resources.
  Future<void> dispose({Duration optionalDelay = Duration.zero});
}
