import 'dart:async';
import 'dart:io';
import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';

/// Headless web engine for Linux platforms.
///
/// This class implements the [HeadlessWebEngine] interface for Linux platforms.
class HeadlessWebEngineLinux implements HeadlessWebEngine {
  @override
  Future<int> run({
    required String url,
    required String urlInterceptFilter,
    required DataCallback onEngineData,
    PageLoadCallback? onPageLoaded,
  }) async {
    // Immediate completion for unsupported platforms.
    if (onPageLoaded != null) {
      await onPageLoaded();
    }
    return HttpStatus.notImplemented;
  }

  @override
  Future<dynamic> evaluateJavascript(String script) async => null;

  @override
  Future<void> dispose({Duration optionalDelay = Duration.zero}) async {}
}
