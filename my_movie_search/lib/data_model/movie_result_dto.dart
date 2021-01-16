class MovieResultDTO {
  MovieSourceType source = MovieSourceType.none;
  String uniqueId = "";
  String title = "";
  MovieContentType type = MovieContentType.none;
  int year = 0;
  String yearRange = "";
  double userRating = 0;
  CensorRatingType censorRating = CensorRatingType.none;
  Duration runTime = Duration(hours: 0, minutes: 0, seconds: 0);
}

enum MovieSourceType {
  none,
  imdb,
  omdb,
  wiki,
  other,
  custom,
}
enum MovieContentType {
  none,
  movie, //      includes "tv movie"
  series, //     anything less that an hour long that does repeat or repeats more than 4 times
  miniseries, // anything more that an hour long that does repeat
  short, //      anything less that an hour long that does not repeat
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

// memebr variable names
final String movieResultDTOSource = 'source';
final String movieResultDTOUniqueId = 'uniqueId';
final String movieResultDTOTitle = 'title';
final String movieResultDTOType = 'type';
final String movieResultDTOYear = 'year';
final String movieResultDTOYearRange = 'yearRange';
final String movieResultDTOUserRating = 'userRating';
final String movieResultDTOCensorRating = 'censorRating';
final String movieResultDTORunTime = 'runTime';

extension DTOConversion on Map {
  MovieResultDTO ToMovieResultDTO() {
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

class MovieResultDTOFactory {
  static MovieResultDTO fromJsonMap(Map map) {
    var x = MovieResultDTO();
    x.source = map[movieResultDTOSource];
    x.uniqueId = map[movieResultDTOUniqueId];
    x.title = map[movieResultDTOTitle];
    x.type = map[movieResultDTOType];
    x.year = map[movieResultDTOYear];
    x.yearRange = map[movieResultDTOYearRange];
    x.userRating = map[movieResultDTOUserRating];
    x.censorRating = map[movieResultDTOCensorRating];
    x.runTime = map[movieResultDTORunTime];
    return x;
  }
}
