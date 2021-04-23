import 'dart:math';

import 'package:my_movie_search/movies/data_model/metadata_dto.dart';
export 'package:my_movie_search/movies/data_model/metadata_dto.dart';

class MovieResultDTO {
  DataSourceType source = DataSourceType.none;
  String uniqueId = movieResultDTOUninitialised;
  String title = "";
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
    dto.source = this[movieResultDTOSource];
    dto.uniqueId = this[movieResultDTOUniqueId];
    dto.title = this[movieResultDTOTitle];
    dto.type = this[movieResultDTOType];
    dto.year = this[movieResultDTOYear];
    dto.yearRange = this[movieResultDTOYearRange];
    dto.userRating = this[movieResultDTOUserRating];
    dto.userRatingCount = this[movieResultDTOUserRatingCount];
    dto.censorRating = this[movieResultDTOCensorRating];
    dto.runTime = this[movieResultDTORunTime];
    return dto;
  }
}

extension DTOHelpers on MovieResultDTO {
  Map toMap() {
    Map<String, dynamic> map = Map();
    map[movieResultDTOSource] = this.source;
    map[movieResultDTOUniqueId] = this.uniqueId;
    map[movieResultDTOTitle] = this.title;
    map[movieResultDTOType] = this.type;
    map[movieResultDTOYear] = this.year;
    map[movieResultDTOYearRange] = this.yearRange;
    map[movieResultDTOUserRating] = this.userRating;
    map[movieResultDTOCensorRating] = this.censorRating;
    map[movieResultDTORunTime] = this.runTime;
    return map;
  }

  String toPrintableString() {
    return this.toMap().toString();
  }

  Map toUnknown() {
    Map<String, dynamic> map = Map();
    map[movieResultDTOSource] = this.source;
    map[movieResultDTOUniqueId] = this.uniqueId;
    map[movieResultDTOTitle] = 'unknown';
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
          this.type == other.type &&
          this.year == other.year &&
          this.yearRange == other.yearRange &&
          this.userRating == other.userRating &&
          this.censorRating == other.censorRating &&
          this.runTime == other.runTime;
  }
}

extension DTOCompare on MovieResultDTO {
  int compareTo(MovieResultDTO other) {
    // Treat null a lower than any other value
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
    try {
      // Any quantity of numeric digits at the end of the string.
      final filter = RegExp(r'[0-9]+$');
      return int.parse(filter.stringMatch(this.yearRange) ?? "");
    } catch (e) {
      return 0;
    }
  }
}
