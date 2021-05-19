import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/duration_extensions.dart';

/*{
    "@context": "http://schema.org",
  "@type": "Movie",
  "url": "/title/tt1111422/",
  "name": "The Taking of Pelham 123",
  "image": "https://m.media-amazon.com/images/M/MV5BMTU3NzA4MDcwNV5BMl5BanBnXkFtZTcwMDAyNzc1Mg@@._V1_.jpg",
  "genre": [
      "Action",
    "Crime",
    "Thriller"
  ],
  "contentRating": "R",
  "actor": [
      {
        "@type": "Person",
      "url": "/name/nm0000243/",
      "name": "Denzel Washington"
    },
    {
        "@type": "Person",
      "url": "/name/nm0000237/",
      "name": "John Travolta"
    },
    {
        "@type": "Person",
      "url": "/name/nm0350079/",
      "name": "Luis Guzmán"
    },
    {
        "@type": "Person",
      "url": "/name/nm2963873/",
      "name": "Victor Gojcaj"
    }
  ],
  "director": {
      "@type": "Person",
    "url": "/name/nm0001716/",
    "name": "Tony Scott"
  },
  "creator": [
      {
        "@type": "Person",
      "url": "/name/nm0001338/",
      "name": "Brian Helgeland"
    },
    {
        "@type": "Person",
      "url": "/name/nm0323945/",
      "name": "John Godey"
    },
    {
        "@type": "Organization",
      "url": "/company/co0050868/"
    },
    {
        "@type": "Organization",
      "url": "/company/co0007143/"
    },
    {
        "@type": "Organization",
      "url": "/company/co0142678/"
    },
    {
        "@type": "Organization",
      "url": "/company/co0074212/"
    },
    {
        "@type": "Organization",
      "url": "/company/co0035535/"
    }
  ],
  "description": "The Taking of Pelham 123 ... turning an ordinary day\\u0027s work...",
  "datePublished": "2009-06-10",
  "keywords": "man wears eyeglasses,woman wears eyeglasses,train,hostage,subway",
  "aggregateRating": {
      "@type": "AggregateRating",
    "ratingCount": 188284,
    "bestRating": "10.0",
    "worstRating": "1.0",
    "ratingValue": "6.4"
  },
  "review": {
      "@type": "Review",
    "itemReviewed": {
        "@type": "CreativeWork",
      "url": "/title/tt1111422/"
    },
    "author": {
        "@type": "Person",
      "name": "dfranzen70"
    },
    "dateCreated": "2009-06-14",
    "inLanguage": "English",
    "name": "Washington offsets Travolta, producing entertainment",
    "reviewBody": "I was surprised ... over the top.",
    "reviewRating": {
        "@type": "Rating",
      "worstRating": "1",
      "bestRating": "10",
      "ratingValue": "7"
    }
  },
  "duration": "PT1H46M",
  "trailer": {
      "@type": "VideoObject",
    "name": "The Taking of Pelham 123: Trailer #2",
    "embedUrl": "/video/imdb/vi1348535065",
    "thumbnail": {
        "@type": "ImageObject",
      "contentUrl": "https://m.media-amazon.com/images/M/MV5BMTc4NTQ4Mjc4Nl5BMl5BanBnXkFtZTgwNjk4MTgyMzE@._V1_.jpg"
    },
    "thumbnailUrl": "https://m.media-amazon.com/images/M/MV5BMTc4NTQ4Mjc4Nl5BMl5BanBnXkFtZTgwNjk4MTgyMzE@._V1_.jpg",
    "description": "Armed men hijack a New York City subway train ... mastermind behind the crime (Travolta).",
    "uploadDate": "2009-04-03T09:47:34Z"
  }
}*/

const outer_element_identity_element = 'id';

const outer_element_title_element = 'name';
const outer_element_description = 'description';
const outer_element_year_element = 'datePublished';
const outer_element_duration = 'duration';
const outer_element_censor_rating = 'contentRating';
const outer_element_rating = 'aggregaterating';
const inner_element_rating_value = 'ratingvalue';
const inner_element_rating_count = 'ratingcount';
const outer_element_type_element = '@type';
const outer_element_image_element = 'image';

class ImdbMoviePageConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    var movie = MovieResultDTO();
    movie.source = DataSourceType.imdb;
    movie.uniqueId = map[outer_element_identity_element] ?? movie.uniqueId;
    movie.title = map[outer_element_title_element] ?? movie.title;
    movie.imageUrl = map[outer_element_image_element] ?? movie.imageUrl;
    movie.censorRating =
        getCensorRating(map[outer_element_censor_rating]) ?? movie.censorRating;

    movie.userRating = map[outer_element_rating]?[inner_element_rating_value] ??
        movie.userRating;
    movie.userRatingCount =
        getRatingCount(map[outer_element_rating]) ?? movie.userRatingCount;
    movie.type = getType(map[outer_element_type_element]) ?? movie.type;

    try {
      movie.year = DateTime.parse(map[outer_element_year_element] ?? "").year;
    } catch (e) {
      movie.yearRange = map[outer_element_year_element] ?? movie.yearRange;
    }
    try {
      movie.runTime = Duration().fromIso8601(map[outer_element_duration]);
    } catch (e) {
      movie.runTime = Duration(hours: 0, minutes: 0, seconds: 0);
    }

    return movie;
  }

  static int? getRatingCount(Map? map) {
    var text = map?[inner_element_rating_count]?.replaceAll(',', '');
    var count = int.parse(text ?? '0');
    return count == 0 ? null : count;
  }

  static MovieContentType? getType(String? type) {
    if (type == null) return null;
    if (type.lastIndexOf('TV Movie') > -1) return MovieContentType.movie;
    if (type.lastIndexOf('TV Mini-Series') > -1)
      return MovieContentType.miniseries;
    if (type.lastIndexOf('Short') > -1) return MovieContentType.short;
    if (type.lastIndexOf('Video') > -1) return MovieContentType.short;
    if (type.lastIndexOf('TV Episode') > -1) return MovieContentType.episode;
    if (type.lastIndexOf('TV Series') > -1) return MovieContentType.series;
    if (type.lastIndexOf('TV Special') > -1) return MovieContentType.series;
    return MovieContentType.movie;
  }

  static CensorRatingType? getCensorRating(String? type) {
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
    if (type.lastIndexOf('14') > -1)
      return CensorRatingType.mature; // 14+, VM14
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
}
