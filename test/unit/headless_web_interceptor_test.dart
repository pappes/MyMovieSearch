import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mockito;

import 'package:my_movie_search/utilities/web_data/headless_web_interceptor.dart';
import 'package:my_movie_search/utilities/web_data/http_method.dart';

import 'headless_web_interceptor_test.mocks.dart';
// To regenerate mocks run the following command
// flutter pub run build_runner build --delete-conflicting-outputs

@GenerateNiceMocks([
  MockSpec<HttpClientRequest>(),
  MockSpec<HttpClientResponse>(),
  MockSpec<HttpHeaders>(),
])
void main() {
  late HeadlessWebInterceptor interceptor;

  setUp(() {
    interceptor = HeadlessWebInterceptor();
  });

  group('Interception Decision Logic', () {
    test('should return SyntheticResponse (204) for ad requests', () async {
      const url = 'https://doubleclick.net/ad';
      final uri = Uri.parse(url);

      final response = await interceptor.shouldProxyUrl(
        uri,
        HttpMethod.get.value,
        (_, _) => throw UnimplementedError(),
        {},
        null,
      );

      expect(response.decision.action, InterceptionAction.syntheticResponse);
      expect(response.decision.statusCode, HttpStatus.noContent);
      expect(response.decision.contentType, 'text/plain');
      expect(response.decision.body, Uint8List(0));
    });

    test(
      'should return SyntheticResponse (204) for image requests by extension',
      () async {
        const url = 'https://example.com/image.png';
        final uri = Uri.parse(url);

        final response = await interceptor.shouldProxyUrl(
          uri,
          HttpMethod.get.value,
          (_, _) => throw UnimplementedError(),
          {},
          null,
        );

        expect(response.decision.action, InterceptionAction.syntheticResponse);
        expect(response.decision.statusCode, HttpStatus.noContent);
      },
    );

    test(
      'should return SyntheticResponse (204) for image requests by header',
      () async {
        const url = 'https://example.com/image';
        final uri = Uri.parse(url);

        final response = await interceptor.shouldProxyUrl(
          uri,
          HttpMethod.get.value,
          (_, _) => throw UnimplementedError(),
          {
            'accept':
                'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
          },
          null,
        );

        expect(response.decision.action, InterceptionAction.syntheticResponse);
        expect(response.decision.statusCode, HttpStatus.noContent);
      },
    );

    test('should return DelegateRequest for CSS resources', () async {
      const url = 'https://example.com/styles.css';
      final uri = Uri.parse(url);

      final response = await interceptor.shouldProxyUrl(
        uri,
        HttpMethod.get.value,
        (_, _) => throw UnimplementedError(),
        {},
        null,
      );

      expect(response.decision.action, InterceptionAction.delegateRequest);
    });

    test(
      'should return DelegateRequest when url proxy filter is not set',
      () async {
        const url = 'https://example.com/home';
        final uri = Uri.parse(url);

        final response = await interceptor.shouldProxyUrl(
          uri,
          HttpMethod.get.value,
          (_, _) => throw UnimplementedError(),
          {},
          null,
        );

        expect(response.decision.action, InterceptionAction.delegateRequest);
      },
    );

    test(
      'should return DelegateRequest when url does not match filter',
      () async {
        const urlProxyFilter = 'MyFilter';
        const url = 'https://example.com/home';
        final uri = Uri.parse(url);

        final response = await interceptor.shouldProxyUrl(
          uri,
          HttpMethod.get.value,
          (_, _) => throw UnimplementedError(),
          {},
          urlProxyFilter,
        );

        expect(response.decision.action, InterceptionAction.delegateRequest);
      },
    );

    test('should return DelegateRequest for non-GET requests', () async {
      const urlProxyFilter = 'MyFilter';
      const url = 'https://example.com/api/MyFilter';
      final uri = Uri.parse(url);

      final response = await interceptor.shouldProxyUrl(
        uri,
        HttpMethod.post.value,
        (_, _) => throw UnimplementedError(),
        {},
        urlProxyFilter,
      );

      expect(response.decision.action, InterceptionAction.delegateRequest);
    });
  });

  group('Proxy Request Execution', () {
    test('should execute proxy request for matching GET requests', () async {
      const urlProxyFilter = 'FilmographyV2Pagination';
      const url =
          'https://example.com/api/data/FilmographyV2Pagination?param=1';
      final uri = Uri.parse(url);

      final mockRequest = MockHttpClientRequest();
      final mockHeaders = MockHttpHeaders();
      mockito.when(mockRequest.headers).thenReturn(mockHeaders);

      final mockResponse = MockHttpClientResponse();
      mockito.when(mockRequest.close()).thenAnswer((_) async => mockResponse);

      final response = await interceptor.shouldProxyUrl(
        uri,
        HttpMethod.get.value,
        (requestedUri, requestedMethod) async {
          expect(requestedUri, uri);
          expect(requestedMethod, HttpMethod.get.value);
          return mockRequest;
        },
        {'Authorization': 'Bearer 123', 'content-length': '100'},
        urlProxyFilter,
      );

      expect(response.decision.action, InterceptionAction.executeRequest);
      expect(response.httpResponse, mockResponse);

      // Verify header transfer, skipping blocked headers
      mockito.verify(mockHeaders.set('Authorization', 'Bearer 123')).called(1);
      mockito.verifyNever(mockHeaders.set('content-length', mockito.any));
    });
  });
}
