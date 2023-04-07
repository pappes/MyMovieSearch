import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import '../../../test_data/imdb_suggestion_converter_data.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonPSample(dynamic dummy) {
  return Future.value(Stream.value('imdbJsonPFunction(null)'));
}

Future<Stream<String>> _emitInvalidJsonPSample(dynamic dummy) {
  return Future.value(Stream.value('imdbJsonPFunction({not valid json})'));
}

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
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryIMDBSuggestions(criteria).myFormatInputAsText(),
        criteria.criteriaTitle,
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList', () {
      final input = SearchCriteriaDTO();
      input.criteriaList = [
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
    test('Run myTransformMapToOutput()', () {
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

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expectedResult =
          'https://sg.media-imdb.com/suggests/n/new%20query.json';

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
      final imdbSuggestions = QueryIMDBSuggestions(criteria);

      // Invoke the functionality.
      await imdbSuggestions
          .readList(
            source: emitImdbSuggestionJsonPSample,
          )
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

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
      final imdbSuggestions = QueryIMDBSuggestions(criteria);
      const expectedException = '''
[QueryIMDBSuggestions] Error in imdbSuggestions with criteria 123 interpreting web text as a map :FormatException: Unexpected character (at character 2)
{not valid json}
 ^
''';

      // Invoke the functionality.
      await imdbSuggestions
          .readList(
            source: _emitInvalidJsonPSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read IMDB suggestions from a simulated byte stream and convert JSON to dtos.
    test('unexpected json contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBSuggestions] Error in imdbSuggestions '
          'with criteria 123 translating page map to objects '
          ':expected map got Null unable to interpret data null';
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSuggestions(criteria);

      // Invoke the functionality.
      await imdbSuggestions
          .readList(
            source: _emitUnexpectedJsonPSample,
          )
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
