import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';

import 'package:universal_io/io.dart'
    show HttpClient, HttpClientRequest, HttpClientResponse, HttpHeaders;

import '../../../test_helper.dart';
import '../../web_fetch_unit_test.mocks.dart';

////////////////////////////////////////////////////////////////////////////////
/// Mock http.Client
////////////////////////////////////////////////////////////////////////////////

// To regenerate mocks run the following command
// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([HttpClient, HttpClientRequest, HttpClientResponse, HttpHeaders])

//HttpClient.getUrl(Uri) = Future<HttpClientRequest>
//HttpClientRequest.close() = HttpClientResponse
//HttpClientResponse.statusCode = 200
//HttpClientResponse.transform(utf8.decoder) = stream<String>
class QueryIMDBTitleDetailsMocked extends QueryIMDBTitleDetails {
  /// Returns a new [HttpClient] instance to allow mocking in tests.
  late int httpStatus;
  String? expectedCriteria;
  QueryIMDBTitleDetailsMocked(this.expectedCriteria, {this.httpStatus = 200});

  @override
  HttpClient myGetHttpClient() {
    final client = MockHttpClient();
    final clientRequest = MockHttpClientRequest();
    final clientResponse = MockHttpClientResponse();
    final headers = MockHttpHeaders();
    final expectedUri = Uri.parse(
      'https://www.imdb.com/title/$expectedCriteria/?ref_=fn_tt_tt_1',
    );

    Future<MockHttpClientResponse> getClientResponse(_) async {
      return clientResponse;
    }

    // Use Mockito to return a successful response when it calls the
    // provided HttpClient.
    when(clientResponse.statusCode).thenAnswer(getHttpStatus);
    //when(clientResponse.statusCode).thenAnswer((_) => httpStatus);
    when(clientResponse.transform(utf8.decoder))
        .thenAnswer((_) => _getOfflineHTML('$expectedCriteria'));

    //when(clientRequest.close()).thenAnswer((_) async => clientResponse);
    when(clientRequest.close()).thenAnswer(getClientResponse);

    when(client.getUrl(expectedUri)).thenAnswer((_) async => clientRequest);
    when(clientRequest.headers).thenAnswer((_) => headers);

    return client;
  }

  int getHttpStatus(_) {
    return httpStatus;
  }
}

/// Make dummy dto results for offline queries.
List<MovieResultDTO> _makeDTOs(int startid, int qty) {
  final results = <MovieResultDTO>[];
  var uniqueId = startid;
  for (int i = 0; i < qty; i++) {
    results.add(
      {
        'source': DataSourceType.imdb.toString(),
        'uniqueId': '$uniqueId',
        'title': '$uniqueId.',
      }.toMovieResultDTO(),
    );
    uniqueId++;
  }
  return results;
}

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int startId, int qty) {
  final results = <String>[];
  var uniqueId = startId;
  for (int i = 0; i < qty; i++) {
    results.add((uniqueId).toString());
    uniqueId++;
  }
  return results;
}

Map offlineMapList(String id) => {
      'props': {
        'pageProps': {
          'tconst': id,
          'aboveTheFold': {
            "titleText": {"text": "$id."},
          },
        }
      }
    };

/// Make dummy html results for offline queries.
Stream<String> _getOfflineHTML(String id) async* {
  yield '''
<!DOCTYPE html>
<html
    <head>
      <script type="application/json">${json.encode(offlineMapList(id))}
      </script>
    </head>
    <body>
    </body>
</html>
''';
}

/// Make dummy html results for offline queries.
Future<Stream<String>> _offlineSearch(dynamic criteria) async {
  criteria as SearchCriteriaDTO;
  return _getOfflineHTML(criteria.criteriaTitle);
}

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(
  List<String> queries,
  bool online,
  bool simulateHTTP404,
) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO();
    final imdbDetails = simulateHTTP404
        ? QueryIMDBTitleDetailsMocked(queryKey, httpStatus: 404)
        : QueryIMDBTitleDetailsMocked(
            queryKey,
          ); //Separate instance per search (async)
    criteria.criteriaTitle = queryKey;

    Future<List<MovieResultDTO>> future;
    if (online) {
      future = imdbDetails.readList(
        criteria,
      );
    } else {
      future = imdbDetails.readList(
        criteria,
        source: _offlineSearch,
      );
    }
    futures.add(future);
  }
  return futures;
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Mocked Unit(integration) tests
  /// test readList including data transformation
  /// but mocks out http calls by replacing myGetHttpClient with _onlineSearch
////////////////////////////////////////////////////////////////////////////////

  group('WebFetchBase ReadList', () {
    Future<void> testRead(
      List<String> criteria,
      List<MovieResultDTO> expectedValue, {
      bool online = true,
      bool forceError = false,
    }) async {
      // Clear any prior test results from the cache
      await QueryIMDBTitleDetailsMocked('').myClearCache();
      // Call IMDB for each criteria in the list.
      final futures = _queueDetailSearch(criteria, online, forceError);

      // Collect the result of all the IMDB queries.
      final queryResult = <MovieResultDTO>[];
      for (final future in futures) {
        future.then((value) => queryResult.addAll(value));
      }
      for (final future in futures) {
        await future;
      }

      // Compare IMDB results to expectations.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    }

    // Convert 1 sample offline page into a dto.
    test('Run read 1 offline page', () async {
      const startId = 1000;
      final queries = _makeQueries(startId, 1);
      final queryResult = _makeDTOs(startId, queries.length);
      await testRead(queries, queryResult, online: false);
    });

    // Convert 300 sample offline pages into dtos.
    test('Run read 300 offline pages', () async {
      const startId = 2000;
      final queries = _makeQueries(startId, 300);
      final queryResult = _makeDTOs(startId, queries.length);
      await testRead(queries, queryResult, online: false);
    });

    // Convert 1 IMDB pages into dtos.
    test('Run read 1 pages from mocked IMDB', () async {
      const startId = 3000;
      final queries = _makeQueries(startId, 1);
      final queryResult = _makeDTOs(startId, queries.length);
      await testRead(queries, queryResult);
    });

    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from mocked IMDB', () async {
      const startId = 4000;
      final queries = _makeQueries(startId, 3);
      final queryResult = _makeDTOs(startId, queries.length);
      await testRead(queries, queryResult);
    });

    // Convert 300 IMDB pages into dtos!!!
    test(
      'Run read 300 pages from mocked IMDB',
      () async {
        const startId = 5000;
        final queries = _makeQueries(startId, 300);
        final queryResult = _makeDTOs(startId, queries.length);
        await testRead(queries, queryResult);
      },
      timeout: const Timeout(Duration(seconds: 40)),
    );

    // Test HTTP exception handling
    test(
      'Test HTTP 404',
      () async {
        const startId = 5000;
        final queries = _makeQueries(startId, 1);
        final errorMessage = MovieResultDTO();
        errorMessage.title =
            '[QueryIMDBTitleDetails] Error in imdb with criteria 5000 interpreting web text as a map :Error in http read, HTTP status code : 404 for https://www.imdb.com/title/$startId/?ref_=fn_tt_tt_1';
        errorMessage.uniqueId = '-2';
        errorMessage.source = DataSourceType.imdb;
        errorMessage.type = MovieContentType.custom;
        await testRead(queries, [errorMessage], forceError: true);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
