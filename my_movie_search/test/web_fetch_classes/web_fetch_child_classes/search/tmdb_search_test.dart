import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/tmdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/tmdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tmdb.dart';
import 'package:my_movie_search/utilities/environment.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(dynamic dummy) {
  return Future.value(Stream.value('[{"hello":"world"}]'));
}

Future<Stream<String>> _emitInvalidJsonSample(dynamic dummy) {
  return Future.value(Stream.value('not valid json'));
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
////////////////////////////////////////////////////////////////////////////////

  group('tmdb search unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () async {
      expect(QueryTMDBMovies().myDataSourceName(), 'tmdbMovie');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () async {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryTMDBMovies().myFormatInputAsText(input),
        'testing',
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
        QueryTMDBMovies().myFormatInputAsText(input),
        contains('test1'),
      );
      expect(
        QueryTMDBMovies().myFormatInputAsText(input),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () async {
      const expectedResult = {
        'source': 'DataSourceType.tmdbMovie',
        'title': '[QueryTMDBMovies] new query',
        'type': 'MovieContentType.custom',
        'related': '{}'
      };

      // Invoke the functionality.
      final actualResult = QueryTMDBMovies().myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () async {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          await QueryTMDBMovies().myConvertWebTextToTraversableTree(
        tmdbJsonSearchFull,
      );
      expect(actualOutput, expectedOutput);
    });
  });

  group('TmdbMovieSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () async {
      final expectedValue = expectedDTOList;
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          TmdbMovieSearchConverter.dtoFromCompleteJsonMap(map as Map),
        );
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryTMDBMovies integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () async {
      await EnvironmentVars.init();
      const expectedResult1 =
          'https://api.themoviedb.org/3/search/movie?api_key=';
      const expectedResult2 = '&query=new%20query&page=1';

      // Invoke the functionality.
      final actualResult =
          QueryTMDBMovies().myConstructURI('new query').toString();

      // Check the results.
      expect(actualResult, startsWith(expectedResult1));
      expect(actualResult, endsWith(expectedResult2));
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryTMDBMovies
////////////////////////////////////////////////////////////////////////////////

  group('QueryTMDBMovies integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final expectedValue = expectedDTOList;
      final testClass = QueryTMDBMovies();
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          await testClass.myConvertTreeToOutputType(map),
        );
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list ${expectedValue.toPrintableString()}',
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () async {
      final testClass = QueryTMDBMovies();

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      //NOTE: Using expect on an async result only works as the last line of the test!
      expect(
        actualResult,
        throwsA('expected map got String unable to interpret data wrongData'),
      );
    });
  });

////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryTMDBMovies
////////////////////////////////////////////////////////////////////////////////

  group('tmdb search query', () {
    // Read tmdb search results from a simulated byte stream and convert JSON to dtos.
    test('Run readList()', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBMovies();

      // Invoke the functionality.
      await testClass
          .readList(
            SearchCriteriaDTO(),
            source: streamTmdbJsonOfflineData,
          )
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

    // Read tmdb search results from a simulated byte stream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBMovies();
      const expectedException = '''
[QueryTMDBMovies] Error in tmdbMovie with criteria  interpreting web text as a map :FormatException: Unexpected character (at character 1)
not valid json
^
''';

      // Invoke the functionality.
      await testClass
          .readList(SearchCriteriaDTO(), source: _emitInvalidJsonSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read tmdb search results from a simulated byte stream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryTMDBMovies] Error in tmdbMovie with criteria  translating page map to objects :expected map got List<dynamic> unable to interpret data [{hello: world}]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBMovies();

      // Invoke the functionality.
      await testClass
          .readList(SearchCriteriaDTO(), source: _emitUnexpectedJsonSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
