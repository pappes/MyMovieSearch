import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
// FIX: Import mockito with a prefix to prevent ambiguity with 'any'
import 'package:mockito/mockito.dart' as mockito;

import 'package:my_movie_search/utilities/web_data/platform_android/headless_web_engine.dart';

import 'web_resource_interceptor_test.mocks.dart';


// To regenerate mocks run the following command
// flutter pub run build_runner build --delete-conflicting-outputs

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
  ConfigurableMockHttpClientResponse(this.bodyBytes);

  final Uint8List bodyBytes;

  @override
  int get statusCode =>
      super.noSuchMethod(
            Invocation.getter(#statusCode),
            returnValue: HttpStatus.ok,
          )
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

// Default implementation of the WebView using HeadlessInAppWebView.
HeadlessInAppWebView mockWebView({
  required String initialUrl,
  required Proxyselector proxySelector,
  required void Function(InAppWebViewController, WebUri?) onLoadStop,
  required void Function(
    InAppWebViewController,
    WebResourceRequest,
    WebResourceError,
  )
  onReceivedError,
  Map<String, String>? headers,
}) => MockHeadlessInAppWebView();

void main() {
  late HeadlessWebEngineAndroid extractor;

  setUp(() {
    extractor =
        HeadlessWebEngineAndroid(
          httpClientFactory: MockHttpClient.new,
          webViewRunner: mockWebView,
        )..run(
          url: 'https://www.imdb.com/name/nm0000149/',
          urlInterceptFilter: 'FilmographyV2Pagination',
          onEngineData: (_) {},
        );
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
        mockito.when(mockResponse.statusCode).thenReturn(HttpStatus.ok);
        mockito.when(mockResponse.headers).thenReturn(mockHeaders);

        // Act
        final webResponse = await extractor.transferResponseData(
          MockWebResourceRequest(),
          mockResponse,
        );

        // Assert
        expect(webResponse.statusCode, HttpStatus.ok);
        expect(webResponse.contentType, 'application/json');
        expect(webResponse.data, bodyBytes);
        expect(webResponse.headers, {
          'Content-Type': 'application/json',
          'Set-Cookie': 'session=abc',
        });
      },
    );
  });

}
