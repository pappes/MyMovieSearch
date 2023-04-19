import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/yts_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/yts_search.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonPSample(dynamic dummy) {
  return Future.value(Stream.value('imdbJsonPFunction(null)'));
}

Future<Stream<String>> _emitInvalidJsonPSample(dynamic dummy) {
  return Future.value(Stream.value('imdbJsonPFunction({not valid json})'));
}

final criteria = SearchCriteriaDTO().init(
  SearchCriteriaType.download,
  title: '123',
  list: [MovieResultDTO().init(uniqueId: 'tt123')],
);

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestions unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryYtsSearch(criteria).myDataSourceName(),
        'ytsSearch',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryYtsSearch(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () {
      final expectedValue = expectedDTOList;
      final ytsSearch = QueryYtsSearch(criteria);

      // Invoke the functionality and collect results.
      final actualResult =
          ytsSearch.myConvertTreeToOutputType(jsonDecode(ytsJsonSampleFull));

      // Check the results.
      expect(
        actualResult,
        completion(MovieResultDTOListMatcher(expectedValue)),
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult = 'https://yts.mx/ajax/search?query=/new%20query';

      // Invoke the functionality.
      final actualResult =
          QueryYtsSearch(criteria).myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'uniqueId': '-',
        'bestSource': 'DataSourceType.ytsSearch',
        'title': '[QueryYtsSearch] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult =
          QueryYtsSearch(criteria).myYieldError('new query').toMap();
      // Exact id does not need to match as long as it is negative number
      actualResult['uniqueId'] =
          actualResult['uniqueId'].toString().substring(0, 1);

      // Check the results.
      expect(actualResult, expectedResult);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestion query', () {
    // Read IMDB suggestions from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final ytsSearch = QueryYtsSearch(criteria);

      // Invoke the functionality.
      await ytsSearch
          .readList(
            source: streamJsonOfflineData,
          )
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );
      // printTestData(queryResult);

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });

    // Read IMDB suggestions from a simulated byte stream and convert JSON to dtos.
    test('invalid jsonp', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final ytsSearch = QueryYtsSearch(criteria);
      const expectedException = '''
[QueryYtsSearch] Error in ytsSearch with criteria 123 interpreting web text as a map :FormatException: Unexpected character (at character 2)
{not valid json}
 ^
''';

      // Invoke the functionality.
      await ytsSearch
          .readList(
            source: _emitInvalidJsonPSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read IMDB suggestions from a simulated byte stream and convert JSON to dtos.
    test('unexpected json contents', () async {
      // Set up the test data.
      const expectedException = '[QueryYtsSearch] Error in ytsSearch '
          'with criteria 123 translating page map to objects '
          ':expected map got Null unable to interpret data null';
      final queryResult = <MovieResultDTO>[];
      final ytsSearch = QueryYtsSearch(criteria);

      // Invoke the functionality.
      await ytsSearch
          .readList(
            source: _emitUnexpectedJsonPSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
