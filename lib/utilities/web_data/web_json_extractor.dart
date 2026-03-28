import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:my_movie_search/utilities/web_data/platform_android/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/platform_linux/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/platform_other/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/web_headless_extractor.dart';

/// Simplified interface for extracting JSON data from a web page.
///
/// Hides the underlying callback mechanism.
class WebJsonSychroniser {
  WebJsonSychroniser(this.webPageUrl, this.apiAcceptFilter) {
    HeadlessWebEngine engine;
    if (Platform.isAndroid) {
      engine = HeadlessWebEngineAndroid();
    } else if (Platform.isLinux) {
      engine = HeadlessWebEngineLinux();
    } else {
      engine = HeadlessWebEngineOther();
    }
    base = WebJsonExtractor(webEngine: engine);
  }

  final String webPageUrl;
  final String apiAcceptFilter;
  late WebJsonExtractor base;
  List<String> jsonResults = [];

  void _jsonCallback(String json) {
    jsonResults.add(json);
  }

  /// Consolidate all json results into a single list.
  ///
  /// If no results are found, add a single entry with the string
  /// 'no dynamic json results'.
  Future<List<String>> getJson() async {
    await base.execute(webPageUrl, apiAcceptFilter, _jsonCallback);
    if (jsonResults.isEmpty) {
      jsonResults.add(jsonEncode('no dynamic json results'));
    }
    return jsonResults;
  }
}

/// Extract JSON data from a web page using a headless web engine.
class WebJsonExtractor extends WebHeadlessExtractor {
  WebJsonExtractor({required super.webEngine});

  /// Execute the web engine and extract JSON data from a web page.
  ///
  /// [url] The URL of the web page to extract JSON data from.
  /// [apiAcceptFilter] The query to use for filtering JSON data.
  /// [onData] A callback function to process the extracted JSON data.
  @override
  Future<void> execute(
    String url,
    String apiAcceptFilter,
    DataCallback onData,
  ) async {
    await webEngine.run(
      url: url,
      apiAcceptFilter: apiAcceptFilter,
      onEngineData: (data) => processRawData(data, onData),
      onPageLoaded: () => _extractJsonScripts(onData),
    );
  }

  /// Extract JSON scripts from the web page.
  ///
  /// This method will click all filter buttons to ensure full data load.
  /// It will then extract all JSON scripts from the web page.
  Future<void> _extractJsonScripts(DataCallback onData) async {
    // Click to remove all filter options to ensure full data load
    // An async function is used to introduce a delay between clicks.
    const clickScript = '''
      (async () => {
        const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));
        const buttons = document.querySelectorAll('.ipc-chip--active');
        for (const button of buttons) {
          button.click();
          await sleep(50);
        }
      })();
''';

    await webEngine.evaluateJavascript(clickScript);
    await Future<void>.delayed(const Duration(seconds: 2));

    const javascriptToExecute = '''
(function() {
  const scripts = document.querySelectorAll('script[type="application/json"]');
  const contents = [];
  scripts.forEach(script => contents.push(script.innerHTML));
  return JSON.stringify(contents);
})();
''';

    // Execute the script and get the result.
    final result = await webEngine.evaluateJavascript(javascriptToExecute);
    if (result != null) {
      logger.t(
        'Found on initial page load: '
        '${result.toString().characters.take(1000)}',
      );
      try {
        final jsonScripts = json.decode(result.toString());
        if (jsonScripts is Iterable) {
          for (final script in jsonScripts) {
            processRawData(script.toString(), onData);
          }
        }
      } catch (_) {}
    }
  }

  /// Callback to process each JSON chunk detected.
  ///
  /// [data] The json chunk to process.
  /// [onData] A callback function to process the extracted JSON data.
  @override
  void processRawData(String data, DataCallback onData) {
    try {
      json.decode(data); // Validate it's valid JSON
      onData(data);
    } catch (_) {
      // Ignore invalid JSON responses
    }
  }
}
