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

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('imdb suggestions unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () async {
      expect(QueryIMDBSuggestions().myDataSourceName(), 'imdbSuggestions');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () async {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryIMDBSuggestions().myFormatInputAsText(input),
        'testing',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO criteriaList',
        () async {
      final input = SearchCriteriaDTO();
      input.criteriaList = [
        MovieResultDTO().error('test1'),
        MovieResultDTO().error('test2'),
      ];
      expect(
        QueryIMDBSuggestions().myFormatInputAsText(input),
        contains('test1'),
      );
      expect(
        QueryIMDBSuggestions().myFormatInputAsText(input),
        contains('test2'),
      );
    });

    // Confirm map can be converted to DTO.
    test('Run myTransformMapToOutput()', () async {
      final expectedValue = await expectedDTOList;
      final imdbSuggestions = QueryIMDBSuggestions();

      // Invoke the functionality and collect results.
      final actualResult = await imdbSuggestions
          .myConvertTreeToOutputType({'d': expectedDTOMap});

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });

    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () async {
      const expectedResult =
          'https://sg.media-imdb.com/suggests/n/new%20query.json';

      // Invoke the functionality.
      final actualResult =
          QueryIMDBSuggestions().myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, expectedResult);
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () async {
      const expectedResult = {
        'uniqueId': '-1',
        'source': 'DataSourceType.imdbSuggestions',
        'title': '[QueryIMDBSuggestions] new query',
        'type': 'MovieContentType.custom',
        'related': {}
      };

      // Invoke the functionality.
      final actualResult =
          QueryIMDBSuggestions().myYieldError('new query').toMap();

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
      final expectedValue = await expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSuggestions();

      // Invoke the functionality.
      await imdbSuggestions
          .readList(SearchCriteriaDTO(), source: emitImdbSuggestionJsonPSample)
          .then((values) => queryResult.addAll(values))
          .onError(
            // ignore: avoid_print
            (error, stackTrace) => print('$error, ${stackTrace.toString()}'),
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
      final imdbSuggestions = QueryIMDBSuggestions();
      const expectedException = '''
[QueryIMDBSuggestions] Error in imdbSuggestions with criteria  interpreting web text as a map :FormatException: Unexpected character (at character 2)
{not valid json}
 ^
''';

      // Invoke the functionality.
      await imdbSuggestions
          .readList(SearchCriteriaDTO(), source: _emitInvalidJsonPSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read IMDB suggestions from a simulated byte stream and convert JSON to dtos.
    test('unexpected json contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryIMDBSuggestions] Error in imdbSuggestions with criteria  translating page map to objects :expected map got Null unable to interpret data null';
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSuggestions();

      // Invoke the functionality.
      await imdbSuggestions
          .readList(SearchCriteriaDTO(), source: _emitUnexpectedJsonPSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
