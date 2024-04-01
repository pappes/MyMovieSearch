import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';
import '../../../test_data/imdb_suggestion_converter_data.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(_) =>
    Future.value(Stream.value('imdbJsonFunction(null)'));

Future<Stream<String>> _emitInvalidJsonSample(_) =>
    Future.value(Stream.value('imdbJsonFunction({not valid json})'));

final criteria = SearchCriteriaDTO().fromString('123');

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestions unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryIMDBSuggestions(criteria).myDataSourceName(),
        'imdbSuggestions',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryIMDBSuggestions(criteria).myFormatInputAsText(),
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
        QueryIMDBSuggestions(input).myFormatInputAsText(),
        contains('test1'),
      );
      expect(
        QueryIMDBSuggestions(input).myFormatInputAsText(),
        contains('test2'),
      );
    });

    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final imdbSuggestions = QueryIMDBSuggestions(criteria);

      // Invoke the functionality and collect results.
      final actualResult =
          imdbSuggestions.myConvertTreeToOutputType({'d': expectedDTOMap});

      // Check the results.
      expect(
        actualResult,
        completion(MovieResultDTOListMatcher(expectedValue)),
      );
    });
    test('Run myConvertTreeToOutputType() with empty search results', () async {
      final expectedValue = <MovieResultDTO>[];
      final testClass = QueryIMDBSuggestions(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateEmptyMapList) {
        actualResult.addAll(
          await testClass.myConvertTreeToOutputType(map),
        );
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    test('Run myConvertTreeToOutputType() with error results', () async {
      final expectedValue = <MovieResultDTO>[];
      final testClass = QueryIMDBSuggestions(criteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateErrorMapList) {
        actualResult.addAll(
          await testClass.myConvertTreeToOutputType(map),
        );
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult =
          'https://sg.media-imdb.com/suggestion/x/new%20query.json';

      // Invoke the functionality.
      final actualResult =
          QueryIMDBSuggestions(criteria).myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'uniqueId': '-',
        'bestSource': 'DataSourceType.imdbSuggestions',
        'title': '[QueryIMDBSuggestions] new query',
        'type': 'MovieContentType.error',
      };

      // Invoke the functionality.
      final actualResult =
          QueryIMDBSuggestions(criteria).myYieldError('new query').toMap();
      // Exact id does not need to match as long as it is negative number
      actualResult['uniqueId'] =
          actualResult['uniqueId'].toString().substring(0, 1);

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          QueryIMDBSuggestions(criteria).myConvertWebTextToTraversableTree(
        jsonSampleFull,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () async {
      final expectedOutput = intermediateEmptyMapList;
      final actualOutput =
          QueryIMDBSuggestions(criteria).myConvertWebTextToTraversableTree(
        jsonSampleEmpty,
      );
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results',
        () async {
      final expectedOutput = throwsA(
        isA<WebConvertException>().having(
          (e) => e.cause,
          'cause',
          startsWith(
            'Invalid json returned from web call',
          ),
        ),
      );

      final actualOutput =
          QueryIMDBSuggestions(criteria).myConvertWebTextToTraversableTree(
        imdbErrorSample,
      );
      expect(actualOutput, expectedOutput);
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestion query', () {
    // Read IMDB suggestions from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSuggestions(criteria);

      // Invoke the functionality.
      await imdbSuggestions
          .readList(source: emitImdbSuggestionJsonSample)
          .then(queryResult.addAll)
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Read IMDB suggestions from a simulated byte stream
    // and convert JSON to dtos.
    test('empty readList()', () async {
      // Set up the test data.
      final expectedValue = <MovieResultDTO>[];
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSuggestions(criteria);

      // Invoke the functionality.
      await imdbSuggestions
          .readList(source: emitEmptyImdbSuggestionJsonSample)
          .then(queryResult.addAll)
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Read IMDB suggestions from a simulated byte stream
    // and convert JSON to dtos.
    test('invalid jsonp', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSuggestions(criteria);
      const expectedException =
          '[QueryIMDBSuggestions] Error in imdbSuggestions with criteria 123 '
          'convert error interpreting web text as a map '
          ':Invalid json returned from web call {not valid json}';

      // Invoke the functionality.
      await imdbSuggestions
          .readList(source: _emitInvalidJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read IMDB suggestions from a simulated byte stream
    // and convert JSON to dtos.
    test('unexpected json contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBSuggestions] Error in imdbSuggestions '
          'with criteria 123 convert error translating page map to objects '
          ':expected map got Null unable to interpret data null';
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSuggestions(criteria);

      // Invoke the functionality.
      await imdbSuggestions
          .readList(source: _emitUnexpectedJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
