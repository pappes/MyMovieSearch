// Tests are allowed to use visible_for_overriding members
// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter_test/flutter_test.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/ms_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/ms_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/ms_search.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';
import 'package:universal_io/io.dart';
import '../../../test_helper.dart';
import 'mssearch_test.mocks.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(_) =>
    Future.value(Stream.value('{"hello":"world"}'));

Future<Stream<String>> _emitInvalidJsonSample(_) =>
    Future.value(Stream.value('not valid json'));

final criteria = SearchCriteriaDTO().fromString('123');

@GenerateMocks([MeiliSearchClient])
@GenerateMocks([MeiliSearchIndex])
@GenerateMocks([Searcheable])
void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
  ////////////////////////////////////////////////////////////////////////////////

  group('MsSearch search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(QueryMsSearchMovies(criteria).myDataSourceName(), 'mssearch');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryMsSearchMovies(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO()
        ..criteriaList = [
          MovieResultDTO().error('test1'),
          MovieResultDTO().error('test2'),
        ];
      expect(
        QueryMsSearchMovies(input).myFormatInputAsText(),
        contains('test1'),
      );
      expect(
        QueryMsSearchMovies(input).myFormatInputAsText(),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'bestSource': 'DataSourceType.mssearch',
        'title': '[QueryMsSearchMovies] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult = QueryMsSearchMovies(
        criteria,
      ).myYieldError('new query').toMap()..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm web text is parsed as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      final expectedOutput = intermediateMapList;
      final actualOutput = QueryMsSearchMovies(
        criteria,
      ).myConvertWebTextToTraversableTree(jsonSampleFull);
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () {
      final expectedOutput = intermediateEmptyMapList;
      final actualOutput = QueryMsSearchMovies(
        criteria,
      ).myConvertWebTextToTraversableTree(jsonSampleEmpty);
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results', () {
      final expectedOutput = intermediateErrorMapList;
      final actualOutput = QueryMsSearchMovies(
        criteria,
      ).myConvertWebTextToTraversableTree(jsonSampleError);
      expect(actualOutput, completion(expectedOutput));
    });
  });

  group('MsSearchMovieSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () async {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          await MsSearchMovieSearchConverter.dtoFromCompleteJsonMap(
            map as List,
          ).toList(),
        );
      }

      // Uncomment this line to update expectedDTOList if sample data changes
      // printTestData(actualResult);

      final expectedValue = expectedDTOList;
      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
  });

  group('QueryMsSearchMovies', () {
    late QueryMsSearchMovies queryMsSearchMovies;
    late MockMeiliSearchClient mockMeiliSearchClient;
    late MockMeiliSearchIndex mockIndex;
    late MockSearcheable<Map<String, dynamic>> mockSearcheable;
    late SearchCriteriaDTO criteria;

    setUp(() {
      Settings().init();
      mockMeiliSearchClient = MockMeiliSearchClient();
      mockIndex = MockMeiliSearchIndex();
      mockSearcheable = MockSearcheable();
      criteria = SearchCriteriaDTO()
        ..init(SearchCriteriaType.movieTitle, title: 'test');
      queryMsSearchMovies = QueryMsSearchMovies(criteria);
    });

    test('fetchFromApi - success', () async {
      when(mockMeiliSearchClient.index(any)).thenReturn(mockIndex);
      when(
        mockIndex.search(any),
      ).thenAnswer((_) => Future.value(mockSearcheable));
      when(mockSearcheable.hits).thenReturn([
        {'title': 'Test Movie 1'},
        {'title': 'Test Movie 2'},
      ]);
      when(mockSearcheable.processingTimeMs).thenReturn(100);

      final result = await queryMsSearchMovies.fetchFromApi(
        mockMeiliSearchClient,
      );

      expect(result, isA<List<dynamic>>());
      expect(result.length, 2);
    });

    test('fetchFromApi - bad API key', () {
      when(mockMeiliSearchClient.index(any)).thenReturn(mockIndex);
      when(
        mockIndex.search(any),
      ).thenThrow(const SocketException(msErrorBadApiKey));

      expect(
        () => queryMsSearchMovies.fetchFromApi(mockMeiliSearchClient),
        throwsA(
          isInstanceOf<SocketException>().having(
            (e) => e.message,
            'message',
            'The provided API key is invalid',
          ),
        ),
      );
    });

    test('fetchFromApi - generic exception', () {
      when(mockMeiliSearchClient.index(any)).thenReturn(mockIndex);
      when(
        mockIndex.search(any),
      ).thenThrow(const SocketException(msErrorServerDown));

      expect(
        () => queryMsSearchMovies.fetchFromApi(mockMeiliSearchClient),
        throwsA(
          isInstanceOf<SocketException>().having(
            (e) => e.message,
            'message',
            msErrorServerDown,
          ),
        ),
      );
    });

    test('fetchFromApi - server down', () {
      when(mockMeiliSearchClient.index(any)).thenReturn(mockIndex);
      when(
        mockIndex.search(any),
      ).thenThrow(CommunicationException(msErrorServerDown));

      expect(
        () => queryMsSearchMovies.fetchFromApi(mockMeiliSearchClient),
        throwsA(
          isInstanceOf<SocketException>().having(
            (e) => e.message,
            'message',
            errServerDown,
          ),
        ),
      );
    });

    test('fetchFromApi - cloud refused', () {
      when(mockMeiliSearchClient.index(any)).thenReturn(mockIndex);
      when(
        mockIndex.search(any),
      ).thenThrow(MeiliSearchApiException(msErrorCloudRefused));

      expect(
        () => queryMsSearchMovies.fetchFromApi(mockMeiliSearchClient),
        throwsA(
          isInstanceOf<SocketException>().having(
            (e) => e.message,
            'message',
            errCloudRefused,
          ),
        ),
      );
    });

    test('fetchFromApi - invalid api key', () {
      when(mockMeiliSearchClient.index(any)).thenReturn(mockIndex);
      when(
        mockIndex.search(any),
      ).thenThrow(MeiliSearchApiException(msErrorBadApiKey));

      expect(
        () => queryMsSearchMovies.fetchFromApi(mockMeiliSearchClient),
        throwsA(
          isInstanceOf<SocketException>().having(
            (e) => e.message,
            'message',
            errBadApiKey,
          ),
        ),
      );
    });
  });

  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryMsSearchMovies
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryMsSearchMovies integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final testClass = QueryMsSearchMovies(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(await testClass.myConvertTreeToOutputType(map));
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    test('Run myConvertTreeToOutputType() with empty search results', () async {
      final expectedValue = <MovieResultDTO>[];
      final testClass = QueryMsSearchMovies(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateEmptyMapList) {
        actualResult.addAll(await testClass.myConvertTreeToOutputType(map));
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () {
      final expectedOutput = throwsA(
        isA<TreeConvertException>().having(
          (e) => e.cause,
          'cause',
          startsWith(
            'expected List got String unable to interpret data wrongData',
          ),
        ),
      );
      final testClass = QueryMsSearchMovies(criteria);

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      //NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryMsSearchMovies
  ////////////////////////////////////////////////////////////////////////////////

  group('MsSearch search query', () {
    // Read MsSearch search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryMsSearchMovies(criteria);

      // Invoke the functionality.
      await testClass
          .readList(source: streamJsonOfflineData)
          .then(queryResult.addAll)
          .onError(
            // Print any errors that occur during the fetch.
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Read MsSearch search results from a simulated byte stream
    // and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryMsSearchMovies(criteria);
      const expectedException = '''
[QueryMsSearchMovies] Error in mssearch with criteria 123 convert error interpreting web text as a map :Invalid json FormatException: Unexpected character (at character 1)
not valid json
^
''';

      // Invoke the functionality.
      await testClass
          .readList(source: _emitInvalidJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read MsSearch search results from a simulated byte stream
    // and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryMsSearchMovies] Error in mssearch '
          'with criteria 123 convert error translating page map to objects '
          ':expected List got _Map<String, dynamic> unable to interpret data '
          '{hello: world}';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryMsSearchMovies(criteria);

      // Invoke the functionality.
      await testClass
          .readList(source: _emitUnexpectedJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
