import 'package:my_movie_search/movies/models/movie_result_dto.dart';

const IMDB_TITLE_PREFIX = 'tt';
const IMDB_PERSON_PREFIX = 'nm';

const IMDB_BASE_URL = 'http://imdb.com';
const IMDB_TITLE_URL = '/title/';
const IMDB_PERSON_URL = '/name/';

String makeImdbUrl(String key) {
  if (key.startsWith(IMDB_TITLE_PREFIX)) {
    return '$IMDB_TITLE_URL$key';
  }
  if (key.startsWith(IMDB_PERSON_PREFIX)) {
    return '$IMDB_PERSON_URL$key';
  }
  return IMDB_BASE_URL;
}

MovieContentType? getImdbMovieContentType(Object? info, int? duration) {
  if (info == null) return null;
  final String title = info.toString().toLowerCase();
  if (title.lastIndexOf('game') > -1) return MovieContentType.custom;
  if (title.lastIndexOf('creativework') > -1) return MovieContentType.custom;
  if (title.lastIndexOf('mini') > -1) // includes TV Mini-series
    return MovieContentType.miniseries;
  if (title.lastIndexOf('episode') > -1) return MovieContentType.episode;
  if (title.lastIndexOf('series') > -1) return MovieContentType.series;
  if (title.lastIndexOf('special') > -1) return MovieContentType.series;
  if (title.lastIndexOf('short') > -1) return MovieContentType.short;
  if (duration != null && duration < 50 && duration > 0)
    return MovieContentType.short;
  if (title.lastIndexOf('movie') > -1) return MovieContentType.movie;
  if (title.lastIndexOf('video') > -1) return MovieContentType.movie;
  if (title.lastIndexOf('feature') > -1) return MovieContentType.movie;
  print('Unknown Imdb MoveContentType $title');
  return MovieContentType.movie;
}

CensorRatingType? getImdbCensorRating(String? type) {
  // Details available at https://help.imdb.com/article/contribution/titles/certificates/GU757M8ZJ9ZPXB39
  if (type == null) return null;
  if (type.lastIndexOf('Banned') > -1) return CensorRatingType.adult;
  if (type.lastIndexOf('X') > -1) return CensorRatingType.adult;
  if (type.lastIndexOf('R21') > -1) return CensorRatingType.adult;

  if (type.lastIndexOf('Z') > -1) return CensorRatingType.restriced;
  if (type.lastIndexOf('R') > -1)
    return CensorRatingType.restriced; //R, R(A), RP18
  if (type.lastIndexOf('Mature') > -1) return CensorRatingType.restriced;
  if (type.lastIndexOf('Adult') > -1) return CensorRatingType.restriced;
  if (type.lastIndexOf('GA') > -1) return CensorRatingType.restriced;
  if (type.lastIndexOf('18') > -1)
    return CensorRatingType.restriced; //18, R18, M18, RP18, 18+, VM18
  if (type.lastIndexOf('17') > -1) return CensorRatingType.restriced; //NC-17

  if (type.lastIndexOf('16') > -1)
    return CensorRatingType.mature; // 16, NC16, R16, RP16, VM 16
  if (type.lastIndexOf('15') > -1)
    return CensorRatingType.mature; // 15+, B15, R15+, 15A, 15PG
  if (type.lastIndexOf('14') > -1) return CensorRatingType.mature; // 14+, VM14
  if (type.lastIndexOf('M') > -1)
    return CensorRatingType.mature; // M, MA, TV-MA
  if (type.lastIndexOf('GY') > -1) return CensorRatingType.mature;
  if (type.lastIndexOf('D') > -1) return CensorRatingType.mature;
  if (type.lastIndexOf('LH') > -1) return CensorRatingType.mature;

  if (type.lastIndexOf('Approved') > -1) return CensorRatingType.family;
  if (type.lastIndexOf('13') > -1)
    return CensorRatingType.family; // PG-13, 13+, R13, RP13
  if (type.lastIndexOf('12') > -1)
    return CensorRatingType.family; // 12+, 12A, PG12, 12A, 12PG
  if (type.lastIndexOf('11') > -1) return CensorRatingType.family; // 11
  if (type.lastIndexOf('10') > -1) return CensorRatingType.family; // 10
  if (type.lastIndexOf('9') > -1) return CensorRatingType.family; // 9+
  if (type.lastIndexOf('Teen') > -1) return CensorRatingType.family; // Teen
  if (type.lastIndexOf('TE') > -1) return CensorRatingType.family; // TE
  if (type.lastIndexOf('7') > -1) return CensorRatingType.family; // 7+
  if (type.lastIndexOf('6') > -1) return CensorRatingType.family; // 6+
  if (type.lastIndexOf('S') > -1) return CensorRatingType.family;
  if (type.lastIndexOf('G') > -1)
    return CensorRatingType.family; // G, PG, PG-13

  if (type.lastIndexOf('C') > -1) return CensorRatingType.kids;
  if (type.lastIndexOf('Y') > -1) return CensorRatingType.kids; //TV-Y
  if (type.lastIndexOf('U') > -1) return CensorRatingType.kids;
  if (type.lastIndexOf('Btl') > -1) return CensorRatingType.kids;
  if (type.lastIndexOf('TP') > -1) return CensorRatingType.kids;
  if (type.lastIndexOf('0') > -1) return CensorRatingType.kids; // 0+
  if (type.lastIndexOf('A') > -1)
    return CensorRatingType.kids; // A, All, AL, AA

  if (type.lastIndexOf('T') > -1) return CensorRatingType.family; // T
  if (type.lastIndexOf('B') > -1) return CensorRatingType.family;
  return CensorRatingType.none;
}

/// Strip image size information from an imdb url
String getBigImage(String? smallImage) {
  // e.g.    https://m.media-amazon.com/images/M/MV5BODQxYWM2ODItYjE4ZC00YzAxLTljZDQtMjRjMmE0ZGMwYzZjXkEyXkFqcGdeQXVyODIyOTEyMzY@._V1_UY268_CR9,0,182,268_AL_.jpg
  // becomes https://m.media-amazon.com/images/M/MV5BODQxYWM2ODItYjE4ZC00YzAxLTljZDQtMjRjMmE0ZGMwYzZjXkEyXkFqcGdeQXVyODIyOTEyMzY@
  if (null != smallImage && smallImage.startsWith('http')) {
    // http followed by zero or more of anything (http.*)
    // followed by a period then multiple non periods (\.[^.]*)
    // followed by .jpg (\.jpg)
    var match = RegExp(r'^(http.*)(\.[^.]*)(\.jpg)$').firstMatch(smallImage);
    if (null != match) {
      if (null != match.group(1)) {
        return match.group(1)! + '.jpg';
      }
    }
    return smallImage;
  }
  return '';
}
