import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_suggestions.dart';
import 'test_data/imdb_suggestion_converter_data.dart';
import 'test_helper.dart';

Future<Stream<String>> emitUnexpectedJsonPSample(dynamic dummy) {
  return Future.value(Stream.value('imdbJsonPFunction(null)'));
}

Future<Stream<String>> emitInvalidJsonPSample(dynamic dummy) {
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
        'source': 'DataSourceType.imdbSuggestions',
        'title': '[QueryIMDBSuggestions] new query',
        'type': 'MovieContentType.custom',
        'related': '{}'
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
    // Confirm map can be converted to DTO.
    test('Run myTransformMapToOutput()', () async {
      final expectedValue = await expectedDTOList;
      final imdbSuggestions = QueryIMDBSuggestions();

      // Invoke the functionality and collect results.
      final actualResult =
          imdbSuggestions.myTransformMapToOutput({'d': expectedDTOMap});

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emmitted DTO list ${actualResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });

    // Read IMDB suggestions from a simulated bytestream and convert JSON to dtos.
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
        reason: 'Emmitted DTO list ${queryResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });

    // Read IMDB suggestions from a simulated bytestream and convert JSON to dtos.
    test('invalid jsonp', () async {
      // Set up the test data.
      final expectedValue = <MovieResultDTO>[];
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSuggestions();
      late String actualException;
      const expectedException = '''
FormatException: Unexpected character (at character 2)
{not valid json}
 ^
''';

      // Invoke the functionality.
      await imdbSuggestions
          .readList(SearchCriteriaDTO(), source: emitInvalidJsonPSample)
          .then((values) => queryResult.addAll(values))
          .onError(
        // ignore: avoid_print
        (error, stackTrace) {
          actualException = error.toString();
        },
      );
      expect(actualException, expectedException);

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emmitted DTO list ${queryResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });

    // Read IMDB suggestions from a simulated bytestream and convert JSON to dtos.
    test('unexpected json contents', () async {
      // Set up the test data.
      final expectedValue = <MovieResultDTO>[];
      final queryResult = <MovieResultDTO>[];
      final imdbSuggestions = QueryIMDBSuggestions();
      late String actualException;
      const expectedException = null;

      // Invoke the functionality.
      await imdbSuggestions
          .readList(SearchCriteriaDTO(), source: emitUnexpectedJsonPSample)
          .then((values) => queryResult.addAll(values))
          .onError(
        // ignore: avoid_print
        (error, stackTrace) {
          actualException = error.toString();
        },
      );
      expect(actualException, expectedException);

      // Check the results.
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emmitted DTO list ${queryResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });
  });
}
