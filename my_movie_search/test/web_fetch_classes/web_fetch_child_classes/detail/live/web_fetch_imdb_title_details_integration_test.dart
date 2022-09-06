import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';

import '../../../../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '{"source":"imdb","uniqueId":"tt0101000","title":"Zacátek dlouhého podzimu","type":"movie","year":"1990","yearRange":"1990","runTime":"4860","language":"foreign","languages":["Czech"],"genres":["Drama"],"keywords":[],"userRating":"5.0","userRatingCount":"7","related":"{Directed by:: (nm1097284), Cast:: (nm0398703, nm0366123, nm0814162, -1, nm0610846, ..., nm1189926, nm0275857)}"}',
  '{"source":"imdb","uniqueId":"tt0101001","title":"Zai shi feng liu jie","type":"movie","year":"1985","yearRange":"1985","runTime":"5340","language":"foreign","languages":["Cantonese"],"genres":["Horror"],"keywords":[],"imageUrl":"https://m.media-amazon.com/images/M/MV5BYjJkYzRkNzMtZWVkYy00MmRjLWE1YTQtYmIwOWE4MTkyZWFmXkEyXkFqcGdeQXVyNzc5MjA3OA@@._V1_QL75_UX190_CR0,1,190,281_.jpg","related":"{Directed by:: (nm0522902), Cast:: (nm1903001, nm7371229, nm0948072, -1, nm0423271, ..., nm1293419, nm2403022)}"}',
  '{"source":"imdb","uniqueId":"tt0101002","title":"Joi jin gong woo","type":"movie","year":"1990","yearRange":"1990","runTime":"6480","language":"someEnglish","languages":["Cantonese","English"],"genres":["Action","Drama"],"keywords":["gangster"],"description":"A well-known gangster is released from prison, and decides look for his daughter with the help of a troubled young woman.","userRating":"6.4","userRatingCount":"152","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjM0MDE5NGYtZDQ1ZC00ZDU5LWFjMmUtOTNiN2RmMTJkMjM2XkEyXkFqcGdeQXVyMzU0NzkwMDg@._V1_QL75_UY281_CR5,0,190,281_.jpg","related":"{Directed by:: (nm0156432), Cast:: (nm0849257, nm0497213, nm0516240, -1, nm0945189, ..., nm0504898, nm1816800), Suggestions:: (tt0100777, tt0100995, tt0098708, tt0096236, ..., tt0093305, tt19717996)}"}',
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
    final future = QueryIMDBTitleDetails().readList(criteria);
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

  group('live QueryIMDBTitleDetails test', () {
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
