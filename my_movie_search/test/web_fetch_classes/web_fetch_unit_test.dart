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
typedef ConvertWebTextToTreeFn = Future<List> Function(String t);
typedef ConvertTreeToOutputType = Future<List<MovieResultDTO>> Function(
  dynamic m,
);

//HttpClient.getUrl(Uri) = Future<HttpClientRequest>
//HttpClientRequest.close() = HttpClientResponse
//HttpClientResponse.statusCode = 200
//HttpClientResponse.transform(utf8.decoder) = stream<String>
//myConstructHeaders(client.headers);
class QueryIMDBTitleDetailsMocked extends QueryIMDBTitleDetails {
  int httpReturnCode = 200;
  String currentCriteria = '';

  /// Returns a new [HttpClient] instance to allow mocking in tests.
  @override
  HttpClient myGetHttpClient() {
    final client = MockHttpClient();
    final clientRequest = MockHttpClientRequest();
    final clientResponse = MockHttpClientResponse();
    final headers = MockHttpHeaders();

    // Use Mockito to return a successful response when it calls the
    // provided HttpClient.
    when(clientResponse.statusCode).thenAnswer((_) => httpReturnCode);
    when(clientResponse.transform(utf8.decoder))
        .thenAnswer((_) => _getOfflineHTML(currentCriteria));

    when(clientRequest.close()).thenAnswer((_) async {
      if (currentCriteria == 'EXCEPTION') throw 'go away!';
      return clientResponse;
    });

    when(client.getUrl(any)).thenAnswer((_) async => clientRequest);
    when(clientRequest.headers).thenAnswer((_) => headers);

    return client;
  }

  // Remember criteria for later
  @override
  String myFormatInputAsText(dynamic contents) {
    contents as SearchCriteriaDTO;
    currentCriteria = contents.criteriaTitle;
    if (currentCriteria == 'HTTP404') httpReturnCode = 404;
    return currentCriteria;
  }

  // Default myConvertTreeToOutputType to
  // convert dart [Map] to [OUTPUT_TYPE] object data
  // but allow it to be overridden
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async =>
      overriddenConvertTreeToOutputType(map);
  ConvertTreeToOutputType overriddenConvertTreeToOutputType = (map) async {
    map as Map;
    final result = MovieResultDTO();
    result.source = DataSourceType.imdb;
    result.uniqueId = map[outerElementIdentity]?.toString() ?? '';
    result.description = map[outerElementDescription]?.toString() ?? '';
    return [result];
  };

  // Default myConvertWebTextToTraversableTree to jsonDecode but allow tests to alter it
  ConvertWebTextToTreeFn overriddenConvertWebTextToTraversableTree =
      (webText) async => [jsonDecode(webText)];
  @override
  Future<List> myConvertWebTextToTraversableTree(String webText) async =>
      overriddenConvertWebTextToTraversableTree(webText);
}

typedef TransformMapToOutputFn = List<String> Function(Map m);

class WebFetchBasic extends WebFetchBase<String, String> {
  WebFetchBasic() {
    selectedDataSource = loopBackDataSource;
  }
  Future<Stream<String>> loopBackDataSource(dynamic s) async =>
      Stream.value(s.toString());

  TransformMapToOutputFn overriddenMyTransformMapToOutput =
      (Map map) => [map.toString()];

  @override
  DataSourceFn myOfflineData() => loopBackDataSource;
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) => Uri();
  @override
  List<String> myTransformMapToOutput(Map map) =>
      overriddenMyTransformMapToOutput(map);
  @override
  String myYieldError(String contents) => contents;

  void setMyTransformMapToOutput(TransformMapToOutputFn fn) {
    overriddenMyTransformMapToOutput = fn;
  }
}

Future<void> _delayedException(Object errorMessage) async {
  await Future.delayed(Duration(seconds: 1));
  throw errorMessage;
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

  group('WebFetchBase myConvertWebTextToTraversableTree unit tests', () {
    final testClass = WebFetchBasic();

    // Default html.
    test('empty string', () async {
      final actualResult = testClass.myConvertWebTextToTraversableTree('');
      await expectLater(
        actualResult,
        throwsA('No content returned from web call'),
      );
    });
    test('html doc', () async {
      final html = await _getOfflineHTML('123').toList();
      final actualResult =
          await testClass.myConvertWebTextToTraversableTree(html.first);
      const expectedResult = '''
<!DOCTYPE html><html><head>
      <script type="application/ld+json">{
        "description": "123." }
      </script>
    </head>
    <body>
    

</body></html>''';

      expect(actualResult.first.outerHtml, expectedResult);
    });
    test('json doc', () async {
      final actualResult =
          await testClass.myConvertWebTextToTraversableTree('[{"key":"val"}]');
      expect(actualResult.toString(), '[[{key: val}]]');
    });
    test('invalid string', () async {
      final actualResult = await testClass
          .myConvertWebTextToTraversableTree('<html>this is junk</ht>');
      expect(actualResult.toString(), '[#document]');
    });
  });

  group('WebFetchBase myConvertCriteriaToWebText unit tests', () {
    final testClass = WebFetchBasic();

    test('empty string', () async {
      final streamResult = await testClass.myConvertCriteriaToWebText('');
      final listResult = await streamResult.toList();
      final textResult = listResult.first;
      expect(textResult, '');
    });

    test('without jsonp tranformation', () async {
      final streamResult =
          await testClass.myConvertCriteriaToWebText('JsonP([{"key":"val"}])');
      final listResult = await streamResult.toList();
      final textResult = listResult.first;
      expect(textResult, 'JsonP([{"key":"val"}])');
    });

    test('with jsonp tranformation', () async {
      testClass.transformJsonP = true;
      final streamResult =
          await testClass.myConvertCriteriaToWebText('JsonP([{"key":"val"}])');
      final listResult = await streamResult.toList();
      final textResult = listResult.first;
      expect(textResult, '[{"key":"val"}]');
    });

    test('exception handler', () async {
      Future<Stream<String>> myError(dynamic s) async => throw s.toString();
      testClass.selectedDataSource = myError;
      final streamResult =
          await testClass.myConvertCriteriaToWebText('JsonP([{"key":"val"}])');
      String actualResult = '';
      try {
        final listResult = await streamResult.toList();
      } catch (error) {
        actualResult = error.toString();
      }
      expect(actualResult,
          'Error in unknown with criteria NullCriteria fetching web text :JsonP([{"key":"val"}])');
    });
  });

  group('WebFetchBase baseTransformMapToOutputHandler unit tests', () {
    final testClass = WebFetchBasic();

    test('empty map', () {
      final map = <String, String>{};
      final actualResult = testClass.baseTransformMapToOutputHandler(map);
      final expectedResult = ['{}'];
      expect(actualResult, expectedResult);
    });

    test('simple value', () async {
      final map = <String, String>{"Hello": "World"};
      final actualResult = testClass.baseTransformMapToOutputHandler(map);
      final expectedResult = ['{Hello: World}'];
      expect(actualResult, expectedResult);
    });

    test('exception handler', () async {
      testClass.setMyTransformMapToOutput(
          (_) => throw "This is a test error message");

      final map = <String, String>{"Hello": "World"};
      final actualResult = testClass.baseTransformMapToOutputHandler(map);
      final expectedResult = [
        'Error in unknown with criteria NullCriteria transform map {Hello: World} to List<String> :This is a test error message',
      ];
      expect(actualResult, expectedResult);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Mocked Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchBase mocked baseConvertTreeToOutputType', () {
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
        await expectLater(actualOutput, emitsInOrder(expectedMatchers));
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

    //overridde myConvertTreeToOutputType to throw an exception
    test(
      'exception handling',
      () async {
        final testClass = QueryIMDBTitleDetailsMocked();
        testClass.overriddenConvertTreeToOutputType =
            (_) => throw 'Convertion Failed';
        final actualOutput = testClass.baseConvertTreeToOutputType(
          Stream.fromIterable(_makeMaps(2)),
        );
        final expectedOutput = testClass.myYieldError(
          'Error in imdb with criteria '
          'NullCriteria translating pagemap '
          'to objects :Convertion Failed',
        );
        final newId = int.parse(expectedOutput.uniqueId) - 1;
        expectedOutput.uniqueId = newId.toString();

        await expectLater(
          actualOutput,
          emitsInOrder(
            [MovieResultDTOMatcher(expectedOutput)],
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  group('WebFetchBase mocked baseConvertWebTextToTraversableTree', () {
    Future<void> testConvert(
      String input,
      List<dynamic>? expectedValue, [
      String? expectedError,
    ]) async {
      final jsonStream = Stream.value(input);
      final actualOutput = QueryIMDBTitleDetailsMocked()
          .baseConvertWebTextToTraversableTree(jsonStream);
      if (null != expectedValue) {
        await expectLater(actualOutput, emitsInOrder(expectedValue));
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

    //overridde myConvertWebTextToTraversableTree to provide a multi-part stream
    test(
      'stream with multiple results',
      () async {
        final testClass = QueryIMDBTitleDetailsMocked();
        final streamOutput = testClass.baseConvertWebTextToTraversableTree(
          Stream.fromIterable([
            '[{"id": "1000","description": "1000."},',
            '{"id": "1001","description": "1001."},',
            '{"id": "1002","description": "1002."},',
            '{"id": "1003","description": "1003."}]',
          ]),
        );
        //final actualOutput = await streamOutput.toList();
        final expectOutput = _makeMaps(4);

        await expectLater(streamOutput, emitsInOrder([expectOutput]));
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    //overridde myConvertWebTextToTraversableTree to throw an exception
    test(
      'exception handling',
      () async {
        final testClass = QueryIMDBTitleDetailsMocked();
        testClass.overriddenConvertWebTextToTraversableTree =
            (_) => throw 'Search Failed';
        final actualOutput = testClass.baseConvertWebTextToTraversableTree(
          Stream.fromIterable(['Part1', 'Part2']),
        );

        await expectLater(
          actualOutput,
          emitsError(
            'Error in imdb with criteria NullCriteria '
            'intepreting web text as a map :Search Failed',
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  group('WebFetchBase mocked baseFetchWebText', () {
    Future<void> testConvert(
      String input,
      String expectedValue, [
      String? expectedError,
    ]) async {
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = input;
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

  group('WebFetchBase mocked myConvertCriteriaToWebText', () {
    Future<void> testConvert(
      String input,
      String expectedValue, [
      String? expectedError,
    ]) async {
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = input;
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
  group('WebFetchBase mocked baseConvertCriteriaToWebText', () {
    Future<void> testConvert(
      String input,
      String expectedValue, [
      String? expectedError,
    ]) async {
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = input;
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
    test(
      'exception handling',
      () async {
        final testClass = QueryIMDBTitleDetailsMocked();
        testClass.selectedDataSource = (_) => throw 'Convert Failed';
        final actualOutput =
            testClass.baseConvertCriteriaToWebText(SearchCriteriaDTO());
        await expectLater(
          actualOutput,
          emitsError(
            'Error in imdb with criteria NullCriteria '
            'fetching web text :Convert Failed',
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  group('WebFetchBase mocked baseFetchWebText unit tests', () {
    final testClass = QueryIMDBTitleDetailsMocked();

    test('fetch sucessful', () async {
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = '123';
      final streamResult = await testClass.baseFetchWebText(criteria);
      final listResult = await streamResult.toList();
      final textResult = listResult.first;
      final expectedResult =
          await _getOfflineHTML(criteria.criteriaTitle).toList();
      expect([textResult], expectedResult);
    });

    test('http error code 404', () async {
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = 'HTTP404';
      const expectedResult =
          'Error in http read, HTTP status code : 404 for https://www.imdb.com/title/HTTP404/?ref_=fn_tt_tt_1';
      final fetchResult = await testClass.baseFetchWebText(criteria);
      expect(fetchResult, emitsError(expectedResult));
    });

    test('http exception', () async {
      final criteria = SearchCriteriaDTO();
      criteria.criteriaTitle = 'EXCEPTION';
      const expectedResult =
          'Error in imdb with criteria NullCriteria fetching web text: :go away!';
      final fetchResult = await testClass.baseFetchWebText(criteria);
      expect(fetchResult, emitsError(expectedResult));
    });
  });
}
