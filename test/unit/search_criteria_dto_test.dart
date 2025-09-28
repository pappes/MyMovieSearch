import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import '../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////
// Class to assist with Restorable tests
class RestorationTestParent extends State with RestorationMixin {
  RestorationTestParent(this.uniqueId);
  String uniqueId;
  final _criteria = RestorableSearchCriteria();

  @override
  // The restoration bucket id for this page.
  String get restorationId => 'abc';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) =>
      // Register our property to be saved every time it changes,
      // and to be restored every time our app is killed by the OS!
      registerForRestoration(_criteria, '${uniqueId}criteria');

  @override
  Widget build(BuildContext context) => const Text('');
}

void compareCriteria(SearchCriteriaDTO actual, SearchCriteriaDTO matcher) {
  expect(actual.criteriaType, matcher.criteriaType);
  expect(actual.criteriaTitle, matcher.criteriaTitle);
  expect(actual.searchId, matcher.searchId);
  expect(
    actual.criteriaList.first.uniqueId,
    matcher.criteriaList.first.uniqueId,
  );
  expect(
    actual.criteriaList.last.uniqueId,
    matcher.criteriaList.last.uniqueId,
  );

  MovieResultDTOMatcher(matcher.criteriaList.first);
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

      RestorableSearchCriteria.nextId = 100;
      final encoded = rtp._criteria.dtoToPrimitives(criteria);
      RestorableSearchCriteria.nextId = 50; // Temporary set to a lower value;
      rtp._criteria.initWithValue(rtp._criteria.fromPrimitives(encoded));

      expect(
        100,
        lessThanOrEqualTo(RestorableSearchCriteria.nextId),
        reason: 'RestorationId not in sync after restoration',
      );

      RestorableSearchCriteria.nextId = 100;
      final encoded2 = rtp._criteria.toPrimitives();

      compareCriteria(criteria, rtp._criteria.value);
      expect(
        encoded,
        encoded2,
        reason: 'primitives not restored correctly',
      );
    });
  });
}
