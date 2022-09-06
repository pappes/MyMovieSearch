import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_cast.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '{"source":"imdb","uniqueId":"tt0101000","languages":[],"genres":[],"keywords":[],"related":"{Directed by:: (nm1097284), Cast:: (nm0398703, nm0366123, nm0814162, nm0610846, ..., nm0275857, nm0575922), Music by:: (nm0880720), Cinematography by:: (nm0299592), Film Editing by:: (nm2919431), Art Direction by:: (nm0810552), Costume Design by:: (nm0532669), Production Management:: (nm2761158), Sound Department:: (nm0468088), Camera and Electrical Department:: (nm0463004)}"}',
  '{"source":"imdb","uniqueId":"tt0101001","languages":[],"genres":[],"keywords":[],"related":"{Directed by:: (nm0522902), Writing Credits:: (nm0522902, nm7832339), Cast:: (nm1903001, nm7371229, nm0948072, nm0423271, nm0530839, nm1293419, nm2403022), Produced by:: (nm4086248), Production Management:: (nm7832339)}"}',
  '{"source":"imdb","uniqueId":"tt0101002","languages":[],"genres":[],"keywords":[],"related":"{Directed by:: (nm0156432), Writing Credits:: (nm0156432, nm0939182), Cast:: (nm0849257, nm0497213, nm0516240, nm0945189, ..., nm3472222, nm0950963), Produced by:: (nm0849257, nm0849331, nm2550043), Music by:: (nm0482657), Cinematography by:: (nm0490486, nm11436615), Art Direction by:: (nm0369130), Makeup Department:: (nm0341344, nm4984121), Production Management:: (nm5109290, nm5108288), Second Unit Director or Assistant Director:: (nm1224058), Stunts:: (nm0389883, nm0477094, nm0876600), Camera and Electrical Department:: (nm10091321, nm0508670, nm0594224), Script and Continuity Department:: (nm0151755, nm0387341, nm2445533), Additional Crew:: (nm2807214, nm0849331, nm9248293)}"}',
];

/// Create a string list with [qty] unique criteria values.
List<String> _makeQueries(int qty) {
  final results = <String>[];
  for (int i = 0; i < qty; i++) {
    results.add('tt010${1000 + i}');
  }
  return results;
}

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures = [];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    final future = QueryIMDBCastDetails().readList(criteria);
    futures.add(future);
  }
  return futures;
}

Future<List<MovieResultDTO>> _testRead(List<String> criteria) async {
  // Call IMDB for each criteria in the list.
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

  group('live QueryIMDBCastDetails test', () {
    // Convert 3 IMDB pages into dtos.
    test('Run read 3 pages from IMDB', () async {
      final queries = _makeQueries(3);
      final actualOutput = await _testRead(queries);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      //print(actualOutput.toJsonStrings());
      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(expectedOutput),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
