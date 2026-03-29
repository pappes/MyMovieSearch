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
  Future<void> run({
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
