import 'dart:collection';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_enums.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_formatting.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/barcode_helpers.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';

/// Extension methods for comparing [MovieResultDTO] objects.
extension DTOCompare on MovieResultDTO {
  /// Extract year release or year of most recent episode.
  ///
  int maxYear() => max(year, yearRangeAsNumber());

  /// Rank movies against each other for sorting.
  ///
  int compareTo(MovieResultDTO other) {
    // Preference people > movies > information.
    if (contentCategory() != other.contentCategory()) {
      return contentCategory().compareTo(other.contentCategory());
    }
    switch (type) {
      case .person:
        return personCompare(other);
      case .error:
      case .information:
      case .status:
        return messageCompare(other);
      case .download:
        return downloadCompare(other);
      case .barcode:
      case .searchprompt:
        return barcodeCompare(other);
      case .movie:
      case .keyword:
      case .navigation:
      case .none:
      case .short:
      case .series:
      case .miniseries:
      case .episode:
      case .title:
      case .custom:
        return movieCompare(other);
    }
  }

  /// Compare people based returned order and populatrity.
  @visibleForTesting
  int personCompare(MovieResultDTO other) {
    if (creditsOrder != other.creditsOrder ||
        userRatingCount != other.userRatingCount) {
      return personPopularityCompare(other);
    }
    return title.compareTo(other.title) * -1;
  }

  /// Compare people based returned order and populatrity.
  int messageCompare(MovieResultDTO other) {
    // Boost sources with highest qtyErrors.
    if (creditsOrder != other.creditsOrder) {
      return creditsOrder.compareTo(other.creditsOrder);
    }
    // Boost sources with highest qtyCachedResponses.
    if (userRating != other.userRating) {
      return userRating.compareTo(other.userRating);
    }
    // Boost sources with highest qtyRequests.
    if (userRatingCount != other.userRatingCount) {
      return userRatingCount.compareTo(other.titleContentCategory());
    }
    return title.compareTo(other.title) * -1;
  }

  /// Compare downloads based availability.
  @visibleForTesting
  int barcodeCompare(MovieResultDTO other) {
    final hasYear = alternateTitle.contains(RegExp(r'.*\s\d\d\d\d\s.*'));
    final otherHasYear = other.alternateTitle.contains(
      RegExp(r'.*\s\d\d\d\d\s.*'),
    );

    // Deprioritise Ebay results.
    if (isEbay(bestSource) && !isEbay(other.bestSource)) {
      return -1;
    }
    if (isEbay(other.bestSource) && !isEbay(bestSource)) {
      return 1;
    }

    // Prefer whichever has a year.
    if (hasYear && !otherHasYear) {
      return 1;
    }
    if (otherHasYear && !hasYear) {
      return -1;
    }
    // Compare normal movie fields.
    return movieCompare(other);
  }

  /// Compare movies based on popularity, type, language, year, etc.
  @visibleForTesting
  int movieCompare(MovieResultDTO other) {
    // See how many people have rated this movie.
    if (userRatingCategory() != other.userRatingCategory()) {
      return userRatingCategory().compareTo(other.userRatingCategory());
    }
    // See how many people have rated this movie.
    if (viewedCategory() != other.viewedCategory()) {
      return viewedCategory().compareTo(other.viewedCategory());
    }
    // Preference movies > series > short film > episodes.
    if (titleContentCategory() != other.titleContentCategory()) {
      return titleContentCategory().compareTo(other.titleContentCategory());
    }
    // Preference English > Foreign Language.
    if (language.index != other.language.index) {
      return languageCategory().compareTo(other.languageCategory());
    }
    // Rank older (less than 2000) and low rated movies lower.
    if (popularityCategory() != other.popularityCategory()) {
      return popularityCategory().compareTo(other.popularityCategory());
    }
    // If all things are equal, sort by year.
    return yearCompare(other);
  }

  /// Rank movies based on popularity.
  ///
  /// 0-99, 100-9999, 10000+
  @visibleForTesting
  int userRatingCategory() {
    if (userRatingCount == 0) return 0;
    if (userRatingCount < 100) return 1;
    if (userRatingCount < 10000) return 2;
    return 3;
  }

  /// Rank movies based not recently viewed.
  ///
  @visibleForTesting
  int viewedCategory() {
    final read = getReadIndicator();

    switch (read) {
      case '':
        return 98;
      case null:
        return 98;
      case 'blank': // old version of as ReadHistory.read
        return 0;
      default:
        {
          try {
            final readHistory = ReadHistory.values.byFullName(read);
            switch (readHistory) {
              case .starred:
                return 99;
              case .reading:
                return 1;
              case .read:
                return 0;
              case null:
              case .none:
              case .custom:
            }
            // Allow deserialisation to be more robust.
            // ignore: avoid_catching_errors
          } on ArgumentError catch (_) {}
        }
    }
    return 0;
  }

  /// Rank movies based on type of content.
  ///
  /// movie > miniseries > tv series > short > series episode > game & unknown
  @visibleForTesting
  int titleContentCategory() {
    if (type == .none || type == .custom || type == .error) {
      return 0;
    }
    if (type == .episode) return 1;
    if (type == .short) return 2;
    if (type == .series) return 3;
    if (type == .miniseries) return 4;
    return 5;
  }

  /// Rank dto based on type (person Vs movie).
  ///
  /// person > movie
  @visibleForTesting
  int contentCategory() {
    switch (type) {
      case .person:
        return 99;
      case .movie:
        return 98;
      case .series:
        return 90;
      case .none:
      case .title:
        return 80;
      case .episode:
      case .miniseries:
        return 20;
      case .short:
        return 18;
      case .custom:
        return 15;
      case .navigation:
        return 10;
      case .keyword:
      case .barcode:
      case .searchprompt:
        return 8;
      case .download:
        return 4;
      case .error:
        return 3;
      case .information:
        return 2;
      case .status:
        return 0;
    }
  }

  /// Rank movies based on spoken language.
  ///
  /// English > mostly English > some English > no English > silent
  // Need to reverse the enum order for use with CompareTo().
  @visibleForTesting
  int languageCategory() => language.index * -1;

  /// Rank movies based on popular opinion.
  ///
  /// Any movie with a super low rating is probably not worth watching.
  /// A rating of 2 out of 5 is not great but better than nothing.
  /// Movies and series made before 2000 have a lower relevancy to today.
  @visibleForTesting
  int popularityCategory() {
    if (userRating < 2) return 0;
    if (maxYear() < 2000) return 1;
    return 2;
  }

  /// Rank movies based on year released.
  ///
  /// For series use year of most recent episode.
  @visibleForTesting
  int yearCompare(MovieResultDTO? other) {
    final thisYear = maxYear();
    final otherYear = other?.maxYear() ?? 0;
    return thisYear.compareTo(otherYear);
  }

  /// Rank movies based on raw popularity.
  ///
  @visibleForTesting
  int personPopularityCompare(MovieResultDTO other) {
    if (creditsOrder > 1 || other.creditsOrder > 1) {
      return creditsOrder.compareTo(other.creditsOrder);
    }
    return userRatingCount.compareTo(other.userRatingCount);
  }

  /// Extract year of most recent episode.
  ///
  @visibleForTesting
  int yearRangeAsNumber() => yearRange.lastNumber();

  /// Compare downloads based availability and scope.
  @visibleForTesting
  int downloadCompare(MovieResultDTO other) {
    if (downloadScope() != other.downloadScope()) {
      return downloadScope().compareTo(other.downloadScope());
    }
    if (creditsOrder != other.creditsOrder) {
      // Compare seeders.
      return creditsOrder.compareTo(other.creditsOrder);
    }
    // Compare Leachers.
    return userRatingCount.compareTo(other.userRatingCount);
  }

  /// Rank dto based on type (season Vs episode).
  ///
  /// season > early episode > episode
  @visibleForTesting
  int downloadScope() {
    if (isFirstSeason()) {
      return 99;
    }
    if (isSeason()) {
      return 90;
    }
    if (isEarlyEpisode()) {
      return 10;
    }
    if (isEpisode()) {
      return 1;
    }
    // Unknown so increase visibility to let the user choose.
    return 50;
  }

  /// DTO is a season if it has keywords or contains S## and is not an episode.
  @visibleForTesting
  bool isSeason() {
    final regexpSeason = RegExp(r'S\d{2}', caseSensitive: false);
    final regexpSeasonFull = RegExp(r'Season ? ?\d', caseSensitive: false);
    if (keywords.isNotEmpty) return true;
    if (isEpisode()) return false;
    if (regexpSeason.hasMatch(title)) return true;
    if (regexpSeasonFull.hasMatch(title)) return true;
    return false;
  }

  /// DTO is the full first season if it contains S01.
  @visibleForTesting
  bool isFirstSeason() {
    final regexpSeason = RegExp('S01', caseSensitive: false);
    final regexpSeasonFull = RegExp('Season ? ?1', caseSensitive: false);
    final regexpSeason01 = RegExp('Season.01', caseSensitive: false);
    if (isEpisode()) return false;
    if (regexpSeason.hasMatch(title)) return true;
    if (regexpSeasonFull.hasMatch(title)) return true;
    if (regexpSeason01.hasMatch(title)) return true;
    return false;
  }

  /// DTO is an early episode if it contains S##E0#.
  @visibleForTesting
  bool isEarlyEpisode() {
    final regexpEarlyEpisode = RegExp(r'S\d{2}E0\d', caseSensitive: false);
    if (regexpEarlyEpisode.hasMatch(title)) return true;
    return false;
  }

  /// DTO is an episode if it contains S##E## and is not an early episode.
  @visibleForTesting
  bool isEpisode() {
    final regexpEpisode = RegExp(r'S\d{2}E\d{2}', caseSensitive: false);
    if (regexpEpisode.hasMatch(title)) return true;
    return false;
  }

  /// dto type is an error.
  bool isError() => type == .error;

  /// dto type is an error, navigation command, or info.
  bool isMessage() {
    switch (type) {
      case .error:
      case .navigation:
      case .information:
      case .status:
        return true;

      case .none:
      case .keyword:
      case .barcode:
      case .searchprompt:
      case .person:
      case .download:
      case .movie:
      case .short:
      case .series:
      case .miniseries:
      case .episode:
      case .title:
      case .custom:
        return false;
    }
  }

  /// dto type is an error, navigation command, or info.
  bool isTitle() {
    switch (type) {
      case .error:
      case .navigation:
      case .information:
      case .status:
      case .keyword:
      case .barcode:
      case .searchprompt:
      case .person:
      case .download:
        return false;

      case .none:
      case .movie:
      case .short:
      case .series:
      case .miniseries:
      case .episode:
      case .title:
      case .custom:
        return true;
    }
  }

  /// dto type is an error or navigation command.
  bool isAControlObject() {
    switch (type) {
      case .error:
      case .navigation:
        return true;

      case .status:
      case .information:
      case .none:
      case .keyword:
      case .barcode:
      case .searchprompt:
      case .person:
      case .download:
      case .movie:
      case .short:
      case .series:
      case .miniseries:
      case .episode:
      case .title:
      case .custom:
        return false;
    }
  }

  /// Compare 2 fields and describe the difference.
  void _matchCompare<T>(
    Map<String, String> mismatches,
    String fieldName,
    T actual,
    T expected, {
    bool fuzzy = false,
  }) {
    if (fuzzy && (actual is num || expected is num)) {
      _matchFuzzyCompare(mismatches, fieldName, actual as num, expected as num);
    } else {
      if (expected != actual) {
        mismatches[fieldName] =
            'is different\n  Expected: "$expected"\n    Actual: "$actual"\n';
      }
    }
  }

  /// Compare 2 fields and describe the difference.
  void _matchFuzzyCompare<T extends num>(
    Map<String, String> mismatches,
    String fieldName,
    T actual,
    T expected,
  ) {
    if (expected != actual) {
      if (!DoubleHelper.fuzzyMatch(actual, expected)) {
        mismatches[fieldName] =
            'is different\n'
            '  Expected approx: "$expected"\n'
            '           Actual: "$actual"\n';
      }
    }
  }

  /// Compare 2 identifiers and describe the difference.
  ///
  /// Allow error identifiers to be different.
  void _matchCompareId(
    Map<String, String> mismatches,
    String fieldName,
    String actual,
    String expected,
  ) {
    if (!expected.startsWith(movieDTOMessagePrefix) ||
        !actual.startsWith(movieDTOMessagePrefix)) {
      _matchCompare(mismatches, fieldName, actual, expected);
    }
  }

  /// Compare 2 movie source collections and describe the difference.
  ///
  /// Allow error identifiers to be different.
  void _matchCompareIdMap(
    Map<String, String> mismatches,
    String fieldName,
    MovieSources actual,
    MovieSources expected,
  ) {
    if (expected.length != actual.length) {
      _matchCompare(mismatches, '$fieldName length', actual, expected);
      return;
    }
    final actualSorted = SplayTreeMap<DataSourceType, String>.from(
      actual,
      Enum.compareByIndex,
    );
    final expectedSorted = SplayTreeMap<DataSourceType, String>.from(
      expected,
      Enum.compareByIndex,
    );
    for (var index = 0; index < expected.length; index++) {
      final actualKey = actualSorted.keys.elementAt(index);
      final expectedKey = expectedSorted.keys.elementAt(index);
      final actualValue = actualSorted.values.elementAt(index);
      final expectedValue = expectedSorted.values.elementAt(index);
      // Compare source name
      _matchCompare(mismatches, fieldName, actualKey, expectedKey);
      // Compare source identifier
      _matchCompareId(mismatches, fieldName, actualValue, expectedValue);
    }
  }

  /// Test framework matcher to compare current [MovieResultDTO] to [actualDTO]
  ///
  /// Explains any difference found.
  /// [matchState] allows information about mismatches to be passed back
  /// [related] allows exclusion of the related dto collection for comparison
  /// [fuzzy] allows volitile numeric data to have a 75% variation.
  bool matches(
    MovieResultDTO actualDTO, {
    Map<Object?, Object?>? matchState,
    bool related = true,
    bool fuzzy = false,
    bool ignorePopularity = false,
    String prefix = '',
  }) {
    if (title == actualDTO.title && title == 'unknown') return true;

    final mismatches = <String, String>{};
    void matchCompare<T>(String fieldName, T actual, T expected) =>
        _matchCompare(
          mismatches,
          '$prefix$fieldName',
          actual,
          expected,
          fuzzy: fuzzy,
        );
    void popularityCompare<T>(String fieldName, num actual, num expected) {
      if (ignorePopularity) return;
      if (actual > 0 && expected > 0) {
        // We have a value, we dont care what the value is.
        return;
      }
      return matchCompare(fieldName, actual, expected);
    }

    /// Compare 2 identifiers and store a description of the difference.
    ///
    /// Allow error identifiers to be different.
    void matchCompareId(String fieldName, String actual, String expected) =>
        _matchCompareId(mismatches, '$prefix$fieldName', actual, expected);

    /// Compare 2 movie source collections and store a description of the diff.
    ///
    /// Allow error identifiers to be different.
    void matchCompareIdMap(
      String fieldName,
      MovieSources actual,
      MovieSources expected,
    ) => _matchCompareIdMap(mismatches, '$prefix$fieldName', actual, expected);

    matchCompare('bestSource', actualDTO.bestSource, bestSource);
    matchCompareId('uniqueId', actualDTO.uniqueId, uniqueId);
    if (type != .error && sources.isNotEmpty) {
      matchCompareIdMap('sources', actualDTO.sources, sources);
    }
    matchCompare('title', actualDTO.title, title);
    matchCompare('alternateTitle', actualDTO.alternateTitle, alternateTitle);
    matchCompare('characterName', actualDTO.characterName, characterName);
    matchCompare('description', actualDTO.description, description);
    matchCompare('type', actualDTO.type, type);
    matchCompare('year', actualDTO.year, year);
    matchCompare('yearRange', actualDTO.yearRange, yearRange);
    matchCompare('censorRating', actualDTO.censorRating, censorRating);
    matchCompare('runTime', actualDTO.runTime, runTime);
    matchCompare('imageUrl', actualDTO.imageUrl, imageUrl);
    matchCompare('language', actualDTO.language, language);
    popularityCompare(
      'userRatingCount',
      actualDTO.userRatingCount,
      userRatingCount,
    );
    popularityCompare('creditsOrder', actualDTO.creditsOrder, creditsOrder);
    if (!fuzzy) {
      popularityCompare('userRating', actualDTO.userRating, userRating);
    }
    matchCompare(
      'languages',
      languages.toString(),
      actualDTO.languages.toString(),
    );
    matchCompare('genres', actualDTO.genres.toString(), genres.toString());
    matchCompare(
      'keywords',
      actualDTO.keywords.toString(),
      keywords.toString(),
    );
    matchCompare('links', actualDTO.links.toString(), links.toString());

    if (related) {
      final expected = this.related.toPrintableString();
      final actual = actualDTO.related.toPrintableString();
      if (expected != actual) matchCompare('related', actual, expected);
    }

    if (mismatches.isNotEmpty) {
      if (null != matchState) matchState['differences'] = mismatches;
      return false;
    }
    return true;
  }
}
