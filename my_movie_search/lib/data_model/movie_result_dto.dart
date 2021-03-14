import 'package:my_movie_search/data_model/metadata_dto.dart';

class MovieResultDTO {
  DataeSourceType source = DataeSourceType.none;
  String uniqueId = "";
  String title = "";
  MovieContentType type = MovieContentType.none;
  int year = 0;
  String yearRange = "";
  double userRating = 0;
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
final String movieResultDTOCensorRating = 'censorRating';
final String movieResultDTORunTime = 'runTime';

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
    dto.censorRating = this[movieResultDTOCensorRating];
    dto.runTime = this[movieResultDTORunTime];
    return dto;
  }
}

extension DTOhelpers on MovieResultDTO {
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

  bool compareTo(MovieResultDTO other) {
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
