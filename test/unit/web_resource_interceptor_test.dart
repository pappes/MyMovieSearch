import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
// FIX: Import mockito with a prefix to prevent ambiguity with 'any'
import 'package:mockito/mockito.dart' as mockito;

import 'package:my_movie_search/utilities/web_data/platform_android/web_json_extractor.dart';
import 'package:my_movie_search/utilities/web_data/web_json_extractor.dart';

import 'web_resource_interceptor_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HttpClient>(),
  MockSpec<HttpHeaders>(),
  MockSpec<WebResourceRequest>(),
  MockSpec<WebUri>(),
  MockSpec<HeadlessInAppWebView>(),
])
// === MOCK CLASSES FOR NETWORK INTERACTION ===
// Mocks for standard Dart I/O and flutter_inappwebview classes.
class ConfigurableMockHttpClientResponse extends mockito.Mock
    implements HttpClientResponse {
  final Uint8List bodyBytes;

  ConfigurableMockHttpClientResponse(this.bodyBytes);

  @override
  int get statusCode =>
      super.noSuchMethod(Invocation.getter(#statusCode), returnValue: 200)
          as int;

  @override
  HttpHeaders get headers =>
      super.noSuchMethod(
            Invocation.getter(#headers),
            returnValue: MockHttpHeaders(),
          )
          as HttpHeaders;

  // This override allows the mock to return the configured bodyBytes
  // when the `fold` method is called to read the response stream.
  @override
  Future<S> fold<S>(S initialValue, S Function(S, List<int>) combine) {
    if (S == List<int>) {
      return Future.value(bodyBytes.toList()) as Future<S>;
    }
    return Future.value(initialValue);
  }
}

class MockHttpClientRequest extends mockito.Mock implements HttpClientRequest {
  @override
  HttpHeaders get headers =>
      super.noSuchMethod(
            Invocation.getter(#headers),
            returnValue: MockHttpHeaders(),
          )
          as HttpHeaders;
}


// Default implementation of the WebView using HeadlessInAppWebView.
HeadlessInAppWebView mockWebView({
  required String initialUrl,
  required WebResourceInterceptor proxySelector,
  required void Function(InAppWebViewController, WebUri?) onLoadStop,
}) => MockHeadlessInAppWebView();

void main() {
  late WebJsonExtractorAndroid extractor;

  setUp(() {
    extractor = WebJsonExtractorAndroid.internal(
      'https://www.imdb.com/name/nm0000149/',
      (_) {},
      'FilmographyV2Pagination',
      httpClientFactory: () => MockHttpClient(),
      webViewRunner: mockWebView,
    );
  });
  // Helper function to create a mock request
  WebResourceRequest createMockRequest({
    required String url,
    String method = 'GET',
    Map<String, String>? headers,
  }) {
    final mockUri = MockWebUri();
    mockito.when(mockUri.uriValue).thenReturn(Uri.parse(url));

    final mockRequest = MockWebResourceRequest();
    mockito.when(mockRequest.url).thenReturn(mockUri);
    mockito.when(mockRequest.method).thenReturn(method);
    mockito.when(mockRequest.headers).thenReturn(headers);
    return mockRequest;
  }

  group('getInterceptionDecision (Parent Logic Tests)', () {
    test('should return SyntheticResponse (204) for image requests', () {
      const url = 'https://example.com/image.png';
      final request = createMockRequest(url: url, method: 'GET');
      final decision = extractor.getInterceptionDecision(url, request.method);

      expect(decision.action, InterceptionAction.syntheticResponse);
      expect(decision.statusCode, 204);
      expect(decision.contentType, 'text/plain');
      expect(decision.body, Uint8List(0));
    });

    test('should return Passthrough for CSS resources', () {
      const url = 'https://example.com/styles.css';
      final request = createMockRequest(url: url, method: 'GET');
      final decision = extractor.getInterceptionDecision(url, request.method);

      expect(decision.action, InterceptionAction.delegateRequest);
    });

    test('should return Passthrough for non-/api/ URLs', () {
      const url = 'https://example.com/home';
      final request = createMockRequest(url: url, method: 'GET');
      final decision = extractor.getInterceptionDecision(url, request.method);

      expect(decision.action, InterceptionAction.delegateRequest);
    });

    test(
      'should return Passthrough for POST requests (if not explicitly targeted)',
      () {
        const url = 'https://example.com/api/submit';
        final request = createMockRequest(url: url, method: 'POST');
        final decision = extractor.getInterceptionDecision(url, request.method);

        expect(decision.action, InterceptionAction.delegateRequest);
      },
    );

    test('should return ProxyNetwork for valid API GET requests', () {
      const url = 'https://example.com/api/data/FilmographyV2Pagination?param=1';
      final request = createMockRequest(url: url, method: 'GET');
      final decision = extractor.getInterceptionDecision(url, request.method);

      expect(decision.action, InterceptionAction.executeRequest);
    });
  });

  group('transferResponseData (Network Response Translation)', () {
    test(
      'should correctly map HttpClientResponse to WebResourceResponse',
      () async {
        // Arrange
        const responseBody = '{"status": "ok"}';
        final bodyBytes = Uint8List.fromList(responseBody.codeUnits);

        final mockResponse = ConfigurableMockHttpClientResponse(bodyBytes);
        final mockHeaders = MockHttpHeaders();

        // Mock the headers behavior
        mockito.when(mockHeaders.contentType).thenReturn(ContentType.json);

        // Mockito 5.x: Use when(...).thenAnswer(...) for forEach
        mockito.when(mockHeaders.forEach(mockito.any)).thenAnswer((invocation) {
          final action =
              invocation.positionalArguments[0]
                  as void Function(String, List<String>);
          action('Content-Type', ['application/json']);
          action('Set-Cookie', ['session=abc']);
        });

        // Mock the response behavior
        mockito.when(mockResponse.statusCode).thenReturn(200);
        mockito.when(mockResponse.headers).thenReturn(mockHeaders);

        // Act
        final webResponse = await extractor.transferResponseData(
          MockWebResourceRequest(),
          mockResponse,
        );

        // Assert
        expect(webResponse.statusCode, 200);
        expect(webResponse.contentType, 'application/json');
        expect(webResponse.data, bodyBytes);
        expect(webResponse.headers, {
          'Content-Type': 'application/json',
          'Set-Cookie': 'session=abc',
        });
      },
    );
  });

  group('transferRequestData (Header Translation)', () {
    test('should transfer necessary headers and skip blocked ones', () {
      // Setup: Mock the platform request
      final mockPlatformRequest = createMockRequest(
        url: 'https://example.com',
        headers: {
          'Authorization': 'Bearer 123',
          'User-Agent': 'TestClient',
          'Content-Length': '100', // Should be skipped
          'Host': 'example.com', // Should be skipped
          'X-Custom-Header': 'CustomValue',
        },
      );

      final mockDartRequest = MockHttpClientRequest();
      final mockHeaders = MockHttpHeaders();
      mockito.when(mockDartRequest.headers).thenReturn(mockHeaders);
      // Stub set method on mockHeaders
      mockito.when(mockHeaders.set(mockito.any, mockito.any)).thenReturn(null);

      // Execute the function
      WebJsonExtractorAndroid.transferRequestData(
        mockPlatformRequest,
        mockDartRequest,
      );

      // Assertions: Verify the set method was called only for allowed headers
      mockito.verify(mockHeaders.set('Authorization', 'Bearer 123')).called(1);
      mockito.verify(mockHeaders.set('User-Agent', 'TestClient')).called(1);
      mockito
          .verify(mockHeaders.set('X-Custom-Header', 'CustomValue'))
          .called(1);

      // Verify that headers in the blocklist were never set.
      mockito.verifyNever(mockHeaders.set('Content-Length', '100'));
      mockito.verifyNever(mockHeaders.set('Host', 'example.com'));
    });
  });
}
