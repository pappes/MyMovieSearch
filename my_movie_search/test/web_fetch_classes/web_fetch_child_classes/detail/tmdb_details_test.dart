import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tmdb_movie_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tmdb_movie_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_movie_detail.dart';
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
      expect(QueryTMDBMovieDetails().myDataSourceName(), 'tmdbMovie');
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () async {
      final input = SearchCriteriaDTO();
      input.criteriaTitle = 'testing';
      expect(
        QueryTMDBMovieDetails().myFormatInputAsText(input),
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
        QueryTMDBMovieDetails().myFormatInputAsText(input),
        contains('test1'),
      );
      expect(
        QueryTMDBMovieDetails().myFormatInputAsText(input),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () async {
      const expectedResult = {
        'source': 'DataSourceType.tmdbMovie',
        'title': '[QueryTMDBDetails] new query',
        'type': 'MovieContentType.custom',
        'related': '{}'
      };

      // Invoke the functionality.
      final actualResult =
          QueryTMDBMovieDetails().myYieldError('new query').toMap();
      actualResult.remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
  });

  group('QueryTMDBMovieDetails unit tests', () {
    // Confirm webtext is parsed  as expected.
    test('Run myDataSourceName()', () async {
      final expectedOutput = intermediateMapList;
      final actualOutput =
          await QueryTMDBMovieDetails().myConvertWebTextToTraversableTree(
        tmdbJsonSearchFull,
      );
      expect(actualOutput, expectedOutput);
    });
  });

  group('GoogleSearchConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () async {
      final expectedValue = expectedDTOList;
      //final expectedValue = <MovieResultDTO>[];
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMapList) {
        actualResult.addAll(
          TmdbMovieDetailConverter.dtoFromCompleteJsonMap(map as Map),
        );
      }

      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason: 'Emmitted DTO list ${actualResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
////////////////////////////////////////////////////////////////////////////////

  group('QueryTMDBMovieDetails integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () async {
      await EnvironmentVars.init();
      const expected = 'https://api.themoviedb.org/3/movie/1234?api_key=';

      // Invoke the functionality.
      final actualResult =
          QueryTMDBMovieDetails().myConstructURI('1234').toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
  });
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using GoogleSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('GoogleSearchConverter integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final testClass = QueryTMDBMovieDetails();
      final expectedValue = expectedDTOList;
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
        reason: 'Emmitted DTO list ${actualResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () async {
      final testClass = QueryTMDBMovieDetails();

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
  /// Integration tests using WebFetchBase and env and GoogleSearchConverter
////////////////////////////////////////////////////////////////////////////////

  group('tmdb search query', () {
    // Read tmdb search results from a simulated bytestream and convert JSON to dtos.
    test('Run readList()', () async {
      // Wait for api key to be initialised
      await EnvironmentVars.init();
      // Set up the test data.
      final expectedValue = expectedDTOList;
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBMovieDetails();

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
        reason: 'Emmitted DTO list ${queryResult.toString()} '
            'needs to match expected DTO list ${expectedValue.toString()}',
      );
    });

    // Read tmdb search results from a simulated bytestream and report error due to invalid html.
    test('invalid html', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBMovieDetails();
      const expectedException = '''
[QueryTMDBDetails] Error in tmdbMovie with criteria  intepreting web text as a map :FormatException: Unexpected character (at character 1)
not valid json
^
''';

      // Invoke the functionality.
      await testClass
          .readList(SearchCriteriaDTO(), source: _emitInvalidJsonSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);
    });

    // Read tmdb search results from a simulated bytestream and report error due to unexpected html.
    test('unexpected html contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryTMDBDetails] Error in tmdbMovie with criteria  translating pagemap to objects :expected map got List<dynamic> unable to interpret data [{hello: world}]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTMDBMovieDetails();

      // Invoke the functionality.
      await testClass
          .readList(SearchCriteriaDTO(), source: _emitUnexpectedJsonSample)
          .then((values) => queryResult.addAll(values));
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
