import 'dart:math';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
export 'package:my_movie_search/movies/models/metadata_dto.dart';

class MovieResultDTO {
  DataSourceType source = DataSourceType.none;
  String uniqueId = movieResultDTOUninitialised;
  String title = "";
  String description = "";
  MovieContentType type = MovieContentType.none;
  int year = 0;
  String yearRange = "";
  double userRating = 0;
  int userRatingCount = 0;
  CensorRatingType censorRating = CensorRatingType.none;
  Duration runTime = Duration(hours: 0, minutes: 0, seconds: 0);
  String imageUrl = "";
}

enum MovieContentType {
  none,
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
final String movieResultDTOTitle = 'title';
final String movieResultDTODescription = 'description';
final String movieResultDTOType = 'type';
final String movieResultDTOYear = 'year';
final String movieResultDTOYearRange = 'yearRange';
final String movieResultDTOUserRating = 'userRating';
final String movieResultDTOUserRatingCount = 'userRatingCount';
final String movieResultDTOCensorRating = 'censorRating';
final String movieResultDTORunTime = 'runTime';
final String movieResultDTOUninitialised = '-1';

extension MapDTOConversion on Map {
  MovieResultDTO toMovieResultDTO() {
    var dto = MovieResultDTO();
    dto.source = this[movieResultDTOSource] ?? dto.source;
    dto.uniqueId = this[movieResultDTOUniqueId] ?? dto.uniqueId;
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
    map[movieResultDTOTitle] = this.title;
    map[movieResultDTODescription] = this.description;
    map[movieResultDTOType] = this.type;
    map[movieResultDTOYear] = this.year;
    map[movieResultDTOYearRange] = this.yearRange;
    map[movieResultDTOUserRating] = this.userRating;
    map[movieResultDTOUserRatingCount] = this.userRatingCount;
    map[movieResultDTOCensorRating] = this.censorRating;
    map[movieResultDTORunTime] = this.runTime;
    return map;
  }

  void merge(MovieResultDTO newValue) {
    if (newValue.description != "") {
      print(newValue.description);
    }
    if (newValue.userRatingCount > this.userRatingCount) {
      this.source = bestval(newValue.source, this.source);
      this.title = bestval(newValue.title, this.title);
      this.description = bestval(newValue.description, this.description);
      this.type = bestval(newValue.type, this.type);
      this.year = bestval(newValue.year, this.year);
      this.yearRange = bestval(newValue.yearRange, this.yearRange);
      this.userRating = bestval(newValue.userRating, this.userRating);
      this.userRatingCount =
          bestval(newValue.userRatingCount, this.userRatingCount);
      this.runTime = bestval(newValue.runTime, this.runTime);
      this.type = bestval(newValue.type, this.type);
      this.censorRating = bestval(newValue.censorRating, this.censorRating);
      this.source = bestval(newValue.source, this.source);
    }
  }

  T bestval<T>(T a, T b) {
    if (a is MovieContentType && b is MovieContentType) bestType(a, b);
    if (a is CensorRatingType && b is CensorRatingType) bestRating(a, b);
    if (a is DataSourceType && b is DataSourceType) bestSource(a, b);
    if (a is num && b is num && a < b) return b;
    if (a.toString().length < b.toString().length) return b;
    if (lastNumberFromString(a.toString()) < lastNumberFromString(b.toString()))
      return b;
    return a;
  }

  MovieContentType bestType(MovieContentType a, MovieContentType b) {
    if (b.index > a.index) return b;
    return a;
  }

  CensorRatingType bestRating(CensorRatingType a, CensorRatingType b) {
    if (b.index > a.index) return b;
    return a;
  }

  DataSourceType bestSource(DataSourceType a, DataSourceType b) {
    if (b == DataSourceType.imdb) return b;
    return a;
  }

  String toPrintableString() {
    return this.toMap().toString();
  }

  Map toUnknown() {
    Map<String, dynamic> map = Map();
    map[movieResultDTOSource] = this.source;
    map[movieResultDTOUniqueId] = this.uniqueId;
    map[movieResultDTOTitle] = 'unknown';
    map[movieResultDTODescription] = this.description;
    map[movieResultDTOType] = this.type;
    map[movieResultDTOYear] = this.year;
    map[movieResultDTOYearRange] = this.yearRange;
    map[movieResultDTOUserRating] = this.userRating;
    map[movieResultDTOCensorRating] = this.censorRating;
    map[movieResultDTORunTime] = this.runTime;
    return map;
  }

  bool matches(MovieResultDTO other) {
    if (this.title == other.title && this.title == 'unknown')
      return true;
    else
      return this.source == other.source &&
          this.uniqueId == other.uniqueId &&
          this.title == other.title &&
          this.description == other.description &&
          this.type == other.type &&
          this.year == other.year &&
          this.yearRange == other.yearRange &&
          this.userRating == other.userRating &&
          this.censorRating == other.censorRating &&
          this.runTime == other.runTime;
  }
}

extension ListMovieResultDTOHelpers on List<MovieResultDTO> {
  String toPrintableString() {
    String listContents = "";
    for (var i = 0; i < this.length - 1; i++) {
      listContents += "${this[i].toPrintableString()},\n";
    }
    return 'List<MovieResultDTO>(${this.length})[\n$listContents\n]';
  }
}

extension DTOCompare on MovieResultDTO {
  int compareTo(MovieResultDTO other) {
    // Treat null as lower than any other value
    if (this.uniqueId == movieResultDTOUninitialised &&
        other.uniqueId != movieResultDTOUninitialised) return -1;
    if (this.uniqueId != movieResultDTOUninitialised &&
        other.uniqueId == movieResultDTOUninitialised) return 1;
    // See how many peopel have rated this movie.
    if (this.userRatingCategory() != other.userRatingCategory())
      return this.userRatingCategory().compareTo(other.userRatingCategory());
    // Preference movies > series > short film > episodes.
    if (this.userContentCategory() != other.userContentCategory())
      return this.userContentCategory().compareTo(other.userContentCategory());
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
      // Any quantity of numeric digits at the end of the string.
      final filter = RegExp(r'[0-9]+$');
      return int.parse(filter.stringMatch(str) ?? "");
    } catch (e) {
      return 0;
    }
  }
}
