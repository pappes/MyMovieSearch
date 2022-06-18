import 'dart:convert';

import 'package:flutter/foundation.dart';
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

import 'test_helper.dart';
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

  /// Convert webtext to a traversable tree of [Map] data.
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async {
    final tree = jsonDecode(webText);

    return [tree];
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

/// Make dummy html results for offline queries.
Future<Stream<String>> _offlineSearch(dynamic criteria) async {
  criteria as SearchCriteriaDTO;
  return _getOfflineHTML(criteria.criteriaTitle);
}

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (int i = 0; i < qty; i++) {
    results.add((1000 + i).toString());
  }
  return results;
}

/// Build a live IMDB url and route Javascript requests through a HTTP tunnel.
Uri constructURI(String searchText) {
  _currentCriteria = searchText;
  const baseURL = 'https://www.imdb.com/title/';
  const baseURLsuffix = '/?ref_=fn_tt_tt_1';
  final titleId = searchText.padLeft(7, '0');
  var url = '${baseURL}tt$titleId$baseURLsuffix';

  // Route web requests through a tunnel if using the Javascript
  // XMLHttpRequest http client library.
  if (kIsWeb) {
    url = 'http://localhost:8080?origin=https://www.imdb.com&'
        'referer=https://www.imdb.com/&'
        'destination=${Uri.encodeQueryComponent(url)}';
  }

  // ignore: avoid_print
  print('fetching redirected details $url');
  return Uri.parse(url);
}

/// Retrieve HTML from IMDB.
Future<Stream<String>> _onlineSearch(dynamic criteria) async {
  final SearchCriteriaDTO criteriaText = criteria as SearchCriteriaDTO;
  final encoded = Uri.encodeQueryComponent(criteriaText.criteriaTitle);
  final address = constructURI(encoded);

  final client = await HttpClient().getUrl(address);
  final request = client.close();

  HttpClientResponse response;
  try {
    response = await request;
  } catch (error, stackTrace) {
    // ignore: avoid_print
    print('Error in web_fetch read: $error\n${stackTrace.toString()}');
    rethrow;
  }
  // Check for successful HTTP status before transforming (avoid HTTP 404)
  if (200 != response.statusCode) {
    // ignore: avoid_print
    print(
      'Error in http read, HTTP status code : ${response.statusCode} for address',
    );
    return _offlineSearch(criteria);
  }
  return response.transform(utf8.decoder);
}

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(
  List<String> queries,
  bool online,
) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO();
    final imdbDetails =
        QueryIMDBTitleDetailsMocked(); //Seperate instance per search (async)
    criteria.criteriaTitle = queryKey;
    final future = imdbDetails.readList(
      criteria,
      source: online ? _onlineSearch : _offlineSearch,
    );
    futures.add(future);
  }
  return futures;
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Non Mocked Unit tests
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
            startsWith: '<!DOCTYPE html>\n<html>',
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
      /*final expectedStream2 = emitStringChars(expectedValue).printStream();
      final expectedStream = expectedStream2.printStream();
      final expectedList = await expectedStream.toList();*/
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

////////////////////////////////////////////////////////////////////////////////
  /// Mocked Unit(integration) tests
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchBase ReadList', () {
    Future<void> testRead(
      List<String> criteria,
      List<MovieResultDTO> expectedValue, {
      bool online = true,
    }) async {
      // Call IMDB for each criteria in the list.
      final futures = _queueDetailSearch(criteria, online);

      // Collect the result of all the IMDB queries.
      final queryResult = <MovieResultDTO>[];
      for (final future in futures) {
        future.then((value) => queryResult.addAll(value));
      }
      for (final future in futures) {
        await future;
      }

      // Compare IMDB results to expectations.
      if (!online) {
        expect(
          queryResult,
          MovieResultDTOListMatcher(expectedValue),
          reason: 'Emmitted DTO list ${queryResult.toString()} '
              'needs to match expected DTO list ${expectedValue.toString()}',
        );
      }
    }

    // Convert 1 sample offline page into a dto.
    test('Run read 1 offline page', () async {
      final queries = _makeQueries(1);
      final queryResult = _makeDTOs(queries.length);
      await testRead(queries, queryResult, online: false);
    });

    // Convert 300 sample offline pages into dtos.
    test('Run read 300 offline pages', () async {
      final queries = _makeQueries(300);
      final queryResult = _makeDTOs(queries.length);
      await testRead(queries, queryResult, online: false);
    });

    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from mocked IMDB', () async {
      final queries = _makeQueries(3);
      final queryResult = _makeDTOs(queries.length);
      await testRead(queries, queryResult);
    });

    // Convert 300 IMDB pages into dtos!!!
    test(
      'Run read 300 pages from mocked IMDB',
      () async {
        final queries = _makeQueries(300);
        final queryResult = _makeDTOs(queries.length);
        await testRead(queries, queryResult);
      },
      timeout: const Timeout(Duration(seconds: 40)),
    );
  });
}
