import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/yts_detail.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"magnet:?xt=urn:btih:35EB8826EA87E7D655949F8A715CD36FEB0730F3&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B2160p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce","bestSource":"DataSourceType.ytsDetails","title":"2001: A Space Odyssey","type":"MovieContentType.download","year":"1968","creditsOrder":"81","description":"7.02 GB 3840*1746 English 5.1 NR","imageUrl":"https://img.yts.mx/assets/images/movies/2001_a_space_odyssey_1968/medium-cover.jpg","sources":{"DataSourceType.ytsDetails":"magnet:?xt=urn:btih:35EB8826EA87E7D655949F8A715CD36FEB0730F3&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B2160p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce","bestSource":"DataSourceType.ytsDetails","title":"2001: A Space Odyssey","type":"MovieContentType.download","year":"1968","description":"2.38 GB 1920*864 English 2.0 NR","imageUrl":"https://img.yts.mx/assets/images/movies/2001_a_space_odyssey_1968/medium-cover.jpg","sources":{"DataSourceType.ytsDetails":"magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce"}}
''',
  r'''
{"uniqueId":"magnet:?xt=urn:btih:E3529DBC0CE47429A8A9B411AB381C893BFEF575&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B720p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce","bestSource":"DataSourceType.ytsDetails","title":"2001: A Space Odyssey","type":"MovieContentType.download","year":"1968","creditsOrder":"51","description":"853.57 MB 1280*720 English 2.0 NR","imageUrl":"https://img.yts.mx/assets/images/movies/2001_a_space_odyssey_1968/medium-cover.jpg","sources":{"DataSourceType.ytsDetails":"magnet:?xt=urn:btih:E3529DBC0CE47429A8A9B411AB381C893BFEF575&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B720p%5D+%5BYTS.MX%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.tracker.cl%3A1337%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=https%3A%2F%2Fopentracker.i2p.rocks%3A443%2Fannounce"}}
''',
];

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (int i = 0; i < qty - 1; i++) {
    results.add('tt010${1000 + i}');
  }
  results.add('2001-a-space-odyssey-1968');
  return results;
}

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    // ignore: discarded_futures
    final future = QueryYtsDetails(criteria).readList();
    futures.add(future);
  }
  return futures;
}

Future<List<MovieResultDTO>> _testRead(List<String> criteria) async {
  // Call webfetch for each criteria in the list.
  final futures = _queueDetailSearch(criteria);

  // Collect the result of all the IMDB queries.
  final queryResult = <MovieResultDTO>[];
  for (final future in futures) {
    queryResult.addAll(await future);
  }
  return queryResult;
}

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryYtsDetails test', () {
    // Convert 3 YTS pages into dtos.
    test('Run read 3 pages from YTS', () async {
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);

      // To update expected data, uncomment the following lines
      // printTestData(actualOutput);

      final expectedOutput = expectedDTOList;
      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 50),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('unknown-movie-2000');
      final actualOutput = await QueryYtsDetails(criteria).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(
          expectedOutput,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
  });
}
