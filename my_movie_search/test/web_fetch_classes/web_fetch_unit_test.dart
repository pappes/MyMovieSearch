import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/utilities/extensions/stream_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

import 'package:universal_io/io.dart'
    show HttpClient, HttpClientRequest, HttpClientResponse, HttpHeaders;

import '../test_helper.dart';
import 'web_fetch_unit_test.mocks.dart';

////////////////////////////////////////////////////////////////////////////////
/// Mock http.Client
////////////////////////////////////////////////////////////////////////////////

// To regenertate mocks run the following command
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([HttpClient, HttpClientRequest, HttpClientResponse, HttpHeaders])
String _currentCriteria = '';

//HttpClient.getUrl(Uri) = Future<HttpClientRequest>
//HttpClientRequest.close() = HttpClientResponse
//HttpClientResponse.statusCode = 200
//HttpClientResponse.transform(utf8.decoder) = stream<String>
//myConstructHeaders(client.headers);
class QueryIMDBTitleDetailsMocked extends QueryIMDBTitleDetails {
  /// Returns a new [HttpClient] instance to allow mocking in tests.
  @override
  HttpClient myGetHttpClient() {
    final client = MockHttpClient();
    final clientRequest = MockHttpClientRequest();
    final clientResponse = MockHttpClientResponse();
    final headers = MockHttpHeaders();

    // Use Mockito to return a successful response when it calls the
    // provided HttpClient.
    when(clientResponse.statusCode).thenAnswer((_) => 200);
    when(clientResponse.transform(utf8.decoder))
        .thenAnswer((_) => _getOfflineHTML(_currentCriteria));

    when(clientRequest.close()).thenAnswer((_) async => clientResponse);

    when(client.getUrl(any)).thenAnswer((_) async => clientRequest);
    when(clientRequest.headers).thenAnswer((_) => headers);

    return client;
  }

  /// Convert dart [Map] to [OUTPUT_TYPE] object data.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    map as Map;
    final result = MovieResultDTO();
    result.source = DataSourceType.imdb;
    result.uniqueId = map[outerElementIdentity]?.toString() ?? '';
    result.description = map[outerElementDescription]?.toString() ?? '';
    return [result];
  }
}

/// Make dummy dto results for offline queries.
List<MovieResultDTO> _makeDTOs(int qty) {
  final results = <MovieResultDTO>[];
  for (int i = 0; i < qty; i++) {
    final uniqueId = 1000 + i;
    results.add(
      {
        'source': DataSourceType.imdb.toString(),
        'uniqueId': '$uniqueId',
        'description': '$uniqueId.',
      }.toMovieResultDTO(),
    );
  }
  return results;
}

/// Make dummy dto results for offline queries.
List<Map> _makeMaps(int qty) {
  final results = <Map>[];
  for (int i = 0; i < qty; i++) {
    final uniqueId = 1000 + i;
    results.add(
      {
        outerElementIdentity: '$uniqueId',
        outerElementDescription: '$uniqueId.',
      },
    );
  }
  return results;
}

/// Make dummy html results for offline queries.
Stream<String> _getOfflineHTML(String id) {
  if (id == '') return Stream.value('');
  return Stream.value(
    '''
<!DOCTYPE html>
<html>
    <head>
      <script type="application/ld+json">{
        "description": "$id." }
      </script>
    </head>
    <body>
    </body>
</html>
''',
  );
}

/// Make dummy josn results for offline queries.
String _makeJson(int qty) {
  final results = StringBuffer();
  results.write('[');
  for (int i = 0; i < qty; i++) {
    if (i > 0) results.write(', \n  ');
    results.write('{"id": "${1000 + i}","description": "${1000 + i}."}');
  }
  results.write(']');
  return results.toString();
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Non Mocked Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchBase simple unit tests', () {
    final testClass = QueryIMDBTitleDetailsMocked();

    // Default data source name.
    test('myDataSourceName()', () {
      expect(testClass.myDataSourceName(), 'imdb');
    });
    // Simple criteria text.
    test('myFormatInputAsText()', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'criteria';
      expect(testClass.myFormatInputAsText(input), 'criteria');
    });
    // Default not cached.
    test('myIsResultCached()', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'criteria';
      expect(testClass.myIsResultCached(input), false);
    });
    // Default not stale cache.
    test('myIsCacheStale()', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'criteria';
      expect(testClass.myIsCacheStale(input), false);
    });
    // Default no cacheing.
    test('myIsResultCached()', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'criteria';
      //testClass.myAddResultToCache(input);
      expect(testClass.myIsResultCached(input), false);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Mocked Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchBase baseConvertTreeToOutputType', () {
    Future<void> testConvert(
      List<Map> input,
      List<MovieResultDTO>? expectedValue, [
      String? expectedError,
    ]) async {
      final pageMap = Stream.fromIterable(input);
      final actualOutput =
          QueryIMDBTitleDetailsMocked().baseConvertTreeToOutputType(pageMap);
      if (null != expectedValue) {
        final expectedMatchers =
            expectedValue.map((e) => MovieResultDTOMatcher(e));
        expectLater(actualOutput, emitsInOrder(expectedMatchers));
      }
    }

    // Convert 0 maps into dtos.
    test('empty input', () async {
      final input = [<String, dynamic>{}];
      final output = <MovieResultDTO>[];
      await testConvert(input, output);
    });
    // Convert 1 map into a dto.
    test(
      'single map input',
      () async {
        final input = _makeMaps(1);
        final output = _makeDTOs(1);
        await testConvert(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
    // Convert multiple maps into dtos.
    test(
      'multiple map input',
      () async {
        final input = _makeMaps(100);
        final output = _makeDTOs(100);
        await testConvert(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  group('WebFetchBase baseConvertWebTextToTraversableTree', () {
    Future<void> testConvert(
      String input,
      List<dynamic>? expectedValue, [
      String? expectedError,
    ]) async {
      final jsonStream = Stream.value(input);
      final actualOutput = QueryIMDBTitleDetailsMocked()
          .baseConvertWebTextToTraversableTree(jsonStream);
      if (null != expectedValue) {
        expectLater(actualOutput, emitsInOrder(expectedValue));
      }
    }

    // Convert 0 json maps into a trees.
    test('empty input', () async {
      final input = _makeJson(0);
      final output = _makeMaps(0);
      await testConvert(input, [output]);
    });
    // Convert 1 json map into a tree.
    test(
      'single map input',
      () async {
        final input = _makeJson(1);
        final output = _makeMaps(1);
        await testConvert(input, [output]);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
    // Convert multiple json maps into a trees.
    test(
      'multiple map input',
      () async {
        final input = _makeJson(10);
        final output = _makeMaps(10);
        await testConvert(input, [output]);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  group('WebFetchBase baseFetchWebText', () {
    Future<void> testConvert(
      String input,
      String expectedValue, [
      String? expectedError,
    ]) async {
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = input;
      _currentCriteria = input;
      final testClass = QueryIMDBTitleDetailsMocked();

      final actualOutput = await testClass.baseFetchWebText(criteria);
      await expectLater(
        actualOutput.printStream(input),
        emitsInOrder([
          containsSubstring(
            expectedValue,
            startsWith: input == '' ? '' : '<!DOCTYPE html>\n<html>',
          )
        ]),
      );
    }

    // Convert empty input to empty output.
    test('empty input', () async {
      const input = '';
      const output = '';
      await testConvert(input, output);
    });
    // Convert 1 json map into a tree.
    test(
      'mocked http call',
      () async {
        const input = '1234';
        const output = '1234.';
        await testConvert(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  group('WebFetchBase myConvertCriteriaToWebText', () {
    Future<void> testConvert(
      String input,
      String expectedValue, [
      String? expectedError,
    ]) async {
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = input;
      _currentCriteria = input;
      final testClass = QueryIMDBTitleDetailsMocked();

      final actualOutput = await testClass.myConvertCriteriaToWebText(criteria);
      await expectLater(
        actualOutput,
        emitsInOrder([
          containsSubstring(
            expectedValue,
            startsWith: input == '' ? '' : '<!DOCTYPE html>\n<html>',
          )
        ]),
      );
    }

    // Convert empty input to empty output.
    test('empty input', () async {
      const input = '';
      const output = '';
      await testConvert(input, output);
    });
    // Convert 1 json map into a tree.
    test(
      'mocked http call',
      () async {
        const input = '1234';
        const output = '1234.';
        await testConvert(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });
  group('WebFetchBase baseConvertCriteriaToWebText', () {
    Future<void> testConvert(
      String input,
      String expectedValue, [
      String? expectedError,
    ]) async {
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = input;
      _currentCriteria = input;
      final testClass = QueryIMDBTitleDetailsMocked();
      final actualOutput = testClass
          .baseConvertCriteriaToWebText(criteria)
          .printStream('testConvert1:');
      await expectLater(
        actualOutput,
        emitsInOrder([
          containsSubstring(
            expectedValue,
            startsWith: input == '' ? '' : '<!DOCTYPE html>\n<html>',
          ),
        ]),
      );
    }

    // Convert empty input to empty output.
    test('empty input', () async {
      const input = '';
      const output = '';
      await testConvert(input, output);
    });
    // Convert 1 json map into a tree.
    test(
      'mocked http call',
      () async {
        const input = '1234';
        const output = '1234.';
        await testConvert(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });
}
