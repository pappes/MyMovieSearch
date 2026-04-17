import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:my_movie_search/utilities/web_data/http_method.dart';

/// This function type abstracts the creation of the HttpClientRequest.
typedef HttpRequestFactory = Future<HttpClientRequest> Function(Uri, String);

class InterceptionResponse {
  InterceptionResponse(this.decision, {this.httpResponse});
  final InterceptionDecision decision;
  HttpClientResponse? httpResponse;
}

/// A synthetic response to be returned instead of the actual response.
class SyntheticResponse {
  SyntheticResponse({
    required this.statusCode,
    required this.contentType,
    required this.body,
    this.headers,
  });
  final int statusCode;
  final String contentType;
  final Map<String, String>? headers;
  final String body;
}

/// Defines the three possible outcomes of an interception request,
///
/// [delegateRequest] The request should be handled by the source.
/// [syntheticResponse] The request does not need to run.
/// [executeRequest] The request should be handled by a httpClient.
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

/// Decides how to handle all resource load requests for a headless web engine.
///
/// Each request is handled by the following logic:
/// 1. Check if the request should be blocked (e.g., ad servers).
/// 2. Check if the request should be handled by the web engine.
/// 3. Check if the request should be proxied through a Dart HttpClient.
class HeadlessWebInterceptor {
  HeadlessWebInterceptor();

  /// Handles the interception of specific URL requests (e.g., /api/)
  /// and proxies them through a Dart HttpClient to allow for manipulation
  /// or inspection, returning the result to the WebView.
  Future<InterceptionResponse> shouldProxyUrl(
    Uri uri,
    String? method,
    HttpRequestFactory request,
    Map<String, String> headers,
    String? urlProxyFilter,
  ) async {
    final decision = _getInterceptionDecision(
      uri.toString(),
      method,
      acceptHeader: headers[HttpHeaders.acceptHeader],
      urlProxyFilter: urlProxyFilter,
    );
    // print('Interception decision: ${decision.action} for ${request.url}');

    final response = InterceptionResponse(decision);

    if (decision.action == InterceptionAction.executeRequest) {
      response.httpResponse = await _executeProxyRequest(
        uri,
        method,
        request,
        headers,
      );
    }
    return response;
  }

  /// Determines the interception decision for a given request.
  InterceptionDecision _getInterceptionDecision(
    String url,
    String? method, {
    String? acceptHeader,
    String? urlProxyFilter,
  }) {
    if (_discardImageRequests(url, acceptHeader) || _discardAdRequests(url)) {
      // Decision: Block the request with a synthetic 404.
      return InterceptionDecision.syntheticResponse(
        statusCode: HttpStatus.noContent,
        contentType: 'text/plain',
        body: Uint8List(0),
      );
    }
    if (_shouldPassthroughRequest(url, method, urlProxyFilter)) {
      // Decision: Let the WebView handle it.
      return InterceptionDecision.delegateRequest();
    }
    // Decision: Proxy the request over Dart network.
    return InterceptionDecision.executeRequest();
  }

  static const _blackListedEndPoints = [
    'amazon.com/images',
    'unagi-na.amazon.com',
    'unagi.amazon.com',
    'https://app.link',
    'fls-na.amazon.com',
    'cdn.prod.metrics',
    'api/_ajax/metrics',
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

  /// Determines if a request targets an ad server and should be blocked.
  bool _discardAdRequests(String url) {
    for (final endpoint in _blackListedEndPoints) {
      if (url.contains(endpoint)) return true;
    }
    return false;
  }

  /// Determines if a request targets a static image and should be blocked.
  bool _discardImageRequests(String url, String? acceptHeader) {
    const blockedExtensions = ['.png', '.gif', '.jpg', '.jpeg'];
    return blockedExtensions.any((ext) => url.endsWith(ext)) ||
        (acceptHeader != null && acceptHeader.contains('image/'));
  }

  /// Determines if a request should be executed by the WebView without
  /// Dart interception.
  /// Returns `true` to skip interception (return null from _handleIntercept).
  bool _shouldPassthroughRequest(
    String url,
    String? method,
    String? urlProxyFilter,
  ) {
    // Pass through scripts, styles, and fonts
    const passedExtensions = ['.js', '.css', '.woff2'];

    if (passedExtensions.any((ext) => url.endsWith(ext))) {
      return true;
    }
    // Pass through non-API URLs
    if (urlProxyFilter == null ||
        urlProxyFilter.isEmpty ||
        !url.contains(urlProxyFilter)) {
      return true;
    }
    // Pass through non-GET requests
    if (method != HttpMethod.get.value) {
      return true;
    }
    return false; // Intercept all other requests.
  }

  /// Executes the proxy request using the injected HttpClient factory.
  /// This helper encapsulates the networking aspect of the interception flow.
  Future<HttpClientResponse> _executeProxyRequest(
    Uri uri,
    String? method,
    HttpRequestFactory requestFactory,
    Map<String, String>? headers,
  ) async {
    final dartRequest = await requestFactory(
      uri,
      method ?? HttpMethod.get.value,
    );
    _transferHeaders(headers, dartRequest);
    return dartRequest.close();
  }

  /// Transfers request data from `Map<String, String>`
  /// to a `HttpClientRequest`.
  ///
  /// [headers] The HTTP request headers to transfer data from.
  /// [dartRequest] The HTTP client request to transfer data to.
  static void _transferHeaders(
    Map<String, String>? headers,
    HttpClientRequest dartRequest,
  ) {
    final skipHeaders = [
      'content-length',
      'host',
      'connection',
      'accept-encoding',
    ];
    headers?.forEach((name, value) {
      if (!skipHeaders.contains(name.toLowerCase())) {
        dartRequest.headers.set(name, value);
      }
    });
  }
}
