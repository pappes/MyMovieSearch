// allow test to do thing production code should not
// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/yts_detail_api.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/yts_detail_api.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/yts_detail_api.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

import '../../../test_helper.dart';

Future<Stream<String>> _emitUnexpectedJsonSample(_) =>
    Future.value(Stream.value('["stuff"]'));

Future<Stream<String>> _emitInvalidJsonSample(_) =>
    Future.value(Stream.value('not valid json'));

SearchCriteriaDTO sampleCriteria() {
  final dto = MovieResultDTO().init(uniqueId: 'tt7602562');
  return SearchCriteriaDTO().fromString('movie title')..criteriaContext = dto;
}

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryYtsDetailApi unit tests', () {
    // Confirm class description is constructed as expected.
    test('Run myDataSourceName()', () {
      expect(
        QueryYtsDetailApi(sampleCriteria()).myDataSourceName(),
        'yts_detail_api',
      );
    });

    // Confirm criteria is displayed as expected.
    test('Run myFormatInputAsText() for SearchCriteriaDTO title', () {
      expect(
        QueryYtsDetailApi(sampleCriteria()).myFormatInputAsText(),
        'tt7602562',
      );
    });

    // Confirm error is constructed as expected.
    test('Run myYieldError()', () {
      const expectedResult = {
        'title': '[QueryYtsDetailApi] new query',
        'bestSource': 'DataSourceType.ytsDetailApi',
        'type': 'MovieContentType.error',
      };
      final criteria = SearchCriteriaDTO();
      // Invoke the functionality.
      final actualResult = QueryYtsDetailApi(
        criteria,
      ).myYieldError('new query').toMap()..remove('uniqueId');

      // Check the results.
      expect(actualResult, expectedResult);
    });
    // Confirm web text is parsed  as expected.
    test('Run myConvertWebTextToTraversableTree()', () {
      const expectedOutput = jsonSampleSimple;
      final testClass = QueryYtsDetailApi(sampleCriteria());
      final actualOutput = testClass.myConvertWebTextToTraversableTree(
        jsonTextSimple,
      );
      expect(actualOutput, completion([expectedOutput]));
    });
    test('Run myConvertWebTextToTraversableTree() for 0 results', () {
      const expectedOutput = jsonSampleNotFound;
      final actualOutput = QueryYtsDetailApi(
        sampleCriteria(),
      ).myConvertWebTextToTraversableTree(jsonTextNotFound);
      expect(actualOutput, completion([expectedOutput]));
    });
  });

  group('YtsDetailConverter unit tests', () {
    // Confirm map can be converted to DTO.
    test('Run dtoFromCompleteJsonMap()', () {
      final actualResult = YtsDetailApiConverter.dtoFromCompleteJsonMap(
        jsonSampleSimple,
      );

      // Uncomment this line to update expectedDTOList if sample data changes
      // writeTestData(actualResult);

      final expectedValue = readTestData();
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
    test('Run dtoFromCompleteJsonMap() empty', () {
      final actualResult = YtsDetailApiConverter.dtoFromCompleteJsonMap(
        jsonSampleNotFound,
      );

      // Uncomment this line to update expectedDTOList if sample data changes
      // writeTestData(actualResult);

      final expectedValue = <MovieResultDTO>[];
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
    test('Run dtoFromCompleteJsonMap() extra seeders', () async {
      final basicResult = YtsDetailApiConverter.dtoFromCompleteJsonMap(
        jsonSampleSimple,
      );
      var extendedResult = basicResult;
      // Backup the original list of magnet sources.
      final originalUrls = List<String>.from(magnetSources);
      try {
        await YtsDetailApiConverter.init();
        extendedResult = YtsDetailApiConverter.dtoFromCompleteJsonMap(
          jsonSampleSimple,
        );
      } finally {
        // Restore the original list of magnet sources.
        magnetSources
          ..clear()
          ..addAll(originalUrls);
      }

      // Check the results.
      expect(
        basicResult.first.imageUrl.length,
        lessThan(extendedResult.first.imageUrl.length),
        reason:
            'Emitted image URL length \n${basicResult.first.imageUrl} \n'
            'needs to be less than expected image URL length \n'
            '${extendedResult.first.imageUrl}',
      );
    });
  });

  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using env
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryYtsDetailApi integration tests', () {
    // Confirm URL is constructed as expected.
    test('Run myConstructURI()', () {
      const expected =
          'https://movies-api.accel.li/api/v2/movie_details.json?imdb_id=1234';

      // Invoke the functionality.
      final actualResult = QueryYtsDetailApi(
        sampleCriteria(),
      ).myConstructURI('1234').toString();

      // Check the results.
      expect(actualResult, expected);
    });
  });
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using QueryYtsDetailApi
  ////////////////////////////////////////////////////////////////////////////////

  group('QueryYtsDetailApi integration tests', () {
    // Confirm map can be converted to DTO.
    test('Run myConvertTreeToOutputType()', () async {
      final testClass = QueryYtsDetailApi(sampleCriteria());
      await testClass.myClearCache();

      final actualResult = await testClass.myConvertTreeToOutputType(
        jsonSampleSimple,
      );

      // Check the results.
      final expectedValue = readTestData();
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
    test('myConvertTreeToOutputType() errors', () async {
      final expectedOutput = throwsA(
        isA<TreeConvertException>().having(
          (e) => e.cause,
          'cause',
          startsWith(
            'expected map got String unable to interpret data wrongData',
          ),
        ),
      );
      final testClass = QueryYtsDetailApi(sampleCriteria());
      await testClass.myClearCache();

      // Invoke the functionality and collect results.
      final actualResult = testClass.myConvertTreeToOutputType('wrongData');

      // Check the results.
      // NOTE: Using expect on an async result
      // only works as the last line of the test!
      expect(actualResult, expectedOutput);
    });
  });

  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests using WebFetchBase and env and QueryYtsDetailApi
  ////////////////////////////////////////////////////////////////////////////////

  group('imdb search query', () {
    // Read imdb search results from a simulated byte stream
    // and convert JSON to dtos.
    test('Run readList()', () async {
      // Set up the test data.
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryYtsDetailApi(sampleCriteria());
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: streamhtmlOfflineData)
          .then(queryResult.addAll)
          .onError(
            // Print any errors encountered during processing.
            // ignore: avoid_print
            (error, stackTrace) => print('$error, $stackTrace'),
          );

      // Check the results.
      final expectedValue = readTestData();
      expect(
        queryResult,
        MovieResultDTOListMatcher(expectedValue),
        reason:
            'Emitted DTO list ${queryResult.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedValue.toPrintableString()}',
      );
    });

    // Read imdb search results from a simulated byte stream
    // and report error due to invalid json.
    test('invalid json', () async {
      // Set up the test data.
      const expectedException =
          '[QueryYtsDetailApi] Error in yts_detail_api with criteria tt7602562 '
          'convert error interpreting web text as a map '
          ':Invalid json FormatException: '
          'Unexpected character (at character 1)\n'
          'not valid json\n'
          '^\n';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryYtsDetailApi(sampleCriteria());
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: _emitInvalidJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);
    });

    // Read imdb search results from a simulated byte stream
    // and report error due to unexpected json.
    test('unexpected json contents', () async {
      // Set up the test data.
      const expectedException =
          '[QueryYtsDetailApi] Error in yts_detail_api with '
          'criteria tt7602562 convert error translating page map to objects '
          ':expected map got List<dynamic> unable to interpret data [stuff]';
      final queryResult = <MovieResultDTO>[];
      final testClass = QueryYtsDetailApi(sampleCriteria());
      await testClass.myClearCache();

      // Invoke the functionality.
      await testClass
          .readList(source: _emitUnexpectedJsonSample)
          .then(queryResult.addAll);
      expect(queryResult.first.title, expectedException);

      // Check the results.
    });
  });
}
