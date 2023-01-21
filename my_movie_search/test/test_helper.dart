import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';

////////////////////////////////////////////////////////////////////////////////
/// Helper functions
////////////////////////////////////////////////////////////////////////////////
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

/// Expectation matcher for test framework to compare DTOs
class MovieResultDTOMatcher extends Matcher {
  MovieResultDTO expected;
  bool related;
  bool verbose;
  late MovieResultDTO _actual;

  MovieResultDTOMatcher(
    this.expected, {
    this.related = true,
    this.verbose = false,
  });

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
      mismatchDescription.add('Expected: ${expected.toPrintableString()}\n');
      mismatchDescription.add('  Actual: ${_actual.toPrintableString()}\n');
    }
    return mismatchDescription.add(matchState['differences'].toString());
  }

  @override
  // Compare expected with actual.
  bool matches(dynamic actual, Map matchState) {
    if (actual is MovieResultDTO) {
      _actual = actual;
    } else {
      _actual = MovieResultDTO().toUnknown();
    }
    matchState['actual'] = _actual;
    return expected.matches(_actual, matchState: matchState, related: related);
  }
}

/// Expectation matcher for test framework to compare DTO lists
class MovieResultDTOListMatcher extends Matcher {
  List<MovieResultDTO> expected;
  bool related;
  bool verbose;
  late List<MovieResultDTO> _actual;

  MovieResultDTOListMatcher(
    this.expected, {
    this.related = true,
    this.verbose = false,
  });

  @override
  // Tell test framework what content was expected.
  Description describe(Description description) => description.add(
        '$expected (set MovieResultDTOListMatcher verbose:true for full details)',
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
      mismatchDescription.add('Expected: ${expected.toPrintableString()}\n');
      mismatchDescription.add('  Actual: ${_actual.toPrintableString()}\n');
    }
    return mismatchDescription.add(matchState['differences'].toString());
  }

  @override
  // Compare expected with actual.
  bool matches(dynamic actual, Map matchState) {
    if (actual is List<MovieResultDTO>) {
      _actual = actual;
    } else {
      _actual = [MovieResultDTO().toUnknown()];
    }
    matchState['actual'] = _actual;

    if (_actual.length != expected.length) return false;
    for (var i = 0; i < _actual.length; i++) {
      final match = _actual[i].matches(
        expected[i],
        matchState: matchState,
        related: related,
        prefix: 'instance(${i + 1}) -> ',
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
  List<MovieResultDTO> expected;
  int matchQuantity = 0;
  int percentMatch;
  late List<MovieResultDTO> _actual;

  /// Constructor for fuzzy match list comparison
  ///
  /// [expected] is the list of DTOs to look for
  /// [percentMatch] allows a portion of the records to match instead of all records
  MovieResultDTOListFuzzyMatcher(this.expected, {this.percentMatch = 100});

  @override
  // Tell test framework what content was expected.
  Description describe(Description description) {
    return description.add('has expected ${expected.toPrintableString()}');
  }

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
  bool matches(dynamic actual, Map matchState) {
    matchQuantity = (expected.length * percentMatch / 100).ceil();
    if (actual is List<MovieResultDTO>) {
      _actual = actual;
    } else {
      _actual = [MovieResultDTO().toUnknown()];
    }
    matchState['actual'] = _actual;

    for (final actualDto in _actual) {
      bool resultMatched = false;
      for (final expectedDto in expected) {
        final differences = {};
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
      if (false == resultMatched) {
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

/// Converts [text] to a stream containing a list of bytes.
///
/// Emits all bytes at the same time.
Stream<List<int>> emitConsolidatedByteStream(String text) async* {
  final lst = <int>[];

  for (final rune in text.runes.toList()) {
    lst.add(rune);
  }
  yield lst;
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
  final relatedDto1 = makeResultDTO("{sample}1");
  final relatedDto2 = makeResultDTO("{sample}2");
  final relatedDto3 = makeResultDTO("{sample}3");
  final relatedDto4 = makeResultDTO("{sample}4");
  mainDto.related = {
    "director": {
      relatedDto1.uniqueId: relatedDto1,
      relatedDto2.uniqueId: relatedDto2,
    },
    "actor": {relatedDto3.uniqueId: relatedDto3},
    "writer": {relatedDto4.uniqueId: relatedDto4},
  };
  return mainDto;
}

/// Helper function to make a unique dto containing unique values.
MovieResultDTO makeResultDTO(String sample, {bool makeRelated = true}) {
  final dto = MovieResultDTO();

  dto.bestSource = DataSourceType.wiki;
  dto.uniqueId = '${sample}_uniqueId';
  dto.title = '${sample}_title';
  dto.alternateTitle = '${sample}_alternateTitle';
  dto.charactorName = '${sample}_charactorName';
  dto.description = '${sample}_description';
  dto.type = MovieContentType.custom;
  dto.year = 123;
  dto.yearRange = '${sample}_yearRange';
  dto.aListRanking = 42;
  dto.userRating = 456;
  dto.userRatingCount = 789;
  dto.censorRating = CensorRatingType.family;
  dto.runTime = const Duration(hours: 1, minutes: 2, seconds: 3);
  dto.imageUrl = '${sample}_imageUrl';
  dto.language = LanguageType.mostlyEnglish;
  dto.languages = {'${sample}_language1', '${sample}_language2'};
  dto.genres = {'${sample}_genre1', '${sample}_genre2'};
  dto.keywords = {'${sample}_keyword1', '${sample}_keyword2'};
  dto.sources = {
    DataSourceType.tmdbMovie: '${sample}_alternateTitle',
    DataSourceType.wiki: '${sample}_uniqueId'
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
SearchCriteriaDTO makeCriteriaDTO(String sample) {
  final dto = SearchCriteriaDTO();

  dto.criteriaSource = SearchCriteriaSource.google;
  dto.criteriaTitle = '${sample}_criteriaTitle';
  dto.searchId = '${sample}_searchId';
  dto.criteriaList = [
    makeResultDTO('first'),
    makeResultDTO('second'),
  ];
  return dto;
}

class TestApp extends StatelessWidget {
  const TestApp({
    Key? key,
    required this.children,
  }) : super(key: key);
  const TestApp.con({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
}
