import 'dart:math' show max;

import 'metadata_dto.dart';

class MovieResultDTO {
  DataSourceType source = DataSourceType.none;
  String uniqueId = movieResultDTOUninitialised;
  String alternateId = '';
  String title = '';
  String description = '';
  MovieContentType type = MovieContentType.none;
  int year = 0;
  String yearRange = '';
  double userRating = 0;
  int userRatingCount = 0;
  CensorRatingType censorRating = CensorRatingType.none;
  Duration runTime = Duration(hours: 0, minutes: 0, seconds: 0);
  String imageUrl = '';
  LanguageType language = LanguageType.none;
  List<MovieResultDTO> related = [];
}

enum MovieContentType {
  none,
  person,
  movie, //      includes "tv movie"
  series, //     anything less that an hour long that does repeat or repeats more than 4 times
  miniseries, // anything more that an hour long that does repeat
  short, //      anything less that an hour long that does not repeat
  episode, //    anything that is part of a series or mini-series
  custom,
}
enum CensorRatingType {
  none,
  kids, //      C G
  family, //    PG
  mature, //    M
  adult, //     M15+, R
  restriced, // X, RC
  custom,
}
enum LanguageType {
  none,
  allEnglish,
  mostlyEnglish,
  someEnglish,
  silent,
  foreign,
  custom,
}

// member variable names
final String movieResultDTOSource = 'source';
final String movieResultDTOUniqueId = 'uniqueId';
final String movieResultDTOAlternateId = 'alternateId';
final String movieResultDTOTitle = 'title';
final String movieResultDTODescription = 'description';
final String movieResultDTOType = 'type';
final String movieResultDTOYear = 'year';
final String movieResultDTOYearRange = 'yearRange';
final String movieResultDTOUserRating = 'userRating';
final String movieResultDTOUserRatingCount = 'userRatingCount';
final String movieResultDTOCensorRating = 'censorRating';
final String movieResultDTORunTime = 'runTime';
final String movieResultImageUrl = 'imageUrl';
final String movieResultLanguage = 'language';
final String movieResultRelated = 'related';
final String movieResultDTOUninitialised = '-1';
final String movieResultDTOMessagePrefix = '-';

extension MapDTOConversion on Map {
  MovieResultDTO toMovieResultDTO() {
    var dto = MovieResultDTO();
    dto.source = this[movieResultDTOSource] ?? dto.source;
    dto.uniqueId = this[movieResultDTOUniqueId] ?? dto.uniqueId;
    dto.alternateId = this[movieResultDTOAlternateId] ?? dto.alternateId;
    dto.title = this[movieResultDTOTitle] ?? dto.title;
    dto.description = this[movieResultDTODescription] ?? dto.description;
    dto.type = this[movieResultDTOType] ?? dto.type;
    dto.year = this[movieResultDTOYear] ?? dto.year;
    dto.yearRange = this[movieResultDTOYearRange] ?? dto.yearRange;
    dto.userRating = this[movieResultDTOUserRating] ?? dto.userRating;
    dto.userRatingCount =
        this[movieResultDTOUserRatingCount] ?? dto.userRatingCount;
    dto.censorRating = this[movieResultDTOCensorRating] ?? dto.censorRating;
    dto.runTime = this[movieResultDTORunTime] ?? dto.runTime;
    dto.imageUrl = this[movieResultImageUrl] ?? dto.imageUrl;
    dto.language = this[movieResultLanguage] ?? dto.language;
    //TODO related
    return dto;
  }
}

extension MovieResultDTOHelpers on MovieResultDTO {
  static int _lastError = -1;
  MovieResultDTO error() {
    _lastError = _lastError - 1;
    this.uniqueId = _lastError.toString();
    return this;
  }

  Map toMap() {
    Map<String, dynamic> map = Map();
    map[movieResultDTOSource] = this.source;
    map[movieResultDTOUniqueId] = this.uniqueId;
    map[movieResultDTOAlternateId] = this.alternateId;
    map[movieResultDTOTitle] = this.title;
    map[movieResultDTODescription] = this.description;
    map[movieResultDTOType] = this.type;
    map[movieResultDTOYear] = this.year;
    map[movieResultDTOYearRange] = this.yearRange;
    map[movieResultDTOUserRating] = this.userRating;
    map[movieResultDTOUserRatingCount] = this.userRatingCount;
    map[movieResultDTOCensorRating] = this.censorRating;
    map[movieResultDTORunTime] = this.runTime;
    map[movieResultImageUrl] = this.imageUrl;
    map[movieResultLanguage] = this.language;
    //TODO: related
    return map;
  }

  void merge(MovieResultDTO newValue) {
    if (newValue.description != '') {
      print(newValue.description);
    }
    if (DataSourceType.imdb == newValue.source) {
      print(newValue.description);
    }
    //TODO alternate ID
    if (newValue.userRatingCount > this.userRatingCount ||
        DataSourceType.imdb == newValue.source) {
      this.source = bestval(newValue.source, this.source);
      if (DataSourceType.imdb == newValue.source && "" != newValue.title) {
        this.title = newValue.title;
      } else {
        this.title = bestval(newValue.title, this.title);
      }

      this.description = bestval(newValue.description, this.description);
      this.type = bestval(newValue.type, this.type);
      this.year = bestval(newValue.year, this.year);
      this.yearRange = bestval(newValue.yearRange, this.yearRange);
      this.runTime = bestval(newValue.runTime, this.runTime);
      this.type = bestval(newValue.type, this.type);
      this.censorRating = bestval(newValue.censorRating, this.censorRating);
      this.imageUrl = bestval(newValue.imageUrl, this.imageUrl);
      this.language = bestval(newValue.language, this.language);
      this.userRating = bestUserRating(
        newValue.userRating,
        newValue.userRatingCount,
        this.userRating,
        this.userRatingCount,
      );
      this.userRatingCount =
          bestval(newValue.userRatingCount, this.userRatingCount);
      mergeDtoList(this.related, newValue.related);
    }
  }

  void mergeDtoList(
      List<MovieResultDTO> existingDtos, List<MovieResultDTO> newDtos) {
    for (var dto in newDtos) {
      if (!existingDtos.contains(dto)) {
        existingDtos.add(dto);
      }
    }
  }

  T bestval<T>(T a, T b) {
    if (a is MovieContentType && b is MovieContentType) bestType(a, b);
    if (a is CensorRatingType && b is CensorRatingType) bestCensorRating(a, b);
    if (a is DataSourceType && b is DataSourceType) bestSource(a, b);
    if (a is LanguageType && b is LanguageType) bestLanguage(a, b);
    if (a is num && b is num && a < b) return b;
    if (a.toString().length < b.toString().length) return b;
    if (lastNumberFromString(a.toString()) < lastNumberFromString(b.toString()))
      return b;
    return a;
  }

  double bestUserRating(
      double rating1, num count1, double rating2, num count2) {
    if (count1 > count2) return rating1;
    return rating2;
  }

  MovieContentType bestType(MovieContentType a, MovieContentType b) {
    if (b.index > a.index) return b;
    return a;
  }

  CensorRatingType bestCensorRating(CensorRatingType a, CensorRatingType b) {
    if (b.index > a.index) return b;
    return a;
  }

  DataSourceType bestSource(DataSourceType a, DataSourceType b) {
    if (b == DataSourceType.imdb) return b;
    return a;
  }

  LanguageType bestLanguage(LanguageType a, LanguageType b) {
    if (b.index > a.index) return b;
    return a;
  }

  String toPrintableString() {
    return this.toMap().toString();
  }

  Map toUnknown() {
    Map<String, dynamic> map = Map();
    map[movieResultDTOSource] = this.source;
    map[movieResultDTOUniqueId] = this.uniqueId;
    map[movieResultDTOAlternateId] = this.alternateId;
    map[movieResultDTOTitle] = 'unknown';
    map[movieResultDTODescription] = this.description;
    map[movieResultDTOType] = this.type;
    map[movieResultDTOYear] = this.year;
    map[movieResultDTOYearRange] = this.yearRange;
    map[movieResultDTOUserRating] = this.userRating;
    map[movieResultDTOUserRatingCount] = this.userRatingCount;
    map[movieResultDTOCensorRating] = this.censorRating;
    map[movieResultDTORunTime] = this.runTime;
    map[movieResultImageUrl] = this.imageUrl;
    map[movieResultLanguage] = this.language;
    map[movieResultRelated] = this.related;
    return map;
  }

  bool matches(MovieResultDTO other) {
    if (this.title == other.title && this.title == 'unknown')
      return true;
    else
      return this.source == other.source &&
          this.uniqueId == other.uniqueId &&
          this.alternateId == other.alternateId &&
          this.title == other.title &&
          this.description == other.description &&
          this.type == other.type &&
          this.year == other.year &&
          this.yearRange == other.yearRange &&
          this.userRating == other.userRating &&
          this.censorRating == other.censorRating &&
          this.runTime == other.runTime &&
          this.language == other.language &&
          this.imageUrl == other.imageUrl &&
          this.related.toPrintableString() == other.related.toPrintableString();
  }
}

extension ListMovieResultDTOHelpers on List<MovieResultDTO> {
  String toPrintableString() {
    String listContents = '';
    for (var i = 0; i < this.length; i++) {
      listContents += '${this[i].toPrintableString()},\n';
    }
    return 'List<MovieResultDTO>(${this.length})[\n$listContents\n]';
  }

  String toShortString() {
    String listContents = '';
    for (var i = 0; i < this.length; i++) {
      listContents += '${this[i].title},\n';
    }
    return listContents;
  }
}

extension DTOCompare on MovieResultDTO {
  //Rank movies against each other for sorting
  int compareTo(MovieResultDTO other) {
    // Treat null as lower than any other value
    if (this.uniqueId == movieResultDTOUninitialised &&
        other.uniqueId != movieResultDTOUninitialised) return -1;
    if (this.uniqueId != movieResultDTOUninitialised &&
        other.uniqueId == movieResultDTOUninitialised) return 1;
    // See how many people have rated this movie.
    if (this.userRatingCategory() != other.userRatingCategory())
      return this.userRatingCategory().compareTo(other.userRatingCategory());
    // Preference movies > series > short film > episodes.
    if (this.userContentCategory() != other.userContentCategory())
      return this.userContentCategory().compareTo(other.userContentCategory());
    // Preference English > Foreign Language.
    if (this.language.index != other.language.index)
      return this.languageCategory().compareTo(other.languageCategory());
    // Rank older (less than 2000) and low rated movies lower.
    if (this.popularityCategory() != other.popularityCategory())
      return this.popularityCategory().compareTo(other.popularityCategory());
    // If all things are equal, sort by year.
    return this.yearCompare(other);
  }

  int userRatingCategory() {
    if (this.userRatingCount == 0) return 0;
    if (this.userRatingCount < 100) return 1;
    if (this.userRatingCount < 10000) return 2;
    return 3;
  }

  int userContentCategory() {
    if (this.type == MovieContentType.none ||
        this.type == MovieContentType.custom) return 0;
    if (this.type == MovieContentType.episode) return 1;
    if (this.type == MovieContentType.short) return 2;
    if (this.type == MovieContentType.series) return 3;
    if (this.type == MovieContentType.miniseries) return 4;
    return 5;
  }

  int languageCategory() {
    // Need to reverse the enum order for use with CompareTo().
    return this.language.index * -1;
  }

  int popularityCategory() {
    // Any movie with a super low rating is probably not worth watching.
    // A rating of 2 out of 5 is not great but better than nothing.
    if (this.userRating < 2) return 0;
    // Movies and series made before 2000 have a lower relevancy to today.
    if (this.maxYear() < 2000) return 1;
    return 2;
  }

  int yearCompare(MovieResultDTO? other) {
    final thisYear = this.maxYear();
    final otherYear = other?.maxYear() ?? 0;
    return (thisYear.compareTo(otherYear));
  }

  int maxYear() {
    return max(this.year, this.yearRangeAsNumber());
  }

  int yearRangeAsNumber() {
    return lastNumberFromString(this.yearRange);
  }

  int lastNumberFromString(String str) {
    try {
      // one or more numeric digits ([0-9]+)
      // followed by 0 or more dashes ([\-]*)
      var match = RegExp(r'([0-9]+)([\-]*)$').firstMatch(str);
      if (null != match) {
        if (null != match.group(1)) {
          return int.parse(match.group(1)!);
        }
      }
    } catch (e) {
      return 0;
    }
    return 0;
  }
}
