import 'dart:async';
import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';

/// Headless web engine for Linux platforms.
///
/// This class implements the [HeadlessWebEngine] interface for Linux platforms.
class HeadlessWebEngineLinux implements HeadlessWebEngine {
  @override
  Future<void> run({
    required String url,
    required String apiAcceptFilter,
    required DataCallback onEngineData,
    PageLoadCallback? onPageLoaded,
  }) async {
    // Immediate completion for unsupported platforms.
    if (onPageLoaded != null) {
      await onPageLoaded();
    }
  }

  @override
  Future<dynamic> evaluateJavascript(String script) async => null;

  @override
  Future<void> dispose({Duration optionalDelay = Duration.zero}) async {}
}
