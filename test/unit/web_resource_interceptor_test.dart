import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
// FIX: Import mockito with a prefix to prevent ambiguity with 'any'
import 'package:mockito/mockito.dart' as mockito;
import 'package:mockito/annotations.dart';

import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/imdb_sha_extractor.dart';
import 'package:my_movie_search/utilities/web_data/platform_android/imdb_sha_extractor.dart';
import 'web_resource_interceptor_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HttpClient>(),
  MockSpec<HttpHeaders>(),
  MockSpec<WebResourceRequest>(),
  MockSpec<WebUri>(),
])
// === MOCK CLASSES FOR NETWORK INTERACTION ===
// Mocks for standard Dart I/O and flutter_inappwebview classes.
class MockHttpClientResponse extends mockito.Mock
    implements HttpClientResponse {
  // Add a fallback for `fold` to satisfy the type system.
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
  // For the test, always return the expected bytes for fold
  @override
  Future<S> fold<S>(S initialValue, S Function(S, List<int>) combine) {
    // Only for the test case, return the bytes for '{"status": "ok"}'
    if (S == List<int>) {
      const responseBody = '{"status": "ok"}';
      final bodyBytes = Uint8List.fromList(responseBody.codeUnits);
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

void main() {
  // We use a dummy extractor instance for the test cases.
  final extractor = WebPageShaExtractorAndroid.internal(
    {},
    {},
    ImdbJsonSource.director,
  );

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
    test('should return SyntheticResponse (404) for image requests', () {
      const url = 'https://example.com/image.png';
      final request = createMockRequest(url: url, method: 'GET');
      final decision = extractor.getInterceptionDecision(url, request.method);

      expect(decision.action, InterceptionAction.syntheticResponse);
      expect(decision.statusCode, 404);
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
      const url = 'https://example.com/api/data?param=1';
      final request = createMockRequest(url: url, method: 'GET');
      final decision = extractor.getInterceptionDecision(url, request.method);

      expect(decision.action, InterceptionAction.executeRequest);
    });
  });

  group('transferResponseData (Network Response Translation)', () {
    test(
      'should correctly map HttpClientResponse to WebResourceResponse',
      () async {
        // Setup: Mock the network response
        final mockResponse = MockHttpClientResponse();
        final mockHeaders = MockHttpHeaders();

        const responseBody = '{"status": "ok"}';
        final bodyBytes = Uint8List.fromList(responseBody.codeUnits);

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

        // Execute the function
        final webResponse = await extractor.transferResponseData(mockResponse);

        // Assert the result
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
      WebPageShaExtractorAndroid.transferRequestData(
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
