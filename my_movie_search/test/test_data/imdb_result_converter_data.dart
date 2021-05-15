import 'package:my_movie_search/movies/models/movie_result_dto.dart';

import '../test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Test Data
////////////////////////////////////////////////////////////////////////////////

// movieResultDTOSource = 'source';
// movieResultDTOUniqueId = 'uniqueId';
// movieResultDTOTitle = 'title';
// movieResultDTOType = 'type';
// movieResultDTOYear = 'year';
// movieResultDTOYearRange = 'yearRange';
// movieResultDTOUserRating = 'userRating';
// movieResultDTOUserRatingCount = 'userRatingCount';
// movieResultDTOCensorRating = 'censorRating';
// movieResultDTORunTime = 'runTime';
// movieResultDTOUninitialised = '-1';

final expectedDTOList = expectedDTOStream.toList();
final expectedDTOStream = streamMovieResultDTOFromJsonMap([
  {
    movieResultDTOTitle: '1234',
    movieResultDTOUniqueId: 'tt7602562',
    movieResultDTOSource: DataSourceType.imdb,
    movieResultDTOYear: 2016,
// movieResultDTOYearRange = 'yearRange';
    movieResultDTOType: MovieContentType.movie,
    //movieResultDTOUserRating: 6.5,
    //movieResultDTOUserRatingCount: 6.5,
// movieResultDTOCensorRating = 'censorRating';
    //movieResultDTORunTime: 'Wonder Woman',
  }
]);

final String htmlSampleInner = r'''
<script type="application/ld+json">{
  "@context": "http://schema.org",
  "@type": "Movie",
  "url": "/title/tt7602562/",
  "name": "1234",
  "image": "https://m.media-amazon.com/images/M/MV5B...c4OTM4NjE@._V1_.jpg",
  "genre": "Drama",
  "actor": [
    {
      "@type": "Person",
      "url": "/name/nm2487587/",
      "name": "Abhijeet Chavhan"
    },
    {
      "@type": "Person",
      "url": "/name/nm3874318/",
      "name": "Kishore Chougule"
    },
    {
      "@type": "Person",
      "url": "/name/nm5794167/",
      "name": "Tejaa Deokar"
    },
    {
      "@type": "Person",
      "url": "/name/nm4391467/",
      "name": "Arun Kadam"
    }
  ],
  "director": {
    "@type": "Person",
    "url": "/name/nm4940617/",
    "name": "Milind Arun Kavde"
  },
  "description": "1234 is a movie ... terror in the country.",
  "datePublished": "2016-08-05",
  "creator": {
    "@type": "Organization",
    "url": "/company/co0813120/"
  },
  "keywords": "terror",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingCount": 10,
    "bestRating": "10.0",
    "worstRating": "1.0",
    "ratingValue": "6.5"
  },
  "trailer": {
    "@type": "VideoObject",
    "name": "1234 (2016) Trailer",
    "embedUrl": "/video/imdb/vi962903577",
    "thumbnail": {
      "@type": "ImageObject",
      "contentUrl": "https://m.media-amazon.com/images/M/MV5B...xvdw@@._V1_.jpg"
    },
    "thumbnailUrl": "https://m.media-amazon.com/images/M/MV5B...mxvdw@@._V1_.jpg",
    "description": "On India\u0027s Independence Day... terror in the country.",
    "uploadDate": "2020-07-31T09:13:47Z"
  }
}</script>
''';
final String htmlSampleOuter = '<html> $htmlSampleInner </html>>';
final String htmlSampleFull = '$htmlSampleOuter';
