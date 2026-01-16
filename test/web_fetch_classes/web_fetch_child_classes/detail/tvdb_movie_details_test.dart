import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tvdb_movie_details.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tvdb_movie_details.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tvdb_movie_details.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';
import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(_) =>
    Future.value(Stream.value('[{"hello":"world"}]'));

Future<Stream<String>> _emitInvalidJsonSample(_) =>
    Future.value(Stream.value('not valid json'));

final imdbCriteria = SearchCriteriaDTO().fromString('tt1231');
final dto = MovieResultDTO()..init(type: MovieContentType.movie.toString());

final tvdbCriteria = SearchCriteriaDTO().fromString('987654');

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
  ////////////////////////////////////////////////////////////////////////////////

  group('tvdb details unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryTVDBMovieDetails(imdbCriteria).myDataSourceName(),
        'QueryTVDBMovieDetails',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryTVDBMovieDetails(imdbCriteria).myFormatInputAsText(),
        imdbCriteria.criteriaTitle,
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
        QueryTVDBMovieDetails(input).myFormatInputAsText(),
        contains('test1'),
      );
      expect(
        QueryTVDBMovieDetails(input).myFormatInputAsText(),
        contains('test2'),
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'uniqueId': '-2',
        'bestSource': 'DataSourceType.tvdbDetails',
        'title': '[tvdbDetails] new query',
        'type': 'MovieContentType.error',
      };
      MovieResultDTOHelpers.resetError();

      // Invoke the functionality.
      final actualResult = QueryTVDBMovieDetails(
        imdbCriteria,
      ).myYieldError('new query').toMap();

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      final expectedOutput = intermediateMovieList;
      final actualOutput = QueryTVDBMovieDetails(
        imdbCriteria,
      ).myConvertWebTextToTraversableTree(jsonSampleFull);
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () {
      final expectedOutput = intermediateErrorList;
      final actualOutput = QueryTVDBMovieDetails(
        imdbCriteria,
      ).myConvertWebTextToTraversableTree(jsonSampleEmpty);
      expect(actualOutput, completion(expectedOutput));
    });
    test('Run myConvertWebTextToTraversableTree() for invalid results', () {
      final expectedOutput = throwsA(
        isA<WebConvertException>().having(
          (e) => e.cause,
          'cause',
          'TVDB results data not detected for criteria tt1231 in '
              'json:{"status_code":7,"status_message":"Invalid API key: '
              'You must be granted a valid key.","success":false}',
        ),
      );
      final actualOutput = QueryTVDBMovieDetails(
        imdbCriteria,
      ).myConvertWebTextToTraversableTree(jsonSampleError);
      expect(actualOutput, expectedOutput);
    });
  });

  group('TvdbDetailsConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap() for Empty', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateErrorList) {
        actualResult.addAll(
          TvdbMovieDetailConverter(
            MovieContentType.movie,
          ).dtoFromCompleteJsonMap(map as Map),
        );
      }

      // Uncomment this line to update expectedDTOList if sample data changes
      // writeTestData(actualResult, suffix: '_empty.json');

      final expectedValue = readTestData(suffix: '_empty.json');
      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap() for Movie', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMovieList) {
        actualResult.addAll(
          TvdbMovieDetailConverter(
            MovieContentType.movie,
          ).dtoFromCompleteJsonMap(map as Map),
        );
      }

      // Uncomment this line to update expectedDTOList if sample data changes
      // writeTestData(actualResult, suffix: '_movie.json');

      final expectedValue = readTestData(suffix: '_movie.json');
      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap() for Series', () {
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateSeriesList) {
        actualResult.addAll(
          TvdbMovieDetailConverter(
            MovieContentType.movie,
          ).dtoFromCompleteJsonMap(map as Map),
        );
      }

      // Uncomment this line to update expectedDTOList if sample data changes
      // writeTestData(actualResult, suffix: '_series.json');

      final expectedValue = readTestData(suffix: '_series.json');
      // Check the results.
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
  });
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryTVDBMovieDetails uri tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI() for imdbid', () {
      final testClass = QueryTVDBMovieDetails(imdbCriteria);
      const expected =
          'https://api4.thetvdb.com/v4/search?query=tt1234/extended?short=true';

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI('tt1234').toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
    // Confirm URL is constructed as expected.
    test('Run myConstructURIAsync() for imdbid', () async {
      // clone criteria to avoid impacting other test
      final testClass = QueryTVDBMovieDetails(imdbCriteria.clone());
      const expected =
          'https://api4.thetvdb.com/v4/movies/409676/extended?short=true';

      // Invoke the functionality.
      final actualResult = await testClass.myConstructURIAsync('tt1234');

      // Check the results.
      expect(actualResult.toString(), startsWith(expected));
    });
    // Confirm URL is constructed as expected.
    test('Run myConstructURI() for movie tvdbid', () {
      dto.type = MovieContentType.movie;
      final criteria = tvdbCriteria.clone()..criteriaContext = dto;
      final testClass = QueryTVDBMovieDetails(criteria);
      const expected =
          'https://api4.thetvdb.com/v4/movies/987654/extended?short=true';

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI('987654').toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
    // Confirm URL is constructed as expected.
    test('Run myConstructURI() for series tvdbid', () {
      dto.type = MovieContentType.series;
      final criteria = tvdbCriteria.clone()..criteriaContext = dto;
      final testClass = QueryTVDBMovieDetails(criteria);
      const expected =
          'https://api4.thetvdb.com/v4/series/987654/extended?short=true';

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI('987654').toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
    // Confirm URL is constructed as expected.
    test('Run myConstructURI() for person tvdbid', () {
      dto.type = MovieContentType.person;
      final criteria = tvdbCriteria.clone()..criteriaContext = dto;
      final testClass = QueryTVDBMovieDetails(criteria);
      const expected =
          'https://api4.thetvdb.com/v4/people/987654/extended?short=true';

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI('987654').toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
    // Confirm URL is constructed as expected.
    test('Run myConstructURI() for episode tvdbid', () {
      dto.type = MovieContentType.episode;
      final criteria = tvdbCriteria.clone()..criteriaContext = dto;
      final testClass = QueryTVDBMovieDetails(criteria);
      const expected =
          'https://api4.thetvdb.com/v4/episodes/987654/extended?short=true';

      // Invoke the functionality.
      final actualResult = testClass.myConstructURI('987654').toString();

      // Check the results.
      expect(actualResult, startsWith(expected));
    });
  });
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryTVDBMovieDetails
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryTVDBMovieDetails integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final testClass = QueryTVDBMovieDetails(imdbCriteria);
      final actualResult = <MovieResultDTO>[];

      // Invoke the functionality and collect results.
      for (final map in intermediateMovieList) {
        actualResult.addAll(await testClass.myConvertTreeToOutputType(map));
      }

      // Check the results.
      final expectedValue = readTestData(suffix: '_movie.json');
      expect(
        actualResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${actualResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });
    // Test error detection.
    test('myConvertTreeToOutputType() errors', () {
      final expectedOutput = throwsA(
        isA<TreeConvertException>().having(
          (e) => e.cause,
          'cause',
          startsWith(
            'expected map got String unable to interpret data wrongData',
          ),
        ),
      );
      final testClass = QueryTVDBMovieDetails(imdbCriteria);

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryTVDBMovieDetails
  ////////////////////////////////////////////////////////////////////////////////

  group('tvdb search query', () {
    // Read tvdb search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTVDBMovieDetails(imdbCriteria);

      // Invoke the functionality.
      await testClass
          .readList(source: streamTvdbJsonOfflineData)
          .then(queryResult.addAll)
          .onError(
            // Print any errors encountered during processing.
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      final expectedValue = readTestData(suffix: '_movie.json');
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Read tvdb search results from a simulated byte stream
    // and report error due to invalid json.
    test('invalid json', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTVDBMovieDetails(imdbCriteria);
      const expectedException =
          '[tvdbDetails] Error in QueryTVDBMovieDetails with criteria tt1231 '
          'convert error interpreting web text as a map '
          ':Invalid json returned from web call not valid json';

      // Invoke the functionality.
      await testClass
          .readList(source: _emitInvalidJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read tvdb search results from a simulated byte stream
    // and report error due to unexpected json.
    test('unexpected json contents', () async {
      // Set up the test data.
      const expectedException =
          '[tvdbDetails] Error in QueryTVDBMovieDetails with criteria tt1231 '
          'convert error interpreting web text as a map '
          ':TVDB results data not detected for criteria '
          'tt1231 in json:[{"hello":"world"}]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryTVDBMovieDetails(imdbCriteria);

      // Invoke the functionality.
      await testClass
          .readList(source: _emitUnexpectedJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
