import 'dart:io';
import 'dart:typed_data';
import 'package:my_movie_search/utilities/web_data/platform_android/web_json_extractor.dart';
import 'package:my_movie_search/utilities/web_data/platform_linux/web_json_extractor.dart';
import 'package:my_movie_search/utilities/web_data/platform_other/web_json_extractor.dart';

/// Defines the three possible outcomes of an interception request,
enum InterceptionAction { delegateRequest, syntheticResponse, executeRequest }

/// Represents the interception decision made by the orchestration layer.
class InterceptionDecision {
  InterceptionDecision.delegateRequest()
    : action = InterceptionAction.delegateRequest,
      statusCode = null,
      contentType = null,
      body = null;

  InterceptionDecision.executeRequest()
    : action = InterceptionAction.executeRequest,
      statusCode = null,
      contentType = null,
      body = null;

  InterceptionDecision.syntheticResponse({
    required this.statusCode,
    required this.contentType,
    required this.body,
  }) : action = InterceptionAction.syntheticResponse;
  final InterceptionAction action;
  final int? statusCode;
  final String? contentType;
  final Uint8List? body;
}

// This function type abstracts the creation of the HttpClient, making it mockable.
typedef JsonCallback = void Function(String);

/// Extract the json from a web page
/// using a platform specific implementation to drive a web browser.
abstract class WebJsonExtractor {
  /// Constructor to create a new instance
  /// of the appropriate platform specific implementation.
  factory WebJsonExtractor(
    String imdbUrl,
    JsonCallback jsonCallback,
    String imdbApi,
  ) {
    // TODO: Use environment variable to drive platform specific implementation
    // so that the compiler can tree shake unused code.
    if (Platform.isAndroid) {
      return WebJsonExtractorAndroid.internal(imdbUrl, jsonCallback, imdbApi);
    }
    if (Platform.isLinux) {
      return WebJsonExtractorLinux.internal(imdbUrl, jsonCallback, imdbApi);
    }

    return WebJsonExtractorOther.internal(imdbUrl, jsonCallback, imdbApi);
  }

  /// Internal constructor to setup internal state for the instance.
  WebJsonExtractor.internal(this.imdbUrl, this.jsonCallback, this.imdbApi);

  String imdbUrl;
  JsonCallback jsonCallback;
  String imdbApi;

  Future<void> waitForCompletion();

  // Get the CSS selector for the page element to click on.
  String getClickOnFilter() => '''
      // Click to remove all filter options to ensure full data load
      // An async function is used to introduce a delay between clicks.
      (async () => {
        const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));
        const buttons = document.querySelectorAll('.ipc-chip--active');
        for (const button of buttons) {
          button.click();
          await sleep(10); // Wait for 10 milliseconds
        }
      })();
''';

  void consumeJsonData(String json) {
    jsonCallback(json);
  }
  static const List<String> _blackListedEndPoints = [
    'amazon.com/images',
    'm.media-amazon.com/images',
    'googletagservices.com',
    'cloudfront.net/jwplayer',
    'c.amazon-adsystem.com/',
    'ww.imdb.com/_json/getads',
    'launchpad-wrapper.privacymanager.io',
    'secure.cdn.fastclick.net',
    'tags.crwdcntrl.net',
    'cdn-ima.33across.com',
    'cdn.hadronid.net',
    'lexicon.33across.com',
    'sb.scorecardresearch.com',

    'doubleclick.net',
    'adsystem',
    'adtraffic',
    'yahoo.com',
    
  ];

  bool discardAdRequests(String url) {
    for (final endpoint in _blackListedEndPoints) {
      if (url.contains(endpoint)) {
        return true;
      }
    }
    return false;
  }

  /// Determines the interception decision for a given request.
  InterceptionDecision getInterceptionDecision(
    String url,
    String? method, {
    String? acceptHeader,
  }) {
    if (discardImageRequests(url, acceptHeader) || discardAdRequests(url)) {
      //return InterceptionDecision.delegateRequest();
      // Decision: Block the request with a synthetic 404.
      // return InterceptionDecision.delegateRequest();
      return InterceptionDecision.syntheticResponse(
        statusCode: 204,
        contentType: 'text/plain',
        body: Uint8List(0),
      );
      return InterceptionDecision.syntheticResponse(
        statusCode: 404,
        contentType: 'text/plain',
        body: Uint8List(0),
      );
    }

    //TODO: stop doubleclick.net and adsystem and adtraffic and yahoo.com
    // and m.media-amazon.com/images and googletagservices.com
    // and cloudfront.net/jwplayer-unlimited-8.25.6/jwplayer.js
    // and c.amazon-adsystem.com/ and ww.imdb.com/_json/getads
    // and launchpad-wrapper.privacymanager.io
    // and secure.cdn.fastclick.net and tags.crwdcntrl.net
    // and cdn-ima.33across.com and cdn.hadronid.net and lexicon.33across.com
    // and sb.scorecardresearch.com

    if (shouldPassthroughRequest(url, method)) {
      // Decision: Let the WebView handle it.
      return InterceptionDecision.delegateRequest();
    }

    // Decision: Proxy the request over Dart network.
    return InterceptionDecision.executeRequest();
  }

  /// Determines if a request should be executed by the WebView without Dart interception.
  /// Returns `true` to skip interception (return null from _handleIntercept).
  bool shouldPassthroughRequest(String url, String? method) {
    // Pass through scripts, styles, and fonts
    const passedExtensions = ['.js', '.css', '.woff2'];

    if (passedExtensions.any((ext) => url.endsWith(ext))) {
      return true;
    }
    // Pass through non-API URLs
    if (!url.contains(imdbApi)) {
      return true;
    }
    // Pass through non-GET requests
    if (method != 'GET') {
      return true;
    }

    return false; // Intercept all other requests.
  }

  /// Determines if a request targets a static image and should be blocked.
  bool discardImageRequests(String url, String? acceptHeader) {
    const blockedExtensions = ['.png', '.gif', '.jpg', '.jpeg'];
    return blockedExtensions.any((ext) => url.endsWith(ext)) ||
        (acceptHeader != null && acceptHeader.contains('image/'));
  }
}
