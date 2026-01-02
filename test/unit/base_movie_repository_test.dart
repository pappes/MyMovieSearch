import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

// Generate mocks for dependencies.
// Run 'dart run build_runner build' to generate this file.
@GenerateNiceMocks([
  MockSpec<SearchCriteriaDTO>(),
  MockSpec<WebFetchBase<MovieResultDTO, SearchCriteriaDTO>>(),
])
import 'base_movie_repository_test.mocks.dart';

/// A concrete implementation of [BaseMovieRepository] for testing purposes.
/// Allows injecting mock providers and simulating errors.
class TestMovieRepository extends BaseMovieRepository {
  TestMovieRepository({
    Map<WebFetchBase<MovieResultDTO, SearchCriteriaDTO>, int> providers =
        const {},
    bool shouldThrow = false,
  }) : _providers = providers,
       _shouldThrow = shouldThrow;

  final Map<WebFetchBase<MovieResultDTO, SearchCriteriaDTO>, int> _providers;
  final bool _shouldThrow;

  @override
  Map<WebFetchBase<MovieResultDTO, SearchCriteriaDTO>, int> getProviders() {
    if (_shouldThrow) {
      throw Exception('Simulated provider error');
    }
    return _providers;
  }
}

void main() {
  group('BaseMovieRepository', () {
    late TestMovieRepository repository;
    late MockSearchCriteriaDTO mockCriteria;

    setUp(() {
      mockCriteria = MockSearchCriteriaDTO();
      // Setup default behavior for mockCriteria to avoid null errors.
      when(mockCriteria.criteriaList).thenReturn([]);
      // We assume SearchCriteriaType is an enum. If the mock returns null,
      // it won't match specific enum values (like barcode), 
      // which is fine for defaults.
    });

    test('search emits "Searching ..." indicator immediately', () async {
      repository = TestMovieRepository();

      final stream = repository.search(mockCriteria);
      final first = await stream.take(1).first;

      expect(first.title, equals('Searching ...'));
    });

    test('search handles errors during initialization', () async {
      // Create a repository that throws when getting providers.
      // This simulates an error inside the unawaited initSearch future.
      repository = TestMovieRepository(shouldThrow: true);

      final stream = repository.search(mockCriteria);

      // The error should be caught by handleError and emitted as a result.
      await expectLater(
        stream,
        emitsThrough(
          predicate<MovieResultDTO>(
            (dto) => dto.title.contains('Error in BaseMovieRepository'),
          ),
        ),
      );
    });

    test('close terminates the stream', () async {
      repository = TestMovieRepository();
      final stream = repository.search(mockCriteria);

      // We need to listen to the stream to ensure it's active.
      final subscription = stream.listen((_) {});

      await repository.close();

      // Verify the subscription completes.
      await expectLater(subscription.asFuture<void>(), completes);
      unawaited(subscription.cancel());
    });

    test('search calls providers when configured', () async {
      final mockProvider =
          MockWebFetchBase<MovieResultDTO, SearchCriteriaDTO>();
      repository = TestMovieRepository(providers: {mockProvider: 10});

      // Setup mock provider to return a future.
      when(
        mockProvider.readList(limit: anyNamed('limit')),
      ).thenAnswer((_) async => <MovieResultDTO>[]);

      // Trigger search.
      repository.search(mockCriteria).listen((_) {});

      // Allow async tasks to run.
      await Future<void>.delayed(Duration.zero);

      // Verify provider was called with the correct limit.
      verify(mockProvider.readList(limit: 10)).called(1);
    });
  });
}
