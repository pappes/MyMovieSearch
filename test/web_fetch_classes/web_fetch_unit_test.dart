// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'dart:async' show StreamController;
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

import 'package:universal_io/io.dart'
    show
        HttpClient,
        HttpClientRequest,
        HttpClientResponse,
        HttpHeaders,
        SocketException;

import '../test_helper.dart';
import 'web_fetch_unit_test.mocks.dart';

////////////////////////////////////////////////////////////////////////////////
/// Mock http.Client
////////////////////////////////////////////////////////////////////////////////

// To regenerate mocks run the following command
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([HttpClient, HttpClientRequest, HttpClientResponse, HttpHeaders])
typedef ConvertWebTextToTreeFn = Future<List<dynamic>> Function(String t);
typedef ConvertTreeToOutputType = Future<List<MovieResultDTO>> Function(
  dynamic m,
);

//HttpClient.getUrl(Uri) = Future<HttpClientRequest>
//HttpClientRequest.close() = HttpClientResponse
//HttpClientResponse.statusCode = 200
//HttpClientResponse.transform(utf8.decoder) = stream<String>
//myConstructHeaders(client.headers);
class QueryUnknownSourceMocked
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryUnknownSourceMocked(this.mockedCriteria) : super(mockedCriteria);

  @override
  String myDataSourceName() => 'QueryUnknownSourceMocked';

  int httpReturnCode = 200;
  SearchCriteriaDTO mockedCriteria;

  /// Returns a new [HttpClient] instance to allow mocking in tests.
  @override
  HttpClient baseGetHttpClient() {
    final client = MockHttpClient();
    final clientRequest = MockHttpClientRequest();
    final clientResponse = MockHttpClientResponse();
    final headers = MockHttpHeaders();

    // Use Mockito to return a successful response when it calls the
    // provided HttpClient.
    when(clientResponse.statusCode).thenAnswer((_) => httpReturnCode);
    when(clientResponse.transform(utf8.decoder)).thenAnswer(
      (_) => Stream.value(_getOfflineJson(mockedCriteria.criteriaTitle)),
    );

    // ignore: discarded_futures
    when(clientRequest.close()).thenAnswer((_) async {
      if (mockedCriteria.criteriaTitle == 'EXCEPTION') {
        throw Exception('go away!');
      }
      if (mockedCriteria.criteriaTitle == 'SOCKETEXCEPTION') {
        throw const SocketException("Failed host lookup: 'solidtorrents.eu'");
      }
      return clientResponse;
    });

    // ignore: discarded_futures
    when(client.getUrl(any)).thenAnswer((_) => Future.value(clientRequest));
    when(clientRequest.headers).thenAnswer((_) => headers);

    return client;
  }

  // Remember mockedCriteria for later
  @override
  String myFormatInputAsText() {
    if (mockedCriteria.criteriaTitle == 'HTTP404') httpReturnCode = 404;
    return mockedCriteria.criteriaTitle;
  }

  // Default myConvertTreeToOutputType to
  // convert dart [List] or [Map] to [OUTPUT_TYPE] object data
  // but allow it to be overridden
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic tree,
  ) async =>
      overriddenConvertTreeToOutputType(tree);
  ConvertTreeToOutputType overriddenConvertTreeToOutputType = treeToDto;

  // Default myConvertWebTextToTraversableTree
  // to jsonDecode but allow tests to alter it
  ConvertWebTextToTreeFn overriddenConvertWebTextToTraversableTree =
      (webText) => Future.value([jsonDecode(webText)]);
  @override
  Future<List<dynamic>> myConvertWebTextToTraversableTree(
    String webText,
  ) async =>
      overriddenConvertWebTextToTraversableTree(webText);

  /// Include entire error in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryIMDBTitleDetails] $message',
        DataSourceType.custom,
      );

  // Define myConstructURI to return an fake Uri
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) => Uri.parse(
        'https://www.unknown.com/title/$searchCriteria/?ref_=fn_tt_tt_1',
      );

  // Define myOfflineData to return an empty stream
  @override
  DataSourceFn myOfflineData() => (_) async => const Stream<String>.empty();

  static Future<List<MovieResultDTO>> treeToDto(dynamic tree) {
    if (tree is Map) return Future.value([_mapToDto(tree)]);
    if (tree is List) return Future.value(_listToDto(tree));
    throw TreeConvertException('Unknown: $tree');
  }

  static MovieResultDTO _mapToDto(Map<dynamic, dynamic> map) =>
      MovieResultDTO().init(
        uniqueId: DynamicHelper.toString_(map[outerElementIdentity]),
        description: DynamicHelper.toString_(map[outerElementDescription]),
      );

  static List<MovieResultDTO> _listToDto(List<dynamic> list) {
    final List<MovieResultDTO> results = [];
    for (final value in list) {
      results.add(_mapToDto(value as Map));
    }
    return results;
  }
}

typedef ConvertTreeToOutputTypeFn = Future<List<String>> Function(dynamic m);

// ignore: missing_override_of_must_be_overridden
class WebFetchBasic extends WebFetchBase<String, String> {
  WebFetchBasic(super.criteria) {
    selectedDataSource = loopBackDataSource;
  }
  Future<Stream<String>> loopBackDataSource(dynamic s) =>
      Future.value(Stream.value(s.toString()));

  @override
  String myDataSourceName() => 'WebFetchBasic';

  ConvertTreeToOutputTypeFn overriddenMyConvertTreeToOutputType =
      (dynamic map) async => [map.toString()];

  @override
  DataSourceFn myOfflineData() => loopBackDataSource;
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) => Uri();
  @override
  Future<List<String>> myConvertTreeToOutputType(dynamic map) async =>
      overriddenMyConvertTreeToOutputType(map);
  @override
  String myYieldError(String contents) => contents;
}

// ignore: missing_override_of_must_be_overridden
class WebFetchCached extends WebFetchBasic {
  WebFetchCached(super.criteria);

  @override
  String myDataSourceName() => 'WebFetchCached';

  String lastCriteria = '';
  String lastResult = '';

  @override
  Future<bool> myIsResultCached() async => criteria == lastCriteria;
  @override
  bool myIsCacheStale() => false;
  @override
  Future<void> myAddResultToCache(String fetchedResult) async {
    lastCriteria = criteria;
    lastResult = fetchedResult;
  }

  @override
  List<String> myFetchResultFromCache() {
    if (criteria == lastCriteria) {
      return [lastResult];
    }
    return [];
  }

  @override
  Future<void> myClearCache() async {
    lastCriteria = '';
    lastResult = '';
  }
}

/// Make dummy dto results for offline queries.
List<MovieResultDTO> _makeDTOs(int qty) {
  final results = <MovieResultDTO>[];
  for (int i = 0; i < qty; i++) {
    final uniqueId = 1000 + i;
    results.add(
      {
        'uniqueId': '$uniqueId',
        'description': '$uniqueId.',
      }.toMovieResultDTO(),
    );
  }
  return results;
}

/// Make dummy dto results for offline queries.
List<Map<String, dynamic>> _makeMaps(int qty) {
  final results = <Map<String, dynamic>>[];
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

/// Make dummy json results for offline queries.
String _getOfflineJson(String id) {
  if (id == '') return '';
  return '[{"id": "$id","description": "$id."}]';
}

/// Make dummy json results for offline queries.
String _makeJson(int qty) {
  final results = StringBuffer()..write('[');
  for (int i = 0; i < qty; i++) {
    if (i > 0) results.write(', \n  ');
    results.write('{"id": "${1000 + i}","description": "${1000 + i}."}');
  }
  results.write(']');
  return results.toString();
}

final criteriaDto = SearchCriteriaDTO().fromString('criteria');
void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Non Mocked Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchBase simple unit tests', () {
    final testClass = QueryUnknownSourceMocked(criteriaDto);

    // Default data source name.
    test('myDataSourceName()', () {
      expect(testClass.myDataSourceName(), 'QueryUnknownSourceMocked');
    });
    // Simple criteria text.
    test('myFormatInputAsText()', () {
      expect(testClass.myFormatInputAsText(), criteriaDto.criteriaTitle);
    });
    // Default not cached.
    test('myIsResultCached()', () async {
      expect(testClass.myIsResultCached(), completion(false));
    });
    // Default not stale cache.
    test('myIsCacheStale()', () {
      expect(testClass.myIsCacheStale(), false);
    });
    // Default no caching.
    test('myIsResultCached()', () async {
      //testClass.myAddResultToCache(input);
      expect(testClass.myIsResultCached(), completion(false));
    });
  });

  group('WebFetchBase myConvertWebTextToTraversableTree unit tests', () {
    final testClass = WebFetchBasic('stuff');

    // Default html.
    test('empty string', () async {
      final actualResult = testClass.myConvertWebTextToTraversableTree('');
      await expectLater(
        actualResult,
        throwsA(
          isA<WebConvertException>().having(
            (e) => e.cause,
            'cause',
            startsWith('No content returned from web call'),
          ),
        ),
      );
    });
    test('html doc', () async {
      const expectedResult = '''
<!DOCTYPE html><html><head>
      <script type="application/ld+json">{
        "description": "123." }
      </script>
    </head>
    <body>
    

</body></html>''';
      final actualResult = _getOfflineHTML('123')
          .toList()
          .then(
            (html) => testClass.myConvertWebTextToTraversableTree(html.first),
          )
          // ignore: avoid_dynamic_calls
          .then((element) => element.first.outerHtml);

      expect(actualResult, completion(expectedResult));
    });
    test('json doc', () async {
      final actualResult =
          testClass.myConvertWebTextToTraversableTree('[{"key":"val"}]');
      expect(
        actualResult,
        completion(
          [
            [
              {'key': 'val'},
            ],
          ],
        ),
      );
    });
    test('invalid string', () async {
      final actualResult = testClass
          .myConvertWebTextToTraversableTree('<html>this is junk</ht>')
          .then((val) => val.toString());
      expect(actualResult, completion('[#document]'));
    });
  });

  group('WebFetchBase myConvertCriteriaToWebText unit tests', () {
    test('empty string', () async {
      final testClass = WebFetchBasic('');
      final result = testClass
          .myConvertCriteriaToWebText()
          .then((stream) => stream.toList());
      expect(result, completion(['']));
    });

    test('without jsonp transformation', () async {
      const jsonpText = 'JsonP([{"key":"val"}])';
      final testClass = WebFetchBasic(jsonpText);
      final result = testClass
          .myConvertCriteriaToWebText()
          .then((stream) => stream.toList());
      expect(result, completion([jsonpText]));
    });

    test('with jsonp transformation', () async {
      const jsonText = '[{"key":"val"}]';
      final testClass = WebFetchBasic('JsonP($jsonText)')
        ..transformJsonP = true;
      final result = testClass
          .myConvertCriteriaToWebText()
          .then((stream) => stream.toList());
      expect(result, completion([jsonText]));
    });

    test('generic exception handler', () async {
      Future<Stream<String>> myError(dynamic s) async =>
          throw Exception(s.toString());
      const jsonpText = 'JsonP([{"key":"val"}])';
      final testClass = WebFetchBasic(jsonpText)..selectedDataSource = myError;
      final streamResult = await testClass.myConvertCriteriaToWebText();
      String actualResult = '';
      try {
        await streamResult.toList();
      } catch (error) {
        actualResult = error.toString();
      }
      expect(
          actualResult,
          'Error in WebFetchBasic with criteria $jsonpText '
          'fetching web text :Exception: $jsonpText\n');
    });

    test('WebFetchException exception handler', () async {
      Future<Stream<String>> myError(dynamic s) async =>
          throw WebFetchException(s.toString());
      const jsonpText = 'JsonP([{"key":"val"}])';
      final testClass = WebFetchBasic(jsonpText)..selectedDataSource = myError;
      final streamResult = await testClass.myConvertCriteriaToWebText();
      String actualResult = '';
      try {
        await streamResult.toList();
      } catch (error) {
        actualResult = error.toString();
      }
      expect(
          actualResult,
          'Error in WebFetchBasic with criteria $jsonpText '
          'fetching web text :$jsonpText\n');
    });
  });

  group('WebFetchBase cache unit tests', () {
    test('empty cache', () async {
      final testClass = WebFetchCached('Marco');
      final listResult = await testClass.readCachedList(
        source: (_) => Future.value(Stream.value('Polo')),
      );
      expect(listResult, <void>[]);
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, false);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('add to cache via populateStream', () async {
      final testClass = WebFetchCached('Marco');
      final sc = StreamController<String>();
      testClass.populateStream(
        sc,
        source: (_) =>
            Future.value(Stream.value('"Polo"')), // Stream a Json result
      );
      await sc.stream.drain<void>();
      final listResult = await testClass.readCachedList(
        source: (_) => Future.value(Stream.value('Who Is Marco?')),
      );
      expect(listResult, ['Polo']);
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('manually add to cache', () async {
      final testClass = WebFetchCached('Marco');
      await testClass.myAddResultToCache('Polo');
      final listResult = await testClass.readCachedList(
        source: (_) => Future.value(Stream.value('Polo')),
      );
      expect(listResult, ['Polo']);
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('fetch result from cache', () async {
      final testClass = WebFetchCached('Marco');
      await testClass.myAddResultToCache('Polo');
      final listResult = testClass.myFetchResultFromCache().toList();
      expect(listResult, ['Polo']);
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, true);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });

    test('clear cache', () async {
      final testClass = WebFetchCached('Marco');
      await testClass.myAddResultToCache('Polo');
      await testClass.myClearCache();
      final listResult = await testClass.readCachedList();
      expect(listResult, <void>[]);
      final resultIsCached = await testClass.myIsResultCached();
      expect(resultIsCached, false);
      final resultIsStale = testClass.myIsCacheStale();
      expect(resultIsStale, false);
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Mocked Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchBase mocked baseConvertTreeToOutputType', () {
    void testConvert(
      List<Map<dynamic, dynamic>> input,
      List<MovieResultDTO>? expectedValue, [
      String? expectedError,
    ]) {
      final pageMap = Stream.fromIterable(input);
      final actualOutput =
          QueryUnknownSourceMocked(criteriaDto).baseConvertTreeToOutputType(
        pageMap,
      );
      if (null != expectedValue) {
        final expectedMatchers = expectedValue.map(MovieResultDTOMatcher.new);
        expect(actualOutput, emitsInOrder(expectedMatchers));
      }
    }

    // Convert 0 maps into dtos.
    test('empty input', () {
      final input = [<String, dynamic>{}];
      final output = <MovieResultDTO>[];
      testConvert(input, output);
    });
    // Convert 1 map into a dto.
    test(
      'single map input',
      () {
        final input = _makeMaps(1);
        final output = _makeDTOs(1);
        testConvert(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
    // Convert multiple maps into dtos.
    test(
      'multiple map input',
      () {
        final input = _makeMaps(100);
        final output = _makeDTOs(100);
        testConvert(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
    // Limit number of DTOs returned.
    test(
      'limit output',
      () {
        final input = _makeMaps(123);
        final output = _makeDTOs(100);
        testConvert(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    test(
      'exception handling1',
      () {
        final testClass = QueryUnknownSourceMocked(criteriaDto);
        final actualOutput = testClass.baseConvertTreeToOutputType(
          Stream.fromIterable(['Conversion Failed1', 'Conversion Failed2']),
        );
        final expectedOutput = [
          testClass.myYieldError(
              'Error in QueryUnknownSourceMocked with criteria '
              '${criteriaDto.criteriaTitle} convert error translating page map '
              'to objects :Unknown: Conversion Failed1'),
          testClass.myYieldError(
            'Error in QueryUnknownSourceMocked with criteria '
            '${criteriaDto.criteriaTitle} convert error translating page map '
            'to objects :Unknown: Conversion Failed2',
          ),
        ];
        final newId = int.parse(expectedOutput.first.uniqueId) - 1;
        expectedOutput.first.uniqueId = newId.toString();

        expect(
          actualOutput,
          emitsInOrder([
            MovieResultDTOMatcher(expectedOutput.first),
            MovieResultDTOMatcher(expectedOutput.last),
          ]),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    //override myConvertTreeToOutputType to throw a generic exception
    test(
      'exception handling2',
      () {
        final testClass = QueryUnknownSourceMocked(criteriaDto)
          ..overriddenConvertTreeToOutputType =
              (_) => throw Exception('Conversion Failed');
        final actualOutput = testClass.baseConvertTreeToOutputType(
          Stream.fromIterable(_makeMaps(2)),
        );
        final expectedOutput = [
          testClass.myYieldError('Error in QueryUnknownSourceMocked '
              'with criteria ${criteriaDto.criteriaTitle} '
              'non-confomant baseConvertTreeToOutputType error '
              'translating page map to objects '
              ':Exception: Conversion Failed'),
          testClass.myYieldError(
            'Error in QueryUnknownSourceMocked with criteria '
            '${criteriaDto.criteriaTitle} '
            'non-confomant baseConvertTreeToOutputType error '
            'translating page map to objects '
            ':Exception: Conversion Failed',
          ),
        ];
        final newId = int.parse(expectedOutput.first.uniqueId) - 1;
        expectedOutput.first.uniqueId = newId.toString();

        expect(
          actualOutput,
          emitsInOrder([
            MovieResultDTOMatcher(expectedOutput.first),
            MovieResultDTOMatcher(expectedOutput.last),
          ]),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    // override myConvertTreeToOutputType
    // to throw a TreeConvertException exception
    test(
      'exception handling3',
      () {
        final testClass = QueryUnknownSourceMocked(criteriaDto)
          ..overriddenConvertTreeToOutputType =
              (_) => throw TreeConvertException('Conversion Failed');
        final actualOutput = testClass.baseConvertTreeToOutputType(
          Stream.fromIterable(_makeMaps(2)),
        );
        final expectedOutput = [
          testClass.myYieldError('Error in QueryUnknownSourceMocked '
              'with criteria '
              '${criteriaDto.criteriaTitle} convert error translating page map '
              'to objects :Conversion Failed'),
          testClass.myYieldError(
            'Error in QueryUnknownSourceMocked with criteria '
            '${criteriaDto.criteriaTitle} convert error translating page map '
            'to objects :Conversion Failed',
          ),
        ];
        final newId = int.parse(expectedOutput.first.uniqueId) - 1;
        expectedOutput.first.uniqueId = newId.toString();

        expect(
          actualOutput,
          emitsInOrder([
            MovieResultDTOMatcher(expectedOutput.first),
            MovieResultDTOMatcher(expectedOutput.last),
          ]),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    //override myConvertWebTextToTraversableTree to encapsulate errors
    test(
      'stream exception handling',
      () async {
        final testClass = QueryUnknownSourceMocked(criteriaDto);
        final expectedError = '[QueryIMDBTitleDetails] '
            'Error in QueryUnknownSourceMocked with criteria '
            '${criteriaDto.criteriaTitle} stream error translating page map '
            'to objects :more exception handling';
        final actualOutput = testClass.baseConvertTreeToOutputType(
          Stream.error('more exception handling'),
        );
        final dtoOutput = actualOutput.toList().then((dto) => dto.first.title);
        expect(dtoOutput, completion(expectedError));
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  test(
    'success + exception handling',
    () {
      final testClass = QueryUnknownSourceMocked(criteriaDto);
      final actualOutput = testClass.baseConvertTreeToOutputType(
        Stream.fromIterable([
          ..._makeMaps(1),
          'Conversion Failed2',
        ]),
      );
      final expectedOutput = [
        ..._makeDTOs(1),
        testClass.myYieldError(
          'Error in QueryUnknownSourceMocked with criteria '
          '${criteriaDto.criteriaTitle} convert error translating page map '
          'to objects :Unknown: Conversion Failed2',
        ),
      ];

      expect(
        actualOutput,
        emitsInOrder([
          MovieResultDTOMatcher(expectedOutput.first),
          MovieResultDTOMatcher(expectedOutput.last),
        ]),
      );
    },
    timeout: const Timeout(Duration(seconds: 5)),
  );

  test(
    'exception handling + success',
    () {
      final testClass = QueryUnknownSourceMocked(criteriaDto);
      final actualOutput = testClass.baseConvertTreeToOutputType(
        Stream.fromIterable([
          'Conversion Failed2',
          ..._makeMaps(1),
        ]),
      );
      final expectedOutput = [
        ..._makeDTOs(1),
        testClass.myYieldError(
          'Error in QueryUnknownSourceMocked with criteria '
          '${criteriaDto.criteriaTitle} convert error translating page map '
          'to objects :Unknown: Conversion Failed2',
        ),
      ];
      final newId = int.parse(expectedOutput.last.uniqueId) - 1;
      expectedOutput.last.uniqueId = newId.toString();

      expect(
        actualOutput,
        emitsInOrder([
          MovieResultDTOMatcher(expectedOutput.first),
          MovieResultDTOMatcher(expectedOutput.last),
        ]),
      );
    },
    timeout: const Timeout(Duration(seconds: 5)),
  );

  group('WebFetchBase mocked WebFetchBasic', () {
    void testConvert(
      String input,
      List<dynamic>? expectedValue, [
      String? expectedError,
    ]) {
      final jsonStream = Stream.value(input);
      final actualOutput = QueryUnknownSourceMocked(criteriaDto)
          .baseConvertWebTextToTraversableTree(jsonStream);
      if (null != expectedValue) {
        expect(actualOutput, emitsInOrder(expectedValue));
      }
    }

    // Convert 0 json maps into a trees.
    test('empty input', () {
      final input = _makeJson(0);
      final output = _makeMaps(0);
      testConvert(input, [output]);
    });
    // Convert 1 json map into a tree.
    test(
      'single map input',
      () {
        final input = _makeJson(1);
        final output = _makeMaps(1);
        testConvert(input, [output]);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
    // Convert multiple json maps into a trees.
    test(
      'multiple map input',
      () {
        final input = _makeJson(10);
        final output = _makeMaps(10);
        testConvert(input, [output]);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    //override myConvertWebTextToTraversableTree to provide a multi-part stream
    test(
      'stream with multiple results',
      () {
        final testClass = QueryUnknownSourceMocked(criteriaDto);
        final streamOutput = testClass.baseConvertWebTextToTraversableTree(
          Stream.fromIterable([
            '[{"id": "1000","description": "1000."},',
            '{"id": "1001","description": "1001."},',
            '{"id": "1002","description": "1002."},',
            '{"id": "1003","description": "1003."}]',
          ]),
        );
        final expectOutput = _makeMaps(4);

        expect(streamOutput, emitsInOrder([expectOutput]));
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    //override myConvertWebTextToTraversableTree to provide a streamed error
    test(
      'stream throws error message',
      () async {
        final testClass = QueryUnknownSourceMocked(criteriaDto);
        final actualOutput = testClass.baseConvertWebTextToTraversableTree(
          Stream<String>.error('error on the stream'),
        );

        await expectLater(
          actualOutput.toList,
          throwsA(
              'Error in QueryUnknownSourceMocked with criteria criteria stream '
              'error interpreting web text as a map :error on the stream'),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    //override myConvertWebTextToTraversableTree to provide a streamed error
    test(
      'stream contents after error',
      () async {
        List<String> captureStreamError(dynamic error, StackTrace _) {
          expect(
            error,
            'Error in QueryUnknownSourceMocked with criteria criteria '
            'stream error interpreting web text as a map :error on the stream',
            reason: 'myConvertWebTextToTraversableTree was called '
                'when logic should have stopped due to an error',
          );
          return [];
        }

        final testClass = QueryUnknownSourceMocked(criteriaDto)
          ..overriddenConvertWebTextToTraversableTree = (_) => throw Exception(
                'Do Not Want calls to myConvertWebTextToTraversableTree!',
              );
        final streamOutput = testClass.baseConvertWebTextToTraversableTree(
          Stream<String>.error('error on the stream'),
        );
        final actualOutput =
            await streamOutput.handleError(captureStreamError).toList();

        expect(actualOutput, <String>[]);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    //override myConvertWebTextToTraversableTree to encapsulate errors
    test(
      'child function generic exception handling',
      () async {
        final testClass = QueryUnknownSourceMocked(criteriaDto)
          ..overriddenConvertWebTextToTraversableTree =
              (_) => throw Exception('Search Failed');
        final actualOutput = testClass.baseConvertWebTextToTraversableTree(
          Stream.fromIterable(['Part1', 'Part2']),
        );

        await expectLater(
          actualOutput,
          emitsError(
            'Error in QueryUnknownSourceMocked with criteria'
            ' ${criteriaDto.criteriaTitle} '
            'non-confomant baseConvertWebTextToTraversableTree '
            'error interpreting web text as a map :Exception: Search Failed',
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    //override myConvertWebTextToTraversableTree to encapsulate errors
    test(
      'child function WebConvertException exception handling',
      () async {
        final testClass = QueryUnknownSourceMocked(criteriaDto)
          ..overriddenConvertWebTextToTraversableTree =
              (_) => throw WebConvertException('Search Failed');
        final actualOutput = testClass.baseConvertWebTextToTraversableTree(
          Stream.fromIterable(['Part1', 'Part2']),
        );

        await expectLater(
          actualOutput,
          emitsError(
            'Error in QueryUnknownSourceMocked with criteria '
            '${criteriaDto.criteriaTitle} '
            'convert error interpreting web text as a map :Search Failed',
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    //override myConvertWebTextToTraversableTree to encapsulate errors
    test(
      'stream exception handling',
      () async {
        final testClass = QueryUnknownSourceMocked(criteriaDto)
          ..overriddenConvertWebTextToTraversableTree =
              (_) => throw Exception('Search Failed');
        final actualOutput = testClass.baseConvertWebTextToTraversableTree(
          Stream.error('more exception handling'),
        );

        await expectLater(
          actualOutput,
          emitsError(
            'Error in QueryUnknownSourceMocked with criteria '
            '${criteriaDto.criteriaTitle} '
            'stream error interpreting web text as a map '
            ':more exception handling',
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
      final criteria = SearchCriteriaDTO().fromString(input);
      final testClass = QueryUnknownSourceMocked(criteria);

      final actualOutput = testClass.baseFetchWebText(criteria);
      expect(
        actualOutput, //.printStream(input),
        completion(
          emitsInOrder(
            [
              containsSubstring(
                expectedValue,
                startsWith: input == '' ? '' : '[{"id": "',
              ),
            ],
          ),
        ),
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
      final criteria = SearchCriteriaDTO().fromString(input);
      final testClass = QueryUnknownSourceMocked(criteria);

      final actualOutput = testClass.myConvertCriteriaToWebText();
      expect(
        actualOutput,
        completion(
          emitsInOrder(
            [
              containsSubstring(
                expectedValue,
                startsWith: input == '' ? '' : '[{"id": "',
              ),
            ],
          ),
        ),
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
    void testConvert(
      String input,
      String expectedValue, [
      String? expectedError,
    ]) {
      final criteria = SearchCriteriaDTO().fromString(input);
      final testClass = QueryUnknownSourceMocked(criteria);
      final actualOutput = testClass.baseConvertCriteriaToWebText();
      //.printStream('testConvert1:');
      expect(
        actualOutput,
        emitsInOrder([
          containsSubstring(
            expectedValue,
            startsWith: input == '' ? '' : '[{"id": "',
          ),
        ]),
      );
    }

    // Convert empty input to empty output.
    test('empty input', () {
      const input = '';
      const output = '';
      testConvert(input, output);
    });
    // Convert 1 json map into a tree.
    test(
      'mocked http call',
      () {
        const input = '1234';
        const output = '1234.';
        testConvert(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
    test(
      'generic exception handling',
      () async {
        final testClass = QueryUnknownSourceMocked(criteriaDto)
          ..selectedDataSource = (_) => throw Exception('Convert Failed');
        final actualOutput = testClass.baseConvertCriteriaToWebText();
        await expectLater(
          actualOutput,
          emitsError(
            'Error in QueryUnknownSourceMocked with criteria'
            ' ${criteriaDto.criteriaTitle} '
            'non-confomant baseConvertCriteriaToWebText error '
            'fetching web text chunks :Exception: Convert Failed',
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
    test(
      'WebFetchException exception handling',
      () async {
        final testClass = QueryUnknownSourceMocked(criteriaDto)
          ..selectedDataSource =
              (_) => throw WebFetchException('Convert Failed');
        final actualOutput = testClass.baseConvertCriteriaToWebText();
        await expectLater(
          actualOutput,
          emitsError(
            'Error in QueryUnknownSourceMocked with criteria '
            '${criteriaDto.criteriaTitle} '
            'fetching web text chunks :Convert Failed',
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });

  group('WebFetchBase mocked baseFetchWebText unit tests', () {
    test('fetch successful', () async {
      final criteria = SearchCriteriaDTO().fromString('123');
      final testClass = QueryUnknownSourceMocked(criteria);
      final streamResult = await testClass.baseFetchWebText(criteria);
      final listResult = await streamResult.toList();
      final textResult = listResult.first;
      final expectedResult = _getOfflineJson(criteria.criteriaTitle);
      expect(textResult, expectedResult);
    });

    test('http error code 404', () async {
      final criteria = SearchCriteriaDTO().fromString('HTTP404');
      final testClass = QueryUnknownSourceMocked(criteria);
      const expectedResult =
          'Error in http read, HTTP status code : 404 for https://www.unknown.com/title/HTTP404/?ref_=fn_tt_tt_1';
      final fetchResult = await testClass.baseFetchWebText(criteria);
      expect(fetchResult, emitsError(expectedResult));
    });

    test('http exception', () async {
      final criteria = SearchCriteriaDTO().fromString('EXCEPTION');
      final testClass = QueryUnknownSourceMocked(criteria);
      final expectedResult = 'Error in QueryUnknownSourceMocked '
          'with criteria ${criteria.criteriaTitle} '
          'fetching web text: :Exception: go away!';
      final fetchResult = await testClass.baseFetchWebText(criteria);
      expect(fetchResult, emitsError(expectedResult));
    });

    test('socket exception', () async {
      final criteria = SearchCriteriaDTO().fromString('SOCKETEXCEPTION');
      final testClass = QueryUnknownSourceMocked(criteria);
      final expectedResult = 'Error in QueryUnknownSourceMocked '
          'with criteria ${criteria.criteriaTitle} '
          'unable to contact website, has the host moved? : '
          ":SocketException: Failed host lookup: 'solidtorrents.eu'";
      final fetchResult = await testClass.baseFetchWebText(criteria);
      expect(fetchResult, emitsError(expectedResult));
    });
  });

  group('WebFetchBase mocked baseTransform unit tests', () {
    Future<void> testTransform(
      String input,
      List<MovieResultDTO>? expectedValue, [
      String? expectedError,
    ]) async {
      final criteria = SearchCriteriaDTO()..criteriaTitle = input;
      final actualOutput = QueryUnknownSourceMocked(criteria).baseTransform();
      if (null != expectedValue) {
        final expectedMatchers = expectedValue.map(MovieResultDTOMatcher.new);
        expect(actualOutput, emitsInOrder(expectedMatchers));
      }
      if (null != expectedError) {
        final dtoTitle = actualOutput.toList().then((list) => list.first.title);
        expect(dtoTitle, completion(expectedError));
      }
    }

    // Convert 0 maps into dtos.
    test('empty input', () async {
      const input = '';
      final output = <MovieResultDTO>[];
      await testTransform(input, output);
    });
    // Convert 1 map into a dto.
    test(
      'single map input',
      () async {
        const input = '1000';
        final output = _makeDTOs(1);
        await testTransform(input, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
    test(
      'http error code 404',
      () async {
        const input = 'HTTP404';
        const output = '[QueryIMDBTitleDetails] '
            'Error in QueryUnknownSourceMocked '
            'with criteria $input '
            'stream error interpreting web text as a map :Error in http read, '
            'HTTP status code : 404 for https://www.unknown.com/title/HTTP404/?ref_=fn_tt_tt_1';
        await testTransform(input, null, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
    test(
      'http EXCEPTION',
      () async {
        const input = 'EXCEPTION';
        const output = '[QueryIMDBTitleDetails] '
            'Error in QueryUnknownSourceMocked '
            'with criteria $input '
            'fetching web text: :Exception: go away!';
        await testTransform(input, null, output);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });
}
