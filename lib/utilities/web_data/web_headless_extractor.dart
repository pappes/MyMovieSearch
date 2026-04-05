import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';

/// Abstract class to coordinate the extraction of data from a web page.
///
/// Uses a full headless browser to load a web page and extract data from it.
abstract class WebHeadlessExtractor {
  WebHeadlessExtractor({this.webEngine});

  HeadlessWebEngine? webEngine;

  /// Executes the web engine to extract data.
  Future<int> execute(
    String url,
    DataCallback onData, {
    String apiAcceptFilter,
  });

  /// Processes raw data intercepted or received,
  /// executing the [onData] callback.
  void processRawData(String data, DataCallback onData);
}
