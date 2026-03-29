import 'dart:io';

import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/platform_linux/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/platform_other/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/web_headless_extractor.dart';

/// Extracts the HTML body from a web page.
class WebHtmlExtractor extends WebHeadlessExtractor {
  WebHtmlExtractor({super.webEngine}) {
    if (webEngine == null) {
      if (Platform.isAndroid) {
        //  webEngine = HeadlessWebEngineAndroid();
        //} else if (Platform.isLinux) {
        webEngine = HeadlessWebEngineLinux();
      } else {
        webEngine = HeadlessWebEngineOther();
      }
    }
  }

  /// Executes the extraction process.
  @override
  Future<void> execute(
    String url,
    String apiAcceptFilter,
    DataCallback onData,
  ) async {
    await webEngine?.run(
      url: url,
      apiAcceptFilter: apiAcceptFilter,
      onEngineData: (data) => processRawData(data, onData),
      onPageLoaded: () => _extractHtmlBody(onData),
    );
  }

  /// Extracts the HTML body from the web page.
  Future<void> _extractHtmlBody(DataCallback onData) async {
    const javascriptToExecute = 'document.documentElement.outerHTML;';
    final result = await webEngine?.evaluateJavascript(javascriptToExecute);
    if (result != null) {
      processRawData(result.toString(), onData);
    }
  }

  /// Processes the raw data extracted from the web page.
  @override
  void processRawData(String data, DataCallback onData) {
    // Basic validation to ensure it's HTML
    if (data.trim().startsWith('<') && data.contains('>')) {
      onData(data);
    }
  }
}
