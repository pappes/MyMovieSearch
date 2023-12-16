import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////
// Class to assist with Restorable tests
class RestorationTestParent extends State with RestorationMixin {
  RestorationTestParent(this.uniqueId);
  String uniqueId;
  final criteria = RestorableSearchCriteria();

  @override
  // The restoration bucket id for this page.
  String get restorationId => 'abc';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) =>
      // Register our property to be saved every time it changes,
      // and to be restored every time our app is killed by the OS!
      registerForRestoration(criteria, '${uniqueId}criteria');

  @override
  Widget build(BuildContext context) => const Text('');
}

void compareCriteria(SearchCriteriaDTO actual, SearchCriteriaDTO matcher) {
  expect(actual.criteriaType, matcher.criteriaType);
  expect(actual.criteriaTitle, matcher.criteriaTitle);
  expect(actual.searchId, matcher.searchId);
  expect(
    actual.criteriaList.first,
    MovieResultDTOMatcher(matcher.criteriaList.first),
  );
  expect(
    actual.criteriaList.last,
    MovieResultDTOMatcher(matcher.criteriaList.last),
  );
}

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

void main() {
  group('toMap_toMovieResultDTO', () {
    // Compare a dto to a map equivialent of the dto.
    void testToSearchCriteriaDTO(
      SearchCriteriaDTO expected,
      Map<String, String> map,
    ) {
      final actual = map.toSearchCriteriaDTO();

      compareCriteria(expected, actual);
    }

    // Convert a dto to a map.
    test('single_DTO', () {
      final dto = makeCriteriaDTO('abc');

      final map = dto.toMap();

      testToSearchCriteriaDTO(dto, map);
    });
  });
  group('RestoreSearchCriteriaDTO', () {
    // Convert a restorable dto to JSON
    //and then convert the JSON to a restorable dto.
    test('RestorableCriteria', () {
      final criteria = makeCriteriaDTO('abc');
      final rtp = RestorationTestParent(criteria.criteriaTitle)
        ..restoreState(null, true);

      final encoded = rtp.criteria.dtoToPrimitives(criteria);
      rtp.criteria.initWithValue(rtp.criteria.fromPrimitives(encoded));
      final encoded2 = rtp.criteria.toPrimitives();

      compareCriteria(criteria, rtp.criteria.value);
      expect(encoded, encoded2);
    });
  });
}
