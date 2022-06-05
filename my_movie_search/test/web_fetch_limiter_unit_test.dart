import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/utilities/web_data/src/web_fetch_limiter.dart';

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Mocked Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchLimiter', () {
    test('consume 1 result from default limit', () async {
      final l = WebFetchLimiter();
      expect(l.currentUsage, 0, reason: 'initial usage');
      expect(l.limit, 100, reason: 'initial limit');
      final consumed = l.consume();
      expect(consumed, 1, reason: 'qty consumed');
      expect(l.currentUsage, 1, reason: 'final usage');
      expect(l.limit, 100, reason: 'final limit');
    });
    test('consume all results from default limit', () async {
      final l = WebFetchLimiter();
      expect(l.currentUsage, 0, reason: 'initial usage');
      expect(l.limit, 100, reason: 'initial limit');
      final consumed = l.consume(100);
      expect(consumed, 100, reason: 'qty consumed');
      expect(l.currentUsage, 100, reason: 'final usage');
      expect(l.limit, 100, reason: 'final limit');
    });
    test('consume too many results from default limit', () async {
      final l = WebFetchLimiter();
      expect(l.currentUsage, 0, reason: 'initial usage');
      expect(l.limit, 100, reason: 'initial limit');
      final consumed = l.consume(200);
      expect(consumed, 100, reason: 'qty consumed');
      expect(l.currentUsage, 100, reason: 'final usage');
      expect(l.limit, 100, reason: 'final limit');
    });
    test('non default limit from constructor', () async {
      final l = WebFetchLimiter(10);
      expect(l.currentUsage, 0, reason: 'initial usage');
      expect(l.limit, 10, reason: 'initial limit');
      final consumed = l.consume(200);
      expect(consumed, 10, reason: 'qty consumed');
      expect(l.currentUsage, 10, reason: 'final usage');
      expect(l.limit, 10, reason: 'final limit');
    });
    test('non default limit from setter', () async {
      final l = WebFetchLimiter();
      l.limit = 10;
      expect(l.currentUsage, 0, reason: 'initial usage');
      expect(l.limit, 10, reason: 'initial limit');
      final consumed = l.consume(200);
      expect(consumed, 10, reason: 'qty consumed');
      expect(l.currentUsage, 10, reason: 'final usage');
      expect(l.limit, 10, reason: 'final limit');
    });
  });
}
