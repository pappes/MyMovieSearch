import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

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
const outer_element_rating = 'aggregateRating';
const inner_element_rating_value = 'ratingValue';
const inner_element_rating_count = 'ratingCount';
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
    movie.description = map[outer_element_description] ?? movie.title;
    movie.imageUrl = map[outer_element_image_element] ?? movie.imageUrl;
    movie.censorRating = getImdbCensorRating(
          map[outer_element_censor_rating],
        ) ??
        movie.censorRating;

    movie.userRating = DoubleHelper.fromText(
      map[outer_element_rating]?[inner_element_rating_value],
      nullValueSubstitute: movie.userRating,
    )!;
    movie.userRatingCount = IntHelper.fromText(
      map[outer_element_rating]?[inner_element_rating_count],
      nullValueSubstitute: movie.userRatingCount,
    )!;

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
    movie.type = getImdbMovieContentType(
          map[outer_element_type_element],
          movie.runTime.inMinutes,
        ) ??
        movie.type;

    return movie;
  }
}
