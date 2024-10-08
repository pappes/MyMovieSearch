import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/settings.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////

void sortDtoList(
  List<MovieResultDTO> dtos, {
  bool includeRelated = true,
}) {
  dtos.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
  if (includeRelated) {
    for (final entry in dtos) {
      // sort categories by converting map to a SplayTreeMap
      entry.related = SplayTreeMap.from(entry.related);
      for (final category in entry.related.keys) {
        // sort related DTOs by converting map to a SplayTreeMap
        entry.related[category] = SplayTreeMap.from(
          entry.related[category]!,
          //DTOCompare.compare,
        );
      }
    }
  }
}

void printTestData(
  Iterable<MovieResultDTO> actualResult, {
  bool includeRelated = true,
}) {
  final sorted = actualResult.toList();
  sortDtoList(sorted, includeRelated: includeRelated);
  // ignore: avoid_print
  print(
    sorted.toListOfDartJsonStrings(includeRelated: includeRelated),
  );
  expect(
    'debug code has been left uncommented!',
    'all call to printTestData must be commented out',
  );
}

Matcher containsSubstring(String substring, {String startsWith = ''}) {
  bool testFunction(String actual) {
    if (actual.startsWith(startsWith) &&
        actual.contains(RegExp(substring, caseSensitive: false))) {
      return true;
    }
    return false;
  }

  return predicate(testFunction);
}

Future<bool> waitForExcusiveAccess(String mutexName) async {
  final lockFile = File('/tmp/testMutex_$mutexName.txt');
  while (lockFile.existsSync()) {
    await Future<void>.delayed(const Duration(seconds: 1));
  }
  lockFile.openSync(mode: FileMode.write).closeSync();
  return true;
}

Future<void> releaseExcusiveAccess(String mutexName) async {
  File('/tmp/testMutex_$mutexName.txt').deleteSync();
}

Future<bool> lockWebFetchTreadedCache() async {
  Settings().init();
  return waitForExcusiveAccess('WebFetchTreadedCache');
}

Future<void> unlockWebFetchTreadedCache() async =>
    releaseExcusiveAccess('WebFetchTreadedCache');

/// Expectation matcher for test framework to compare DTOs
class MovieResultDTOMatcher extends Matcher {
  MovieResultDTOMatcher(
    this.expected, {
    this.related = true,
    this.verbose = false,
  });

  MovieResultDTO expected;
  bool related;
  bool verbose;
  late MovieResultDTO _actual;

  @override
  // Tell test framework what content was expected.
  Description describe(Description description) => description.add(
        '$expected (set MovieResultDTOMatcher verbose:true for full details)',
      );

  @override
  // Tell test framework what difference was found.
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (verbose || this.verbose) {
      mismatchDescription
        ..add('Expected: ${expected.toPrintableString()}\n')
        ..add('  Actual: ${_actual.toPrintableString()}\n');
    }
    return mismatchDescription.add(matchState['differences'].toString());
  }

  @override
  // Compare expected with actual.
  bool matches(dynamic actual, Map<dynamic, dynamic> matchState) {
    if (actual is MovieResultDTO) {
      _actual = actual;
      sortDtoList([_actual]);
      sortDtoList([expected]);
    } else {
      _actual = MovieResultDTO().toUnknown();
    }
    matchState['actual'] = _actual;
    return expected.matches(_actual, matchState: matchState, related: related);
  }
}

/// Expectation matcher for test framework to compare DTO lists
class MovieResultDTOListMatcher extends Matcher {
  MovieResultDTOListMatcher(
    this.expected, {
    this.related = true,
    this.verbose = false,
  });

  List<MovieResultDTO> expected;
  bool related;
  bool verbose;
  late List<MovieResultDTO> _actual;

  @override
  // Tell test framework what content was expected.
  Description describe(Description description) => description.add(
        '$expected (set MovieResultDTOListMatcher '
        'verbose:true for full details)',
      );

  @override
  // Tell test framework what difference was found.
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (verbose || this.verbose) {
      mismatchDescription
        ..add('Expected: ${expected.toPrintableString()}\n')
        ..add('  Actual: ${_actual.toPrintableString()}\n');
    }
    return mismatchDescription.add(matchState['differences'].toString());
  }

  @override
  // Compare expected with actual.
  bool matches(dynamic actual, Map<dynamic, dynamic> matchState) {
    if (actual is List<MovieResultDTO>) {
      _actual = actual;
      sortDtoList(_actual);
      sortDtoList(expected);
    } else {
      _actual = [MovieResultDTO().toUnknown()];
    }
    matchState['actual'] = _actual;

    if (_actual.length != expected.length) return false;
    for (var i = 0; i < _actual.length; i++) {
      final match = expected[i].matches(
        _actual[i],
        matchState: matchState,
        related: related,
        prefix: 'instance ${expected[i].uniqueId} -> ',
      );
      if (!match) {
        return false;
      }
    }
    return true;
  }
}

/// Expectation matcher for comparing volitile DTO list data
class MovieResultDTOListFuzzyMatcher extends Matcher {
  /// Constructor for fuzzy match list comparison
  ///
  /// [expected] is the list of DTOs to look for
  /// [percentMatch] allows a portion of the records
  /// to match instead of all records
  MovieResultDTOListFuzzyMatcher(this.expected, {this.percentMatch = 100});

  List<MovieResultDTO> expected;
  int matchQuantity = 0;
  int percentMatch;
  late List<MovieResultDTO> _actual;

  @override
  // Tell test framework what content was expected.
  Description describe(Description description) =>
      description.add('has expected ${expected.toPrintableString()}');

  @override
  // Tell test framework what difference was found.
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    mismatchDescription.add('has actual ${_actual.toPrintableString()}\n');
    for (final difference in matchState.entries) {
      mismatchDescription.add(
        ' UniqueId ${difference.key} mismatch is \n${difference.value}',
      );
    }
    return mismatchDescription;
  }

  @override
  // Compare expected with actual.
  bool matches(dynamic actual, Map<dynamic, dynamic> matchState) {
    matchQuantity = (expected.length * percentMatch / 100).ceil();
    if (actual is List<MovieResultDTO>) {
      _actual = actual;
    } else {
      _actual = [MovieResultDTO().toUnknown()];
      sortDtoList(_actual);
      sortDtoList(expected);
    }
    matchState['actual'] = _actual;
    if (_actual.isEmpty && expected.isEmpty) {
      return true;
    }

    for (final actualDto in _actual) {
      bool resultMatched = false;
      for (final expectedDto in expected) {
        final differences = <dynamic, dynamic>{};
        if (actualDto.uniqueId == expectedDto.uniqueId) {
          resultMatched = true;
          if (actualDto.matches(
            expectedDto,
            matchState: differences,
            related: false,
            fuzzy: true,
          )) {
            matchQuantity--;
            if (0 == matchQuantity) {
              // There have been enough matches to declare victory!
              return true;
            }
          } else {
            matchState[actualDto.uniqueId] = differences;
          }
        }
      }
      if (!resultMatched) {
        matchState[actualDto.uniqueId] = 'No match for ${actualDto.uniqueId}\n';
      }
    }
    return false;
  }
}

/// Converts a [text] to a stream.
Stream<String> emitString(String text) => Stream.value(text);

/// Converts a [text] to a stream of charactors.
///
/// Emits one charactor at a time.
Stream<String> emitStringChars(String text) async* {
  for (final chr in text.characters) {
    yield chr;
  }
}

/// Converts a [text] to a stream of bytes.
///
/// Emits one byte at a time.
Stream<List<int>> emitByteStream(String text) async* {
  for (final rune in text.runes) {
    yield [rune];
  }
}

/// Converts [records] to a stream of DTOs.
Stream<MovieResultDTO> streamMovieResultDTOFromJsonMap(
  Iterable<Map<String, dynamic>> records,
) async* {
  for (final record in records) {
    yield record.toMovieResultDTO();
  }
}

/// Helper function to make a unique dto containing unique values.
MovieResultDTO makeResultDTOWithRelatedDTO(String sample) {
  final mainDto = makeResultDTO(sample);
  final relatedDto1 = makeResultDTO('{sample}1');
  final relatedDto2 = makeResultDTO('{sample}2');
  final relatedDto3 = makeResultDTO('{sample}3');
  final relatedDto4 = makeResultDTO('{sample}4');
  mainDto.related = {
    'director': {
      relatedDto1.uniqueId: relatedDto1,
      relatedDto2.uniqueId: relatedDto2,
    },
    'actor': {relatedDto3.uniqueId: relatedDto3},
    'writer': {relatedDto4.uniqueId: relatedDto4},
  };
  return mainDto;
}

/// Helper function to make a unique dto containing unique values.
MovieResultDTO makeResultDTO(String sample, {bool makeRelated = true}) {
  final dto = MovieResultDTO()
    ..bestSource = DataSourceType.wiki
    ..uniqueId = '${sample}_uniqueId'
    ..title = '${sample}_title'
    ..alternateTitle = '${sample}_alternateTitle'
    ..charactorName = '${sample}_charactorName'
    ..description = '${sample}_description'
    ..type = MovieContentType.custom
    ..year = 123
    ..yearRange = '${sample}_yearRange'
    ..creditsOrder = 42
    ..userRating = 456
    ..userRatingCount = 789
    ..censorRating = CensorRatingType.family
    ..runTime = const Duration(hours: 1, minutes: 2, seconds: 3)
    ..imageUrl = '${sample}_imageUrl'
    ..language = LanguageType.mostlyEnglish
    ..languages = {'English', '${sample}_language1', '${sample}_language2'}
    ..genres = {'${sample}_genre1', '${sample}_genre2'}
    ..keywords = {'${sample}_keyword1', '${sample}_keyword2'}
    ..sources = {
      DataSourceType.tmdbMovie: '${sample}_alternateTitle',
      DataSourceType.wiki: '${sample}_uniqueId',
    };
  if (makeRelated) {
    final ref = 'rel$sample';
    dto.related = {
      'suggestions': {
        '$ref 1': makeResultDTO('$ref 1', makeRelated: false),
        '$ref 2': makeResultDTO('$ref 2', makeRelated: false),
        '$ref 3': makeResultDTO('$ref 3', makeRelated: false),
      },
      'actors': {
        '$ref a': makeResultDTO('$ref a', makeRelated: false),
        '$ref b': makeResultDTO('$ref b', makeRelated: false),
        '$ref c': makeResultDTO('$ref c', makeRelated: false),
      },
    };
  }
  return dto;
}

/// Helper function to make a unique dto containing unique values.
SearchCriteriaDTO makeCriteriaDTO(String sample) => SearchCriteriaDTO()
  ..criteriaType = SearchCriteriaType.movieDTOList
  ..criteriaTitle = '${sample}_criteriaTitle'
  ..searchId = '${sample}_searchId'
  ..criteriaList = [
    MovieResultDTO().init(uniqueId: 'first'),
    MovieResultDTO().init(uniqueId: 'second'),
  ];

class TestApp extends StatelessWidget {
  const TestApp({
    required this.children,
    super.key,
  });
  const TestApp.con({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Testing',
        home: Scaffold(
          body: Center(
            child: Flex(
              direction: Axis.vertical,
              children: children,
            ),
          ),
        ),
      );
}
